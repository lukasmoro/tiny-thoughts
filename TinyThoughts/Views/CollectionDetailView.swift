//
//  CollectionDetailView.swift
//  TinyThoughts
//
//  View for displaying and editing a collection
//

import SwiftUI
import CoreData

struct CollectionDetailView: View {
    @ObservedObject var collectionViewModel: CollectionViewModel
    @StateObject private var threadViewModel: ThreadViewModel
    let collection: Collection
    let formatter: DateFormatter
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAddThread = false
    @State private var isEditing = false
    @State private var editedName: String = ""
    @State private var editedSummary: String = ""
    @State private var selectedThread: Thread? = nil
    @StateObject private var thoughtViewModel: ThoughtViewModel
    @State private var showingAddThought = false
    @State private var isEditingThread = false
    @State private var editedThreadTitle: String = ""
    @State private var editedThreadSummary: String = ""
    
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
        .navigationTitle("Collection Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    Button("Save") {
                        if !editedName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            collectionViewModel.updateCollection(
                                collection,
                                name: editedName,
                                summary: editedSummary.isEmpty ? nil : editedSummary
                            )
                            isEditing = false
                        }
                    }
                    .disabled(editedName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                } else {
                    Button("Edit") {
                        editedName = collection.name ?? ""
                        editedSummary = collection.summary ?? ""
                        isEditing = true
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddThread = true }) {
                    Label("Add Thread", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddThread) {
            AddThreadView(viewModel: threadViewModel, collection: collection)
        }
        .sheet(isPresented: $showingAddThought) {
            if let thread = selectedThread {
                AddThoughtView(viewModel: ThoughtViewModel(viewContext: viewContext, thread: thread))
            }
        }
        .onAppear {
            threadViewModel.fetchThreads()
            // Select the first thread by default if available
            if let firstThread = threadViewModel.threads.first, selectedThread == nil {
                selectedThread = firstThread
                thoughtViewModel.setThread(firstThread)
            }
        }
    }
    
    // MARK: - Header View
    private var collectionHeaderView: some View {
        VStack(alignment: .leading, spacing: 10) {
            if isEditing {
                TextField("Collection Name", text: $editedName)
                    .font(.title)
                    .padding(.bottom, 5)
                
                TextField("Summary", text: $editedSummary, axis: .vertical)
                    .lineLimit(3...5)
            } else {
                Text(collection.name ?? "Unnamed Collection")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 5)
                
                if let summary = collection.summary, !summary.isEmpty {
                    Text(summary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Text("Created:")
                    .font(.caption)
                Text(collection.creationDate ?? Date(), formatter: formatter)
                    .font(.caption)
                
                Spacer()
                
                if let lastModified = collection.lastModified, lastModified != collection.creationDate {
                    Text("Last modified:")
                        .font(.caption)
                    Text(lastModified, formatter: formatter)
                        .font(.caption)
                }
            }
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    // MARK: - Thread Content View
    private var threadContentView: some View {
        HStack(spacing: 0) {
            threadListView
            Divider()
            threadDetailView
        }
    }
    
    // MARK: - Thread List View
    private var threadListView: some View {
        VStack {
            List {
                ForEach(threadViewModel.threads, id: \.id) { thread in
                    ThreadView(thread: thread, formatter: formatter)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedThread = thread
                            // Update thought view model with the selected thread
                            thoughtViewModel.setThread(thread)
                        }
                        .background(
                            selectedThread?.id == thread.id ? 
                            Color(.systemGray4).opacity(0.5) : 
                            Color.clear
                        )
                }
                .onDelete(perform: threadViewModel.deleteThreads)
            }
            .listStyle(PlainListStyle())
            .refreshable {
                threadViewModel.fetchThreads()
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.35)
    }
    
    // MARK: - Thread Detail View
    private var threadDetailView: some View {
        VStack {
            if let thread = selectedThread {
                threadHeaderView(thread: thread)
                Divider()
                thoughtsView(thread: thread)
            } else {
                // No thread selected
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
            if isEditingThread {
                TextField("Thread Title", text: $editedThreadTitle)
                    .font(.title2)
                    .padding(.bottom, 5)
                
                TextField("Summary", text: $editedThreadSummary, axis: .vertical)
                    .lineLimit(3...5)
            } else {
                Text(thread.title ?? "Untitled Thread")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 5)
                
                if let summary = thread.summary, !summary.isEmpty {
                    Text(summary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Text("Created:")
                    .font(.caption)
                Text(thread.creationDate ?? Date(), formatter: formatter)
                    .font(.caption)
                
                Spacer()
                
                if let lastModified = thread.lastModified, lastModified != thread.creationDate {
                    Text("Last modified:")
                        .font(.caption)
                    Text(lastModified, formatter: formatter)
                        .font(.caption)
                }
            }
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditingThread {
                    Button("Save") {
                        if !editedThreadTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            threadViewModel.updateThread(
                                thread,
                                title: editedThreadTitle,
                                summary: editedThreadSummary.isEmpty ? nil : editedThreadSummary
                            )
                            isEditingThread = false
                        }
                    }
                    .disabled(editedThreadTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                } else {
                    Button("Edit Thread") {
                        editedThreadTitle = thread.title ?? ""
                        editedThreadSummary = thread.summary ?? ""
                        isEditingThread = true
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddThought = true }) {
                    Label("Add Thought", systemImage: "plus.circle")
                }
            }
        }
    }
    
    // MARK: - Thoughts View
    private func thoughtsView(thread: Thread) -> some View {
        Group {
            if thoughtViewModel.thoughts.isEmpty {
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "text.bubble")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No thoughts yet")
                        .font(.headline)
                    
                    Button(action: { showingAddThought = true }) {
                        Text("Add your first thought")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(thoughtViewModel.thoughts, id: \.id) { thought in
                        ThoughtView(thought: thought)
                    }
                    .onDelete(perform: thoughtViewModel.deleteThoughts)
                }
                .listStyle(PlainListStyle())
            }
        }
    }
} 
