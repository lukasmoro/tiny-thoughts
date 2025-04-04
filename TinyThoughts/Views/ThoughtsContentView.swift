//
//  ThoughtsContentView.swift
//  TinyThoughts
//
//  Component for displaying a list of thoughts
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