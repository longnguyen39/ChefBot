//
//  ChatHist.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/4/25.
//

import Foundation

struct ChatHistory: Hashable, Codable {
    var id: String
    var chat: String
    var name: String
    var timestamp: Date
}
