package com.example.eduethiopia

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import java.io.File
import java.io.FileOutputStream
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val downloadChannel = "com.example.eduethiopia/download"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            downloadChannel,
        ).setMethodCallHandler { call, result ->
            if (call.method == "savePdf") {
                val fileName = call.argument<String>("fileName")
                val bytes = call.argument<ByteArray>("bytes")
                if (fileName == null || bytes == null) {
                    result.error("INVALID_ARGUMENT", "Missing PDF data", null)
                    return@setMethodCallHandler
                }

                try {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        val values = ContentValues().apply {
                            put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                            put(MediaStore.Downloads.MIME_TYPE, "application/pdf")
                            put(
                                MediaStore.Downloads.RELATIVE_PATH,
                                Environment.DIRECTORY_DOWNLOADS + "/EduEthiopia",
                            )
                            put(MediaStore.Downloads.IS_PENDING, 1)
                        }

                        val resolver = applicationContext.contentResolver
                        val uri = resolver.insert(
                            MediaStore.Downloads.EXTERNAL_CONTENT_URI,
                            values,
                        ) ?: throw IllegalStateException("Could not create download")

                        resolver.openOutputStream(uri)?.use { it.write(bytes) }
                            ?: throw IllegalStateException("Could not open download")

                        values.clear()
                        values.put(MediaStore.Downloads.IS_PENDING, 0)
                        resolver.update(uri, values, null, null)
                    } else {
                        val directory = File(
                            Environment.getExternalStoragePublicDirectory(
                                Environment.DIRECTORY_DOWNLOADS,
                            ),
                            "EduEthiopia",
                        )
                        if (!directory.exists()) directory.mkdirs()
                        val file = File(directory, fileName)
                        FileOutputStream(file).use { it.write(bytes) }
                    }
                    result.success(null)
                } catch (error: Exception) {
                    result.error("DOWNLOAD_FAILED", error.message, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
