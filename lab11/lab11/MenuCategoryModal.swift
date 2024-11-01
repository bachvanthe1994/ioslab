//
//  MenuItem.swift
//  lab11
//
//  Created by thebv on 24/10/2024.
//

import Foundation

struct MenuCategoryModal: Codable, Equatable, Identifiable {
    static func == (lhs: MenuCategoryModal, rhs: MenuCategoryModal) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String
    var name: String
    var items: [MenuItemModel]
}
