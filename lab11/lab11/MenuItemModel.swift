//
//  MenuItem.swift
//  lab11
//
//  Created by thebv on 24/10/2024.
//

import Foundation

struct MenuItemModel: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var photoCredit: String
    var price: Int
    var restrictions: [String]
    var description: String
    
    var mainImage: String {
        return name.replacingOccurrences(of: " ", with: "-").lowercased()
    }
}
