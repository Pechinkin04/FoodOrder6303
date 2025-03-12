//
//  DropBoxSevice.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 11.03.2025.
//

import Foundation
import SwiftUI

class DropBoxSevice {
    static let shared = DropBoxSevice()
    
    private init() {}
    
    
    private let apiDropbox = "sl.u.AFkVGV2QA05jvQw2biGmsKwOfWH9uBwPjMXjYYqcDSjcRCmiYSzSFlqpLrcxkhBRyrXzBeqyWNXxbD3Dyn_brk7ZfPUGdcHv3hMDMphDVWv1Zxg_AB4s3R9h2Z46zh_yDVtI8b3qeGBXXn4lWvhOzcVZReQTXnCLF5MXTLyemqqlp03TQ35t7Kt5_84yNdehy85RP7W8cot8NtGzIA2pdaH78OTBc0D_W86HNIPawYjVf4ox8DXmGCLQWgXTHEnZ8WsAZevdXKp-J6VZp0j7_VPV3OyBPUzNv2oDU5NVT30dcHc90R8OnlWyf2V0BS050hkMEPi65nGG-F0PUIemINT8vvTulAiJIgnDFz1W86OAdRdw6SquUr_IH0V9fQyG7nKisGnj9vhBmhSJW0J9PTSlzUitLfwQzexpDLdtWBKLAIgE3Dr67F_H9d5QN891UbdHxYNtR6Efn4XKl42b1SOnKqVxbh0BXIF8kjjcod_4A4Cor1ghNuxi0_GvzH9TmkjkIWHDefA0AHw_G-JavwHcLHn68AjHb4fhf1WFUNSSSJxCPTk0uiKJdMmO2WnX1a9fvE0xtvMQ1_Ekzo6AD0Tr4LKpLU76hm0eKHx8_nMfh5fJFVLPw4Ro_4LjcCN3eeEKABMQ2jJv_4vP8cm9pC1JOXJ8aluQ4G3Oql6M16wrNhWlqM4IPYY72Iu_CF7sO-3QDUz86mIzC-pf5GFcz-LY1N-tHhCn5N8Q2XJx4CJf90w0DbJbcgxkGO85b4X3wwbRp8uyWbrsACVikH3xxnBc4zpt_xxLMvNHwqIQm0QYO43Y1SnI_D_3ZDnTj6_xBr_ExMr78xVyaEQAI_sdxbsGqE2-PRe4nXATh_ME1ijbCW0tynvhpw8qTShU_jCCDE8nGuYcLR_fIfbnbk7WqZpjaXz5z8GOApoFZPuK3HS4gijW4p_dT60S_TiawIhLVmXQm566NG8zDAhHT0ofGLeleoWiunVs-eVwFgcyBLvsZqTljTXsGhQI1tkTLZEGEBq7VeML1gEw1pKrJZa-Xn_A8G6evP9Q8WYXHPVrwUy0NNS2G-BEHrTIynveuKs2sP37CtQ2zsq_rE95ETcp6ms61QrOQo2lgX-A_jLxqtbeic-B-C0lYx896-8VvAypy5BNXX1ImdX2trdlfZyE-5PM1DtYOjSe24jFMeN1F220qobX9vhcSc8HWC7sGuktGhsug5Gtmvp-ZjLfri17g3f7ZB2lfVDW6uJCrLE3ja_uVR6ken0q8OUUzig2NGHCIH4RZ-0QtV7PCbnpYu-9MGWf5ETFGHKWzd8O8vrwIyitr4aTOUzQD9FcR_PjGdEqU3TvNW7_hobGDfOt2aX7rgPBXDhMAh5yGZkaBD9cUL9U6vmkePyzxauzVd-SgU3Ac4teGJ5qF2v-jTSXTQG5U6ifL0GRjcHfZbjttYYpN5TR275PJmo_QvFd9k9XRhGvkgI"
    
    // Функция загрузки изображения в Dropbox
    func uploadImageToDropbox(_ image: UIImage, nameImg: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не удалось конвертировать изображение"])))
            return
        }
        
        let url = URL(string: "https://content.dropboxapi.com/2/files/upload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let accessToken = "\(apiDropbox)"  // ЗАМЕНИ на свой Dropbox API Token
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
//        request.setValue("{\"path\": \"/photo.jpg\", \"mode\": \"add\", \"autorename\": true, \"mute\": false}", forHTTPHeaderField: "Dropbox-API-Arg")
        request.setValue("{\"path\": \"/\(nameImg).jpg\", \"mode\": \"add\", \"autorename\": true, \"mute\": false}", forHTTPHeaderField: "Dropbox-API-Arg")
        
        request.httpBody = imageData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            print(String(data: data!, encoding: .utf8)!)
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let path = json["path_display"] as? String else {
                completion(.failure(NSError(domain: "DropboxError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Ошибка при разборе ответа Dropbox"])))
                return
            }
            
            // Запрашиваем ссылку на скачивание
            self.getDropboxPreviewLink(for: path, accessToken: accessToken, completion: completion)
        }
        
        task.resume()
    }

    // Функция для получения ссылки на изображение
    func getDropboxPreviewLink(for filePath: String, accessToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://api.dropboxapi.com/2/sharing/create_shared_link_with_settings")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["path": filePath]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let link = json["url"] as? String else {
                completion(.failure(NSError(domain: "DropboxError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Ошибка получения ссылки"])))
                return
            }

            // Заменяем "dl=0" на "raw=1" для прямой ссылки на изображение
//            let directPreviewURL = link.replacingOccurrences(of: "?dl=0", with: "?raw=1")
            let directPreviewURL = link.replacingOccurrences(of: "&dl=0", with: "&raw=1")
            print(directPreviewURL)
            // Возвращаем прямую ссылку
            completion(.success(directPreviewURL))
        }

        task.resume()
    }

    // Функция для удаления изображения с помощью ссылки на изображение
    func deleteFileFromDropboxUsingLink(sharedLink: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Получаем метаданные файла по публичной ссылке
        let metadataUrl = URL(string: "https://api.dropboxapi.com/2/sharing/get_shared_link_metadata")!
        var request = URLRequest(url: metadataUrl)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiDropbox)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["url": sharedLink]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            print(String(data: data!, encoding: .utf8)!)
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let path = json["path_lower"] as? String else {
                completion(.failure(NSError(domain: "DropboxError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Ошибка получения метаданных файла"])))
                return
            }
            
            // Теперь, когда мы знаем путь, используем его для удаления файла
            self.deleteFileFromDropbox(filePath: path, completion: completion)
        }
        
        task.resume()
    }
    
    // Функция для удаления изображения с помощью указанного пути
    private func deleteFileFromDropbox(filePath: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://api.dropboxapi.com/2/files/delete_v2")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiDropbox)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Подготовка тела запроса с путем файла для удаления
        let body: [String: Any] = ["path": filePath]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            // Если файл успешно удален
            guard let data = data else {
                completion(.failure(NSError(domain: "DropboxError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Ошибка удаления файла"])))
                return
            }

            // Печатаем ответ от сервера (например, путь удаленного файла)
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let deletedFilePath = jsonResponse["metadata"] as? [String: Any],
               let path = deletedFilePath["path_display"] as? String {
                completion(.success("Файл удален по пути: \(path)"))
            } else {
                completion(.failure(NSError(domain: "DropboxError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Ошибка обработки ответа от Dropbox"])))
            }
        }

        task.resume()
    }
}
