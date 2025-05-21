//
//  CourierAccountView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 25.04.2025.
//

import SwiftUI

struct CourierAccountView: View {
    @EnvironmentObject var mainVM: MainVM
    @EnvironmentObject var courierVM: CourierVM
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bgMain.ignoresSafeArea()
                
                info
                
                logoutBtn
                
                if mainVM.isLoad {
                    LoadProgressView()
                }
            }
            .animation(.default, value: mainVM.isLoad)
            .alert(item: $mainVM.alertItem, content: { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.btns)
            })
            
            .navigationTitle("Аккаунт")
        }
    }
    
    var info: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Menu {
                    Button("Работа") {
                        mainVM.account?.isWork = true
                        mainVM.updateAccount()
                    }
                    
                    Button("Отдых") {
                        mainVM.account?.isWork = false
                        mainVM.updateAccount()
                    }
                } label: {
                    Text(mainVM.account?.isWork == true ? "Работа" : "Отдых")
                        .foregroundStyle(.textMain)
                        .embedInTextField(title: "Статус работы")
                }
            }
            .padding()
        }
    }
    
    var logoutBtn: some View {
        Button {
            mainVM.logout()
        } label: {
            Text("Выйти")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red)
                )
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding()
    }
}

#Preview {
    CourierAccountView()
        .environmentObject(MainVM())
        .environmentObject(CourierVM())
}
