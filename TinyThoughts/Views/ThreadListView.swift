//
//  ThreadListView.swift
//  TinyThoughts
//
//  Component for displaying a list of threads
//

import SwiftUI
import CoreData

struct ThreadListView: View {
    // MARK: - Properties
    @ObservedObject var threadViewModel: ThreadViewModel
    @ObservedObject var thoughtViewModel: ThoughtViewModel
    @Binding var selectedThread: Thread?
    @Binding var showingAddThread: Bool
    let formatter: DateFormatter
    
    var body: some View {
        ZStack {
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
            
            VStack {
                Spacer()
                AddButtonView(action: { showingAddThread = true })
            }
        }
    }
} 