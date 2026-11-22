import Flutter
import PDFKit
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    if let messenger = engineBridge.applicationRegistrar.messenger() as FlutterBinaryMessenger? {
      let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "EduEthiopiaPdfPlugin")
      registrar.register(
        PdfPlatformViewFactory(messenger: messenger),
        withId: "eduethiopia/pdf_viewer"
      )

      let downloadChannel = FlutterMethodChannel(
        name: "com.example.eduethiopia/download",
        binaryMessenger: messenger
      )
      downloadChannel.setMethodCallHandler { call, result in
        guard call.method == "savePdf",
              let arguments = call.arguments as? [String: Any],
              let fileName = arguments["fileName"] as? String,
              let bytes = arguments["bytes"] as? FlutterStandardTypedData else {
          result(FlutterMethodNotImplemented)
          return
        }

        do {
          let documents = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
          )[0]
          let file = documents.appendingPathComponent(fileName)
          try bytes.data.write(to: file, options: .atomic)
          result(nil)
        } catch {
          result(FlutterError(
            code: "DOWNLOAD_FAILED",
            message: error.localizedDescription,
            details: nil
          ))
        }
      }
    }
  }
}

class PdfPlatformViewFactory: NSObject, FlutterPlatformViewFactory {
  private let messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    return PdfPlatformView(
      frame: frame,
      viewIdentifier: viewId,
      arguments: args,
      messenger: messenger
    )
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

class PdfPlatformView: NSObject, FlutterPlatformView {
  private let pdfView: PDFView
  private let channel: FlutterMethodChannel
  private var pageCount = 0

  init(
    frame: CGRect,
    viewIdentifier: Int64,
    arguments: Any?,
    messenger: FlutterBinaryMessenger
  ) {
    pdfView = PDFView(frame: frame)
    channel = FlutterMethodChannel(
      name: "com.example.eduethiopia/pdf_viewer/\(viewIdentifier)",
      binaryMessenger: messenger
    )
    super.init()

    pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    pdfView.displayMode = .singlePageContinuous
    pdfView.displayDirection = .vertical
    pdfView.autoScales = true
    pdfView.isUserInteractionEnabled = true
    pdfView.backgroundColor = .systemBackground

    if let arguments = arguments as? [String: Any],
       let filePath = arguments["filePath"] as? String {
      let url = URL(fileURLWithPath: filePath)
      if let document = PDFDocument(url: url) {
        pdfView.document = document
        pageCount = document.pageCount
        channel.invokeMethod("documentLoaded", arguments: [
          "pageCount": pageCount
        ])
      }
    }

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(pageChanged),
      name: .PDFViewPageChanged,
      object: pdfView
    )

    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else {
        result(nil)
        return
      }
      if call.method == "previousPage" {
        self.pdfView.goToPreviousPage(nil)
        result(nil)
      } else if call.method == "nextPage" {
        self.pdfView.goToNextPage(nil)
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }

  func view() -> UIView {
    return pdfView
  }

  @objc private func pageChanged() {
    guard let page = pdfView.currentPage,
          let document = pdfView.document else {
      return
    }
    let pageIndex = document.index(for: page)
    channel.invokeMethod("pageChanged", arguments: [
      "pageNumber": pageIndex + 1
    ])
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
