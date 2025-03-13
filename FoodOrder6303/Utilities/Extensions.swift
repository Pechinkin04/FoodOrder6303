import Foundation
import SwiftUI


// MARK: - Allow swipes
extension UINavigationController: UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return viewControllers.count > 1
    }
}


extension Date {
    func toStringDays(format: String = "dd.MM.yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toStringHours(format: String = "dd.MM.yyyy, HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension Bundle {
    var version: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    var build: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

public func hideKeyboard() {
    UIApplication.shared.endEditing()
}

let amountFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.zeroSymbol = ""
    formatter.allowsFloats = false // Разрешить ввод дробей
    formatter.maximumFractionDigits = 0 // Максимальное количество знаков после запятой
    return formatter
}()

let amountFormatterDouble: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.zeroSymbol = ""
    formatter.allowsFloats = true // Разрешить ввод дробей
    formatter.maximumFractionDigits = 2 // Максимальное количество знаков после запятой
    return formatter
}()


extension UserDefaults {
    func getArray<T: Codable>(forKey key: String)  -> [T] {
        if let data = data(forKey: key), let array = try? JSONDecoder().decode([T].self, from: data) {
            return array
        }
        return []
    }
    
    func setArray<T: Codable>(_ array: [T], forKey key: String) {
        if let encoded = try? JSONEncoder().encode(array) {
            set(encoded, forKey: key)
        }
    }
    
    func getDate(forKey key: String)  -> Date {
        if let data = data(forKey: key), let Date = try? JSONDecoder().decode(Date.self, from: data) {
            return Date
        }
        return Date()
    }
    
    func setDate(_ Date: Date?, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(Date) {
            set(encoded, forKey: key)
        }
    }
}


extension LocalizedStringKey {
    func lastWord() -> String {
        let string = NSLocalizedString(self.localizedString(), comment: "")
        return string.split(separator: " ").last.map(String.init) ?? ""
    }
    
    func localizedString() -> String {
        Mirror(reflecting: self).descendant("key") as? String ?? ""
    }
}
