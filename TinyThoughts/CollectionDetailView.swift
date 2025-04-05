//
//  CollectionDetailView.swift
//  TinyThoughts
//
//  View for displaying and editing a collection
//

import SwiftUI
import CoreData

struct CollectionDetailView: View {
   
    // MARK: - View Models
    @ObservedObject var collectionViewModel: CollectionViewModel
    @StateObject private var threadViewModel: ThreadViewModel
    @StateObject private var thoughtViewModel: ThoughtViewModel

    // MARK: - Data Models
    let collection: Collection
    let formatter: DateFormatter
    @Environment(\.managedObjectContext) private var viewContext

    // MARK: - Collection Editing State
    struct EditingState {
        var isEditing: Bool = false
        var name: String = ""
        var summary: String = ""
    }

    @State private var collectionEditState = EditingState()
    @State private var threadEditState = EditingState()

    // MARK: - Thread State
    @State private var selectedThread: Thread? = nil
    @State private var showingAddThread = false
    @State private var editedThreadTitle: String = ""
    @State private var editedThreadSummary: String = ""

    // MARK: - Thought State
    @State private var showingAddThought = false
    
    // MARK: - Initialization
    // initializes the collection detail view with the collection view model, collection, and formatter
    init(viewContext: NSManagedObjectContext, collectionViewModel: CollectionViewModel, collection: Collection, formatter: DateFormatter) {
        self.collectionViewModel = collectionViewModel
        self.collection = collection
        self.formatter = formatter
        _threadViewModel = StateObject(wrappedValue: ThreadViewModel(viewContext: viewContext, collection: collection))
        _thoughtViewModel = StateObject(wrappedValue: ThoughtViewModel(viewContext: viewContext))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CollectionHeaderView(
                collection: collection,
                formatter: formatter,
                collectionViewModel: collectionViewModel,
                editState: $collectionEditState
            )
            Divider()
            ThreadContentView(
                threadViewModel: threadViewModel,
                thoughtViewModel: thoughtViewModel,
                selectedThread: $selectedThread,
                showingAddThread: $showingAddThread,
                showingAddThought: $showingAddThought,
                formatter: formatter
            )
        }
        .sheet(isPresented: $showingAddThread) {
            AddThreadView(viewModel: threadViewModel, collection: collection)
        }
        .onChange(of: showingAddThread) { oldValue, newValue in
            if !newValue {
                threadViewModel.fetchThreads()
            }
        }
        .sheet(isPresented: $showingAddThought) {
            if let thread = selectedThread {
                AddThoughtView(viewModel: ThoughtViewModel(viewContext: viewContext, thread: thread))
            }
        }
        .onChange(of: showingAddThought) { oldValue, newValue in
            if !newValue && selectedThread != nil {
                thoughtViewModel.fetchThoughts()
            }
        }
        .onChange(of: collectionEditState.isEditing) { oldValue, newValue in
            if !newValue {
                collectionViewModel.fetchCollections()
            }
        }
        .onAppear {
            threadViewModel.fetchThreads()
            if let firstThread = threadViewModel.threads.first, selectedThread == nil {
                selectedThread = firstThread
                thoughtViewModel.setThread(firstThread)
            }
        }
        .onChange(of: threadEditState.isEditing) { oldValue, newValue in
            if !newValue && selectedThread != nil {
                threadViewModel.fetchThreads()
                thoughtViewModel.fetchThoughts()
            }
        }
    }
} 
