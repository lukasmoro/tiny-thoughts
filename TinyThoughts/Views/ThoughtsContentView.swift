//
//  ThoughtsContentView.swift
//  TinyThoughts
//
//  created for tiny software by lukas moro
//
//  thoughts content view used for displaying thoughts in the thread content view
//

import SwiftUI
import CoreData

struct ThoughtsContentView: View {
    // MARK: - Properties
    @ObservedObject var thoughtViewModel: ThoughtViewModel
    @Binding var showingAddThought: Bool
    let thread: Thread
    
    var body: some View {
        ZStack {
            VStack {
                if thoughtViewModel.thoughts.isEmpty {
                    EmptyStateView(
                        icon: "text.bubble",
                        title: "No thoughts yet",
                        message: "Use the + button below to add your first thought"
                    )
                } else {
                    List {
                        ForEach(thoughtViewModel.thoughts, id: \.id) { thought in
                            ThoughtView(thought: thought)
                                .listRowInsets(EdgeInsets())
                        }
                        .onDelete(perform: thoughtViewModel.deleteThoughts)
                    }
                    .listStyle(PlainListStyle())
                    .padding(.horizontal, 0)
                }
            }
            
            VStack {
                Spacer()
                AddButtonView(action: { showingAddThought = true }, size: 50)
            }
        }
    }
} 