//
//  ContentView.swift
//  TinyThoughts
//
//  created for tiny software by lukas moro
//
//  content view is the main view of the app
//  it displays the collections and allows the user to add new collections
//  it also allows the user to add new thoughts to the selected collection via quick add (NEEDS FIXING)

import SwiftUI
import CoreData

struct ContentView: View {
    
    // MARK: - Properties
    // environment manages object context through core data, collection view model, active sheet        
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var collectionViewModel: CollectionViewModel
    @State private var activeSheet: ActiveSheet?

    // MARK: - Types
    // active sheet enum for activating addCollection and quickAddThought views 
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
    
    // MARK: - Constants
    // grid columns
    private let gridColumns = [GridItem(.adaptive(minimum: 300), spacing: 16)]
    
    // MARK: - Initialization
    // initializes the content view through the collection view model and the persistence controller
    init() {
        _collectionViewModel = StateObject(wrappedValue: CollectionViewModel(viewContext: PersistenceController.shared.container.viewContext))
    }
    
    // MARK: - Body
    // body is the main view of the content view
    var body: some View {
        NavigationView {
            VStack {
                titleView
                collectionsGrid
            }
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
    
    // title of the content view
    private var titleView: some View {
        Text("🪡💭")
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, AppConfig.Padding.horizontal)
            .padding(.top)
    }

    // grid of collections
    private var collectionsGrid: some View {
        ScrollView {
            LazyVGrid(columns: AppConfig.Grid.columns, spacing: AppConfig.Grid.spacing) {
                ForEach(collectionViewModel.collections, id: \.id) { collection in
                    NavigationLink {
                        CollectionDetailView(
                            viewContext: viewContext,
                            collectionViewModel: collectionViewModel,
                            collection: collection,
                            formatter: DateFormatterManager.shared.dateFormatter
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
            .padding(AppConfig.Padding.grid)
        }
        .padding(.bottom, AppConfig.Padding.vertical)
    }

    // card view of the collection
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

    // toolbar content is the toolbar of the content view
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { activeSheet = .addCollection }) {
                Label("Add Collection", systemImage: "plus")
            }
        }
    }

    // quick add button is the button to add a new thought to the selected collection
    private var quickAddButton: some View {
        Button(action: { activeSheet = .quickAddThought }) {
            Image(systemName: "pencil.circle.fill")
                .font(.system(size: AppConfig.Layout.quickAddButtonSize)) 
                .foregroundColor(AppConfig.Colors.threadCount)
                .shadow(radius: AppConfig.Layout.cardShadowRadius)
        }
        .accessibility(label: Text("Quick add thought"))
        .padding(.trailing, AppConfig.Padding.horizontal)
        .padding(.bottom, AppConfig.Padding.vertical)
    }
}

// MARK: - Preview
// preview is the preview of the content view (NOT NEEDED IN PRODUCTION)
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}