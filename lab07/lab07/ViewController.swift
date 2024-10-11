//
//  ViewController.swift
//  lab07
//
//  Created by thebv on 11/10/2024.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var vPdfContent: UIView!
    var downloader: MADownloader?
    var fileUrl: String?
    let webView = WKWebView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vPdfContent.addSubview(self.webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.vPdfContent.topAnchor),
            webView.leadingAnchor.constraint(equalTo: self.vPdfContent.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.vPdfContent.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: self.vPdfContent.bottomAnchor)
        ])
    }
    
    func formatBytes(_ bytes: Int64) -> String {
        if bytes >= 1024 * 1024 {
            let mb = Double(bytes) / (1024 * 1024)
            return String(format: "%.2f MB", mb)
        } else {
            let kb = Double(bytes) / 1024
            return String(format: "%.2f KB", kb)
        }
    }
    
    func viewPdf() {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        if let fileUrl = self.fileUrl {
            let pdfFilePath = URL.init(fileURLWithPath: fileUrl)
            if FileManager.default.fileExists(atPath: pdfFilePath.path) {
                webView.loadFileURL(pdfFilePath, allowingReadAccessTo: documentDirectory)
            } else {
                print("Tệp PDF không tồn tại.")
            }
        } else {
            self.webView.reload()
        }
    }
    
    @IBAction func btnDownloadPressed(_ sender: Any) {
        self.fileUrl = nil
        self.viewPdf()
        self.lblStatus.text = "Download status: doing"
        self.downloader?.stop()
        self.downloader = MADownloader()
        self.downloader?.download(
            url: "https://bachvanthe1994.github.io/demo/01.%20Chiec%20Khan%20Bien%20Hoa.pdf",
            fileName: "01. Chiec Khan Bien Hoa.pdf"
        ) { [weak self] fileUrl, message, error in
            guard let self = self else { return }
            self.fileUrl = fileUrl
            DispatchQueue.main.async {
                if let error = error {
                    self.lblStatus.text = "Download status: Error: \(error)"
                } else {
                    self.lblStatus.text = "Download status: Done"
                    self.viewPdf()
                }
            }
        } progress: { [weak self] downloadSize, totalSize in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.lblSize.text = "\(self.formatBytes(Int64(downloadSize)))/\(self.formatBytes(Int64(totalSize)))"
                self.lblPercent.text = "\(Int(downloadSize * 100 / totalSize))%"
            }
        }
        
    }
    
}

