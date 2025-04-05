//
//  ThreadView.swift
//  TinyThoughts
//
//  created for tiny software by lukas moro
//
//  thread view used for displaying a thread in the thread list view
//

import SwiftUI

struct ThreadView: View {
    let thread: Thread
    let formatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(thread.title ?? "Untitled Thread")
                .font(.caption)
                .padding(.bottom, 2)
            HStack {
                if let thoughts = thread.thoughts?.allObjects as? [Thought] {
                    Text("\(thoughts.count) thought\(thoughts.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                Spacer()
            }
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray5))
        )
    }
} 