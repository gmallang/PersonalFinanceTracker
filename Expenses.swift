import Foundation

struct Expense: Identifiable, Codable {
    var id = UUID()  // Unique identifier
    var name: String
    var amount: Double
    var category: String
}

