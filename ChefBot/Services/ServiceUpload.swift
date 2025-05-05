//
//  ServiceUpload.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/4/25.
//

import Foundation
import Firebase

class ServiceUpload {
    
    static let shared = ServiceUpload()
    
    
    func uploadChatToHist(userID: String, chat: ChatHistory) async {
        
        var chatUpload = chat
        chatUpload.id = "\(Date.now)"
        chatUpload.name = "\(Date.now)"
        
        let ref = Firestore.firestore().collection(DB_Coll.User).document(userID).collection(DB_Coll.Hist).document(chatUpload.id)
        
        guard let encodedChat = try? Firestore.Encoder().encode(chatUpload) else { return }
        try? await ref.setData(encodedChat)
    }
    
    func deleteHistChat(userID: String, docID: String) async {
        let ref = Firestore.firestore().collection(DB_Coll.User).document(userID).collection(DB_Coll.Hist).document(docID)
        
        do {
            print("DEBUG_ServiceUpload: deleting hist cell")
            try await ref.delete()
        } catch {
            print("DEBUG_ServiceUpload: err deleting, \(error.localizedDescription)")
        }
    }
}
