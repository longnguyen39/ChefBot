//
//  Authentication.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/3/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AuthService {
    
    static let shared = AuthService()
    
    @AppStorage(UserDe.userID) var userID: String?

    //MARK: - Functions
    
    @MainActor //execute on the main thread (where most UI works)
    func createUserWithEmail(passedUser: User) async throws {
        
        let email1 = randomString(length: 10)
        let email2 = randomNo(length: 2)
        var user = passedUser
        user.email = "\(user.name.replacingOccurrences(of: " ", with: "_")).\(email1).\(email2)@gmail.com"
        
        let result = try await Auth.auth().createUser(withEmail: user.email, password: UniversalPassword)
        userID = result.user.uid
        user.id = userID!
        
        let ref = Firestore.firestore().collection(DB_Coll.User).document(user.id)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try? await ref.setData(encodedUser)
    }
    
    func fetchUserData(uid: String) async throws -> User {
        let ref = Firestore.firestore().collection(DB_Coll.User).document(uid)
        let doc = try await ref.getDocument()
        return try doc.data(as: User.self)
    }
    
    func updateUsername(userID: String, newName: String) async throws {
        let ref = Firestore.firestore().collection(DB_Coll.User).document(userID)
        try await ref.updateData([
            "name": newName
        ])
    }
}
