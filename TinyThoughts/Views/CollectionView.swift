//
//  CollectionView.swift
//  TinyThoughts
//
//  Created for MVVM refactoring
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
                Text("Created:")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(collection.creationDate ?? Date(), formatter: formatter)
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                Spacer()
                
                if let threads = collection.threads?.allObjects as? [Thread] {
                    Text("\(threads.count) thread\(threads.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
} 