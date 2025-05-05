//
//  FlowLayout.swift
//  ChefBot
//
//  Created by Long Nguyen on 5/4/25.
//

import SwiftUI

struct ItemSizePreferenceKey: PreferenceKey {
    typealias Value = [AnyHashable: CGSize]

    static var defaultValue: Value = [:]

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

//Custom Flow Layout View

struct FlowLayout<Data: RandomAccessCollection, ItemView: View>: View where Data.Element: Identifiable, Data.Element: Hashable {
    // Input Data & Configuration
    let data: Data
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat
    @ViewBuilder let viewForItem: (Data.Element) -> ItemView

    // State for Measured Sizes and Calculated Layout
    @State private var itemSizes: [Data.Element.ID: CGSize] = [:]
    @State private var calculatedFrames: [Data.Element.ID: CGRect] = [:]
    @State private var totalHeight: CGFloat = .zero // Calculated total height for the layout

    var body: some View {
        GeometryReader { geometry in
            // Main content is the displayPass ZStack
            displayPass(availableWidth: geometry.size.width)
                // Attach measurementPass in the background so it doesn't affect layout
                .background(
                    measurementPass(availableWidth: geometry.size.width)
                )
                // Listen for preference changes (sizes reported from background)
                .onPreferenceChange(ItemSizePreferenceKey.self) { receivedSizes in
                     // Create a new dictionary with the correctly typed keys
                     var newTypedSizes: [Data.Element.ID: CGSize] = [:]
                     for (key, value) in receivedSizes {
                         if let typedKey = key.base as? Data.Element.ID {
                             newTypedSizes[typedKey] = value
                         }
                     }
                     // Update state only if sizes actually changed
                     if self.itemSizes != newTypedSizes {
                          self.itemSizes = newTypedSizes
                          // Trigger layout calculation asynchronously
                          DispatchQueue.main.async {
                              recalculateLayout(availableWidth: geometry.size.width)
                          }
                     }
                }
                // Recalculate layout if container width changes
                .onChange(of: geometry.size.width) { _, newWidth in
                     // Ensure we have sizes before recalculating on width change
                     if !itemSizes.isEmpty {
                         // Trigger layout calculation asynchronously
                         DispatchQueue.main.async {
                             recalculateLayout(availableWidth: newWidth)
                         }
                     }
                }
        }
        // Apply the calculated total height to the GeometryReader container
        .frame(height: totalHeight)
    }

    // Measurement Pass: Renders items transparently in background to measure them
    private func measurementPass(availableWidth: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: verticalSpacing) {
            ForEach(data) { item in
                viewForItem(item)
                    // Measure the actual size using a background GeometryReader
                    .background(GeometryReader { proxy in
                        Color.clear // Needs some content for GeometryReader
                            .preference(key: ItemSizePreferenceKey.self,
                                        value: [item.id: proxy.size]) // Report size
                    })
                    .opacity(0) // Make invisible
                    .allowsHitTesting(false) // Prevent interaction
            }
        }
        .frame(maxWidth: availableWidth, alignment: .leading) // Constrain width
    }

    // Display Pass: Renders items visibly at their calculated positions
    private func displayPass(availableWidth: CGFloat) -> some View {
        // Use ZStack for positioning items via offset from topLeading
        ZStack(alignment: .topLeading) {
            // Only display if frames have been calculated
            if !calculatedFrames.isEmpty {
                ForEach(data) { item in
                    // Ensure frame exists for this item
                    if let frame = calculatedFrames[item.id] {
                        viewForItem(item)
                            // Position the view using calculated origin
                            .offset(x: frame.origin.x, y: frame.origin.y)
                    }
                }
            }
        }
        // Ensure this ZStack aligns correctly within its parent space
        .frame(maxWidth: availableWidth, alignment: .leading)
    }

    // Calculation Function: Determines position and total height
    private func recalculateLayout(availableWidth: CGFloat) {
        var frames: [Data.Element.ID: CGRect] = [:]
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0 // Start Y at 0 for the first row
        var rowHeight: CGFloat = 0
        var calculatedTotalHeight: CGFloat = 0

        for item in data {
            let itemSize = itemSizes[item.id] ?? .zero // Get measured size
            guard itemSize != .zero else { continue } // Skip if size is zero

            // Check if item fits on current line, wrap if not
            if currentX + itemSize.width > availableWidth && currentX > 0 {
                currentY += rowHeight + verticalSpacing // Move to next line
                currentX = 0                          // Reset X
                rowHeight = 0                         // Reset row height tracker
            }

            // Calculate and store the frame for this item
            let itemFrame = CGRect(origin: CGPoint(x: currentX, y: currentY), size: itemSize)
            frames[item.id] = itemFrame

            // Update position and row height for next item
            currentX += itemSize.width + horizontalSpacing
            rowHeight = max(rowHeight, itemSize.height)
        }

        // Final total height includes the last row
        calculatedTotalHeight = currentY + rowHeight

        // Update state variables directly (call to this func is already async)
        self.calculatedFrames = frames
        self.totalHeight = calculatedTotalHeight
    }
}
