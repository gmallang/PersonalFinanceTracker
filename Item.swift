import Foundation

struct Item: Identifiable, Codable, Hashable {
    let id = UUID()
    var name: String
    var amount: Double
    var category: String
    var date: Date
    
    init(name: String, amount: Double, category: String, date: Date = Date()) {
        self.name = name
        self.amount = amount
        self.category = category
        self.date = date
    }
}
