import Foundation

class DataManager {
    private static let savedItemsKey = "SavedItems"
    
    static func saveItems(_ items: [Item]) {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: savedItemsKey)
        }
    }
    
    static func loadItems() -> [Item] {
        guard let savedData = UserDefaults.standard.data(forKey: savedItemsKey),
              let decoded = try? JSONDecoder().decode([Item].self, from: savedData)
        else { return [] }
        return decoded
    }
}

