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
            threadContentView
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
    
    // MARK: - Thread Content View
    private var threadContentView: some View {
        HStack(spacing: 0) {
            threadDetailView
            Divider()
            VStack {
                ThreadListView(
                    threadViewModel: threadViewModel,
                    thoughtViewModel: thoughtViewModel,
                    selectedThread: $selectedThread,
                    showingAddThread: $showingAddThread,
                    formatter: formatter
                )
            }
            .frame(width: UIScreen.main.bounds.width * 0.35)
        }
    }
    
    // MARK: - Thread Detail View
    private var threadDetailView: some View {
        VStack {
            if let thread = selectedThread {
                ThreadHeaderView(
                    thread: thread,
                    formatter: formatter,
                    threadViewModel: threadViewModel,
                    isEditing: $threadEditState.isEditing,
                    editedTitle: $editedThreadTitle,
                    editedSummary: $editedThreadSummary
                )
                Divider()
                ThoughtsContentView(
                    thoughtViewModel: thoughtViewModel,
                    showingAddThought: $showingAddThought,
                    thread: thread
                )
            } else {
                VStack {
                    Spacer()
                    Text("Select a thread to view thoughts")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
        }
    }
} 
