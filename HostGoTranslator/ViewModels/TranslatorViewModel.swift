import SwiftUI
import UIKit

@MainActor
final class TranslatorViewModel: ObservableObject {
    @Published var inputText = ""
    @Published var resultText = "普通のLINEを入れると、ここにホスト語が出ます"
    @Published var selectedCharacter: HostCharacter = .oudo
    @Published var savedPhrases: [SavedPhrase] = []
    @Published var selectedSaveCategory: SavedCategory = .sasatta
    @Published var generatedShareImage: UIImage?
    @Published var showShareSheet = false
    @Published var showInterstitialHint = false
    @Published var unlockedCharacters: Set<HostCharacter> = Set(HostCharacter.initialUnlocked)
    @Published var lastGachaResult: GachaResult?
    @Published var showGachaResult = false

    private let translator = TranslationService()
    private let storage = StorageService()
    private let feedback = FeedbackService()
    private let shareRenderer = ShareImageRenderer()
    private let adService = AdMobService()
    private let gachaService = GachaService()
    private let unlockedKey = "unlockedHostCharacters.v1"

    init() {
        savedPhrases = storage.load()
        loadUnlockedCharacters()
        feedback.prepareHaptics()
    }

    var isNightMode: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour >= 22 || hour < 5
    }

    var todayPhrase: String {
        isNightMode ? "もうお前しか勝たん" : selectedCharacter.sample
    }

    var ranking: [String] {
        ["俺以外見てんじゃねーよ", "今日も可愛い更新してるじゃん", "返信ない5分、永遠だった"]
    }

    var unlockedCountText: String {
        "\(unlockedCharacters.count)/\(HostCharacter.allCases.count)"
    }

    func isUnlocked(_ character: HostCharacter) -> Bool {
        unlockedCharacters.contains(character)
    }

    func selectCharacter(_ character: HostCharacter) {
        guard isUnlocked(character) else { return }
        selectedCharacter = character
    }

    func translate() {
        resultText = translator.translate(inputText, character: selectedCharacter, isNightMode: isNightMode)
        feedback.playTranslateFeedback()
        adService.registerTranslation()
        showInterstitialHint = adService.shouldShowInterstitialHint
    }

    func copyResult() {
        UIPasteboard.general.string = resultText
        feedback.playCopyFeedback()
    }

    func saveResult() {
        let phrase = SavedPhrase(
            input: inputText.isEmpty ? "普通の言葉" : inputText,
            output: resultText,
            character: selectedCharacter,
            category: selectedSaveCategory
        )
        savedPhrases.insert(phrase, at: 0)
        storage.save(savedPhrases)
        feedback.playCopyFeedback()
    }

    func deleteSaved(_ phrase: SavedPhrase) {
        savedPhrases.removeAll { $0.id == phrase.id }
        storage.save(savedPhrases)
    }

    func shareResult() {
        generatedShareImage = shareRenderer.render(
            input: inputText.isEmpty ? "お疲れ" : inputText,
            output: resultText,
            character: selectedCharacter,
            isNightMode: isNightMode
        )
        showShareSheet = generatedShareImage != nil
    }

    func watchRewardedAdAndDrawGacha() {
        adService.showRewardedAd { [weak self] in
            Task { @MainActor in
                self?.drawGachaAfterReward()
            }
        }
    }

    private func drawGachaAfterReward() {
        let result = gachaService.draw(unlocked: unlockedCharacters)
        lastGachaResult = result

        if result.isNewUnlock {
            unlockedCharacters.insert(result.character)
            selectedCharacter = result.character
            saveUnlockedCharacters()
        }

        feedback.playTranslateFeedback()
        showGachaResult = true
    }

    private func loadUnlockedCharacters() {
        guard let rawValues = UserDefaults.standard.array(forKey: unlockedKey) as? [String] else { return }
        let loaded = rawValues.compactMap(HostCharacter.init(rawValue:))
        unlockedCharacters = Set(HostCharacter.initialUnlocked + loaded)
    }

    private func saveUnlockedCharacters() {
        UserDefaults.standard.set(unlockedCharacters.map(\.rawValue), forKey: unlockedKey)
    }
}
