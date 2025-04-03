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
            collectionHeaderView
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
    
    // MARK: - Header View
    private var collectionHeaderView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                if collectionEditState.isEditing {
                    TextField("Collection Name", text: $collectionEditState.name)
                        .font(.title)
                        .padding(.bottom, 5)
                } else {
                    Text(collection.name ?? "Unnamed Collection")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 5)
                }

                Spacer()

                if collectionEditState.isEditing {
                    Button("Save") {
                        if !collectionEditState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            collectionViewModel.updateCollection(
                                collection,
                                name: collectionEditState.name,
                                summary: collectionEditState.summary.isEmpty ? nil : collectionEditState.summary
                            )
                            collectionEditState.isEditing = false
                        }
                    }
                    .disabled(collectionEditState.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                } else {
                    Button("Edit") {
                        collectionEditState.name = collection.name ?? ""
                        collectionEditState.summary = collection.summary ?? ""
                        collectionEditState.isEditing = true
                    }
                }
            }
            
            if collectionEditState.isEditing {
                TextField("Summary", text: $collectionEditState.summary, axis: .vertical)
                    .lineLimit(3...5)
            } else {
                if let summary = collection.summary, !summary.isEmpty {
                    Text(summary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                if let lastModified = collection.lastModified, lastModified != collection.creationDate {
                    Text("Last modified:")
                        .font(.caption)
                    Text(lastModified, formatter: formatter)
                        .font(.caption)
                } else {
                    Text("Created:")
                        .font(.caption)
                    Text(collection.creationDate ?? Date(), formatter: formatter)
                        .font(.caption)
                }
                
                Spacer()
            }
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    // MARK: - Thread Content View
    private var threadContentView: some View {
        HStack(spacing: 0) {
            VStack {
                HStack {
                    Text("Threads")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                ZStack {
                    threadListView
                    
                    VStack {
                        Spacer()
                        Button(action: { showingAddThread = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                                .frame(width: 44, height: 44)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.35)
            Divider()
            threadDetailView
        }
    }
    
    // MARK: - Thread List View
    private var threadListView: some View {
        List {
            ForEach(threadViewModel.threads, id: \.id) { thread in
                ThreadView(thread: thread, formatter: formatter)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedThread = thread
                        thoughtViewModel.setThread(thread)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedThread?.id == thread.id ? 
                                 Color.blue.opacity(0.8) : 
                                 Color.clear, 
                                 lineWidth: 2)
                    )
                    .listRowSeparator(.hidden)
            }
            .onDelete(perform: threadViewModel.deleteThreads)
        }
        .listStyle(PlainListStyle())
        .refreshable {
            threadViewModel.fetchThreads()
        }
    }
    
    // MARK: - Thread Detail View
    private var threadDetailView: some View {
        VStack {
            if let thread = selectedThread {
                threadHeaderView(thread: thread)
                Divider()
                thoughtsView(thread: thread)
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
    
    // MARK: - Thread Header View
    private func threadHeaderView(thread: Thread) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                if threadEditState.isEditing {
                    TextField("Thread Title", text: $editedThreadTitle)
                        .font(.title2)
                        .padding(.bottom, 5)
                } else {
                    Text(thread.title ?? "Untitled Thread")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 5)
                }
                
                Spacer()
                
                if threadEditState.isEditing {
                    Button("Save") {
                        if !editedThreadTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            threadViewModel.updateThread(
                                thread,
                                title: editedThreadTitle,
                                summary: editedThreadSummary.isEmpty ? nil : editedThreadSummary
                            )
                            threadEditState.isEditing = false
                        }
                    }
                    .disabled(editedThreadTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                } else {
                    Button(action: {
                        editedThreadTitle = thread.title ?? ""
                        editedThreadSummary = thread.summary ?? ""
                        threadEditState.isEditing = true
                    }) {
                        Image(systemName: "pencil.circle")
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 2)
                }
            }
            
            if threadEditState.isEditing {
                TextField("Summary", text: $editedThreadSummary, axis: .vertical)
                    .lineLimit(3...5)
            } else {
                if let summary = thread.summary, !summary.isEmpty {
                    Text(summary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                if let lastModified = thread.lastModified, lastModified != thread.creationDate {
                    Text("Last modified:")
                        .font(.caption)
                    Text(lastModified, formatter: formatter)
                        .font(.caption)
                } else {
                    Text("Created:")
                        .font(.caption)
                    Text(thread.creationDate ?? Date(), formatter: formatter)
                        .font(.caption)
                }
                
                Spacer()
            }
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    // MARK: - Thoughts View
    private func thoughtsView(thread: Thread) -> some View {
        VStack {
            if thoughtViewModel.thoughts.isEmpty {
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "text.bubble")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No thoughts yet")
                        .font(.headline)
                    
                    Text("Use the + button below to add your first thought")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ZStack {
                    List {
                        ForEach(thoughtViewModel.thoughts, id: \.id) { thought in
                            ThoughtView(thought: thought)
                        }
                        .onDelete(perform: thoughtViewModel.deleteThoughts)
                    }
                    .listStyle(PlainListStyle())
                    
                    VStack {
                        Spacer()
                        Button(action: { showingAddThought = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                                .frame(width: 50, height: 50)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
        }
    }
} 
