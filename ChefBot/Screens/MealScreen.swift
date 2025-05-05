//
//  MealScreen.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/4/25.
//

import SwiftUI

struct MealScreen: View {
    
    @Binding var showMealScreen: Bool
    @Binding var ingredientList: [Ingredient]
    @StateObject private var openAIService = OpenAIService()

    @State private var chatMessages: [ChatMessage] = []
    @State private var currentInput: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil

    var body: some View {
        ZStack {
            VStack {
                // Chat Message Display Area
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(chatMessages) { message in
                                MessageView(message: message)
                                    .id(message.id) // Assign ID for scrolling
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    .onChange(of: chatMessages.count) { _ , _ in
                        // Scroll to the bottom when new messages are added
                        if let lastMessage = chatMessages.last {
                            withAnimation {
                                scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Input Area
                HStack {
                    TextField("Ask me anything...", text: $currentInput, axis: .vertical)
                        .font(.headline)
                        .fontWeight(.regular)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .lineLimit(1...5) // Limit vertical expansion
                        .disabled(isLoading) // Disable input while loading
                    
                    Button {
                        sendMessage(isInit: false)
                    } label: {
                        if isLoading {
                            ProgressView() // Show spinner while loading
                                .padding(.horizontal, 5) // Adjust padding for spinner
                        } else {
                            Image(systemName: "paperplane.fill")
                                .font(.title2)
                                .fontWeight(.medium)
                                .padding(.horizontal, 8)
                        }
                    }
                    .disabled(currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
                }
                .padding()
            }
            
            if isLoading {
                LoadingView()
            }
        }
        .navigationTitle("Meal generator")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: .constant(errorMessage != nil), actions: {
            Button("OK") {
                errorMessage = nil // Clear error on dismissal
            }
        }, message: {
            Text(errorMessage ?? "An unknown error occurred.")
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showMealScreen.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .imageScale(.medium)
                        .fontWeight(.semibold)
                        .foregroundStyle(.pink)
                }
            }
        }
        .onAppear {
            sendMessage(isInit: true)
        }
    }

//MARK: Function
    
    private func sendMessage(isInit: Bool) {
        var trimmedInput = ""
        if isInit {
            trimmedInput = "Here is the list of my current ingredients: \(ingredientList). Generate some ideas on what meal to cook for me. After done, ask me if I want some specific recipe."
        } else {
            trimmedInput = currentInput.trimmingCharacters(in: .whitespacesAndNewlines) //remove space and empty space b4 and after the input
        }
        
        // Ensure input is not empty
        guard !trimmedInput.isEmpty else { return }
        
        // Add user message to the chat history
        let userMessage = ChatMessage(role: .user, content: trimmedInput)
        if !isInit {
            chatMessages.append(userMessage)
        }
        
        // Clear input field and set loading state
        currentInput = ""
        isLoading = true
        errorMessage = nil // Clear previous errors
        
        var messagesToSend: [ChatMessage] = []
        if isInit {
            messagesToSend.append(userMessage)
        } else {
            messagesToSend = chatMessages // Send the whole history for context
        }
        
        // Start asynchronous task to call the API
        Task {
            do {
                let assistantResponseContent = try await openAIService.sendMessage(messages: messagesToSend)

                // Create assistant message and add to history
                let assistantMessage = ChatMessage(role: .assistant, content: assistantResponseContent)
                chatMessages.append(assistantMessage)
                
            } catch {
                // Error Handling
                if let urlError = error as? URLError {
                    // Handle specific URL errors
                    errorMessage = "Network Error: \(urlError.localizedDescription) (Code: \(urlError.code.rawValue))"
                    print("URLError Code: \(urlError.code)") // Log the specific code
                    switch urlError.code {
                    case .networkConnectionLost:
                        print("Detailed: The network connection was lost.")
                    case .notConnectedToInternet:
                        print("Detailed: Not connected to the internet.")
                    case .timedOut:
                        print("Detailed: The request timed out.")
                        // Add other cases as needed
                    default:
                        print("Detailed: Other URLError - \(urlError.code)")
                    }
                } else if let apiError = error as? OpenAIService.APIError {
                    // Handle custom API errors
                    errorMessage = apiError.localizedDescription
                    print("APIError: \(error)")
                } else {
                    // Handle other unexpected errors
                    errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
                    print("Unexpected Error: \(error)")
                }
                
            }
            
            isLoading = false
        }
    }
    
    
    
}

#Preview {
    MealScreen(showMealScreen: .constant(false), ingredientList: .constant(essentialIngredients))
}
