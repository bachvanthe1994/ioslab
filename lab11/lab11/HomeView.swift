//
//  HomeView.swift
//  lab11
//
//  Created by thebv on 25/10/2024.
//

import Foundation
import UIKit
import SwiftUI

struct HomeView: View {
    
    var body: some View {
        TabView {
            ContentView().tabItem {
                Label.init("Menu", systemImage: "list.dash")
            }
            OrderView().tabItem {
                Label.init("Order", systemImage: "square.and.pencil")
            }
        }
    }
}

#Preview {
    HomeView()
}
