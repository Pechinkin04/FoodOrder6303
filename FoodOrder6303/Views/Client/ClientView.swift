//
//  ClientView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import SwiftUI

struct ClientView: View {
    @EnvironmentObject var mainVM: MainVM
    @StateObject var clientVM: ClientVM
    
    @State private var clientAdresses: [Adress] = []
    
    init() {
        _clientVM = StateObject(wrappedValue: ClientVM(account: mockAccountClient))
    }

    
    var body: some View {
        TabView(selection: $clientVM.tabSelected) {
            ClientMenuView(adresses: $clientAdresses)
                .tabItem {
                    Image(systemName: "menucard.fill")
                    Text("Меню")
                }.tag(0)
            
            ClientOrdersView()
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("Заказы")
                }.tag(1)
            
            ClientAccountView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Аккаунт")
                }.tag(2)
        }
        .environmentObject(clientVM)
        .environmentObject(mainVM)
        
        .onAppear {
            clientAdresses = mainVM.account?.adresses ?? []
            print(clientAdresses)
            if let account = mainVM.account {
                clientVM.account = account
            }
        }
        .onChange(of: mainVM.account?.adresses) { newAdresses in
            clientAdresses = newAdresses ?? []
            print(clientAdresses)
        }

    }
}

#Preview {
    ClientView()
        .environmentObject(MainVM())
}
