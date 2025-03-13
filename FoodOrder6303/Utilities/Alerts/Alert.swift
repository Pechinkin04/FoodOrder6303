//
//  Alert.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 12.03.2025.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let btns: Alert.Button
}

struct AlertContext {
    //MARK: - Network Alerts
    static let invalidData      = AlertItem(title: Text("Ошибка сервера"),
                                            message: Text("Данные, полученные с сервера, недействительны. Пожалуйста, свяжитесь со службой поддержки."),
                                            btns: .default(Text("Ок")))
    
    // MARK: - Dropbox Alerts
//    uploadFileDropboxError
//    case previewLinkDropboxError
//    case deleteFileDropboxError
//    static let upload
    
    static let invalidFail      = AlertItem(title: Text("Неизвестная ошибка"),
                                            message: Text("Обратитесь к разработчику или попробуте позже."),
                                            btns: .default(Text("Ок")))
}
