import Foundation

struct PhraseData: Codable, Identifiable {
    var id: String { keyword + character }
    let keyword: String
    let character: String
    let responses: [String]
    let nightResponses: [String]?
}

struct PhraseBook: Codable {
    let phrases: [PhraseData]
    let prefixes: [String]
    let middles: [String]
    let suffixes: [String]
    let nightPrefixes: [String]
    let nightSuffixes: [String]
}
