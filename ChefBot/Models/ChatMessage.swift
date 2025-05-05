//
//  ChatMessage.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/1/25.
//

import Foundation

// Represents a single message in the chat history
struct ChatMessage: Identifiable, Codable {
    let id = UUID() // For SwiftUI List identification
    var role: Role
    var content: String
    
    enum Role: String, Codable {
        case system, user, assistant
    }

    // Need custom coding keys if your Swift property names don't match JSON keys
    enum CodingKeys: String, CodingKey {
        case role
        case content
        // 'id' is not part of the API payload, so we don't include it here
    }
}

// Structure for the entire request payload sent to OpenAI
struct OpenAIChatRequest: Codable {
    let model: String
    let messages: [ChatMessage] // Note: 'id' will not be encoded
    // Add other parameters like temperature, max_tokens etc. if needed
    // let temperature: Double?
    // let max_tokens: Int?
}

// Structure to decode the response from OpenAI
struct OpenAIChatResponse: Decodable {
    let choices: [Choice]
    // Add other fields like 'usage' if you need them
}

struct Choice: Decodable {
    let message: ResponseMessage
    // Add 'finish_reason' if needed
}

struct ResponseMessage: Decodable {
    let role: String // Will be "assistant"
    let content: String
}
