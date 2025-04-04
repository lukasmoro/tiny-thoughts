//
//  ThoughtView.swift
//  TinyThoughts
//
//  View for displaying a thought
//

import SwiftUI

struct ThoughtView: View {
    
    let thought: Thought
        
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(thought.content ?? "")
                .font(.body)
                .lineLimit(nil)
                .padding(.bottom, 5)
        }
        .padding(.vertical)
        .padding(.horizontal, 16)
        .background(Color(.systemBackground))
    }
} 
