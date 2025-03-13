//
//  DropBoxSevice.swift
//  FoodOrder6303
//
//  Created by Александр Печинкин on 11.03.2025.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

class DropBoxSevice {
    static let shared = DropBoxSevice()
    
    private init() { }
    
    private var db = Firestore.firestore()
    
    func fetchApiKey() {
        db.collection("apiKeyDropBox").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            print(documents)

            if let firstDocument = documents.first {
                let data = firstDocument.data()
                print(data)
                
                if let apiKey = data["key"] as? String {
                    self.apiDropbox = apiKey
//                    print(self.apiDropbox)
                } else {
                    print("API key not found in document")
                }
            }
        }
    }
    
    private var apiDropbox = ""

    // Функция для загрузки изображения
    func uploadImageToDropbox(_ image: UIImage, nameImg: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw APError.invalidData
        }
        
        let url = URL(string: "https://content.dropboxapi.com/2/files/upload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let accessToken = "\(apiDropbox)"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.setValue("{\"path\": \"/\(nameImg).jpg\", \"mode\": \"add\", \"autorename\": true, \"mute\": false}", forHTTPHeaderField: "Dropbox-API-Arg")
        
        request.httpBody = imageData
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let path = json["path_display"] as? String else {
                throw APError.invalidData
            }
            
            return try await getDropboxPreviewLink(for: path, accessToken: accessToken)
        } catch {
            throw APError.uploadFileDropboxError
//            throw APError.requestFailed(error)
        }
    }

    // Функция для получения ссылки изображения
    func getDropboxPreviewLink(for filePath: String, accessToken: String) async throws -> String {
        let url = URL(string: "https://api.dropboxapi.com/2/sharing/create_shared_link_with_settings")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["path": filePath]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let link = json["url"] as? String else {
                throw APError.invalidData
            }
            
            return link.replacingOccurrences(of: "&dl=0", with: "&raw=1")
        } catch {
            print(error.localizedDescription)
            throw APError.previewLinkDropboxError
//            throw APError.requestFailed(error)
        }
    }

    // Функция для удаления изображения по ссылке
    func deleteFileFromDropboxUsingLink(sharedLink: String) async throws -> String {
        let metadataUrl = URL(string: "https://api.dropboxapi.com/2/sharing/get_shared_link_metadata")!
        var request = URLRequest(url: metadataUrl)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiDropbox)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["url": sharedLink]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let path = json["path_lower"] as? String else {
                throw APError.invalidData
            }
            
            return try await deleteFileFromDropbox(filePath: path)
        } catch {
            throw APError.deleteFileDropboxError
//            throw APError.requestFailed(error)
        }
    }

    private func deleteFileFromDropbox(filePath: String) async throws -> String {
        let url = URL(string: "https://api.dropboxapi.com/2/files/delete_v2")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiDropbox)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["path": filePath]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let deletedFilePath = jsonResponse["metadata"] as? [String: Any],
                  let path = deletedFilePath["path_display"] as? String else {
                throw APError.invalidData
            }
            
            return "Файл удален по пути: \(path)"
        } catch {
            throw APError.deleteFileDropboxError
//            throw APError.requestFailed(error)
        }
    }

}
