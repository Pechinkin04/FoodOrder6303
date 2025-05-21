//
//  ModeratorView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 23.04.2025.
//

import SwiftUI

struct ModeratorView: View {
    @EnvironmentObject var mainVM: MainVM
    @StateObject var modVM = ModeratorVM()
    
    var body: some View {
        TabView(selection: $modVM.tabSelected) {
            ModeratorOrdersView()
                .tabItem {
                    Image(systemName: "menucard.fill")
                    Text("Заказы")
                }.tag(0)
            
            ModeratorHistoryViews()
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("История")
                }.tag(1)
        }
        .environmentObject(modVM)
        .environmentObject(mainVM)
    }
}

#Preview {
    ModeratorView()
        .environmentObject(MainVM())
}
