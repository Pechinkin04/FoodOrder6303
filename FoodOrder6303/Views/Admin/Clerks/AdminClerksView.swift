//
//  AdminClerksView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import SwiftUI

struct AdminClerksView: View {
    @EnvironmentObject var mainVM: MainVM
    @EnvironmentObject var adminVM: AdminVM
    
    @State private var searchCLerk: String = ""
    var clerks: [Client] {
        guard !searchCLerk.isEmpty else { return mainVM.accounts.filter { $0.role != .client } }
        
        return mainVM.accounts.filter {
            $0.role != .client &&
            (
            $0.name.lowercased().contains(searchCLerk.lowercased()) ||
            $0.phone.lowercased().contains(searchCLerk.lowercased()) ||
            $0.login.lowercased().contains(searchCLerk.lowercased())
            )
        }
    }
    
    @State private var delClerk: Client?
    
    var body: some View {
        ZStack {
            NavigationStack {
                info
                
                    .navigationTitle("Сотрудники")
                
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink {
                                AddEditClerkView(clerk: Client(role: .courier, isWork: true), isNew: true)
                                    .environmentObject(adminVM)
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                            .opacity(mainVM.isLoad ? 0 : 1)
                        }
                    }
            }
            
            .searchable(text: $searchCLerk, placement: .navigationBarDrawer(displayMode: .always), prompt: "Поиск сотрудника")
            
            LoadProgressView()
                .opacity(adminVM.isLoad ? 1 : 0)
                .animation(.spring, value: adminVM.isLoad)
        }
        .alert(item: $delClerk) { clerk in
            Alert(title: Text("Удалить \(clerk.name)?"), primaryButton: .cancel(Text("Отмена")), secondaryButton: .destructive(Text("Удалить"), action: {
                adminVM.deleteClerk(clerk)
            }))
        }
    }
    
    var info: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 10) {
                ForEach(clerks) { clerk in
                    NavigationLink {
                        AddEditClerkView(clerk: clerk, isNew: false)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(clerk.name)
                                    .font(.system(.title2, weight: .semibold))
                                    .foregroundColor(.textMain)
                                
                                Text("\(clerk.login)\n\(clerk.phone)")
                                    .font(.system(.headline, weight: .medium))
                                    .foregroundColor(.textMain)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("\(clerk.role.raw) \(clerk.role.emoji)")
                                    .foregroundStyle(.textMain)
                                Spacer()
                                if mainVM.account?.id != clerk.id {
                                    Button {
                                        delClerk = clerk
                                    } label: {
                                        Image(systemName: "trash")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundStyle(.textMain)
                                    }
                                }
                            }
                            .layoutPriority(1)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.bgMain)
                        )
                        .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                    }
                }
            }
            .padding()
            .animation(.default, value: clerks.count)
        }
    }
}

#Preview {
    AdminClerksView()
        .environmentObject(MainVM())
        .environmentObject(AdminVM())
}
