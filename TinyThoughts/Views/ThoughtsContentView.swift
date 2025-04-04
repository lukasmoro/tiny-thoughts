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