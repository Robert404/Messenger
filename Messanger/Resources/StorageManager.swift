//
//  StorageManager.swift
//  Messanger
//
//  Created by Robert Nersesyan on 23.07.21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()

    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    public func uploadPicture(with data: Data, name: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(name)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                print("failed to upload")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(name)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("failed to get url")
                    completion(.failure(StorageErrors.failedToGetUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("download url: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
}

public enum StorageErrors: Error {
    case failedToUpload
    case failedToGetUrl
}
