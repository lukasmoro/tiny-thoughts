//
//  CollectionCardView.swift
//  TinyThoughts
//
//  created for tiny software by lukas moro
//
//  collection card view used for displaying collections in the content view
//

import SwiftUI
import CoreData

struct CollectionCardView: View {
    let collection: Collection
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(collection.name ?? "Unnamed Collection")
                .font(.headline)
                .padding(.bottom, 8)
            if let summary = collection.summary, !summary.isEmpty {
                Text(summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .padding(.bottom, 8)
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
        .padding(16)
        .frame(minHeight: 120)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}
