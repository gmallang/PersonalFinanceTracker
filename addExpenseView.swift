import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    let onSave: (Item) -> Void  // Changed to let + public
    
    @State private var name = ""
    @State private var amount = ""
    @State private var category = "Food"
    @State private var showAlert = false
    
    private var categories = ["Food", "Entertainment", "Transport", "Other"]
    
    // Explicit public initializer
    public init(onSave: @escaping (Item) -> Void) {
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            // ... rest of the view remains the same ...
        }
    }
}
