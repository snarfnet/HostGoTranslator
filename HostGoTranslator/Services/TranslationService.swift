import Foundation

struct TranslationService {
    private let phraseBook: PhraseBook

    init(bundle: Bundle = .main) {
        if let url = bundle.url(forResource: "host_phrases", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode(PhraseBook.self, from: data) {
            phraseBook = decoded
        } else {
            phraseBook = PhraseBook(
                phrases: [],
                prefixes: ["てか", "普通に", "今日も"],
                middles: ["可愛すぎ", "反則", "やばい"],
                suffixes: ["なんだけど", "で無理", "罪"],
                nightPrefixes: ["深夜だから言うけど", "もうさ", "今だけ本音ね"],
                nightSuffixes: ["もうお前しか勝たん", "帰したくない", "朝まで覚えてて"]
            )
        }
    }

    func translate(_ input: String, character: HostCharacter, isNightMode: Bool) -> String {
        let normalized = input.trimmingCharacters(in: .whitespacesAndNewlines)
        let matched = phraseBook.phrases.filter { phrase in
            phrase.character == character.rawValue && normalized.localizedCaseInsensitiveContains(phrase.keyword)
        }

        if let phrase = matched.randomElement() {
            let pool = isNightMode ? (phrase.nightResponses ?? phrase.responses) : phrase.responses
            if let response = pool.randomElement() {
                return response
            }
        }

        return templatedResponse(for: normalized, character: character, isNightMode: isNightMode)
    }

    private func templatedResponse(for input: String, character: HostCharacter, isNightMode: Bool) -> String {
        let prefix = (isNightMode ? phraseBook.nightPrefixes : phraseBook.prefixes).randomElement() ?? "てか"
        let middle = phraseBook.middles.randomElement() ?? "可愛すぎ"
        let suffix = (isNightMode ? phraseBook.nightSuffixes : phraseBook.suffixes).randomElement() ?? "なんだけど"

        switch character {
        case .oudo:
            return "\(prefix)、\(input.isEmpty ? "その感じ" : input)、\(middle)\(suffix)"
        case .oraora:
            return "\(input.isEmpty ? "黙ってこっち見て" : input)？ \(middle)から俺の横いろ"
        case .chika:
            return "\(prefix)、会えない間も\(input.isEmpty ? "お前" : input)のこと考えてた"
        case .prince:
            return "\(input.isEmpty ? "今夜" : input)、月より先に俺が見つけたかった"
        case .kansai:
            return "\(prefix)、\(input.isEmpty ? "その可愛さ" : input)、反則やで"
        case .menhera:
            return "\(input.isEmpty ? "返信ない時間" : input)、永遠みたいで無理"
        case .emperor:
            return "\(prefix)、\(input.isEmpty ? "この夜" : input)で一番光ってるの、お前"
        case .vampire:
            return "\(input.isEmpty ? "その可愛さ" : input)、少しだけ吸わせて。嘘、全部ほしい"
        case .champagne:
            return "\(input.isEmpty ? "お前の笑顔" : input)でタワー立った。今夜の主役じゃん"
        }
    }
}
