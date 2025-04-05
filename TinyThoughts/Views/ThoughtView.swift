//
//  ThoughtView.swift
//  TinyThoughts
//
//  created for tiny software by lukas moro
//
//  thought view used for displaying a thought in the thread content view
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
