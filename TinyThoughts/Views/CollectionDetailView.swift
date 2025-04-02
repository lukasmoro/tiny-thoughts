//
//  CollectionDetailView.swift
//  TinyThoughts
//
//  Created for MVVM refactoring
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
    
    init(viewContext: NSManagedObjectContext, collectionViewModel: CollectionViewModel, collection: Collection, formatter: DateFormatter) {
        self.collectionViewModel = collectionViewModel
        self.collection = collection
        self.formatter = formatter
        _threadViewModel = StateObject(wrappedValue: ThreadViewModel(viewContext: viewContext, collection: collection))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Collection info
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
            
            Divider()
            
            // Threads list
            List {
                ForEach(threadViewModel.threads, id: \.id) { thread in
                    NavigationLink {
                        ThreadDetailView(
                            viewContext: threadViewModel.managedObjectContext,
                            threadViewModel: threadViewModel,
                            thread: thread,
                            formatter: formatter
                        )
                    } label: {
                        ThreadView(thread: thread, formatter: formatter)
                    }
                }
                .onDelete(perform: threadViewModel.deleteThreads)
            }
            .listStyle(PlainListStyle())
            .refreshable {
                threadViewModel.fetchThreads()
            }
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
        .onAppear {
            threadViewModel.fetchThreads()
        }
    }
} 