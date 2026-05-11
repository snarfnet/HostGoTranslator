import SwiftUI
import UIKit

struct ContentView: View {
    @EnvironmentObject private var viewModel: TranslatorViewModel

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("ホーム", systemImage: "house.fill") }

            TranslationView()
                .tabItem { Label("翻訳", systemImage: "sparkles") }

            CharacterSelectionView()
                .tabItem { Label("キャラ", systemImage: "person.crop.circle.badge.plus") }

            GachaView()
                .tabItem { Label("ガチャ", systemImage: "gift.fill") }

            SavedPhrasesView()
                .tabItem { Label("保存", systemImage: "heart.fill") }
        }
        .tint(.yellow)
        .preferredColorScheme(.dark)
        .sheet(isPresented: $viewModel.showShareSheet) {
            if let image = viewModel.generatedShareImage {
                ActivityView(items: [image])
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

struct RarityBadge: View {
    let rarity: HostRarity

    var body: some View {
        Text(rarity.displayName)
            .font(.caption2.weight(.black))
            .padding(.horizontal, 7)
            .padding(.vertical, 4)
            .background(rarity == .ssr ? .yellow : .white.opacity(0.16), in: Capsule())
            .foregroundStyle(rarity == .ssr ? .black : .white)
    }
}

struct HostBackground: View {
    let isNightMode: Bool

    var body: some View {
        ZStack {
            LinearGradient(
                colors: isNightMode
                    ? [Color.black, Color(red: 0.07, green: 0.02, blue: 0.12), Color.black]
                    : [Color.black, Color(red: 0.12, green: 0.04, blue: 0.16), Color(red: 0.08, green: 0.05, blue: 0.02)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            RadialGradient(colors: [.purple.opacity(isNightMode ? 0.45 : 0.28), .clear], center: .topTrailing, startRadius: 20, endRadius: 360)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                ForEach(0..<12, id: \.self) { index in
                    Rectangle()
                        .fill(.white.opacity(index.isMultiple(of: 2) ? 0.08 : 0.04))
                        .frame(height: 1)
                        .blur(radius: 0.4)
                }
            }
            .rotationEffect(.degrees(-12))
            .offset(y: -80)
        }
    }
}

struct NeonTitle: View {
    let text: String
    let subtitle: String
    let isNightMode: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(text)
                .font(.system(size: 42, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: .pink.opacity(0.9), radius: isNightMode ? 18 : 10)
                .shadow(color: .yellow.opacity(0.45), radius: 5)
            Text(subtitle)
                .font(.caption.weight(.bold))
                .foregroundStyle(.yellow.opacity(0.9))
                .textCase(.uppercase)
        }
    }
}

struct GlowPanel<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .background(.black.opacity(0.42), in: RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(.white.opacity(0.15)))
            .shadow(color: .purple.opacity(0.25), radius: 18, y: 8)
    }
}

struct CharacterBadge: View {
    let character: HostCharacter

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: character.icon)
                .foregroundStyle(.black)
                .frame(width: 26, height: 26)
                .background(.yellow, in: Circle())
            Text(character.displayName)
                .font(.subheadline.weight(.bold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(.white.opacity(0.10), in: Capsule())
    }
}

struct PrimaryHostButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.headline.weight(.black))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(LinearGradient(colors: [.yellow, .pink], startPoint: .leading, endPoint: .trailing), in: RoundedRectangle(cornerRadius: 8))
                .foregroundStyle(.black)
        }
        .buttonStyle(.plain)
    }
}

struct UtilityButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.title3.weight(.bold))
                Text(title)
                    .font(.caption.weight(.bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(.white.opacity(0.10), in: RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(.white.opacity(0.12)))
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
