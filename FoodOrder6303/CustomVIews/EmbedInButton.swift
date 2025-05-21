//
//  EmbedInButton.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 14.04.2025.
//

import SwiftUI

struct EmbedInButton: ViewModifier {
    var isPrime: Bool = true
    var cornRadius: CGFloat = 100
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(isPrime ? .bgMain : .prime)
            .padding(13)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: cornRadius)
                    .fill(isPrime ? Color.prime : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornRadius)
                    .stroke(Color.prime, lineWidth: isPrime ? 0 : 1)
            )
    }
}

extension View {
    func embedInButton(isPrime: Bool = true, cornRadius: CGFloat = 100) -> some View {
        self.modifier(EmbedInButton(isPrime: isPrime, cornRadius: cornRadius))
    }
}

#Preview {
    Text("Ok")
        .embedInButton()
}
