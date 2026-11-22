package com.example.eduethiopia

import android.content.ContentValues
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Color
import android.graphics.pdf.PdfRenderer
import android.os.Build
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.os.ParcelFileDescriptor
import android.provider.MediaStore
import android.util.LruCache
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.io.File
import java.io.FileOutputStream
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private val downloadChannel = "com.example.eduethiopia/download"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        flutterEngine.platformViewsController.registry.registerViewFactory(
            "eduethiopia/pdf_viewer",
            PdfPlatformViewFactory(flutterEngine.dartExecutor.binaryMessenger),
        )

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
                        FileOutputStream(File(directory, fileName)).use {
                            it.write(bytes)
                        }
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

class PdfPlatformViewFactory(
    private val messenger: BinaryMessenger,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        return PdfPlatformView(
            context,
            messenger,
            id,
            args as? Map<*, *>,
        )
    }
}

class PdfPlatformView(
    private val context: Context,
    messenger: BinaryMessenger,
    id: Int,
    args: Map<*, *>?,
) : PlatformView {
    private val channel = MethodChannel(
        messenger,
        "com.example.eduethiopia/pdf_viewer/$id",
    )
    private val recyclerView = RecyclerView(context)
    private val executor: ExecutorService =
        Executors.newFixedThreadPool(2)
    private val mainHandler = Handler(Looper.getMainLooper())
    private var renderer: PdfRenderer? = null
    private var descriptor: ParcelFileDescriptor? = null
    private var currentPage = 1

    init {
        recyclerView.layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT,
        )
        recyclerView.setBackgroundColor(Color.WHITE)
        recyclerView.overScrollMode = View.OVER_SCROLL_IF_CONTENT_SCROLLS
        recyclerView.isVerticalScrollBarEnabled = true
        recyclerView.setItemViewCacheSize(5)
        recyclerView.setHasFixedSize(true)
        recyclerView.layoutManager = LinearLayoutManager(
            context,
            LinearLayoutManager.VERTICAL,
            false,
        )

        val filePath = args?.get("filePath") as? String
        if (filePath != null) {
            try {
                val file = File(filePath)
                val fileDescriptor = ParcelFileDescriptor.open(
                    file,
                    ParcelFileDescriptor.MODE_READ_ONLY,
                )
                descriptor = fileDescriptor
                renderer = PdfRenderer(fileDescriptor)

                recyclerView.adapter = PdfPageAdapter(
                    context,
                    renderer!!,
                    executor,
                    mainHandler,
                )

                channel.invokeMethod(
                    "documentLoaded",
                    mapOf("pageCount" to renderer!!.pageCount),
                )
            } catch (_: Exception) {
                channel.invokeMethod(
                    "documentLoaded",
                    mapOf("pageCount" to 0),
                )
            }
        }

        recyclerView.addOnScrollListener(
            object : RecyclerView.OnScrollListener() {
                override fun onScrolled(
                    recycler: RecyclerView,
                    dx: Int,
                    dy: Int,
                ) {
                    val layoutManager =
                        recycler.layoutManager as? LinearLayoutManager
                            ?: return
                    val firstVisible =
                        layoutManager.findFirstVisibleItemPosition()
                    val page =
                        if (firstVisible >= 0) firstVisible + 1 else 1
                    if (page != currentPage) {
                        currentPage = page
                        channel.invokeMethod(
                            "pageChanged",
                            mapOf("pageNumber" to page),
                        )
                    }
                }
            },
        )

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "previousPage" -> {
                    if (currentPage > 1) {
                        recyclerView.smoothScrollToPosition(currentPage - 2)
                    }
                    result.success(null)
                }
                "nextPage" -> {
                    val pageCount = renderer?.pageCount ?: 0
                    if (currentPage < pageCount) {
                        recyclerView.smoothScrollToPosition(currentPage)
                    }
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun getView(): View = recyclerView

    override fun dispose() {
        channel.setMethodCallHandler(null)
        executor.shutdown()
        renderer?.close()
        descriptor?.close()
    }
}

class PdfPageAdapter(
    private val context: Context,
    private val renderer: PdfRenderer,
    private val executor: ExecutorService,
    private val mainHandler: Handler,
) : RecyclerView.Adapter<PdfPageAdapter.PageHolder>() {
    private val pageRatios = mutableListOf<Double>()
    private val bitmapCache = LruCache<Int, Bitmap>(8)

    init {
        for (index in 0 until renderer.pageCount) {
            val page = renderer.openPage(index)
            pageRatios.add(
                page.width.toDouble() / page.height.toDouble(),
            )
            page.close()
        }
    }

    override fun getItemCount(): Int = renderer.pageCount

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int,
    ): PageHolder {
        val imageView = ImageView(parent.context).apply {
            scaleType = ImageView.ScaleType.FIT_CENTER
            setBackgroundColor(Color.WHITE)
        }
        return PageHolder(imageView)
    }

    override fun onBindViewHolder(
        holder: PageHolder,
        position: Int,
    ) {
        val width = holder.itemView.context.resources.displayMetrics.widthPixels
        val ratio = pageRatios.getOrElse(position) { 0.772 }
        val height = (width / ratio).toInt().coerceAtMost(2200)
        holder.itemView.layoutParams = RecyclerView.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            height,
        )
        holder.itemView.setPadding(0, 8, 0, 8)
        holder.imageView.setImageBitmap(null)
        holder.positionTag = position

        val cached = bitmapCache.get(position)
        if (cached != null) {
            holder.imageView.setImageBitmap(cached)
            return
        }

        val pageIndex = position
        if (position <= 2) {
            try {
                val page = renderer.openPage(pageIndex)
                val targetWidth =
                    width.coerceAtMost(
                        context.resources.displayMetrics.densityDpi * 2,
                    )
                val targetHeight =
                    (targetWidth / ratio).toInt().coerceAtLeast(1)
                val bitmap = Bitmap.createBitmap(
                    targetWidth,
                    targetHeight,
                    Bitmap.Config.ARGB_8888,
                )
                bitmap.eraseColor(Color.WHITE)
                page.render(
                    bitmap,
                    null,
                    null,
                    PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY,
                )
                page.close()
                bitmapCache.put(pageIndex, bitmap)
                holder.imageView.setImageBitmap(bitmap)
                return
            } catch (error: Exception) {
                Log.e("EduEthiopiaPdf", "Immediate page render failed", error)
            }
        }

        executor.execute {
            try {
                val page = renderer.openPage(pageIndex)
                val targetWidth =
                    width.coerceAtMost(
                        context.resources.displayMetrics.densityDpi * 3,
                    )
                val targetHeight =
                    (targetWidth / ratio).toInt().coerceAtLeast(1)
                val bitmap = Bitmap.createBitmap(
                    targetWidth,
                    targetHeight,
                    Bitmap.Config.ARGB_8888,
                )
                bitmap.eraseColor(Color.WHITE)
                page.render(
                    bitmap,
                    null,
                    null,
                    PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY,
                )
                page.close()
                bitmapCache.put(pageIndex, bitmap)

                mainHandler.post {
                    if (holder.positionTag == pageIndex) {
                        holder.imageView.setImageBitmap(bitmap)
                    }
                }
            } catch (error: Exception) {
                Log.e("EduEthiopiaPdf", "Page render failed", error)
            }
        }
    }

    class PageHolder(val imageView: ImageView) :
        RecyclerView.ViewHolder(imageView) {
        var positionTag = -1
    }
}
