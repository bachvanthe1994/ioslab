//
//  Demo.swift
//  lab12
//
//  Created by thebv on 01/11/2024.
//

import Foundation
import UIKit
import SwiftyJSON
import Security
import CommonCrypto


// Thêm thông tin xác thực vào header
//request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
func genBasicAuthorization(username: String, password: String) {
    let loginString = "\(username):\(password)"
    guard let loginData = loginString.data(using: .utf8) else { return }
    let base64LoginString = loginData.base64EncodedString()
}


func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            let certificateCount = SecTrustGetCertificateCount(serverTrust)
            var serverPins: [String] = []

            // Tính toán mã pin SHA256 cho từng chứng chỉ
            for index in 0..<certificateCount {
                if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, index) {
                    if let pin = getCertificateSHA256Pin(certificate: serverCertificate) {
                        serverPins.append(pin)
                    }
                }
            }
            
            // Kiểm tra các mã pin
            let expectedPins = ["EXPECTED_PIN_1", "EXPECTED_PIN_2", "EXPECTED_PIN_3"] // Thay thế bằng mã pin thực tế
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
    completionHandler(.performDefaultHandling, nil)
}

// Hàm lấy mã pin SHA256 của chứng chỉ
func getCertificateSHA256Pin(certificate: SecCertificate) -> String? {
    let certData = SecCertificateCopyData(certificate) as Data
    
    // Tính toán mã hash SHA256
    var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    certData.withUnsafeBytes {
        _ = CC_SHA256($0.baseAddress, CC_LONG(certData.count), &hash)
    }

    // Chuyển đổi mã hash thành chuỗi hex
    let pin = hash.map { String(format: "%02hhx", $0) }.joined()
    return pin
}

// Hàm kiểm tra tên miền
func isValidDomain(for certificate: SecCertificate, domain: String) -> Bool {
    // Lấy tên miền từ chứng chỉ
    let summary = SecCertificateCopySubjectSummary(certificate) as String?
    return summary?.contains(domain) ?? false
}


class DataByKey: Codable {
    var key3: String?
}

class DataModel: Codable {
    var data_key1: String?
    var data_key2: String?
}

class ObjectModel: Codable {
    var key1: String?
    var key2: String?
    var obj: DataModel?
}

func decodeJSON<T: Codable>(from input: Any?, to type: T.Type) -> T? {
    guard let input = input else {
        print("decodeJSON Error: input nil")
        return nil
    }
    let data: Data?
    if let value = input as? Data {
        data = value
    } else {
        do {
            data = try JSONSerialization.data(withJSONObject: input)
        } catch {
            print("decodeJSON.JSONSerialization.Error: input invalid: \(error)")
            return nil
        }
    }
    guard let jsonData = data else { return nil }
    do {
        return try JSONDecoder().decode(T.self, from: jsonData)
    } catch {
        print("decodeJSON Error: \(error)")
        return nil
    }
}
