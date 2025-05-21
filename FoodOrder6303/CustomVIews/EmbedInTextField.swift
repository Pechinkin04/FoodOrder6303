import SwiftUI

struct EmbedInTextField: ViewModifier {
    var title: String?
    var isSelected: Bool = false
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title {
                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.textMain)
            }
            content
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? .prime : .textMain, lineWidth: isSelected ? 2 : 1)
                )
                .animation(.default, value: isSelected)
        }
    }
}

extension View {
    func embedInTextField(title: String? = nil, isSelected: Bool = false) -> some View {
        self.modifier(EmbedInTextField(title: title, isSelected: isSelected))
    }
}

#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
        Text("Hello")
            .embedInTextFieldLogin(title: "Name")
            .padding()
    }
}

struct EmbedInTextFieldLogin: ViewModifier {
    var title: String?
    var isSelected: Bool = false
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if let title {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.textMain)
            }
            content
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Rectangle()
                .fill(isSelected ? .prime : .textMain)
                .frame(height: 1)
        }
        .animation(.default, value: isSelected)
    }
}

extension View {
    func embedInTextFieldLogin(title: String? = nil, isSelected: Bool = false) -> some View {
        self.modifier(EmbedInTextFieldLogin(title: title, isSelected: isSelected))
    }
}
