//
//  APError.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 12.03.2025.
//

import Foundation
import SwiftUI

enum APError: Error {
    case invalidData
    case invalidError
//    case requestFailed(Error)
    
    // MARK: - FireStore
    case uploadDishError
    case invalidCredentials
    case accountCreationError
    case accountUpdateError
    case accountDeletionError
    case deleteDishError
    
    case orderCreationError
    case orderUpdateError
    case orderDeleteError
    
    // MARK: - Dropbox
    case uploadFileDropboxError
    case previewLinkDropboxError
    case deleteFileDropboxError
//    case deleteFileDropboxSuccess
    
    var alert: AlertItem {
        switch self {
            case .invalidData: AlertItem(title: Text("Ошибка сервера"),
                                         message: Text("Данные, полученные с сервера, недействительны. Пожалуйста, свяжитесь со службой поддержки."),
                                         btns: .default(Text("Ок")))
                
            // MARK: - FireStore
                
            case .uploadDishError: AlertItem(title: Text("Ошибка загрузки блюда"),
                                             message: Text("Не удалось загрузить блюдо, попробуйте позже."),
                                             btns: .default(Text("Ок")))
                
            case .invalidCredentials: AlertItem(title: Text("Ошибка авторизации"),
                                                message: Text("Ошибка при проверке аккаунта"),
                                                btns: .default(Text("Ок")))
                
            case .accountCreationError: AlertItem(title: Text("Ошибка создания аккаунта"),
                                                  message: Text("Не удалось создать аккаунт. Попробуйте позже."),
                                                  btns: .default(Text("Ок")))
                
            case .accountUpdateError: AlertItem(title: Text("Ошибка обновления аккаунта"),
                                                message: Text("Не удалось обновить аккаунт. Попробуйте позже."),
                                                btns: .default(Text("Ок")))
            case .accountDeletionError: AlertItem(title: Text("Ошибка удаления аккаунта"),
                                                  message: Text("Не удалось удалить аккаунт. Попробуйте позже."),
                                                  btns: .default(Text("Ок")))
                
            case .deleteDishError: AlertItem(title: Text("Ошибка при удалении блюда"),
                                             message: Text("Попробуйте позже"),
                                             btns: .default(Text("Ок")))
                
            case .orderCreationError: AlertItem(title: Text("Ошибка создания заказа"),
                                                message: Text("Попробуйте позже"),
                                                btns: .default(Text("Ок")))
                
            case .orderUpdateError: AlertItem(title: Text("Ошибка обновления заказа"),
                                                message: Text("Попробуйте позже"),
                                                btns: .default(Text("Ок")))
                
            case .orderDeleteError: AlertItem(title: Text("Ошибка при удалении заказа"),
                                                message: Text("Попробуйте позже"),
                                                btns: .default(Text("Ок")))
                
            // MARK: - DropBox
                
            case .uploadFileDropboxError: AlertItem(title: Text("Ошибка загрузки фото"),
                                                    message: Text("Не удалось загрузить изображение в Dropbox. Попробуйте позже."),
                                                    btns: .default(Text("Ок")))
                
            case .previewLinkDropboxError: AlertItem(title: Text("Ошибка получения ссылки"),
                                                     message: Text("Не удалось получить ссылку на изображение в Dropbox. Попробуйте позже."),
                                                     btns: .default(Text("Ок")))
                
            case .deleteFileDropboxError: AlertItem(title: Text("Ошибка удаления фото"),
                                                    message: Text("Не удалось удалить изображение в Dropbox. Попробуйте позже."),
                                                    btns: .default(Text("Ок")))
                
            default: AlertItem(title: Text("Неизвестная ошибка"),
                               message: Text("Обратитесь к разработчику или попробуте позже."),
                               btns: .default(Text("Ок")))
        }
    }
}
