//
//  AdminClientsView.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import SwiftUI

struct AdminClientsView: View {
    @EnvironmentObject var mainVM: MainVM
    
    @State private var searchClient: String = ""
    var clients: [Client] {
        guard !searchClient.isEmpty else { return mainVM.accounts.filter({ $0.role == .client }) }
        
        return mainVM.accounts.filter {
            $0.role == .client &&
            (
            $0.name.lowercased().contains(searchClient.lowercased()) ||
            $0.phone.lowercased().contains(searchClient.lowercased()) ||
            $0.login.lowercased().contains(searchClient.lowercased())
            )
        }
    }
    
    var body: some View {
        NavigationStack {
            info
            
                .navigationTitle("Клиенты")
        }
        
        .searchable(text: $searchClient, placement: .navigationBarDrawer(displayMode: .always), prompt: "Поиск клиента")
    }
    
    var info: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 10) {
                ForEach(clients) { client in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(client.name)
                            .font(.system(.title2, weight: .semibold))
                            .foregroundColor(.textMain)
                        
                        Text("\(client.login)")
                            .font(.system(.headline, weight: .medium))
                            .foregroundColor(.textMain)
                        
                        Text("\(client.phone)")
                            .font(.system(.subheadline, weight: .medium))
                            .foregroundColor(.textMain)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.bgMain)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                }
            }
            .padding()
        }
    }
}

#Preview {
    AdminClientsView()
        .environmentObject(MainVM())
}
