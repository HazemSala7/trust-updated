// main.dart
import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart'; // (unused, keep if you use later)
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

import 'package:trust_app_updated/l10n/app_localizations.dart';

import 'LocalDB/Provider/CartProvider.dart';
import 'LocalDB/Provider/FavouriteProvider.dart';
import 'Pages/cart/cart.dart';
import 'Pages/splash_screen/splash_screen.dart';
import 'Services/notification_service/notifications.dart';

/// --- Crashlytics helpers -----------------------------------------------------

Future<void> _setAppAndDeviceKeys() async {
  // App info
  final pkg = await PackageInfo.fromPlatform();
  await FirebaseCrashlytics.instance.setCustomKey('app_name', pkg.appName);
  await FirebaseCrashlytics.instance
      .setCustomKey('app_version', '${pkg.version}+${pkg.buildNumber}');
  await FirebaseCrashlytics.instance.log('App start');

  // Device info
  final info = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final a = await info.androidInfo;
    await FirebaseCrashlytics.instance
        .setCustomKey('device_model', '${a.manufacturer} ${a.model}');
    await FirebaseCrashlytics.instance
        .setCustomKey('android_sdk', a.version.sdkInt);
    await FirebaseCrashlytics.instance
        .setCustomKey('android_release', a.version.release);
  } else if (Platform.isIOS) {
    final i = await info.iosInfo;
    await FirebaseCrashlytics.instance.setCustomKey(
        'device_model', i.utsname.machine ?? i.model ?? 'unknown');
    await FirebaseCrashlytics.instance
        .setCustomKey('ios_version', i.systemVersion ?? 'unknown');
  }
}

Future<void> triggerTestCrash() async {
  await FirebaseCrashlytics.instance.log('Developer triggered test crash');

  // Option A: simulate a Flutter crash
  // throw StateError('Test Flutter crash (Dart)');

  // Option B: Crashlytics fatal (no await here!)
  FirebaseCrashlytics.instance.crash();
}

Future<void> _initFirebaseAndCrashlytics() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Collect in release; keep enabled in debug for testing (set to true here).
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(kReleaseMode || true);

  // Forward Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };

  // Forward uncaught async & platform dispatcher errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Enrich with app/device metadata
  await _setAppAndDeviceKeys();
}

Future<void> _initMessagingAndTopics() async {
  final messaging = FirebaseMessaging.instance;

  // Request permission on BOTH Android & iOS
  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );

  FirebaseCrashlytics.instance
      .log('Notification permission: ${settings.authorizationStatus}');

  if (settings.authorizationStatus == AuthorizationStatus.denied ||
      settings.authorizationStatus == AuthorizationStatus.notDetermined) {
    // User denied or not yet decided – no notifications will be shown
    return;
  }

  if (Platform.isIOS) {
    // iOS-specific: wait for APNS token, then subscribe to topic
    String? apnsToken = await messaging.getAPNSToken();
    if (apnsToken == null) {
      await Future<void>.delayed(const Duration(seconds: 1));
      apnsToken = await messaging.getAPNSToken();
    }
    if (apnsToken != null) {
      await messaging.subscribeToTopic('all');
      FirebaseCrashlytics.instance.log('Subscribed to topic: all (iOS)');
    }
  } else if (Platform.isAndroid) {
    await messaging.subscribeToTopic('all');
    FirebaseCrashlytics.instance.log('Subscribed to topic: all (Android)');
  }
}


/// Lock orientation and any other platform setup
Future<void> _initPlatformPrefs() async {
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
}

/// Single entry to initialize everything that must happen before runApp
Future<void> init() async {
  await _initFirebaseAndCrashlytics();
  await _initMessagingAndTopics();
  await _initPlatformPrefs();
}

/// --- App entry ----------------------------------------------------------------

void main() {
  // Catch anything escaping runApp
  runZonedGuarded(() async {
    await init();
    runApp(Trust(flag: false));
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

bool ArabicLang = false;
Locale locale = const Locale('en', '');

class Trust extends StatefulWidget {
  bool flag = false;
  Trust({Key? key, required this.flag}) : super(key: key);

  @override
  State<Trust> createState() => _TrustState();

  static _TrustState? of(BuildContext context) =>
      context.findAncestorStateOfType<_TrustState>();
}

class _TrustState extends State<Trust> {
  void setLocale(Locale value) {
    setState(() {
      locale = value;
    });
  }

  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';

  Future<void> ios_push() async {
    // Permission is already requested in _initMessagingAndTopics()
    // but you can keep this if other iOS setup lives here.
    final messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();
    if (token != null) {
      FirebaseCrashlytics.instance.setCustomKey('fcm_token_present', true);
    }
  }

  @override
  void initState() {
    super.initState();
    ios_push();

    // Your existing FCM wiring
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications(context);
    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

    // Example breadcrumb for app becoming ready
    FirebaseCrashlytics.instance.log('Trust app initState completed');
  }

  _changeData(String msg) => setState(() => notificationData = msg);
  _changeBody(String msg) => setState(() => notificationBody = msg);
  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavouriteProvider()),
      ],
      child: MaterialApp(
        title: 'Trust',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: locale,
        supportedLocales: const [
          Locale('en', ''),
          Locale('ar', 'AE'),
          Locale('he', ''),
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: locale.languageCode == 'ar'
              ? ThemeData(fontFamily: 'GESSTextMedium').textTheme
              : ThemeData(fontFamily: 'CenturyGothic').textTheme,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: UpgradeAlert(
          child: widget.flag ? Cart() : SplashScreen(),
        ),
      ),
    );
  }
}
