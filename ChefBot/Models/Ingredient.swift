//
//  Ingredient.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/4/25.
//

import SwiftUI

//Identifiable & Hashable needed for this layout approach
struct Ingredient: Identifiable, Hashable {
    let id = UUID()
    let name: String
}
