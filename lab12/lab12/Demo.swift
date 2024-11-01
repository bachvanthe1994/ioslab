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
