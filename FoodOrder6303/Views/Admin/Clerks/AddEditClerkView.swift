//
//  AddEditClerkView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import SwiftUI

struct AddEditClerkView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var adminVM: AdminVM
    
    private enum ClerkEditFocusedState {
        case name
        case login
        case password
    }
    
    @State var clerk: Client = Client(role: .courier)
    var isNew: Bool
    var isDisabled: Bool {
        clerk.name.isEmpty ||
        clerk.login.isEmpty ||
        clerk.password.isEmpty
    }
    
    @FocusState private var focusedState: ClerkEditFocusedState?
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            
            info
            
            if adminVM.isLoad {
                LoadProgressView()
            }
        }
        .animation(.default, value: adminVM.isLoad)
        .onTapGesture {
            hideKeyboard()
        }
        
        .alert(item: $adminVM.alertItem, content: { alertItem in
            Alert(title:         alertItem.title,
                  message:       alertItem.message,
                  dismissButton: alertItem.btns)
        })
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(isNew ? "Добавить" : "Изменить")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if isNew {
                        adminVM.createClerk(clerk: clerk)
                    } else {
                        adminVM.updateClerk(clerk)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Сохранить")
                }
                .disabled(isDisabled)
            }
        }
    }
    
    var info: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                TextField("Ввести", text: $clerk.name)
                    .embedInTextField(title: "Имя", isSelected: focusedState == .name)
                    .focused($focusedState, equals: .name)
                    .onTapGesture { focusedState = .name }
                    .onSubmit { focusedState = .login }
                
                TextField("Ввести", text: $clerk.login)
                    .embedInTextField(title: "Логин", isSelected: focusedState == .login)
                    .focused($focusedState, equals: .login)
                    .onTapGesture { focusedState = .login }
                    .onSubmit { focusedState = .password }
                
                HStack(spacing: 4) {
                    TextField("Ввести", text: $clerk.password)
                }
                .embedInTextField(title: "Пароль", isSelected: focusedState == .password)
                    .focused($focusedState, equals: .password)
                    .onTapGesture { focusedState = .password }
                    .onSubmit { focusedState = nil }
                
                Menu {
                    ForEach(Role.allCases) { role in
                        if role != .client {
                            Button {
                                clerk.role = role
                            } label: {
                                Text("\(role.raw)\(role.emoji)")
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text("\(clerk.role.raw)")
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down")
                    }
                    .embedInTextField(title: "Роль сотрудника")
                }
            }
            .foregroundStyle(.textMain)
            .padding(16)
        }
    }

}

#Preview {
    NavigationStack {
        AddEditClerkView(clerk: Client(role: .courier), isNew: true)
            .environmentObject(AdminVM())
    }
}
