//
//  ToDoListItemsView.swift
//  TodoList
//
//  Created by Dax Granados on 10/22/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ToDoListView: View {
    @StateObject var viewModel: ToDoListViewViewModel
    @FirestoreQuery var items: [TodoListItem]
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
        self._items = FirestoreQuery(
            collectionPath: 
                "users/\(userId)/todos",
            predicates: [.orderBy("isDone", true), .orderBy("dueDate", false)])
        
        self._viewModel = StateObject(
                wrappedValue:
                    ToDoListViewViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(items) {
                    item in
                    TodoListItemView(item: item)
                        .swipeActions {
                            Button {
                                //Delete
                                viewModel.delete(id: item.id)
                            } label: {
                                Text("Delete")
                            }
                            .tint(.red)
                        }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("To Do List")
            .toolbar {
                Button {
                    //Action
                    viewModel.showingNewItemView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView, content: {
                NewItemView(newItemPresented: $viewModel.showingNewItemView)
            })
        }
    }
}

#Preview {
    ToDoListView(userId: "12KU5yhz0hSoCYbru5TokHaTY6c2")
}
