import Foundation

enum SavedCategory: String, CaseIterable, Codable, Identifiable {
    case sasatta = "刺さった"
    case kimoi = "キモい"
    case tsukaitai = "使いたい"
    case kiken = "危険"

    var id: String { rawValue }
}

struct SavedPhrase: Identifiable, Codable, Equatable {
    let id: UUID
    let input: String
    let output: String
    let character: HostCharacter
    var category: SavedCategory
    let createdAt: Date

    init(
        id: UUID = UUID(),
        input: String,
        output: String,
        character: HostCharacter,
        category: SavedCategory,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.input = input
        self.output = output
        self.character = character
        self.category = category
        self.createdAt = createdAt
    }
}
