//
//  ThreadDetailView.swift
//  TinyThoughts
//
//  View for displaying and editing a thread
//

import SwiftUI
import CoreData

struct ThreadDetailView: View {
    @ObservedObject var threadViewModel: ThreadViewModel
    @StateObject private var thoughtViewModel: ThoughtViewModel
    
    let thread: Thread
    let formatter: DateFormatter
    
    @State private var showingAddThought = false
    @State private var isEditing = false
    @State private var editedTitle: String = ""
    @State private var editedSummary: String = ""
    
    init(viewContext: NSManagedObjectContext, threadViewModel: ThreadViewModel, thread: Thread, formatter: DateFormatter) {
        self.threadViewModel = threadViewModel
        self.thread = thread
        self.formatter = formatter
        _thoughtViewModel = StateObject(wrappedValue: ThoughtViewModel(viewContext: viewContext, thread: thread))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                if isEditing {
                    TextField("Thread Title", text: $editedTitle)
                        .font(.title2)
                        .padding(.bottom, 5)
                    
                    TextField("Summary", text: $editedSummary, axis: .vertical)
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
            }
            .padding()
            .background(Color(.systemBackground))
            
            Divider()
            
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
                        NavigationLink {
                            ThoughtDetailView(viewModel: thoughtViewModel, thought: thought, formatter: formatter)
                        } label: {
                            ThoughtView(thought: thought)
                        }
                    }
                    .onDelete(perform: thoughtViewModel.deleteThoughts)
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Thread Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    Button("Save") {
                        if !editedTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            threadViewModel.updateThread(
                                thread,
                                title: editedTitle,
                                summary: editedSummary.isEmpty ? nil : editedSummary
                            )
                            isEditing = false
                        }
                    }
                    .disabled(editedTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                } else {
                    Button("Edit") {
                        editedTitle = thread.title ?? ""
                        editedSummary = thread.summary ?? ""
                        isEditing = true
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddThought = true }) {
                    Label("Add Thought", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddThought) {
            AddThoughtView(viewModel: thoughtViewModel)
        }
        .onChange(of: showingAddThought) { oldValue, newValue in
            if !newValue {
                thoughtViewModel.fetchThoughts()
            }
        }
        .onAppear {
            thoughtViewModel.fetchThoughts()
        }
    }
} 
