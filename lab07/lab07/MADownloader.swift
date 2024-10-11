//
//  MCDownloader.swift
// 
//
//  Created by thebv on 29/12/2022.
//  Copyright © 2022. All rights reserved.
//

import UIKit

enum MADownloaderErrorType {
    case errorUnknow
    case errorNetwork3GWifi
    case errorUrlNil
}

typealias MADownloaderCompleteCallback = (_ fileUrl: String?, _ message: String?, _ error: MADownloaderErrorType?) -> Void
typealias MADownloaderProgressCallback = (_ downloadSize: Double, _ totalSize: Double) -> Void

class MADownloader: NSObject, URLSessionDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {
    
    private var session: URLSession!
    private var dataTask: URLSessionDataTask!
    private var fileUrl: URL!
    private var taskId: UIBackgroundTaskIdentifier?
    private var downloadSize: Double = 0
    private var callback: MADownloaderCompleteCallback?
    private var progress: MADownloaderProgressCallback?
    
    deinit {
        print("deinit \(self)")
    }
    
    func stop() {
        self.callback = nil
        self.progress = nil
        self.dataTask.cancel()
        self.session.invalidateAndCancel()
    }
    
    func readJsonFileFromUrl(url: String, callback: @escaping ([String:Any]?, Error?) -> Void) {
        let url = URL(string: url)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let obj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                    callback(obj, nil)
                } else {
                    callback(nil, NSError.init(domain: "com.thebv.lab07", code: 01, userInfo: [NSLocalizedDescriptionKey: "jsonObject data nil"]))
                }
            } catch {
                print(NSException.init(name: .rangeException, reason: error.localizedDescription))
                print(error)
                callback(nil, NSError.init(domain: "com.thebv.lab07", code: 01, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
            }
        }
        task.resume()
    }
    
    func checkFileExists(filePath: String) -> Bool {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            print("checkFileExists: FILE AVAILABLE: \(filePath)")
            return true
        } else {
            print("checkFileExists: FILE NOT AVAILABLE: \(filePath)")
            return false
        }
    }
    
    func download(
        url: String,
        fileName: String,
        callback: @escaping MADownloaderCompleteCallback,
        progress: @escaping MADownloaderProgressCallback
    ) {
        // get path of directory
        self.callback = callback
        self.progress = progress
        self.downloadSize = 0
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        // create file url
        fileUrl = directory.appendingPathComponent(fileName)
        do {
            print("fileUrl.path: \(fileUrl.path)")
            print("fileUrl.path checkFileExists: \(self.checkFileExists(filePath: fileUrl.path))")
            try FileManager.default.removeItem(atPath: fileUrl.path)
        } catch let error as NSError {
            print(NSException.init(name: .rangeException, reason: error.localizedDescription))
            print("Unable to remove file \(error.debugDescription)")
        }
        print("fileUrl.path checkFileExists: \(checkFileExists(filePath: fileUrl.path))")
        
        // starts download
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.thebv.lab07")
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        if let URLDownload = URL(string: url) {
            var request: URLRequest? = URLRequest(url: URLDownload)
            request?.cachePolicy = .reloadIgnoringLocalCacheData
            if let request = request {
                self.taskId = UIApplication.shared.beginBackgroundTask(withName: "\(Date().timeIntervalSince1970)")
                dataTask = session.dataTask(with: request)
                dataTask.resume()
            } else {
                self.callback?(nil, "MCDownloader download url nil: \(url)", .errorUrlNil)
            }
        } else {
            self.callback?(nil, "MCDownloader download url nil: \(url)", .errorUrlNil)
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("dataTask.response: \(String(describing: dataTask.response))")
        downloadSize += Double(data.count)
        writeToFile(data: data)
        ((dataTask.response as? HTTPURLResponse)?.allHeaderFields as? [String: AnyObject])?.forEach({ obj in
            if (obj.key == "Content-Length") {
                print("obj.value: \(obj.value)")
                if let total = Double("\(obj.value)") {
                    self.progress?(downloadSize, total)
                }
            }
        })
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
        completionHandler(URLSession.ResponseDisposition.allow)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("task.response: \(String(describing: task.response))")
        
        if let taskId = self.taskId {
            UIApplication.shared.endBackgroundTask(taskId)
        }
        
        let responseStatusCode = (task.response as? HTTPURLResponse)?.statusCode
        if (error == nil && responseStatusCode == 200) {
            // download complete without any error
            print("download complete: \(fileUrl.path)")
            self.callback?(fileUrl.path, nil, nil)
        } else {
            // error during download
            print("download complete ERROR: \(String(describing: error))")
            var code = (error as NSError?)?.code
            if (code == nil) {
                code = responseStatusCode
            }
            if (code == NSURLErrorNotConnectedToInternet
                || code == NSURLErrorDataNotAllowed
                || code == NSURLErrorNetworkConnectionLost) {
                self.callback?(nil, error?.localizedDescription, .errorNetwork3GWifi)
            } else {
                self.callback?(nil, error?.localizedDescription, .errorUnknow)
            }
        }
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("--------------------")
        print("didSendBodyData: \(bytesSent)")
        print("totalBytesSent: \(totalBytesSent)")
        print("totalBytesExpectedToSend: \(totalBytesExpectedToSend)")
    }

    func writeToFile(data: Data) {
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            if let fileHandle = FileHandle(forWritingAtPath: fileUrl.path) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            } else {
                //TODO: Can't open file to write
                print("writeToFile Error: Can't open file to write")
            }
        } else {
            do {
                try data.write(to: fileUrl, options: .atomic)
            } catch {
                print(NSException.init(name: .rangeException, reason: error.localizedDescription))
                //TODO: Can't open file to write
                print("writeToFile Error: \(error)")
            }
        }
    }
}
