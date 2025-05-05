//
//  ServiceFetch.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/4/25.
//

import Foundation
import Firebase

class ServiceFetch {
    
    static let shared = ServiceFetch()
    
    
    func fetchChatHistory(userID: String) async -> [ChatHistory] {
        let ref = Firestore.firestore().collection(DB_Coll.User).document(userID).collection(DB_Coll.Hist)
        do {
            let snapshot = try await ref
                .order(by: "timestamp", descending: true)
                .limit(to: 10)
                .getDocuments()
            let arr = snapshot.documents.compactMap({ try? $0.data(as: ChatHistory.self) })

            return arr
            
        } catch {
            print("DEBUG: err \(error.localizedDescription)")
            return []
        }
        
    }
}
