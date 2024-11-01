//
//  ItemView.swift
//  lab11
//
//  Created by thebv on 24/10/2024.
//

import Foundation
import SwiftUI

struct ItemView: View {
    let colors: [String: Color] = ["D": .purple, "G": .black, "N": .red, "S": .blue, "V": .green]
    var item: MenuItemModel
    
    var body: some View {
        HStack() {
            Image(self.item.mainImage)
                .resizable()
                .scaledToFill()
                .overlay(Circle().stroke(Color.black, lineWidth: 2), alignment: .bottom)
                .frame(width: 50, height: 50)
                .clipped()
                .clipShape(.rect(cornerRadii: RectangleCornerRadii.init(topLeading: 25, bottomLeading: 25, bottomTrailing: 25, topTrailing: 25), style: .circular))
            VStack(alignment: .leading, content: {
                Text(self.item.name)
                Text("$\(self.item.price)")
            })
            Spacer()
            ForEach(self.item.restrictions, id: \.self) { restriction in
                Text(restriction)
                    .font(.caption)
                    .padding(5)
                    .background(colors[restriction, default: .black])
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .fontWeight(.black)
            }
        }
    }
}

#Preview {
    if let item = Bundle.main.decode([MenuCategoryModal].self, from: "menu.json").first?.items.first {
        return ItemView(item: item)
    } else {
        return ItemView(item: MenuItemModel(id: "", name: "", photoCredit: "", price: 0, restrictions: [""], description: ""))
    }
}
