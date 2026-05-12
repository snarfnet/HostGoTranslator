import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: TranslatorViewModel
    @State private var pulse = false

    var body: some View {
        NavigationStack {
            ZStack {
                HostBackground(isNightMode: viewModel.isNightMode)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        HStack(alignment: .top) {
                            NeonTitle(text: "HOST", subtitle: "ホスト語翻訳機", isNightMode: viewModel.isNightMode)
                            Spacer()
                            Image(systemName: "wineglass.fill")
                                .font(.system(size: 34, weight: .black))
                                .foregroundStyle(.yellow)
                                .scaleEffect(pulse ? 1.08 : 0.96)
                                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: pulse)
                        }
                        .padding(.top, 18)

                        if viewModel.isNightMode {
                            HStack {
                                Image(systemName: "moon.stars.fill")
                                Text("深夜モード発動中")
                                    .font(.headline.weight(.black))
                                Spacer()
                                Text("22:00-5:00")
                                    .font(.caption.weight(.bold))
                            }
                            .padding(12)
                            .background(.pink.opacity(0.22), in: RoundedRectangle(cornerRadius: 8))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(.pink.opacity(0.55)))
                        }

                        GlowPanel {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("今日のホスト語")
                                    .font(.caption.weight(.black))
                                    .foregroundStyle(.yellow)
                                Text("「\(viewModel.todayPhrase)」")
                                    .font(.title2.weight(.black))
                                    .lineSpacing(4)
                                    .shadow(color: .pink.opacity(0.8), radius: 8)
                                CharacterBadge(character: viewModel.selectedCharacter)
                            }
                        }

                        GlowPanel {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("キャラクター")
                                    .font(.caption.weight(.black))
                                    .foregroundStyle(.yellow)
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                    ForEach(HostCharacter.allCases) { character in
                                        Button {
                                            viewModel.selectCharacter(character)
                                        } label: {
                                            VStack(alignment: .leading, spacing: 8) {
                                                HStack {
                                                    Image(systemName: viewModel.isUnlocked(character) ? character.icon : "lock.fill")
                                                        .font(.title3)
                                                    Spacer()
                                                    RarityBadge(rarity: character.rarity)
                                                }
                                                Text(character.shortName)
                                                    .font(.headline.weight(.black))
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.72)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .frame(height: 74)
                                            .padding(12)
                                            .background(
                                                LinearGradient(colors: character.gradient.map { $0.opacity(viewModel.selectedCharacter == character ? 0.75 : 0.28) }, startPoint: .topLeading, endPoint: .bottomTrailing),
                                                in: RoundedRectangle(cornerRadius: 8)
                                            )
                                            .opacity(viewModel.isUnlocked(character) ? 1 : 0.48)
                                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(viewModel.selectedCharacter == character ? .yellow : .white.opacity(0.15), lineWidth: 1.4))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }

                        RewardedAdButton {
                            viewModel.watchRewardedAdAndDrawGacha()
                        }

                        NavigationLink {
                            TranslationView()
                        } label: {
                            Label("翻訳開始", systemImage: "arrow.right.circle.fill")
                                .font(.headline.weight(.black))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(LinearGradient(colors: [.yellow, .pink], startPoint: .leading, endPoint: .trailing), in: RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.black)
                        }
                        .buttonStyle(.plain)

                        GlowPanel {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("ランキング")
                                    .font(.caption.weight(.black))
                                    .foregroundStyle(.yellow)
                                ForEach(Array(viewModel.ranking.enumerated()), id: \.offset) { index, phrase in
                                    HStack(alignment: .top, spacing: 10) {
                                        Text("#\(index + 1)")
                                            .font(.caption.weight(.black))
                                            .foregroundStyle(.black)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(.yellow, in: Capsule())
                                        Text(phrase)
                                            .font(.subheadline.weight(.bold))
                                        Spacer()
                                    }
                                }
                            }
                        }

                        BannerAdView(adUnitID: "ca-app-pub-9404799280370656/5803546508")
                    .frame(height: 50)
                            .padding(.bottom, 22)
                    }
                    .padding(.horizontal, 18)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $viewModel.showGachaResult) {
                GachaResultView()
                    .presentationDetents([.medium])
            }
        }
        .onAppear { pulse = true }
    }
}
