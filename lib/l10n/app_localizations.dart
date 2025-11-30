import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_he.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('he')
  ];

  /// No description provided for @check_by_product_serical_number.
  ///
  /// In en, this message translates to:
  /// **'Check by product serical number'**
  String get check_by_product_serical_number;

  /// No description provided for @check_by_customer_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Check by customer phone number'**
  String get check_by_customer_phone_number;

  /// No description provided for @new_homepage.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get new_homepage;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @delete_all_notifications.
  ///
  /// In en, this message translates to:
  /// **'Delete All Notifications'**
  String get delete_all_notifications;

  /// No description provided for @under_maintenance.
  ///
  /// In en, this message translates to:
  /// **'Under Maintenance'**
  String get under_maintenance;

  /// No description provided for @maintenance_done.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Done'**
  String get maintenance_done;

  /// No description provided for @waiting_for_delivery_for_maintenance.
  ///
  /// In en, this message translates to:
  /// **'Waiting For Delivery'**
  String get waiting_for_delivery_for_maintenance;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @maintenance_requests_report.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Requests Report'**
  String get maintenance_requests_report;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @order_by_countries.
  ///
  /// In en, this message translates to:
  /// **'Order By Countries'**
  String get order_by_countries;

  /// No description provided for @sort_by_maintenance_department.
  ///
  /// In en, this message translates to:
  /// **'Sort by maintenance department'**
  String get sort_by_maintenance_department;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @order_too_late.
  ///
  /// In en, this message translates to:
  /// **'Too Late'**
  String get order_too_late;

  /// No description provided for @order_late.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get order_late;

  /// No description provided for @new_maintenance_requests.
  ///
  /// In en, this message translates to:
  /// **'New Maintenance Requests'**
  String get new_maintenance_requests;

  /// No description provided for @activate_warranty.
  ///
  /// In en, this message translates to:
  /// **'Activate Warranty'**
  String get activate_warranty;

  /// No description provided for @order_by.
  ///
  /// In en, this message translates to:
  /// **'Order By'**
  String get order_by;

  /// No description provided for @sort_by_order_status.
  ///
  /// In en, this message translates to:
  /// **'Sort By Order Status'**
  String get sort_by_order_status;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @update_available.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get update_available;

  /// No description provided for @new_version_desc.
  ///
  /// In en, this message translates to:
  /// **'A new version of the app is available. Please update to the latest version.'**
  String get new_version_desc;

  /// No description provided for @add_waranty.
  ///
  /// In en, this message translates to:
  /// **'Add Wareanty'**
  String get add_waranty;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @warranties_and_maintenances.
  ///
  /// In en, this message translates to:
  /// **'Warranties And Maintenances'**
  String get warranties_and_maintenances;

  /// No description provided for @in_progress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get in_progress;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @edit_selected.
  ///
  /// In en, this message translates to:
  /// **'Edit Selected'**
  String get edit_selected;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost : '**
  String get cost;

  /// No description provided for @desc_problem.
  ///
  /// In en, this message translates to:
  /// **'Malfunction Description : '**
  String get desc_problem;

  /// No description provided for @notes_warranty.
  ///
  /// In en, this message translates to:
  /// **'Notes : '**
  String get notes_warranty;

  /// No description provided for @my_location.
  ///
  /// In en, this message translates to:
  /// **'My Location'**
  String get my_location;

  /// No description provided for @maintenance_status.
  ///
  /// In en, this message translates to:
  /// **'maintenance Status : '**
  String get maintenance_status;

  /// No description provided for @maintenance_notes.
  ///
  /// In en, this message translates to:
  /// **'maintenance Notes : '**
  String get maintenance_notes;

  /// No description provided for @malfunction_description.
  ///
  /// In en, this message translates to:
  /// **'Malfunction Description : '**
  String get malfunction_description;

  /// No description provided for @maintenance_department.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Department'**
  String get maintenance_department;

  /// No description provided for @merchants_location.
  ///
  /// In en, this message translates to:
  /// **'Merchants Location'**
  String get merchants_location;

  /// No description provided for @show_merchants_location.
  ///
  /// In en, this message translates to:
  /// **'Show All Merchants Location On Map'**
  String get show_merchants_location;

  /// No description provided for @send_order.
  ///
  /// In en, this message translates to:
  /// **'Send Order'**
  String get send_order;

  /// No description provided for @you_have.
  ///
  /// In en, this message translates to:
  /// **'You have'**
  String get you_have;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @copied_successfully.
  ///
  /// In en, this message translates to:
  /// **'Copied Successfully'**
  String get copied_successfully;

  /// No description provided for @no_products.
  ///
  /// In en, this message translates to:
  /// **'There is no more products'**
  String get no_products;

  /// No description provided for @search_place.
  ///
  /// In en, this message translates to:
  /// **'Search by name , or number'**
  String get search_place;

  /// No description provided for @noew_products_favourites.
  ///
  /// In en, this message translates to:
  /// **'There is no products in favorites'**
  String get noew_products_favourites;

  /// No description provided for @first_size.
  ///
  /// In en, this message translates to:
  /// **'size'**
  String get first_size;

  /// No description provided for @empty_cart.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get empty_cart;

  /// No description provided for @empty_products.
  ///
  /// In en, this message translates to:
  /// **'There is no products'**
  String get empty_products;

  /// No description provided for @no_notifications.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get no_notifications;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'ُEdit'**
  String get edit;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @poin_of_sales.
  ///
  /// In en, this message translates to:
  /// **'Point Of Sales'**
  String get poin_of_sales;

  /// No description provided for @hebron.
  ///
  /// In en, this message translates to:
  /// **'Hebron'**
  String get hebron;

  /// No description provided for @ramallah.
  ///
  /// In en, this message translates to:
  /// **'Ramallah'**
  String get ramallah;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @merchant_name.
  ///
  /// In en, this message translates to:
  /// **'Merchant Name : '**
  String get merchant_name;

  /// No description provided for @product_name.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get product_name;

  /// No description provided for @order_status_new.
  ///
  /// In en, this message translates to:
  /// **'Order Status : '**
  String get order_status_new;

  /// No description provided for @merchant_phone.
  ///
  /// In en, this message translates to:
  /// **'Merchant Phone : '**
  String get merchant_phone;

  /// No description provided for @continue_operation.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_operation;

  /// No description provided for @not_effectice.
  ///
  /// In en, this message translates to:
  /// **'Product warranty is not valid.'**
  String get not_effectice;

  /// No description provided for @effectice.
  ///
  /// In en, this message translates to:
  /// **'This product has a valid warranty.'**
  String get effectice;

  /// No description provided for @confirm_info.
  ///
  /// In en, this message translates to:
  /// **'Confirm Information'**
  String get confirm_info;

  /// No description provided for @no_internet.
  ///
  /// In en, this message translates to:
  /// **'No internet , plesae check internet connection'**
  String get no_internet;

  /// No description provided for @empty_warranties.
  ///
  /// In en, this message translates to:
  /// **'There is no warranties'**
  String get empty_warranties;

  /// No description provided for @empty_maintencaes.
  ///
  /// In en, this message translates to:
  /// **'There is no maintenance request'**
  String get empty_maintencaes;

  /// No description provided for @add_maintenance_request.
  ///
  /// In en, this message translates to:
  /// **'Add Maintenance Request'**
  String get add_maintenance_request;

  /// No description provided for @effectice_status.
  ///
  /// In en, this message translates to:
  /// **'Warranty Status'**
  String get effectice_status;

  /// No description provided for @customer_name.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customer_name;

  /// No description provided for @please_enter_product_serial_number.
  ///
  /// In en, this message translates to:
  /// **'please enter product serial number'**
  String get please_enter_product_serial_number;

  /// No description provided for @please_enter_a_your_customer_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter a your customer name'**
  String get please_enter_a_your_customer_name;

  /// No description provided for @please_enter_a_customer_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter a customer phone number'**
  String get please_enter_a_customer_phone_number;

  /// No description provided for @customer_phone.
  ///
  /// In en, this message translates to:
  /// **'Customer Phone'**
  String get customer_phone;

  /// No description provided for @maintenance_requests.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Requests'**
  String get maintenance_requests;

  /// No description provided for @product_serial_number.
  ///
  /// In en, this message translates to:
  /// **'Product Serial Number'**
  String get product_serial_number;

  /// No description provided for @navigator_home.
  ///
  /// In en, this message translates to:
  /// **'Go To Home'**
  String get navigator_home;

  /// No description provided for @order_first.
  ///
  /// In en, this message translates to:
  /// **'Order Sent Successfully'**
  String get order_first;

  /// No description provided for @order_second.
  ///
  /// In en, this message translates to:
  /// **'Our sales team will follow up with you soon!'**
  String get order_second;

  /// No description provided for @edit_success.
  ///
  /// In en, this message translates to:
  /// **'Product has been updated successfully!'**
  String get edit_success;

  /// No description provided for @categories_page.
  ///
  /// In en, this message translates to:
  /// **'Categories Page'**
  String get categories_page;

  /// No description provided for @order_status.
  ///
  /// In en, this message translates to:
  /// **'Order Status : '**
  String get order_status;

  /// No description provided for @order_number.
  ///
  /// In en, this message translates to:
  /// **'Order Number : '**
  String get order_number;

  /// No description provided for @my_orders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get my_orders;

  /// No description provided for @search_no_products.
  ///
  /// In en, this message translates to:
  /// **'There are no products'**
  String get search_no_products;

  /// No description provided for @empty_orders.
  ///
  /// In en, this message translates to:
  /// **'There is no orders yet'**
  String get empty_orders;

  /// No description provided for @search_by_name_or_number.
  ///
  /// In en, this message translates to:
  /// **'Search by product number or name'**
  String get search_by_name_or_number;

  /// No description provided for @related_products.
  ///
  /// In en, this message translates to:
  /// **'Related Products'**
  String get related_products;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @explanation.
  ///
  /// In en, this message translates to:
  /// **'Ask abou...'**
  String get explanation;

  /// No description provided for @available_sizes.
  ///
  /// In en, this message translates to:
  /// **'Available Sizes'**
  String get available_sizes;

  /// No description provided for @fav_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'This product has been successfully removed from your favorites'**
  String get fav_deleted_successfully;

  /// No description provided for @fav_added_successfully.
  ///
  /// In en, this message translates to:
  /// **'This product has been successfully added to your favorites'**
  String get fav_added_successfully;

  /// No description provided for @colors.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get colors;

  /// No description provided for @downloaded_successfully.
  ///
  /// In en, this message translates to:
  /// **'The image has been downloaded successfully'**
  String get downloaded_successfully;

  /// No description provided for @downloaded_failed.
  ///
  /// In en, this message translates to:
  /// **'The image download failed, please try again later'**
  String get downloaded_failed;

  /// No description provided for @cart_success.
  ///
  /// In en, this message translates to:
  /// **'Product added successfully to cart'**
  String get cart_success;

  /// No description provided for @select_size.
  ///
  /// In en, this message translates to:
  /// **'Select Size'**
  String get select_size;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @select_color.
  ///
  /// In en, this message translates to:
  /// **'Choose Color'**
  String get select_color;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @name_contact.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name_contact;

  /// No description provided for @message_contact.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message_contact;

  /// No description provided for @search_drawer.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search_drawer;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'ADDRESS'**
  String get address;

  /// No description provided for @view_by.
  ///
  /// In en, this message translates to:
  /// **'View by'**
  String get view_by;

  /// No description provided for @or_select_season.
  ///
  /// In en, this message translates to:
  /// **'Or Select Season'**
  String get or_select_season;

  /// No description provided for @address1.
  ///
  /// In en, this message translates to:
  /// **'P.O.BOX 258 Al-Rameh Suberb'**
  String get address1;

  /// No description provided for @address2.
  ///
  /// In en, this message translates to:
  /// **'Hebron , Palestine P7190117'**
  String get address2;

  /// No description provided for @mailing_address.
  ///
  /// In en, this message translates to:
  /// **'MAILING ADDRESS'**
  String get mailing_address;

  /// No description provided for @mailing_address1.
  ///
  /// In en, this message translates to:
  /// **'P.O.BOX 51841'**
  String get mailing_address1;

  /// No description provided for @mailing_address2.
  ///
  /// In en, this message translates to:
  /// **'Jerusalem , Post Code: 9151702'**
  String get mailing_address2;

  /// No description provided for @show_on_map.
  ///
  /// In en, this message translates to:
  /// **'Show on Map'**
  String get show_on_map;

  /// No description provided for @contact_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get contact_phone;

  /// No description provided for @contact_fax.
  ///
  /// In en, this message translates to:
  /// **'Fax'**
  String get contact_fax;

  /// No description provided for @contact_mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get contact_mobile;

  /// No description provided for @contact_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contact_email;

  /// No description provided for @parts.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get parts;

  /// No description provided for @about_well.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get about_well;

  /// No description provided for @my_account.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get my_account;

  /// No description provided for @more_products.
  ///
  /// In en, this message translates to:
  /// **'More Products'**
  String get more_products;

  /// No description provided for @view_by_season.
  ///
  /// In en, this message translates to:
  /// **'View By Season'**
  String get view_by_season;

  /// No description provided for @view_by_category.
  ///
  /// In en, this message translates to:
  /// **'View By Category'**
  String get view_by_category;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @offer.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offer;

  /// No description provided for @alqaima.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get alqaima;

  /// No description provided for @qaf.
  ///
  /// In en, this message translates to:
  /// **'Common Questions'**
  String get qaf;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @products_added_to_wishlists.
  ///
  /// In en, this message translates to:
  /// **'Products added to favourited'**
  String get products_added_to_wishlists;

  /// No description provided for @password_my_account.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password_my_account;

  /// No description provided for @edit_password.
  ///
  /// In en, this message translates to:
  /// **'Edit Password'**
  String get edit_password;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms Of Use'**
  String get terms;

  /// No description provided for @who.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get who;

  /// No description provided for @favourite.
  ///
  /// In en, this message translates to:
  /// **'Favourite'**
  String get favourite;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'My Order'**
  String get order;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy And Policy'**
  String get privacy;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @dialogl1.
  ///
  /// In en, this message translates to:
  /// **'You have to login first'**
  String get dialogl1;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'ok'**
  String get ok;

  /// No description provided for @enterphone.
  ///
  /// In en, this message translates to:
  /// **'enter phone number'**
  String get enterphone;

  /// No description provided for @enterpassword.
  ///
  /// In en, this message translates to:
  /// **'enter password'**
  String get enterpassword;

  /// No description provided for @donthaveaccount.
  ///
  /// In en, this message translates to:
  /// **'Dont have an account ? '**
  String get donthaveaccount;

  /// No description provided for @youcansignup.
  ///
  /// In en, this message translates to:
  /// **'You can sign up here '**
  String get youcansignup;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'enter username'**
  String get username;

  /// No description provided for @confirmpassword.
  ///
  /// In en, this message translates to:
  /// **'confirm password'**
  String get confirmpassword;

  /// No description provided for @youcansigninhere.
  ///
  /// In en, this message translates to:
  /// **'You can sign in here '**
  String get youcansigninhere;

  /// No description provided for @doyouhaveaccount.
  ///
  /// In en, this message translates to:
  /// **'Do you have an account ? '**
  String get doyouhaveaccount;

  /// No description provided for @logging_in.
  ///
  /// In en, this message translates to:
  /// **'Loggin you in'**
  String get logging_in;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get create_account;

  /// No description provided for @logoutsure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to logout? '**
  String get logoutsure;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @toastlogout.
  ///
  /// In en, this message translates to:
  /// **'You have been successfully logged out'**
  String get toastlogout;

  /// No description provided for @loginsuccess.
  ///
  /// In en, this message translates to:
  /// **'You have been successfully logged in'**
  String get loginsuccess;

  /// No description provided for @loginempty.
  ///
  /// In en, this message translates to:
  /// **'phone number or password is empty'**
  String get loginempty;

  /// No description provided for @incorrectpass.
  ///
  /// In en, this message translates to:
  /// **'password is incorrct!'**
  String get incorrectpass;

  /// No description provided for @incorrectphone.
  ///
  /// In en, this message translates to:
  /// **'phonenumber is incorrect!'**
  String get incorrectphone;

  /// No description provided for @phoneorpassin.
  ///
  /// In en, this message translates to:
  /// **'phone number or password is incorrect!'**
  String get phoneorpassin;

  /// No description provided for @regempty.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all blanks'**
  String get regempty;

  /// No description provided for @regsuccess.
  ///
  /// In en, this message translates to:
  /// **'Your account has been successfully registered'**
  String get regsuccess;

  /// No description provided for @regphonefailed.
  ///
  /// In en, this message translates to:
  /// **'The phone number entered is already registered'**
  String get regphonefailed;

  /// No description provided for @editprofile.
  ///
  /// In en, this message translates to:
  /// **'Edit my profile'**
  String get editprofile;

  /// No description provided for @deletecart.
  ///
  /// In en, this message translates to:
  /// **'It has been successfully removed from the cart'**
  String get deletecart;

  /// No description provided for @alreadydeletecart.
  ///
  /// In en, this message translates to:
  /// **'already deleted'**
  String get alreadydeletecart;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @buynow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buynow;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'price'**
  String get price;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'quantity'**
  String get qty;

  /// No description provided for @namecon.
  ///
  /// In en, this message translates to:
  /// **'name'**
  String get namecon;

  /// No description provided for @phonecon.
  ///
  /// In en, this message translates to:
  /// **'phone number'**
  String get phonecon;

  /// No description provided for @mailcon.
  ///
  /// In en, this message translates to:
  /// **'mail'**
  String get mailcon;

  /// No description provided for @subcon.
  ///
  /// In en, this message translates to:
  /// **'subject of the message'**
  String get subcon;

  /// No description provided for @bodycon.
  ///
  /// In en, this message translates to:
  /// **'body of the message'**
  String get bodycon;

  /// No description provided for @consuccess.
  ///
  /// In en, this message translates to:
  /// **'Your message was sent successfully'**
  String get consuccess;

  /// No description provided for @delete_success.
  ///
  /// In en, this message translates to:
  /// **'Account deleted sunccessfully'**
  String get delete_success;

  /// No description provided for @confailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send the message'**
  String get confailed;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @case1.
  ///
  /// In en, this message translates to:
  /// **'Case'**
  String get case1;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'female'**
  String get female;

  /// No description provided for @editsuccess.
  ///
  /// In en, this message translates to:
  /// **'Your account has been successfully modified'**
  String get editsuccess;

  /// No description provided for @editfailed.
  ///
  /// In en, this message translates to:
  /// **'Edit operation failed'**
  String get editfailed;

  /// No description provided for @editsave.
  ///
  /// In en, this message translates to:
  /// **'save the changes'**
  String get editsave;

  /// No description provided for @queseditpass.
  ///
  /// In en, this message translates to:
  /// **'Do you want to change the password'**
  String get queseditpass;

  /// No description provided for @editpassword.
  ///
  /// In en, this message translates to:
  /// **'Edit PassWord'**
  String get editpassword;

  /// No description provided for @oldpassword.
  ///
  /// In en, this message translates to:
  /// **'Old PassWord'**
  String get oldpassword;

  /// No description provided for @newpassword.
  ///
  /// In en, this message translates to:
  /// **'New PassWord'**
  String get newpassword;

  /// No description provided for @confirmnewpass.
  ///
  /// In en, this message translates to:
  /// **'Confirm newpassword'**
  String get confirmnewpass;

  /// No description provided for @updatepass.
  ///
  /// In en, this message translates to:
  /// **'Update my password'**
  String get updatepass;

  /// No description provided for @dontmatch.
  ///
  /// In en, this message translates to:
  /// **'The new password does not match the password'**
  String get dontmatch;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get product;

  /// No description provided for @getgeoarea.
  ///
  /// In en, this message translates to:
  /// **'Choose a geographical area'**
  String get getgeoarea;

  /// No description provided for @getarea.
  ///
  /// In en, this message translates to:
  /// **'Choose the area'**
  String get getarea;

  /// No description provided for @getcountry.
  ///
  /// In en, this message translates to:
  /// **'Choose the country'**
  String get getcountry;

  /// No description provided for @confirmbuy.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmbuy;

  /// No description provided for @deliveryprice.
  ///
  /// In en, this message translates to:
  /// **'Delivery price'**
  String get deliveryprice;

  /// No description provided for @totally.
  ///
  /// In en, this message translates to:
  /// **'Total all'**
  String get totally;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'notes'**
  String get notes;

  /// No description provided for @nearof.
  ///
  /// In en, this message translates to:
  /// **'near of '**
  String get nearof;

  /// No description provided for @codeoffer.
  ///
  /// In en, this message translates to:
  /// **'Discount code, if any'**
  String get codeoffer;

  /// No description provided for @areaempty.
  ///
  /// In en, this message translates to:
  /// **'Please enter the nearest area and choose the area'**
  String get areaempty;

  /// No description provided for @confirmincorrectcoe.
  ///
  /// In en, this message translates to:
  /// **'The entered code is incorrect'**
  String get confirmincorrectcoe;

  /// No description provided for @confirmincorrectphone.
  ///
  /// In en, this message translates to:
  /// **'The phone number entered is incorrect'**
  String get confirmincorrectphone;

  /// No description provided for @confirmincorrectpassword.
  ///
  /// In en, this message translates to:
  /// **'The password entered is incorrect'**
  String get confirmincorrectpassword;

  /// No description provided for @firstlineconfirm.
  ///
  /// In en, this message translates to:
  /// **'Your account activation code has been sent to the phone number:'**
  String get firstlineconfirm;

  /// No description provided for @secondlineconfirm.
  ///
  /// In en, this message translates to:
  /// **'Enter the code in the box below'**
  String get secondlineconfirm;

  /// No description provided for @entercode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code here'**
  String get entercode;

  /// No description provided for @confirmcode.
  ///
  /// In en, this message translates to:
  /// **'Confirm Code'**
  String get confirmcode;

  /// No description provided for @notcorrectreg.
  ///
  /// In en, this message translates to:
  /// **'Password does not match'**
  String get notcorrectreg;

  /// No description provided for @suggestedproducts.
  ///
  /// In en, this message translates to:
  /// **'Suggested Products'**
  String get suggestedproducts;

  /// No description provided for @takegallery.
  ///
  /// In en, this message translates to:
  /// **'Take the picture from gallery'**
  String get takegallery;

  /// No description provided for @takecamera.
  ///
  /// In en, this message translates to:
  /// **'Take the picture from camera'**
  String get takecamera;

  /// No description provided for @confirmconfirm.
  ///
  /// In en, this message translates to:
  /// **'Please enter the full code'**
  String get confirmconfirm;

  /// No description provided for @reqnum.
  ///
  /// In en, this message translates to:
  /// **'request number'**
  String get reqnum;

  /// No description provided for @reqtot.
  ///
  /// In en, this message translates to:
  /// **'total '**
  String get reqtot;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'time'**
  String get time;

  /// No description provided for @qaid.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get qaid;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search results for'**
  String get search;

  /// No description provided for @sin_cart.
  ///
  /// In en, this message translates to:
  /// **'add to cart'**
  String get sin_cart;

  /// No description provided for @sin_product.
  ///
  /// In en, this message translates to:
  /// **'product'**
  String get sin_product;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @feaa.
  ///
  /// In en, this message translates to:
  /// **'category :'**
  String get feaa;

  /// No description provided for @alqeema.
  ///
  /// In en, this message translates to:
  /// **'the value :'**
  String get alqeema;

  /// No description provided for @modern.
  ///
  /// In en, this message translates to:
  /// **'Just arrived'**
  String get modern;

  /// No description provided for @req_suc.
  ///
  /// In en, this message translates to:
  /// **'Your request has been successfully sent'**
  String get req_suc;

  /// No description provided for @code_failed.
  ///
  /// In en, this message translates to:
  /// **'The entered code is incorrect'**
  String get code_failed;

  /// No description provided for @code_fexpired.
  ///
  /// In en, this message translates to:
  /// **'The entered code has expired'**
  String get code_fexpired;

  /// No description provided for @code_dis.
  ///
  /// In en, this message translates to:
  /// **'has been discount'**
  String get code_dis;

  /// No description provided for @code_total.
  ///
  /// In en, this message translates to:
  /// **'Your total is more than the allowed limit'**
  String get code_total;

  /// No description provided for @limit_buy.
  ///
  /// In en, this message translates to:
  /// **'permissible limit:'**
  String get limit_buy;

  /// No description provided for @my_points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get my_points;

  /// No description provided for @dailt_atten.
  ///
  /// In en, this message translates to:
  /// **'تسجيل حضور عمال يومي'**
  String get dailt_atten;

  /// No description provided for @attendace.
  ///
  /// In en, this message translates to:
  /// **'الحضور'**
  String get attendace;

  /// No description provided for @notes_general.
  ///
  /// In en, this message translates to:
  /// **'ملاحظات عامه'**
  String get notes_general;

  /// No description provided for @save_date.
  ///
  /// In en, this message translates to:
  /// **'حفظ البيانات'**
  String get save_date;

  /// No description provided for @attendace_successfully.
  ///
  /// In en, this message translates to:
  /// **'تم اضافه الحضور و الغياب بنجاح'**
  String get attendace_successfully;

  /// No description provided for @kind_employee_drawer.
  ///
  /// In en, this message translates to:
  /// **'نوع العمال'**
  String get kind_employee_drawer;

  /// No description provided for @user_no_active.
  ///
  /// In en, this message translates to:
  /// **'حسابك غير مفعل , الرجاء التواصل مع صاحب التطبيق'**
  String get user_no_active;

  /// No description provided for @no_employees_here.
  ///
  /// In en, this message translates to:
  /// **'لا يوجد اي عمال في هذه الورشه'**
  String get no_employees_here;

  /// No description provided for @number_attendace.
  ///
  /// In en, this message translates to:
  /// **'عدد الحضور'**
  String get number_attendace;

  /// No description provided for @number_employee.
  ///
  /// In en, this message translates to:
  /// **'الرقم'**
  String get number_employee;

  /// No description provided for @hour_employee.
  ///
  /// In en, this message translates to:
  /// **'الساعات'**
  String get hour_employee;

  /// No description provided for @note_employee.
  ///
  /// In en, this message translates to:
  /// **'اضافه ملاحظات'**
  String get note_employee;

  /// No description provided for @name_employee.
  ///
  /// In en, this message translates to:
  /// **'أسم العامل'**
  String get name_employee;

  /// No description provided for @atten_hour.
  ///
  /// In en, this message translates to:
  /// **'تسجيل حضور عمال بالساعات'**
  String get atten_hour;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'تسجيل حضور العمال'**
  String get app_name;

  /// No description provided for @account_disabled.
  ///
  /// In en, this message translates to:
  /// **'حسابك غير مفعل , يرجى التواصل معنا لتفعيله'**
  String get account_disabled;

  /// No description provided for @project_id.
  ///
  /// In en, this message translates to:
  /// **'Project ID'**
  String get project_id;

  /// No description provided for @kind_employee.
  ///
  /// In en, this message translates to:
  /// **'  '**
  String get kind_employee;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'שעה / ות'**
  String get daily;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'מנהל'**
  String get admin;

  /// No description provided for @hourly.
  ///
  /// In en, this message translates to:
  /// **'יום / יומי'**
  String get hourly;

  /// No description provided for @warranty_inspection.
  ///
  /// In en, this message translates to:
  /// **'Warranty Inspection'**
  String get warranty_inspection;

  /// No description provided for @amending_the_warranty.
  ///
  /// In en, this message translates to:
  /// **'Amending The Warranty'**
  String get amending_the_warranty;

  /// No description provided for @send_to_maintenance.
  ///
  /// In en, this message translates to:
  /// **'Send To Maintenance'**
  String get send_to_maintenance;

  /// No description provided for @maintenance_status_product_id.
  ///
  /// In en, this message translates to:
  /// **'Maintenance status Product number'**
  String get maintenance_status_product_id;

  /// No description provided for @maintenance_status_customer_phone.
  ///
  /// In en, this message translates to:
  /// **'Maintenance status phone number'**
  String get maintenance_status_customer_phone;

  /// No description provided for @inquire_about_product_specifications.
  ///
  /// In en, this message translates to:
  /// **'Inquire About Product Specifications'**
  String get inquire_about_product_specifications;

  /// No description provided for @effective_guarantees.
  ///
  /// In en, this message translates to:
  /// **'Effective Guarantees'**
  String get effective_guarantees;

  /// No description provided for @merchant_address.
  ///
  /// In en, this message translates to:
  /// **'Merchant Address'**
  String get merchant_address;

  /// No description provided for @download_catalog.
  ///
  /// In en, this message translates to:
  /// **'Download Catelog'**
  String get download_catalog;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @available_offers.
  ///
  /// In en, this message translates to:
  /// **'Available Offers'**
  String get available_offers;

  /// No description provided for @there_is_no_offers.
  ///
  /// In en, this message translates to:
  /// **'There is no offers'**
  String get there_is_no_offers;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'You have to enter a valid email, please.'**
  String get invalid_email;

  /// No description provided for @please_enter_a_your_product_serial_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter a your product serial number'**
  String get please_enter_a_your_product_serial_number;

  /// No description provided for @please_enter_a_your_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter a your phone number'**
  String get please_enter_a_your_phone_number;

  /// No description provided for @instead.
  ///
  /// In en, this message translates to:
  /// **'instead'**
  String get instead;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'he'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'he': return AppLocalizationsHe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
