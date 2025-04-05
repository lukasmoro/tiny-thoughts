//
//  AddButtonView.swift
//  TinyThoughts
//
//  created for tiny software by lukas moro
//
//  add button used for adding new threads and thoughts
//

import SwiftUI

struct AddButtonView: View {
    let action: () -> Void
    let size: CGFloat
    
    init(action: @escaping () -> Void, size: CGFloat = 44) {
        self.action = action
        self.size = size
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .frame(width: size, height: size)
                .background(Color(.systemGray6))
                .clipShape(Circle())
        }
        .padding(.bottom, 10)
    }
} 