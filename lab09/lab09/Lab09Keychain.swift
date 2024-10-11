//
//  Lab09Keychain.swift
//  lab09
//
//  Created by thebv on 12/10/2024.
//

import Foundation
import Security
import CommonCrypto

class AES {
    private var key: Data
    private var iv: Data // Initialization Vector

    // Initialize with a 32-byte key (256 bits) and a 16-byte IV (128 bits)
    init(key: String, iv: String) {
        // Ensure the key is 32 bytes (for AES-256)
        self.key = key.data(using: .utf8)!
        // Ensure the IV is 16 bytes
        self.iv = iv.data(using: .utf8)!
    }

    func aesEncrypt(data: Data) -> Data? {
        let keyLength = kCCKeySizeAES256 // 32 bytes for AES-256
        let dataLength = data.count

        // Prepare buffer for encrypted data
        var encryptedData = Data(count: dataLength + kCCBlockSizeAES128)
        var numBytesEncrypted: size_t = 0
        let encryptedDataCount = encryptedData.count
        
        let cryptStatus = encryptedData.withUnsafeMutableBytes { encryptedBytes in
            data.withUnsafeBytes { dataBytes in
                self.key.withUnsafeBytes { keyBytes in
                    self.iv.withUnsafeBytes { ivBytes in
                        CCCrypt(
                            CCOperation(kCCEncrypt), // Encrypt operation
                            CCAlgorithm(kCCAlgorithmAES), // AES algorithm
                            CCOptions(kCCOptionPKCS7Padding), // Padding
                            keyBytes.baseAddress, keyLength, // Key
                            ivBytes.baseAddress, // Initialization Vector
                            dataBytes.baseAddress, dataLength, // Data to encrypt
                            encryptedBytes.baseAddress, encryptedDataCount, // Buffer for encrypted data
                            &numBytesEncrypted // Output: number of bytes encrypted
                        )
                    }
                }
            }
        }

        guard cryptStatus == kCCSuccess else {
            print("Error in encryption: \(cryptStatus)")
            return nil
        }

        return encryptedData.prefix(numBytesEncrypted) // Return only the encrypted data
    }

    func aesDecrypt(data: Data) -> Data? {
        let keyLength = kCCKeySizeAES256
        let dataLength = data.count

        // Prepare buffer for decrypted data
        var decryptedData = Data(count: dataLength)
        var numBytesDecrypted: size_t = 0
        let decryptedDataCount = decryptedData.count
        
        // Use a local variable for the decrypted data buffer
        let cryptStatus = decryptedData.withUnsafeMutableBytes { decryptedBytes in
            data.withUnsafeBytes { dataBytes in
                self.key.withUnsafeBytes { keyBytes in
                    self.iv.withUnsafeBytes { ivBytes in
                        CCCrypt(
                            CCOperation(kCCDecrypt), // Decrypt operation
                            CCAlgorithm(kCCAlgorithmAES), // AES algorithm
                            CCOptions(kCCOptionPKCS7Padding), // Padding
                            keyBytes.baseAddress, keyLength, // Key
                            ivBytes.baseAddress, // Initialization Vector
                            dataBytes.baseAddress, dataLength, // Data to decrypt
                            decryptedBytes.baseAddress, decryptedDataCount, // Buffer for decrypted data
                            &numBytesDecrypted // Output: number of bytes decrypted
                        )
                    }
                }
            }
        }

        guard cryptStatus == kCCSuccess else {
            print("Error in decryption: \(cryptStatus)")
            return nil
        }

        return decryptedData.prefix(numBytesDecrypted) // Return only the decrypted data
    }
}


class Lab09Keychain {
    
    private let service: String
    private let aes: AES
    
    init(service: String, encryptionKey: String) {
        self.service = service
        
        let key = encryptionKey // 32 bytes key for AES-256
        let iv = "abcdefghijklmnop" // 16 bytes IV for AES
        self.aes = AES(key: key, iv: iv)
    }
    
    func set(key: String, value: String) -> Bool {
        guard let encryptedKey = self.aes.aesEncrypt(data: key.data(using: .utf8)!),
              let encryptedValue = self.aes.aesEncrypt(data: value.data(using: .utf8)!) else {
            return false
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: encryptedKey,
            kSecValueData as String: encryptedValue,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        SecItemDelete(query as CFDictionary) // Xóa mục nhập cũ nếu có
        
        let status = SecItemAdd(query as CFDictionary, nil) // Thêm mục mới
        return status == errSecSuccess
    }
    
    func get(key: String) -> String? {
        guard let encryptedKey = self.aes.aesEncrypt(data: key.data(using: .utf8)!) else {
            return nil
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: encryptedKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let encryptedData = dataTypeRef as? Data {
            if let decryptedValue = self.aes.aesDecrypt(data: encryptedData),
               let result = String(data: decryptedValue, encoding: .utf8) {
                return result
            }
        }
        return nil
    }
    
    func delete(key: String) -> Bool {
        guard let encryptedKey = self.aes.aesEncrypt(data: key.data(using: .utf8)!) else {
            return false
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: encryptedKey
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
