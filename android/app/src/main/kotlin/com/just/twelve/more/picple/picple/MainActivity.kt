package com.just.twelve.more.picple

import android.Manifest
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

class MainActivity : FlutterFragmentActivity() {
  companion object {
    private const val CHANNEL = "picple/picker"
  }

  private var methodChannel: MethodChannel? = null
  private var pendingResult: MethodChannel.Result? = null
  private var pendingAction: (() -> Unit)? = null
  private var pendingImagePath: String? = null

  private lateinit var takePictureLauncher: ActivityResultLauncher<Uri>
  private lateinit var pickImageLauncher: ActivityResultLauncher<String>
  private lateinit var permissionLauncher: ActivityResultLauncher<Array<String>>

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    initActivityResultLaunchers()
  }

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    methodChannel?.setMethodCallHandler { call, result ->
      when (call.method) {
        "takePicture" -> handleTakePicture(result)
        "pickFromGallery" -> handlePickFromGallery(result)
        else -> result.notImplemented()
      }
    }
  }

  private fun initActivityResultLaunchers() {
    takePictureLauncher = registerForActivityResult(ActivityResultContracts.TakePicture()) { success ->
      val result = pendingResult
      if (success) {
        val path = pendingImagePath
        if (path != null) {
          result?.success(path)
        } else {
          result?.error("NO_FILE", "Failed to save captured image", null)
        }
      } else {
        result?.error("CANCELLED", "Camera action was cancelled", null)
      }
      clearPendingState()
    }

    pickImageLauncher = registerForActivityResult(ActivityResultContracts.GetContent()) { uri ->
      val result = pendingResult
      if (uri != null) {
        val path = copyUriToCache(uri)
        if (path != null) {
          result?.success(path)
        } else {
          result?.error("COPY_FAILED", "Failed to import selected image", null)
        }
      } else {
        result?.error("CANCELLED", "Image selection was cancelled", null)
      }
      clearPendingState()
    }

    permissionLauncher = registerForActivityResult(ActivityResultContracts.RequestMultiplePermissions()) { grants ->
      val granted = grants.entries.all { it.value }
      if (granted) {
        val action = pendingAction
        pendingAction = null
        action?.invoke()
      } else {
        pendingResult?.error("PERMISSION_DENIED", "Required permissions not granted", null)
        clearPendingState()
      }
    }
  }

  private fun handleTakePicture(result: MethodChannel.Result) {
    if (pendingResult != null) {
      result.error("BUSY", "Another picker request is running", null)
      return
    }

    startOperation(result, cameraPermissions()) {
      val uri = createImageUri()
      if (uri == null) {
        pendingResult?.error("FILE_ERROR", "Unable to create file for camera image", null)
        clearPendingState()
        return@startOperation
      }
      takePictureLauncher.launch(uri)
    }
  }

  private fun handlePickFromGallery(result: MethodChannel.Result) {
    if (pendingResult != null) {
      result.error("BUSY", "Another picker request is running", null)
      return
    }

    startOperation(result, galleryPermissions()) {
      pickImageLauncher.launch("image/*")
    }
  }

  private fun startOperation(
    result: MethodChannel.Result,
    permissions: Array<String>,
    action: () -> Unit,
  ) {
    pendingResult = result
    val missing = permissions.filter {
      ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
    }

    if (missing.isEmpty()) {
      action()
    } else {
      pendingAction = action
      permissionLauncher.launch(missing.toTypedArray())
    }
  }

  private fun cameraPermissions(): Array<String> {
    return arrayOf(Manifest.permission.CAMERA)
  }

  private fun galleryPermissions(): Array<String> {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
      arrayOf(Manifest.permission.READ_MEDIA_IMAGES)
    } else {
      arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE)
    }
  }

  private fun createImageUri(): Uri? {
    return try {
      val storageDir = getExternalFilesDir(Environment.DIRECTORY_PICTURES)
      val file = File.createTempFile(
        "picple_${System.currentTimeMillis()}",
        ".jpg",
        storageDir,
      )
      pendingImagePath = file.absolutePath
      FileProvider.getUriForFile(
        this,
        "${applicationContext.packageName}.fileprovider",
        file,
      )
    } catch (e: IOException) {
      null
    }
  }

  private fun copyUriToCache(uri: Uri): String? {
    return try {
      val inputStream = contentResolver.openInputStream(uri) ?: return null
      val tempFile = File.createTempFile(
        "picple_gallery_${System.currentTimeMillis()}",
        ".jpg",
        cacheDir,
      )
      inputStream.use { input ->
        FileOutputStream(tempFile).use { output ->
          input.copyTo(output)
        }
      }
      tempFile.absolutePath
    } catch (e: IOException) {
      null
    }
  }

  private fun clearPendingState() {
    pendingResult = null
    pendingAction = null
    pendingImagePath = null
  }
}
