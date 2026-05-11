import Foundation

struct GachaService {
    func draw(unlocked: Set<HostCharacter>) -> GachaResult {
        let pool: [(HostCharacter, Int)] = [
            (.oudo, 18),
            (.oraora, 18),
            (.chika, 18),
            (.prince, 16),
            (.kansai, 16),
            (.menhera, 14),
            (.emperor, 5),
            (.vampire, 4),
            (.champagne, 6)
        ]

        let totalWeight = pool.reduce(0) { $0 + $1.1 }
        var ticket = Int.random(in: 1...totalWeight)
        let selected = pool.first { item in
            ticket -= item.1
            return ticket <= 0
        }?.0 ?? .oudo

        let isNew = selected.rarity == .ssr && !unlocked.contains(selected)
        return GachaResult(
            character: selected,
            isNewUnlock: isNew,
            phrase: resultPhrase(for: selected, isNew: isNew)
        )
    }

    private func resultPhrase(for character: HostCharacter, isNew: Bool) -> String {
        if isNew {
            return "\(character.displayName)を解放。今夜のスクショ、強くなった。"
        }

        switch character.rarity {
        case .ssr:
            return "SSR演出きた。\(character.displayName)のセリフ欠片を入手。"
        case .rare:
            return "\(character.displayName)の名刺を入手。"
        case .normal:
            return "\(character.displayName)の営業LINEが届いた。"
        }
    }
}
