import Foundation

final class StorageService {
    private let key = "savedHostPhrases.v1"

    func load() -> [SavedPhrase] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let saved = try? JSONDecoder().decode([SavedPhrase].self, from: data) else {
            return []
        }
        return saved
    }

    func save(_ phrases: [SavedPhrase]) {
        guard let data = try? JSONEncoder().encode(phrases) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
