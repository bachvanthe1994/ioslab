//
//  MenuUsingListView.swift
//  lab11
//
//  Created by thebv on 30/10/2024.
//

import SwiftUI

struct MenuUsingListView: View {
    var body: some View {
        NavigationStack {
            List {
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
            }
            .navigationTitle("Menu")
        }
    }
}

struct MenuUsingListView_Previews: PreviewProvider {
    static var previews: some View {
        MenuUsingListView()
    }
}
