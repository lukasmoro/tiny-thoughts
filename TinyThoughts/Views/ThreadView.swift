//
//  ThreadView.swift
//  TinyThoughts
//
//  Created for MVVM refactoring
//

import SwiftUI

struct ThreadView: View {
    let thread: Thread
    let formatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(thread.title ?? "Untitled Thread")
                .font(.headline)
                .padding(.bottom, 2)
            
            if let summary = thread.summary, !summary.isEmpty {
                Text(summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .padding(.bottom, 2)
            }
            
            HStack {
                Text("Modified:")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(thread.lastModified ?? Date(), formatter: formatter)
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                Spacer()
                
                if let thoughts = thread.thoughts?.allObjects as? [Thought] {
                    Text("\(thoughts.count) thought\(thoughts.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(10)
    }
} 