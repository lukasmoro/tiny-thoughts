//
//  ContentView.swift
//  TinyThoughts
//
//  Created by Lukas Moro on 02.04.25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var collectionViewModel: CollectionViewModel
    @State private var showingAddCollection = false
    @State private var showingQuickAddThought = false
    
    // dummy content for testing
    init() {
        _collectionViewModel = StateObject(wrappedValue: CollectionViewModel(viewContext: PersistenceController.shared.container.viewContext))
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        NavigationView {
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
            .navigationTitle("Tiny Thoughts")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddCollection = true }) {
                        Label("Add Collection", systemImage: "plus")
                    }
                }
            }
            .overlay(
                Button(action: {
                    showingQuickAddThought = true
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                        .shadow(radius: 3)
                }
                .padding([.bottom, .trailing], 30)
                .accessibility(label: Text("Quick add thought"))
                , alignment: .bottomTrailing
            )
            
            // Secondary view when no collection is selected
            VStack {
                Image(systemName: "folder.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding()
                
                Text("Select a Collection")
                    .font(.title)
                
                Text("Or create a new one using the + button")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
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
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

