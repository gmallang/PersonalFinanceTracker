import SwiftUI

struct ContentView: View {
    @State private var expenses: [Expense] = []
    @State private var selectedCategory: String = "All"  // Filter by category
    @State private var sortOrder: SortOrder = .byName     //  Sort order

    enum SortOrder {
        case byName, byAmount
    }

    var body: some View {
        NavigationView {
            VStack {
                // Filter and Sort Controls
                HStack {
                    Picker("Category", selection: $selectedCategory) {
                        Text("All").tag("All")
                        Text("Food").tag("Food")
                        Text("Entertainment").tag("Entertainment")
                        Text("Transport").tag("Transport")
                        Text("Other").tag("Other")
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Spacer()

                    Picker("Sort by", selection: $sortOrder) {
                        Text("Name").tag(SortOrder.byName)
                        Text("Amount").tag(SortOrder.byAmount)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()

                List(filteredAndSortedExpenses) { expense in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(expense.name)
                                .font(.headline)
                            Text(expense.category)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("$\(expense.amount, specifier: "%.2f")")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
                .onDelete(perform: deleteExpense)
            }
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddExpenseView(addExpense: addExpense)) {
                        Image(systemName: "plus")
                            .font(.title)
                    }
                }
            }
        }
        .onAppear(perform: loadExpenses)
    }

    // Computed property to filter and sort
    var filteredAndSortedExpenses: [Expense] {
        var filtered = expenses

        // Filtering
        if selectedCategory != "All" {
            filtered = expenses.filter { $0.category == selectedCategory }
        }

        // Sorting
        switch sortOrder {
        case .byName:
            return filtered.sorted { $0.name < $1.name }
        case .byAmount:
            return filtered.sorted { $0.amount < $1.amount }
        }
    }

    // Add Expense and Save
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
        saveExpenses()
    }

    // Delete Expense and Save
    func deleteExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
        saveExpenses()
    }

    // Save expenses to UserDefaults
    func saveExpenses() {
        if let encoded = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(encoded, forKey: "SavedExpenses")
        }
    }

    // Load expenses from UserDefaults
    func loadExpenses() {
        if let savedData = UserDefaults.standard.data(forKey: "SavedExpenses"),
           let decoded = try? JSONDecoder().decode([Expense].self, from: savedData) {
            expenses = decoded
        }
    }
}
