import SwiftUI

struct TranslationView: View {
    @EnvironmentObject private var viewModel: TranslatorViewModel
    @FocusState private var focused: Bool
    @State private var resultPulse = false

    var body: some View {
        ZStack {
            HostBackground(isNightMode: viewModel.isNightMode)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("ホスト語翻訳")
                                .font(.largeTitle.weight(.black))
                            CharacterBadge(character: viewModel.selectedCharacter)
                        }
                        Spacer()
                        if viewModel.isNightMode {
                            Image(systemName: "moon.fill")
                                .font(.title2)
                                .foregroundStyle(.pink)
                        }
                    }
                    .padding(.top, 18)

                    GlowPanel {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("入力")
                                .font(.caption.weight(.black))
                                .foregroundStyle(.yellow)
                            TextEditor(text: $viewModel.inputText)
                                .focused($focused)
                                .frame(minHeight: 120)
                                .scrollContentBackground(.hidden)
                                .padding(10)
                                .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
                                .overlay(alignment: .topLeading) {
                                    if viewModel.inputText.isEmpty {
                                        Text("普通の言葉を入力")
                                            .foregroundStyle(.white.opacity(0.42))
                                            .padding(.top, 18)
                                            .padding(.leading, 15)
                                    }
                                }
                        }
                    }

                    GlowPanel {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("翻訳結果")
                                    .font(.caption.weight(.black))
                                    .foregroundStyle(.yellow)
                                Spacer()
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.pink)
                                    .scaleEffect(resultPulse ? 1.18 : 0.92)
                            }

                            Text("「\(viewModel.resultText)」")
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .lineSpacing(7)
                                .minimumScaleFactor(0.78)
                                .shadow(color: .pink.opacity(viewModel.isNightMode ? 0.95 : 0.55), radius: viewModel.isNightMode ? 16 : 8)
                                .scaleEffect(resultPulse ? 1.015 : 1)
                                .animation(.spring(response: 0.35, dampingFraction: 0.7), value: viewModel.resultText)

                            Picker("カテゴリ", selection: $viewModel.selectedSaveCategory) {
                                ForEach(SavedCategory.allCases) { category in
                                    Text(category.rawValue).tag(category)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }

                    PrimaryHostButton(title: "翻訳", systemImage: "sparkles") {
                        focused = false
                        withAnimation {
                            resultPulse.toggle()
                            viewModel.translate()
                        }
                    }

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        UtilityButton(title: "コピー", systemImage: "doc.on.doc.fill") { viewModel.copyResult() }
                        UtilityButton(title: "シェア", systemImage: "square.and.arrow.up.fill") { viewModel.shareResult() }
                        UtilityButton(title: "保存", systemImage: "heart.fill") { viewModel.saveResult() }
                        UtilityButton(title: "音声", systemImage: "speaker.wave.2.fill") { viewModel.translate() }
                    }

                    if viewModel.showInterstitialHint {
                        HStack(spacing: 10) {
                            Image(systemName: "play.rectangle.fill")
                            Text("5回翻訳。ここでインタースティシャル広告を表示できます。")
                                .font(.caption.weight(.bold))
                            Spacer()
                        }
                        .padding(12)
                        .background(.yellow.opacity(0.18), in: RoundedRectangle(cornerRadius: 8))
                    }

                    BannerAdPlaceholder()
                        .padding(.bottom, 24)
                }
                .padding(.horizontal, 18)
            }
        }
    }
}
