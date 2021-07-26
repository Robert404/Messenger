//
//  DatabaseManager.swift
//  Messanger
//
//  Created by Robert Nersesyan on 12.07.21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
}

extension DatabaseManager {
    
    public func isUserExists(with email: String, completion: @escaping((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snap in
            guard snap.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        })
    }
    
    /// Inserts new user to database
    public func insertUserToDb(with user: MessengerAppUser, completion: @escaping (Bool) -> Void) {
        
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Failed writing to database")
                completion(false)
                return
            }
            completion(true)
        })
    }
}

struct  MessengerAppUser {
    let firstName: String
    let lastName: String
    let email: String
    
    var safeEmail: String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePicFileName: String {
        return "\(safeEmail)_profile_pic.png"
    }
}
