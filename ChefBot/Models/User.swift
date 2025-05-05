//
//  User.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/3/25.
//

import Foundation

struct User: Encodable, Decodable { //upload to Firebase
    var id: String
    var name: String
    var email: String
    var dateSignedUp: Date
    
    static var initUser: User {
        User(id: "", name: "", email: "", dateSignedUp: Date.now)
    }
    
    static var mockUser: User {
        User(id: "haha", name: "Long", email: "haha@gmail.com", dateSignedUp: Date.now)
    }
}
