//
//  SecondView.swift
//  lab11
//
//  Created by thebv on 24/10/2024.
//

import Foundation
import SwiftUI


struct SecondView: View {
    
    var item: MenuItemModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomTrailing) {
                Image(self.item.mainImage)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width)
                    .scaledToFit()
                Text("Photo credit: \(self.item.photoCredit)")
                    .font(.system(size: 13))
                    .padding(5)
                    .background(Color.black.opacity(0.5))
                    .foregroundColor(Color.white)
                    .offset(.init(width: -5, height: -5))
                    
            }
            Text(self.item.description).padding(20)
            Spacer()
        }
        .navigationTitle(self.item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        if let item = Bundle.main.decode([MenuCategoryModal].self, from: "menu.json").first?.items.first {
            SecondView(item: item)
        }
    }
}
