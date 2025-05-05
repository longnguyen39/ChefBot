//
//  IngredientCell.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/4/25.
//

import SwiftUI

struct IngredientCell: View {
    
    @Environment(\.colorScheme) var mode
    @FocusState var showKeyboard: Bool

    var name: String = ""
    @Binding var ingredientList: [Ingredient]
    @State var enteredIngredient: String = ""
    @State var showAddIngredient: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            Text(name)
                .font(.headline)
                .fontWeight(.medium)
                .lineLimit(1)
                .foregroundStyle(name == "Add more +" ? .blue : .primary)
            
            if !isEssential() {
                Image(systemName: "xmark")
                    .imageScale(.small)
                    .foregroundColor(.red)
                    .onTapGesture {
                        withAnimation {
                            removeIngredient()
                        }
                    }
            }
        }
        .padding()
        .background(mode == .light ? LIGHT_GRAY : DARK_GRAY)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .fixedSize(horizontal: true, vertical: false) //need this for dynamic layout
        .onTapGesture {
            if name == "Add more +" {
                showAddIngredient.toggle()
            }
        }
        .alert("Enter ingredients", isPresented: $showAddIngredient) {
            TextField("Enter ingredients", text: $enteredIngredient)
            Button("Cancel", role: .cancel, action: {
                enteredIngredient = ""
            })
            Button("Add", role: .none, action: {
                addIngredient()
            })
        } message: {}
        
    }
    
//MARK: - Function
    
    private func isEssential() -> Bool {
        let arr = essentialIngredients.filter() { $0.name == name }
        return arr.count > 0
    }
    
    private func removeIngredient() {
        ingredientList = ingredientList.filter() { $0.name != name }
    }
    
    private func addIngredient() {
        if enteredIngredient != "" {
            ingredientList = ingredientList.filter() {
                $0.name != "Add more +"
            }
            withAnimation {
                ingredientList.append(Ingredient(name: enteredIngredient))
                ingredientList.append(Ingredient(name: "Add more +"))
                enteredIngredient = ""
            }
        }
    }
}

#Preview {
    IngredientCell(ingredientList: .constant(essentialIngredients))
}
