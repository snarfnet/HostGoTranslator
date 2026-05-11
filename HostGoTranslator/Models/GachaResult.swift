import Foundation

struct GachaResult: Identifiable, Equatable {
    let id = UUID()
    let character: HostCharacter
    let isNewUnlock: Bool
    let phrase: String
}
