//
//  ThreadContentView.swift
//  TinyThoughts
//
//  created for tiny software by lukas moro
//
//  thread content view used for displaying a thread in collection detail view
//

import SwiftUI
struct ThreadContentView: View {
    // MARK: - Properties
    let threadViewModel: ThreadViewModel
    let thoughtViewModel: ThoughtViewModel
    @Binding var selectedThread: Thread?
    @Binding var showingAddThread: Bool
    @Binding var showingAddThought: Bool
    @Binding var isEditingThread: Bool
    @Binding var editedThreadTitle: String
    @Binding var editedThreadSummary: String
    let formatter: DateFormatter
    
    // MARK: - Body
    var body: some View {
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
                    isEditing: $isEditingThread,
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