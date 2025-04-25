import SwiftUI

struct ContentView: View {
    @State private var items: [Item] = []
    @State private var selectedCategory = "All"
    @State private var sortOrder: SortOrder = .byDate
    
    enum SortOrder: String, CaseIterable {
        case byName, byAmount, byDate
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Category", selection: $selectedCategory) {
                        Text("All").tag("All")
                        Text("Food").tag("Food")
                        Text("Entertainment").tag("Entertainment")
                        Text("Transport").tag("Transport")
                        Text("Other").tag("Other")
                    }
                    
                    Picker("Sort By", selection: $sortOrder) {
                        ForEach(SortOrder.allCases, id: \.self) { order in
                            Text(order.rawValue.capitalized).tag(order)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                ForEach(filteredAndSortedItems) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.category)
                                .font(.subheadline)
                                .foregroundColor(.gray)  // Fixed from 'fore' to 'foregroundColor'
                        }
                        Spacer()
                        Text("$\(item.amount, specifier: "%.2f")")
                            .font(.body.monospacedDigit())
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Add action here
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear {
            items = DataManager.loadItems()
        }
    }
    
    private var filteredAndSortedItems: [Item] {
        var filtered = items
        
        if selectedCategory != "All" {
            filtered = items.filter { $0.category == selectedCategory }
        }
        
        switch sortOrder {
        case .byName: return filtered.sorted { $0.name < $1.name }
        case .byAmount: return filtered.sorted { $0.amount < $1.amount }
        case .byDate: return filtered.sorted { $0.date > $1.date }
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        DataManager.saveItems(items)
    }
}
