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
                .padding(.bottom, AppConfig.Padding.header)
            if let summary = collection.summary, !summary.isEmpty {
                Text(summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .padding(.bottom, AppConfig.Padding.text)
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
        .padding(AppConfig.Padding.card)
        .frame(minHeight: 140)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal, AppConfig.Padding.horizontal)
        .padding(.top, AppConfig.Padding.spacer)
    }
}
