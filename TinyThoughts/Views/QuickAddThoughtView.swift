//
//  QuickAddThoughtView.swift
//  TinyThoughts
//
//  View for quickly adding a thought from anywhere in the app
//

import SwiftUI
import CoreData

struct QuickAddThoughtView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var collectionViewModel: CollectionViewModel
    @ObservedObject var thoughtViewModel: ThoughtViewModel
    @State private var threadViewModel: ThreadViewModel
    @State private var thoughtContent: String = ""
    @State private var selectedCollection: Collection?
    @State private var selectedThread: Thread?
    
    init(collectionViewModel: CollectionViewModel, viewContext: NSManagedObjectContext) {
        self.collectionViewModel = collectionViewModel
        self._thoughtViewModel = ObservedObject(wrappedValue: ThoughtViewModel(viewContext: viewContext))
        self._threadViewModel = State(initialValue: ThreadViewModel(viewContext: viewContext))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Thought")) {
                    TextField("What's on your mind?", text: $thoughtContent, axis: .vertical)
                        .multilineTextAlignment(.leading)
                }
                
                Section(header: Text("Collection")) {
                    Picker("Collection", selection: $selectedCollection) {
                        Text("Select a collection").tag(nil as Collection?)
                        ForEach(collectionViewModel.collections, id: \.id) { collection in
                            Text(collection.name ?? "Unnamed Collection").tag(collection as Collection?)
                        }
                    }
                    .onChange(of: selectedCollection) { oldValue, newValue in
                        // Reset thread when collection changes
                        selectedThread = nil
                        if let collection = newValue {
                            threadViewModel.setCollection(collection)
                        }
                    }
                }
                
                if selectedCollection != nil {
                    Section(header: Text("Thread")) {
                        Picker("Thread", selection: $selectedThread) {
                            Text("Select a thread").tag(nil as Thread?)
                            ForEach(threadViewModel.threads, id: \.id) { thread in
                                Text(thread.title ?? "Unnamed Thread").tag(thread as Thread?)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Quick Thought")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !thoughtContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                           let thread = selectedThread {
                            thoughtViewModel.addThought(content: thoughtContent, to: thread)
                            dismiss()
                        }
                    }
                    .disabled(thoughtContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedThread == nil)
                }
            }
        }
    }
} 
