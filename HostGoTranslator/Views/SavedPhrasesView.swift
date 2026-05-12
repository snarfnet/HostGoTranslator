import SwiftUI

struct SavedPhrasesView: View {
    @EnvironmentObject private var viewModel: TranslatorViewModel
    @State private var filter: SavedCategory? = nil

    private var filteredPhrases: [SavedPhrase] {
        guard let filter else { return viewModel.savedPhrases }
        return viewModel.savedPhrases.filter { $0.category == filter }
    }

    var body: some View {
        ZStack {
            HostBackground(isNightMode: viewModel.isNightMode)

            VStack(alignment: .leading, spacing: 14) {
                Text("保存一覧")
                    .font(.largeTitle.weight(.black))
                    .padding(.top, 18)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        filterButton(title: "全部", active: filter == nil) { filter = nil }
                        ForEach(SavedCategory.allCases) { category in
                            filterButton(title: category.rawValue, active: filter == category) { filter = category }
                        }
                    }
                }

                if filteredPhrases.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "heart.slash.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(.yellow)
                        Text("まだ保存がありません")
                            .font(.headline.weight(.black))
                        Text("刺さったセリフを保存すると、ここに並びます。")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.65))
                    }
                    .frame(maxWidth: .infinity)
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredPhrases) { phrase in
                                savedRow(phrase)
                            }
                            BannerAdView(adUnitID: "ca-app-pub-9404799280370656/5803546508")
                    .frame(height: 50)
                                .padding(.top, 4)
                                .padding(.bottom, 24)
                        }
                    }
                }
            }
            .padding(.horizontal, 18)
        }
    }

    private func filterButton(title: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.caption.weight(.black))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(active ? .yellow : .white.opacity(0.10), in: Capsule())
                .foregroundStyle(active ? .black : .white)
        }
        .buttonStyle(.plain)
    }

    private func savedRow(_ phrase: SavedPhrase) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                CharacterBadge(character: phrase.character)
                Spacer()
                Text(phrase.category.rawValue)
                    .font(.caption.weight(.black))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(.yellow, in: Capsule())
            }

            Text("「\(phrase.output)」")
                .font(.title3.weight(.black))
                .lineSpacing(4)

            HStack {
                Text(phrase.input)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
                Spacer()
                Button {
                    viewModel.deleteSaved(phrase)
                } label: {
                    Image(systemName: "trash.fill")
                        .foregroundStyle(.pink)
                        .frame(width: 34, height: 34)
                        .background(.white.opacity(0.08), in: Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .background(.black.opacity(0.42), in: RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.white.opacity(0.12)))
    }
}
