//
//  ContentView.swift
//  lab11
//
//  Created by thebv on 23/10/2024.
//

import SwiftUI

struct ContentView: View {
    
    var data = Bundle.main.decode([MenuCategoryModal].self, from: "menu.json")
    
    var body: some View {
        NavigationStack() {
            List {
                ForEach(data) { section in
                    Section(section.name) {
                        ForEach(section.items) { item in
                            NavigationLink(value: item) {
                                ItemView(item: item)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Menu")
            .navigationDestination(for: MenuItemModel.self) { obj in
                SecondView(item: obj)
            }
            .toolbar() {
                EditButton()
            }
        }
    }
}

#Preview {
    ContentView()
}
