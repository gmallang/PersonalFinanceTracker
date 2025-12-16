import SwiftUI

struct ContentView: View {
    @State private var items: [Item] = []
    @State private var showingAddView = false
    @State private var selectedCategory = "All"
    @State private var sortOrder: SortOrder = .Date
    
    enum SortOrder: String, CaseIterable {
        case Name, Amount, Date
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Filters") {
                    Picker("Category", selection: $selectedCategory) {
                        Text("All").tag("All")
                        ForEach(["Food", "Entertainment", "Transport", "Other"], id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                    
                    Picker("Sort By", selection: $sortOrder) {
                        ForEach(SortOrder.allCases, id: \.self) {
                            Text($0.rawValue.capitalized).tag($0)
                        }
                    }
                }
                
                // --- Items List Section ---
                Section("Expenses") {
                    ForEach(filteredAndSortedItems) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name).font(.headline)
                                Text(item.category)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: "USD"))
                                // Add a subtle style to the amount based on its value
                                .foregroundColor(amountColor(for: item.amount))
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            // THIS IS WHERE AddExpenseView IS CALLED
            .sheet(isPresented: $showingAddView) {
                AddExpenseView { newItem in
                    items.append(newItem)
                    Expenses.saveItems(items) // Save the updated array
                }
            }
            .onAppear {
                items = Expenses.loadItems() // Load saved items when the view appears
            }
        }
    }
    
    // MARK: - Computed Properties and Methods
    
    private var filteredAndSortedItems: [Item] {
        var filtered = selectedCategory == "All" ? items : items.filter { $0.category == selectedCategory }
        
        switch sortOrder {
        case .Name: filtered.sort { $0.name < $1.name }
        case .Amount: filtered.sort { $0.amount < $1.amount }
        case .Date: filtered.sort { $0.date > $1.date }
        }
        return filtered
    }
    
    private func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        Expenses.saveItems(items) // Save the updated array
    }
    
    private func amountColor(for amount: Double) -> Color {
        if amount > 100 {
            return .red
        } else if amount > 50 {
            return .orange
        } else {
            return .primary
        }
    }
}
