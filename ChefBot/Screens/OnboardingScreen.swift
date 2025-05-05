//
//  OnboardingView.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/3/25.
//

import SwiftUI

struct OnboardingScreen: View {
    
    @FocusState private var keyboardFocused: Bool //keyboard popup

    @State var user: User = .initUser
    @State var errMessage: String = ""
    @State var showLoading: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Welcome to ChefBot!")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding()
                
                Image("logo")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.bottom)
                
                //userInput is store in viewModel.email
                TextField("What is your name?", text: $user.name)
                    .textInputAutocapitalization(.never)
                    .modifier(TxtFieldModifier())
                    .focused($keyboardFocused)
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            keyboardFocused = true //popup keyboard
                        }
                    }
                
                Button {
                    Task {
                        await signUp()
                    }
                } label: {
                    ContBtnView()
                        .opacity(user.name.isEmpty ? 0.5 : 1)
                }
                .disabled(user.name.isEmpty)
                
                Spacer()
            }
            
            if showLoading {
                LoadingView()
            }
        }
        .alert("Oops", isPresented: .constant(errMessage != "")) {
            Button("Try Again", role: .cancel, action: {
                errMessage = ""
            })
        } message: {
            Text(errMessage)
        }
    }
    
    private func signUp() async {
        showLoading = true
        do {
            try await AuthService.shared.createUserWithEmail(passedUser: user)
            showLoading = false
        } catch {
            errMessage = error.localizedDescription
            print("DEBUG_Onboarding: \(errMessage)")
            showLoading = false
        }
    }
}

#Preview {
    OnboardingScreen()
}
