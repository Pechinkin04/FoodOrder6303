//
//  MainView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import SwiftUI

struct MainView: View {
    @StateObject var mainVM: MainVM = MainVM()
    
    var body: some View {
        ZStack {
            if mainVM.isCorrectAccout {
                if let account = mainVM.account {
                    account.role.view
                } else {
                    LoadProgressView()
                }
            } else {
                LoginView()
            }
        }
        .animation(.default, value: mainVM.isCorrectAccout)
        .environmentObject(mainVM)
        
//        .onAppear {
//            mainVM.login = "example@gmail.com"
//            mainVM.password = "12345"
//        }
    }
}

#Preview {
    MainView()
}
