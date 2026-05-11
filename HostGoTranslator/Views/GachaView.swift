import SwiftUI

struct GachaView: View {
    @EnvironmentObject private var viewModel: TranslatorViewModel
    @State private var spin = false

    var body: some View {
        ZStack {
            HostBackground(isNightMode: viewModel.isNightMode)

            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("ホストガチャ")
                            .font(.largeTitle.weight(.black))
                        Text("解放状況 \(viewModel.unlockedCountText)")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.yellow)
                    }
                    Spacer()
                    Image(systemName: "gift.fill")
                        .font(.system(size: 36, weight: .black))
                        .foregroundStyle(.yellow)
                        .rotationEffect(.degrees(spin ? 8 : -8))
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: spin)
                }
                .padding(.top, 18)

                GlowPanel {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("SSRラインナップ")
                                .font(.headline.weight(.black))
                            Spacer()
                            Text("広告視聴で1回")
                                .font(.caption.weight(.black))
                                .foregroundStyle(.yellow)
                        }

                        ForEach(HostCharacter.allCases.filter { $0.rarity == .ssr }) { character in
                            HStack(spacing: 12) {
                                Image(systemName: viewModel.isUnlocked(character) ? character.icon : "lock.fill")
                                    .font(.title3.weight(.black))
                                    .foregroundStyle(.black)
                                    .frame(width: 40, height: 40)
                                    .background(LinearGradient(colors: character.gradient, startPoint: .topLeading, endPoint: .bottomTrailing), in: Circle())

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(character.displayName)
                                            .font(.headline.weight(.black))
                                        RarityBadge(rarity: character.rarity)
                                    }
                                    Text("「\(character.sample)」")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.white.opacity(0.72))
                                        .lineLimit(1)
                                }

                                Spacer()

                                Image(systemName: viewModel.isUnlocked(character) ? "checkmark.seal.fill" : "sparkles")
                                    .foregroundStyle(viewModel.isUnlocked(character) ? .yellow : .white.opacity(0.45))
                            }
                            .padding(12)
                            .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }

                GlowPanel {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("ガチャ結果")
                            .font(.caption.weight(.black))
                            .foregroundStyle(.yellow)

                        if let result = viewModel.lastGachaResult {
                            HStack(spacing: 12) {
                                Image(systemName: result.character.icon)
                                    .font(.title.weight(.black))
                                    .foregroundStyle(.black)
                                    .frame(width: 58, height: 58)
                                    .background(LinearGradient(colors: result.character.gradient, startPoint: .topLeading, endPoint: .bottomTrailing), in: Circle())

                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Text(result.character.displayName)
                                            .font(.headline.weight(.black))
                                        RarityBadge(rarity: result.character.rarity)
                                    }
                                    Text(result.phrase)
                                        .font(.subheadline.weight(.bold))
                                        .foregroundStyle(.white.opacity(0.76))
                                }
                            }
                        } else {
                            Text("広告を見て、今夜のホストを引く。")
                                .font(.title3.weight(.black))
                                .foregroundStyle(.white.opacity(0.82))
                        }
                    }
                }

                RewardedAdButton {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.62)) {
                        viewModel.watchRewardedAdAndDrawGacha()
                    }
                }

                BannerAdView(adUnitID: "ca-app-pub-9404799280370656/5803546508")
                    .frame(height: 50)

                Spacer()
            }
            .padding(.horizontal, 18)
        }
        .onAppear { spin = true }
        .sheet(isPresented: $viewModel.showGachaResult) {
            GachaResultView()
                .presentationDetents([.medium])
        }
    }
}

struct GachaResultView: View {
    @EnvironmentObject private var viewModel: TranslatorViewModel

    var body: some View {
        ZStack {
            HostBackground(isNightMode: viewModel.isNightMode)

            if let result = viewModel.lastGachaResult {
                VStack(spacing: 18) {
                    Text(result.isNewUnlock ? "SSR解放" : "ガチャ結果")
                        .font(.largeTitle.weight(.black))
                        .foregroundStyle(result.isNewUnlock ? .yellow : .white)
                        .shadow(color: .pink.opacity(0.8), radius: 14)

                    Image(systemName: result.character.icon)
                        .font(.system(size: 70, weight: .black))
                        .foregroundStyle(.black)
                        .frame(width: 132, height: 132)
                        .background(LinearGradient(colors: result.character.gradient, startPoint: .topLeading, endPoint: .bottomTrailing), in: Circle())
                        .overlay(Circle().stroke(.white.opacity(0.45), lineWidth: 2))
                        .shadow(color: .yellow.opacity(result.isNewUnlock ? 0.85 : 0.35), radius: 24)

                    HStack {
                        Text(result.character.displayName)
                            .font(.title2.weight(.black))
                        RarityBadge(rarity: result.character.rarity)
                    }

                    Text(result.phrase)
                        .font(.headline.weight(.bold))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white.opacity(0.82))
                        .padding(.horizontal, 24)

                    Button {
                        viewModel.showGachaResult = false
                    } label: {
                        Text("閉じる")
                            .font(.headline.weight(.black))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(.yellow, in: RoundedRectangle(cornerRadius: 8))
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 28)
                }
                .padding(20)
            }
        }
    }
}
