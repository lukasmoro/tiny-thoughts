//
//  ContentView.swift
//  TinyThoughts
//
//  Created by Lukas Moro on 02.04.25.
//

import SwiftUI
import CoreData

/// The main view of the TinyThoughts app that displays collections and provides navigation
struct ContentView: View {
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var collectionViewModel: CollectionViewModel
    @State private var showingAddCollection = false
    @State private var showingQuickAddThought = false
    
    // MARK: - Constants
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    private let quickAddButtonSize: CGFloat = 50
    private let quickAddButtonShadowRadius: CGFloat = 3
    
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
        .sheet(isPresented: $showingAddCollection) {
            AddCollectionView(viewModel: collectionViewModel)
        }
        .sheet(isPresented: $showingQuickAddThought) {
            QuickAddThoughtView(collectionViewModel: collectionViewModel, viewContext: viewContext)
        }
        .onChange(of: showingAddCollection) { oldValue, newValue in
            if !newValue {
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
            collectionsList
        }
    }
    
    private var titleView: some View {
        Text("Tiny Thoughts")
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
            .padding(.top)
    }
    
    private var collectionsList: some View {
        List {
            ForEach(collectionViewModel.collections, id: \.id) { collection in
                NavigationLink {
                    CollectionDetailView(
                        viewContext: viewContext,
                        collectionViewModel: collectionViewModel,
                        collection: collection,
                        formatter: dateFormatter
                    )
                } label: {
                    CollectionView(collection: collection)
                }
            }
            .onDelete(perform: collectionViewModel.deleteCollections)
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            EditButton()
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { showingAddCollection = true }) {
                Label("Add Collection", systemImage: "plus")
            }
        }
    }
    
    private var quickAddButton: some View {
        Button(action: { showingQuickAddThought = true }) {
            Image(systemName: "pencil.circle.fill")
                .font(.system(size: quickAddButtonSize))
                .foregroundColor(.blue)
                .shadow(radius: quickAddButtonShadowRadius)
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

