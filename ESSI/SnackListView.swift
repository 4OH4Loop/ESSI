//
//  SnackListView.swift
//  ESSI
//
//  Created by Carolyn Ballinger on 4/14/25.
//

import SwiftUI
import SwiftData

struct SnackListView: View {
    @Query private var snacks: [Snack]
    @State private var sheetIsPresented = false
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(snacks) { snack in
                    NavigationLink  {
                        SnackDetailView(snack: snack)
                    } label: {
                        VStack (alignment: .leading) {
                            Text(snack.name)
                                .font(.title)
                                .lineLimit(1)
                            
                            HStack {
                                Text("Qty: \(snack.onHand)")
                                Text(snack.notes)
                                    .italic()
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                            .font(.body)
                        }
                    }
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            modelContext.delete(snack)
                            guard let _ = try? modelContext.save() else {
                                print("😡 ERROR: Save after .delete did not work.")
                                return
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Snacks on Hand:")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    SnackDetailView(snack: Snack())
                }
            }
        }
        .padding()
    }
}

#Preview {
    SnackListView()
        .modelContainer(Snack.preview)
}
