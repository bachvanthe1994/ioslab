//
//  DecodeHelper.swift
//  lab11
//
//  Created by thebv on 24/10/2024.
//

import Foundation


struct TestModal: Codable {
    var name: String
    var age: Int
}

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) in bundle.")
        }
        
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        
        let testModal = TestModal(name: "TheBV", age: 30)
        
        let json = try? encoder.encode(testModal)
        print("json: \(json)")
        
        guard let result = try? decoder.decode(type.self, from: data) else {
            fatalError("Failed to decode \(file) in bundle.")
        }
        
        return result
    }
}
