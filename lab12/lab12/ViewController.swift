//
//  ViewController.swift
//  lab12
//
//  Created by thebv on 31/10/2024.
//

import UIKit
import AnyCodable
import SwiftyJSON
import Security
import CommonCrypto
import CryptoKit


/*
 {
     "id":"ff80818192925da70192e7f7cfa04149",
     "name":"Apple MacBook Pro 16",
     "createdAt":"2024-11-01T13:43:50.432+00:00",
     "data":{
         "CPU model":"Intel Core i9",
         "price":1849.99,
         "year":2019,
         "Hard disk size":"1 TB"
     }
 }
 */

struct PostResponseModel: Codable {
    var id: String?
    var name: String?
    var name2: String?
    var createdAt: String?
    var data: [String: AnyCodable]?
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func perfromGet() {
        print("perfromGet do")
        let api = "https://api.restful-api.dev/objects";
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        let session = URLSession(configuration: config)
        guard let url = URL.init(string: api) else {
            print("URL không hợp lệ")
            return
        }
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Lỗi: \(error)")
                return
            }
            guard let data = data else {
                print("Không có dữ liệu trả về")
                return
            }
            do {
                let html = String(data: data, encoding: .utf8)
                print("html: \(html ?? "")")
//                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
//                    print("Dữ liệu nhận được: \(json)")
//                } else {
//                    print("Dữ liệu không phải dạng JSON")
//                }
            } catch {
                print("Lỗi khi xử lý dữ liệu: \(error)")
            }
        }
        task.delegate = self
        task.resume()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: DispatchWorkItem(block: {
//            task.cancel()
//        }))
    }
    
    func performPost() {
        print("performPost do")
        let api = "https://api.restful-api.dev/objects";
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 180
        config.timeoutIntervalForResource = 180
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(configuration: config)
        guard let url = URL.init(string: api) else {
            print("URL không hợp lệ")
            return
        }
        let body: [String: Any] = [
            "name": "Apple MacBook Pro 16",
            "data": [
                "year": 2019,
                "price": 1849.99,
                "CPU model": "Intel Core i9",
                "Hard disk size": "1 TB"
            ]
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("body không hợp lệ")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Lỗi: \(error)")
                return
            }
            guard let data = data else {
                print("Không có dữ liệu trả về")
                return
            }
            do {
                let html = String(data: data, encoding: .utf8)
                print("html: \(html ?? "")")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let model = decodeJSON(from: json, to: PostResponseModel.self)
                    let user = model?.data?["data1"]?.value as? String ?? ""
                    let user2 = model?.data?["data2"]?.value as? String ?? ""
//                    print("Dữ liệu nhận được: \(cpuModel)")
                } else {
                    print("Dữ liệu không phải dạng JSON")
                }
            } catch {
                print("Lỗi khi xử lý dữ liệu: \(error)")
            }
        }
        task.delegate = self
        task.resume()
    }
    
    func performError() {
        print("performError do")
        let api = "https://api.restful-api.dev/objects";
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(configuration: config)
        guard let url = URL.init(string: api) else {
            print("URL không hợp lệ")
            return
        }
        let body: [String: Any] = [
            "name": "Apple MacBook Pro 16",
            "data": [
                "year": 2019,
                "price": 1849.99,
                "CPU model": "Intel Core i9",
                "Hard disk size": "1 TB"
            ]
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            print("body không hợp lệ")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request) { data, response, error in
            if let r = response as? HTTPURLResponse {
                print("r: \(r)")
            }
            if let error = error as? URLError {
                //print("Lỗi: \(error)")
                switch error.code {
                case .cannotFindHost:
                    print("Lỗi: cannotFindHost")
                    break
                case .cannotConnectToHost:
                    print("Lỗi: cannotConnectToHost")
                    break
                default:
                    print("Lỗi: \(error)")
                    break
                }
                
                return
            }
            guard let data = data else {
                print("Không có dữ liệu trả về")
                return
            }
            do {
//                let html = String(data: data, encoding: .utf8)
//                print("html: \(html ?? "")")
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Dữ liệu nhận được: \(json)")
                } else {
                    print("Dữ liệu không phải dạng JSON")
                }
            } catch {
                print("Lỗi khi xử lý dữ liệu: \(error)")
            }
        }
        task.delegate = self
        task.resume()
    }
    
    @IBAction func btnPerfromGetPressed(_ sender: Any) {
        self.perfromGet()
    }
    
    @IBAction func btnPerfromPostPressed(_ sender: Any) {
        self.performPost()
    }
    
    @IBAction func btnPerfromErrorPressed(_ sender: Any) {
        self.performError()
    }
}


//bảo mật
extension ViewController: URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                let certificateCount = SecTrustGetCertificateCount(serverTrust)
                var serverPins: [String] = []

                // Tính toán mã pin SHA256 cho từng chứng chỉ
                for index in 0..<certificateCount {
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, index) {
                        if let pin = getPublicKeyData(from: serverCertificate) {
                            if (isValidDomain(for: serverCertificate, domain: "restful-api.dev")) {
                                serverPins.append(pin)
                            }
                        }
                    }
                }
                print("serverPins: \(serverPins)")
                // Kiểm tra các mã pin
                let expectedPins = [
                    "sha256/ogfvRAVy5aWzqjD8Yy7SYNCm39rwoOlxonjMTgajWHE=",
                    "sha256/F3jGgttHVtSma2SMH+G1E4HzvVvvdIj2ntUG79K0hX0=",
                    "sha256/T2tSOvwzOpDlD0swkfKp91HsepNcVu9v5ORLv8e0yzY="
                ] // Thay thế bằng mã pin thực tế
                
                //ít nhất 1 mã pin hợp lệ
                //vì trong quá trình cấp phép or gia hạn lại cert
                //thông số pin có thể thay đổi
                for expectedPin in expectedPins {
                    if serverPins.contains(expectedPin) {
                        // Nếu mã pin hợp lệ, cấp quyền
                        let credential = URLCredential(trust: serverTrust)
                        completionHandler(.useCredential, credential)
                        return
                    }
                }
            }
        }
        // Nếu không tin tưởng, thực hiện xử lý mặc định
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
    
    func getPublicKeyData(from certificate: SecCertificate) -> String? {
        // Tạo policy X509
        let policy = SecPolicyCreateBasicX509()
        
        // Tạo SecTrust từ chứng chỉ
        var trust: SecTrust?
        let status = SecTrustCreateWithCertificates(certificate, policy, &trust)
        
        guard status == errSecSuccess, let trust = trust else {
            return nil
        }
        
        // Đánh giá SecTrust để lấy public key
        var result = SecTrustResultType.invalid
        SecTrustEvaluate(trust, &result)
        guard let publicKey = SecTrustCopyKey(trust) else {
            return nil
        }
        guard let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) else {
            return nil
        }
        
        return sha256(publicKeyData: publicKeyData as Data)
    }
    
    func sha256(publicKeyData: Data) -> String? {
        // ASN1 header cho khóa RSA 2048
        let rsa2048Asn1Header: [UInt8] = [
            0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
            0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
        ]
        
        // Khởi tạo SHA-256 context
        var shaCtx = CC_SHA256_CTX()
        CC_SHA256_Init(&shaCtx)
        
        // Thêm header ASN1 vào hàm băm
        CC_SHA256_Update(&shaCtx, rsa2048Asn1Header, CC_LONG(rsa2048Asn1Header.count))
        
        // Thêm public key
        publicKeyData.withUnsafeBytes {
            _ = CC_SHA256_Update(&shaCtx, $0.baseAddress, CC_LONG(publicKeyData.count))
        }
        
        // Tạo dữ liệu băm SHA-256
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256_Final(&hash, &shaCtx)
        
        // Chuyển đổi thành Base64
        let hashData = Data(hash)
        let base64Hash = "sha256/\(hashData.base64EncodedString(options: .endLineWithLineFeed))"
        
        return base64Hash
    }

    
    // Hàm kiểm tra tên miền
    func isValidDomain(for certificate: SecCertificate, domain: String) -> Bool {
        // Lấy tên miền từ chứng chỉ
        let summary = SecCertificateCopySubjectSummary(certificate) as String?
        return summary?.contains(domain) ?? false
    }

}

