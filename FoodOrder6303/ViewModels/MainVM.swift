//
//  MainVM.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class MainVM: ObservableObject {
    
    @AppStorage("accountIDStorage")    var accountID: String = ""
    @AppStorage("loginFoodOrder6303")    var login: String = ""
    @AppStorage("passwordFoodOrder6303") var password: String = ""
    @Published var nameAccount: String = ""
    @Published var phoneAccount: String = ""
    
    @AppStorage("isCorrectAccoutFoodOrder6303") var isCorrectAccout: Bool = false
    @Published var account: Client?
    @Published var accounts: [Client] = []
    
    @Published var alertItem: AlertItem?
    @Published var isLoad: Bool = false
    
    init() {
        if isCorrectAccout {
            checkAccount()
        }
        
        fetchAccounts()
    }
    
    private var db = Firestore.firestore()
    
    public func checkAccount() {
        isLoad = true
        Task {
            do {
                let client = try await FirestoreService.shared.fetchClientAccount(login: login, password: password)
                DispatchQueue.main.async {
                    self.account = client
                    self.isCorrectAccout = true
                    self.accountID = client.id.uuidString
                    
                    self.isLoad = false
                }
            } catch {
                print("Ошибка при проверке аккаунта: \(error)")
                DispatchQueue.main.async { [self] in
                    if let apError = error as? APError {
                        alertItem = apError.alert
                    } else {
                        alertItem = APError.invalidError.alert
                    }
                    
                    isLoad = false
                }
            }
        }
    }
    
    public func createAccount() {
        Task {
            do {
                let newClient = Client(
                    login:      login,
                    password:   password,
                    name:       nameAccount,
                    phone:      phoneAccount,
                    adresses:   [],
                    role:       .client,
                    isWork:     false
                )
                
                try await FirestoreService.shared.createClientAccount(newClient)
                print("Аккаунт успешно создан")
                DispatchQueue.main.async { [self] in
                    isCorrectAccout = true
                    checkAccount()
                }
            } catch {
                print("Ошибка при создании аккаунта: \(error)")
                DispatchQueue.main.async { [self] in
                    if let apError = error as? APError {
                        alertItem = apError.alert
                    } else {
                        alertItem = APError.invalidError.alert
                    }
                    
                    isCorrectAccout = true
                }
            }
        }

    }
    
    public func updateAccount() {
        guard let account else { return }
        isLoad = true
        Task {
            do {
                let updatedClient = Client(
                    id:         account.id,               // обязательно сохраняем ID!
                    login:      login,
                    password:   password,
                    name:       nameAccount,
                    phone:      phoneAccount,
                    adresses:   account.adresses,
                    role:       account.role,
                    isWork:     account.isWork
                )
                
                try await FirestoreService.shared.updateClientAccount(updatedClient)
                print("Аккаунт успешно обновлён")
                
                DispatchQueue.main.async { [self] in
                    self.account = updatedClient
                    isCorrectAccout = true
                }
            } catch {
                print("Ошибка при обновлении аккаунта: \(error)")
                
                DispatchQueue.main.async { [self] in
                    if let apError = error as? APError {
                        alertItem = apError.alert
                    } else {
                        alertItem = APError.invalidError.alert
                    }
                    
                    isCorrectAccout = false
                }
            }
            
            DispatchQueue.main.async {
                self.isLoad = false
            }
        }
    }
    
    public func logout() {
        DispatchQueue.main.async { [self] in
            accountID = ""
            login = ""
            password = ""
            nameAccount = ""
            phoneAccount = ""
            isCorrectAccout = false
            account = nil
        }
    }

    
    func fetchAccounts() {
        db.collection("accounts").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No accounts found")
                return
            }

            do {
                self.accounts = try documents.map { queryDocumentSnapshot -> Client in
                    let data = queryDocumentSnapshot.data()
                    let client = try Firestore.Decoder().decode(Client.self, from: data)
                    return client
                }
            } catch {
                print("Ошибка при декодировании аккаунтов: \(error)")
            }
        }
    }

}
