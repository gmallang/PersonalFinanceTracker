import SwiftUI
struct ContentView: View {
    @State private var expenses: [Expense] = [
        Expense(name: "Groceries", amount: 120.50, category: "Food"),
        Expense(name: "Netflix", amount: 15.99, category: "Entertainment"),
        Expense(name: "Gas", amount: 45.30, category: "Transport")
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(expenses) { expense in
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
        }
    }

    func deleteExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
    }
}
