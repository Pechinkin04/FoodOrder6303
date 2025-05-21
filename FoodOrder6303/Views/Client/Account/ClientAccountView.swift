//
//  ClientAccountView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import SwiftUI

struct ClientAccountView: View {
    @EnvironmentObject var mainVM: MainVM
    @EnvironmentObject var clientVM: ClientVM
    
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
            .animation(.default, value: mainVM.account?.adresses.count)
            .animation(.default, value: mainVM.isLoad)
            
            .navigationTitle("Аккаунт")
        }
    }
    
    var info: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                adresses
            }
            .padding()
        }
    }
    
    var adresses: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Text("Адреса")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.textMain)
                
                Button {
//                    guard let account = mainVM.account else { return }
                    mainVM.account?.adresses.append(Adress(name: ""))
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.textMain)
                        .frame(width: 32, height: 32)
                }
                
                Spacer()
                
                Button {
                    mainVM.updateAccount()
                } label: {
                    Text("Сохранить")
                }
                .buttonStyle(.borderedProminent)
            }
            
            VStack(spacing: 8) {
                if let account = mainVM.account {
                    ForEach(account.adresses.indices, id: \.self) { adrInd in
                        HStack(spacing: 2) {
                            Text("\(adrInd + 1)")
                                .font(.system(size: 17, weight: .semibold))
                                .padding(.horizontal, 4)
                                .frame(width: 50, alignment: .leading)
                            TextField("Адрес", text: Binding(
                                get: { mainVM.account?.adresses[adrInd].name ?? "" },
                                set: { newValue in
                                    mainVM.account?.adresses[adrInd].name = newValue
                                }
                            ))
                        }
                        .padding(.vertical, 6)
                        .foregroundStyle(.textMain)
                        .overlay(
                            Rectangle()
                                .fill(.gray.opacity(0.5))
                                .frame(height: 1)
                                .frame(maxHeight: .infinity, alignment: .bottom)
                        )
                    }
                }

            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
    ClientAccountView()
        .environmentObject(MainVM())
        .environmentObject(ClientVM(account: mockAccountClient))
}
