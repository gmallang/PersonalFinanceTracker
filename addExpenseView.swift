import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    let onSave: (Item) -> Void
    
    @State private var name = ""
    @State private var amount = ""
    @State private var category = "Food"
    @State private var showAlert = false
    
    private var categories = ["Food", "Entertainment", "Transport", "Other"]
    
    // Public initializer (as you had it)
    public init(onSave: @escaping (Item) -> Void) {
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) {
                        Text($0)
                    }
                }
            }
            .navigationTitle("Add New Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveItem()
                    }
                    .disabled(!isValid) // Disable save if input is invalid
                }
            }
            .alert("Invalid Input", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a valid name and a positive number for the amount.")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private var isValid: Bool {
        // Check if name is not empty and amount is a valid positive Double
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && Double(amount) ?? 0 > 0
    }
    
    private func saveItem() {
        guard let actualAmount = Double(amount), actualAmount > 0 else {
            showAlert = true
            return
        }
        
        let newItem = Item(name: name, amount: actualAmount, category: category)
        onSave(newItem)
        dismiss()
    }
}
