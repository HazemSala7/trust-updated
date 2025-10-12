package com.royal.trust

import android.content.ContentValues
import android.media.MediaScannerConnection
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {

    private val CHANNEL = "trust.image_saver"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "saveImage" -> {
                        try {
                            val name = call.argument<String>("name")
                                ?: "image_${System.currentTimeMillis()}.jpg"
                            val bytes = call.argument<ByteArray>("bytes")
                            if (bytes == null || bytes.isEmpty()) {
                                result.error("ARG_ERROR", "bytes is null/empty", null)
                                return@setMethodCallHandler
                            }
                            val uri = saveJpegToGallery(bytes, name)
                            if (uri != null) {
                                result.success(mapOf("ok" to true, "uri" to uri.toString()))
                            } else {
                                result.error("SAVE_FAILED", "resolver.insert returned null", null)
                            }
                        } catch (t: Throwable) {
                            result.error("SAVE_FAILED", t.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun saveJpegToGallery(data: ByteArray, fileName: String): Uri? {
        val resolver = applicationContext.contentResolver
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            // Android 10+ (scoped storage, no WRITE permission needed)
            val values = ContentValues().apply {
                put(MediaStore.Images.Media.DISPLAY_NAME, fileName)
                put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
                put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/Trust")
                put(MediaStore.Images.Media.IS_PENDING, 1)
            }
            val uri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values) ?: return null
            resolver.openOutputStream(uri)?.use { it.write(data) }
            val done = ContentValues().apply { put(MediaStore.Images.Media.IS_PENDING, 0) }
            resolver.update(uri, done, null, null)
            uri
        } else {
            // Android 9 and below (needs WRITE permission at runtime to succeed)
            @Suppress("DEPRECATION")
            val pictures = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
            val dir = File(pictures, "Trust")
            if (!dir.exists()) dir.mkdirs()
            val file = File(dir, fileName)
            FileOutputStream(file).use { it.write(data) }
            MediaScannerConnection.scanFile(
                applicationContext,
                arrayOf(file.absolutePath),
                arrayOf("image/jpeg"),
                null
            )
            Uri.fromFile(file)
        }
    }
}
