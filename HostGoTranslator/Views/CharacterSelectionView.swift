import SwiftUI

struct CharacterSelectionView: View {
    @EnvironmentObject private var viewModel: TranslatorViewModel

    var body: some View {
        ZStack {
            HostBackground(isNightMode: viewModel.isNightMode)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("キャラクター選択")
                        .font(.largeTitle.weight(.black))
                        .padding(.top, 18)

                    ForEach(HostCharacter.allCases) { character in
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.78)) {
                                viewModel.selectCharacter(character)
                            }
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: viewModel.isUnlocked(character) ? character.icon : "lock.fill")
                                    .font(.title2.weight(.black))
                                    .foregroundStyle(.black)
                                    .frame(width: 46, height: 46)
                                    .background(LinearGradient(colors: character.gradient, startPoint: .topLeading, endPoint: .bottomTrailing), in: Circle())

                                VStack(alignment: .leading, spacing: 6) {
                                    Text(character.displayName)
                                        .font(.headline.weight(.black))
                                    HStack(spacing: 6) {
                                        RarityBadge(rarity: character.rarity)
                                        if !viewModel.isUnlocked(character) {
                                            Text("ガチャで解放")
                                                .font(.caption2.weight(.bold))
                                                .foregroundStyle(.yellow)
                                        }
                                    }
                                    Text("「\(character.sample)」")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.white.opacity(0.78))
                                        .lineLimit(2)
                                }

                                Spacer()

                                Image(systemName: viewModel.selectedCharacter == character ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(viewModel.selectedCharacter == character ? .yellow : .white.opacity(0.35))
                                    .font(.title3)
                            }
                            .padding(14)
                            .background(.black.opacity(0.42), in: RoundedRectangle(cornerRadius: 8))
                            .opacity(viewModel.isUnlocked(character) ? 1 : 0.58)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(viewModel.selectedCharacter == character ? .yellow : .white.opacity(0.12), lineWidth: 1.2))
                        }
                        .buttonStyle(.plain)
                    }

                    GlowPanel {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "gift.fill")
                                    .foregroundStyle(.yellow)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("SSRホスト解放")
                                        .font(.headline.weight(.black))
                                    Text("解放状況 \(viewModel.unlockedCountText)")
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.7))
                                }
                                Spacer()
                            }
                            RewardedAdButton {
                                viewModel.watchRewardedAdAndDrawGacha()
                            }
                        }
                    }

                    BannerAdPlaceholder()
                        .padding(.bottom, 24)
                }
                .padding(.horizontal, 18)
            }
        }
        .sheet(isPresented: $viewModel.showGachaResult) {
            GachaResultView()
                .presentationDetents([.medium])
        }
    }
}
