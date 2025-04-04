import SwiftUI
import CoreData

struct CollectionCardView: View {
    let collection: Collection
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(collection.name ?? "Unnamed Collection")
                .font(.headline)
                .padding(.bottom, 4)
            
            if let summary = collection.summary, !summary.isEmpty {
                Text(summary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .padding(.bottom, 4)
            }
            
            HStack {
                if let threads = collection.threads?.allObjects as? [Thread] {
                    Text("\(threads.count) thread\(threads.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(AppConfig.Colors.threadCount)
                }
                Spacer()
            }
        }
        .padding(AppConfig.Padding.card)
        .background(
            RoundedRectangle(cornerRadius: AppConfig.Layout.cardCornerRadius)
                .fill(Color(.systemBackground))
                .shadow(
                    color: AppConfig.Colors.shadow,
                    radius: AppConfig.Layout.cardShadowRadius,
                    x: 0,
                    y: 2
                )
        )
    }
}
