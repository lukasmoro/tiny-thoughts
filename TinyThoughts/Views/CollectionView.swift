//
//  CollectionView.swift
//  TinyThoughts
//
//  View for displaying a collection
//

import SwiftUI

struct CollectionView: View {
    let collection: Collection
    let formatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(collection.name ?? "Unnamed Collection")
                .font(.headline)
                .padding(.bottom, 2)
            
            if let summary = collection.summary, !summary.isEmpty {
                Text(summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .padding(.bottom, 2)
            }
            
            HStack {
                if let threads = collection.threads?.allObjects as? [Thread] {
                    Text("\(threads.count) thread\(threads.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
} 