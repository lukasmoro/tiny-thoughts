//
//  ThoughtView.swift
//  TinyThoughts
//
//  Created for MVVM refactoring
//

import SwiftUI

struct ThoughtView: View {
    let thought: Thought
    let formatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(thought.content ?? "")
                .font(.body)
                .lineLimit(nil)
                .padding(.bottom, 5)
            
            HStack {
                Text("Created:")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(thought.creationDate ?? Date(), formatter: formatter)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                if let modified = thought.lastModified, modified != thought.creationDate {
                    Text("Modified:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(modified, formatter: formatter)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
} 