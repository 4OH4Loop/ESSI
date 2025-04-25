//
//  SnackDetailView.swift
//  ESSI
//
//  Created by Carolyn Ballinger on 4/14/25.
//

import SwiftUI
import SwiftData

struct SnackDetailView: View {
    enum ComfortLevel: Int, CaseIterable {
        case doesTheJob = 1
        case solid = 2
        case cravingSatisfyer = 3
        case gourmet = 4
        case emergencyComfort = 5
        
        var label: String {
            switch self {
            case .doesTheJob:
                return "1 - ✅ Does the job"
            case .solid:
                return "2 - 👍 Solid"
            case .cravingSatisfyer:
                return "3 - 🤤 Craving Met"
            case .gourmet:
                return "4 - 👨🍳 Gourmet"
            case .emergencyComfort:
                return "5 - 🚨 Emergency"
            }
        }
    }
    
    @State var snack: Snack
    @State private var name = ""
    @State private var onHand = 0
    @State private var notes = ""
    @State private var selectedComfortLevel = 1
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack (alignment: .leading) {
            TextField("snack name", text: $name)
                .font(.largeTitle)
                .textFieldStyle(.roundedBorder)
            
            
            HStack {
                Text("Qty:")
                    .bold()
                Spacer()
                Text("\(onHand)")
                Stepper("", value: $onHand, in: 0...Int.max)
                    .labelsHidden()
            }
            .padding(.bottom)
            
            HStack {
                Text("Comfort Level:")
                    .bold()
                
                Picker("", selection: $selectedComfortLevel) {
                    ForEach(ComfortLevel.allCases, id: \.self) { comfortLevel in
                        Text(comfortLevel.label).tag(comfortLevel.rawValue)
                    }
                }
            }
            .padding(.bottom)
            
            Text("Notes:")
                .bold()
            TextField("notes", text: $notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
            Spacer()
        }
        
        .padding(.horizontal)
        .font(.title2)
        .onAppear {
            name = snack.name
            onHand = snack.onHand
            notes = snack.notes
            selectedComfortLevel = snack.comfortLevel
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    snack.name = name
                    snack.onHand = onHand
                    snack.notes = notes
                    snack.comfortLevel = selectedComfortLevel
                    modelContext.insert(snack)
                    guard let _ = try? modelContext.save() else {
                        print("😡 ERROR: Save on SnackDetailView did not work.")
                        return
                    }
                    dismiss()
                }
            }
        }
    }
}
    
    #Preview {
        NavigationStack {
            SnackDetailView(snack: Snack(name: "Lil Swifties", onHand: 3, notes: "Homemade cookies baked by Prof. G. He will bring these for Lunar New Year.", comfortLevel: 5))
                .modelContainer(for: Snack.self, inMemory: true)
        }
        
    }

