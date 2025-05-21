import SwiftUI

struct LoginView: View {
    @EnvironmentObject var mainVM: MainVM
    @State private var isLogin: Bool = true

    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            VStack(spacing: 86) {
                Text("Delvel")
                    .font(.system(.largeTitle, weight: .bold))
                    .foregroundColor(.textMain)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 30)
            
            VStack(spacing: 86) {
                Spacer()
                textFields
                btns
            }
            .padding(.horizontal)
            .padding(.vertical, 30)

            LoadProgressView()
                .opacity(mainVM.isLoad ? 1 : 0)
                .animation(.spring, value: mainVM.isLoad)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert(item: $mainVM.alertItem, content: { alertItem in
            Alert(title:         alertItem.title,
                  message:       alertItem.message,
                  dismissButton: alertItem.btns)
        })
    }

    var textFields: some View {
        VStack(spacing: 20) {
            TextField("Ввести", text: $mainVM.login)
                .embedInTextFieldLogin(title: isLogin ? "Логин" : "Email  (является логином)", isSelected: true)
                .animation(nil, value: isLogin)

            if !isLogin {
                TextField("Ввести", text: $mainVM.nameAccount)
                    .embedInTextFieldLogin(title: "Имя", isSelected: true)
                TextField("+7 937 123 45 67", text: $mainVM.phoneAccount)
                    .embedInTextFieldLogin(title: "Телефон", isSelected: true)
            }

            SecureField("Ввести", text: $mainVM.password)
                .embedInTextFieldLogin(title: "Пароль", isSelected: true)
        }
        .disableAutocorrection(true)
        .autocapitalization(.none)
    }

    var btns: some View {
        VStack(spacing: 13) {
            Button {
                login()
            } label: {
                Text("Войти")
                    .font(.system(size: 15, weight: .bold))
                    .embedInButton(isPrime: isLogin)
            }

            Button {
                register()
            } label: {
                Text("Зарегистрироваться")
                    .font(.system(size: 15, weight: .bold))
                    .embedInButton(isPrime: !isLogin)
            }
        }
    }

    private func login() {
        guard isLogin else {
            withAnimation {
                isLogin = true
            }
            return
        }

        guard validateLogin() && validatePassword() else { return }
        mainVM.checkAccount()
    }

    private func register() {
        guard !isLogin else {
            withAnimation {
                isLogin = false
            }
            return
        }

        guard validateLogin(), validatePassword(), validateName(), validatePhone(), validateEmail() else { return }
        mainVM.createAccount()
    }

    // MARK: - Validation methods

    private func validateLogin() -> Bool {
        if mainVM.login.count < 4 {
            mainVM.alertItem = AlertItem(title: Text("Ошибка"),
                                         message: Text("Логин должен быть от 4 символов."),
                                         btns: .default(Text("Ок")))
            return false
        }
        return true
    }

    private func validatePassword() -> Bool {
        if mainVM.password.count < 4 || mainVM.password.count > 10 {
            mainVM.alertItem = AlertItem(title: Text("Ошибка"),
                                         message: Text("Пароль должен быть от 4 до 10 символов."),
                                         btns: .default(Text("Ок")))
            return false
        }
        return true
    }

    private func validateName() -> Bool {
        if mainVM.nameAccount.count < 2 || mainVM.nameAccount.count > 50 {
            mainVM.alertItem = AlertItem(title: Text("Ошибка"),
                                         message: Text("Имя должно содержать от 2 до 50 символов."),
                                         btns: .default(Text("Ок")))
            return false
        }
        return true
    }

    private func validatePhone() -> Bool {
        let phoneRegex = #"^\+7\s?\(?\d{3}\)?[\s\-]?\d{3}[\s\-]?\d{2}[\s\-]?\d{2}$"#
        if !NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: mainVM.phoneAccount) {
            mainVM.alertItem = AlertItem(title: Text("Ошибка"),
                                         message: Text("Введите корректный номер телефона."),
                                         btns: .default(Text("Ок")))
            return false
        }
        return true
    }

    private func validateEmail() -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: mainVM.login) {
            mainVM.alertItem = AlertItem(title: Text("Ошибка"),
                                         message: Text("Введите корректный email."),
                                         btns: .default(Text("Ок")))
            return false
        }
        return true
    }
}

#Preview {
    LoginView()
        .environmentObject(MainVM())
}
