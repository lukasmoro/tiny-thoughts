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
    @StateObject private var sheetManager: SheetManager

    // MARK: - Initialization
    // initializes the content view through the collection view model and the persistence controller
    init() {
        let viewContext = PersistenceController.shared.container.viewContext
        _collectionViewModel = StateObject(wrappedValue: CollectionViewModel(viewContext: viewContext))
        _sheetManager = StateObject(wrappedValue: SheetManager())
    }
    
    // MARK: - Body
    // body is the main view of the content view
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: AppConfig.Spacing.spacer) {
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
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .toolbar { toolbar }
            .overlay(quickAddButton, alignment: .bottomTrailing)
        }
        .sheet(item: $sheetManager.activeSheet) { sheetType in
            SheetViewBuilder(
                sheetType: sheetType,
                collectionViewModel: collectionViewModel,
                viewContext: viewContext
            )
        }
        .onChange(of: sheetManager.activeSheet) { oldValue, newValue in
            if newValue == nil {
                collectionViewModel.fetchCollections()
            }
        }
        .onAppear {
            collectionViewModel.updateContext(viewContext)
        }
    }

    // toolbar content is the toolbar of the content view
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { sheetManager.present(.addCollection) }) {
                Label("Add Collection", systemImage: "plus")
            }
        }
    }

    // quick add button is the button to add a new thought to the selected collection
    private var quickAddButton: some View {
        Button(action: { sheetManager.present(.quickAddThought) }) {
            Image(systemName: "pencil.circle.fill")
                .font(.system(size: AppConfig.Layout.quickAddButtonSize)) 
                .foregroundColor(AppConfig.Colors.threadCount)
                .shadow(radius: AppConfig.Layout.cardShadowRadius)
        }
        .padding(.horizontal, AppConfig.Padding.horizontal)
        .padding(.vertical, AppConfig.Padding.vertical)
    }
}

// MARK: - Preview
// preview is the preview of the content view (NOT NEEDED IN PRODUCTION)
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
