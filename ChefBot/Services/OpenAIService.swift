//
//  OpenAIService.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/4/25.
//

import Foundation

class OpenAIService: ObservableObject {
    
    private let apiKey = "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"
    
    private let endpointURL = "https://api.openai.com/v1/chat/completions"
//    private let modelName = "gpt-4o" // Or "gpt-3.5-turbo", etc.
    private let modelName = "gpt-4.1-mini-2025-04-14"
    
    
    enum APIError: Error, LocalizedError {
        case invalidURL
        case requestFailed(Error)
        case invalidResponseStatus(Int)
        case decodingError(Error)
        case noAssistantResponse

        var errorDescription: String? {
            switch self {
            case .invalidURL: return "The API endpoint URL is invalid."
            case .requestFailed(let error): return "Network request failed: \(error.localizedDescription)"
            case .invalidResponseStatus(let status): return "Received invalid response status: \(status)"
            case .decodingError(let error): return "Failed to decode response: \(error.localizedDescription)"
            case .noAssistantResponse: return "No message content received from the assistant."
            }
        }
    }
    
    func sendMessage(messages: [ChatMessage]) async throws -> String {
        guard let url = URL(string: endpointURL) else {
            throw APIError.invalidURL
        }

        // 1. Create Request Body
        //    Filter out system message if needed, or keep it if you use one
        let requestBody = OpenAIChatRequest(model: modelName, messages: messages)

        // 2. Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 120 // timeout 120 seconds (default is 60)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        // 3. Encode request body
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            // Handle encoding error if necessary, though unlikely for these structs
            print("DEBUG_Service: Failed to encode request: \(error)")
            throw error // Re-throw for now
        }

        // 4. Perform Network Request
        let data: Data
        let response: URLResponse
        do {
             (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            
            throw APIError.requestFailed(error)
        }

        // 5. Check Response Status
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponseStatus(0) // Or a different error type
        }
        
        guard httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 else {
            // Error handling code remains the same...
            if let errorDetail = String(data: data, encoding: .utf8) {
                 print("DEBUG_Service: OpenAI API Error (\(httpResponse.statusCode)): \(errorDetail)")
            }
            throw APIError.invalidResponseStatus(httpResponse.statusCode)
        }

        // 6. Decode Response Body
        do {
            let chatResponse = try JSONDecoder().decode(OpenAIChatResponse.self, from: data)
            // Ensure we got a message back
            guard let assistantMessage = chatResponse.choices.first?.message.content else {
                throw APIError.noAssistantResponse
            }
            print("DEBUG_Service: all response /n \(chatResponse.choices)")
            
            print("DEBUG_Service: picked response /n \(assistantMessage)")

            print("DEBUG_Service: done return response")
            return assistantMessage.trimmingCharacters(in: .whitespacesAndNewlines)
            
        } catch {
            // Print raw data for debugging if decoding fails
            print("DEBUG_Service: Raw response data: \(String(data: data, encoding: .utf8) ?? "Unable to decode data")")
            throw APIError.decodingError(error)
        }
    }
}
