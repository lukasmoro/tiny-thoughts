//
//  ContentView.swift
//  TinyThoughts
//
//  Created by Lukas Moro on 02.04.25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var collectionViewModel: CollectionViewModel
    @State private var activeSheet: ActiveSheet?
    
    // MARK: - Constants
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    private let gridColumns = [GridItem(.adaptive(minimum: 300), spacing: 16)]
    private let gridSpacing: CGFloat = 16
    
    // MARK: - Types
    
    private enum ActiveSheet: Identifiable {
        case addCollection
        case quickAddThought
        
        var id: Int {
            switch self {
            case .addCollection: return 0
            case .quickAddThought: return 1
            }
        }
    }
    
    // MARK: - Initialization
    
    init() {
        _collectionViewModel = StateObject(wrappedValue: CollectionViewModel(viewContext: PersistenceController.shared.container.viewContext))
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            mainContent
                .toolbar { toolbarContent }
                .overlay(quickAddButton, alignment: .bottomTrailing)
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .addCollection:
                AddCollectionView(viewModel: collectionViewModel)
            case .quickAddThought:
                QuickAddThoughtView(collectionViewModel: collectionViewModel, viewContext: viewContext)
            }
        }
        .onChange(of: activeSheet) { oldValue, newValue in
            if newValue == nil {
                collectionViewModel.fetchCollections()
            }
        }
        .onAppear {
            collectionViewModel.updateContext(viewContext)
        }
    }
    
    // MARK: - View Components
    
    private var mainContent: some View {
        VStack {
            titleView
            collectionsGrid
        }
    }
    
    private var titleView: some View {
        Text("🪡💭")
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
            .padding(.top)
    }
    
    private var collectionsGrid: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: gridSpacing) {
                ForEach(collectionViewModel.collections, id: \.id) { collection in
                    NavigationLink {
                        CollectionDetailView(
                            viewContext: viewContext,
                            collectionViewModel: collectionViewModel,
                            collection: collection,
                            formatter: dateFormatter
                        )
                    } label: {
                        CollectionCardView(collection: collection)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .contextMenu {
                        Button(role: .destructive) {
                            collectionViewModel.deleteCollection(collection)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding()
        }
        .padding(.bottom, 30)
    }

    private struct CollectionCardView: View {
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
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { activeSheet = .addCollection }) {
                Label("Add Collection", systemImage: "plus")
            }
        }
    }
    
    private var quickAddButton: some View {
        Button(action: { activeSheet = .quickAddThought }) {
            Image(systemName: "pencil.circle.fill")
                .font(.system(size: 50)) 
                .foregroundColor(.blue)
                .shadow(radius: 3)
        }
        .accessibility(label: Text("Quick add thought"))
        .padding(.trailing, 20)
        .padding(.bottom, 20)
    }
}

// MARK: - Preview

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

