import SwiftUI

struct ShareCardView: View {
    let input: String
    let output: String
    let character: HostCharacter
    let isNightMode: Bool

    var body: some View {
        ZStack {
            LinearGradient(
                colors: isNightMode ? [.black, Color(red: 0.16, green: 0.02, blue: 0.12)] : [.black, Color(red: 0.12, green: 0.06, blue: 0.02)],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 32) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("普通のLINEを")
                            .font(.system(size: 46, weight: .black, design: .rounded))
                        Text("ホスト語に翻訳した結果")
                            .font(.system(size: 56, weight: .black, design: .rounded))
                            .foregroundStyle(.yellow)
                            .shadow(color: .pink, radius: 14)
                    }
                    Spacer()
                    Text("HOST")
                        .font(.system(size: 50, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .shadow(color: .pink, radius: 12)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 22) {
                    chatBubble(text: input, incoming: true)
                    HStack {
                        Spacer()
                        chatBubble(text: output, incoming: false)
                    }
                }

                Spacer()

                HStack {
                    Label(character.displayName, systemImage: character.icon)
                        .font(.system(size: 30, weight: .black, design: .rounded))
                    Spacer()
                    Text(isNightMode ? "深夜モード" : "通常モード")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundStyle(.yellow)
                }
            }
            .padding(64)
        }
        .foregroundStyle(.white)
    }

    private func chatBubble(text: String, incoming: Bool) -> some View {
        Text(text)
            .font(.system(size: 42, weight: .black, design: .rounded))
            .lineSpacing(8)
            .foregroundStyle(incoming ? .black : .white)
            .padding(.horizontal, 34)
            .padding(.vertical, 28)
            .frame(maxWidth: 760, alignment: incoming ? .leading : .trailing)
            .background(incoming ? .white : .pink, in: RoundedRectangle(cornerRadius: 34))
            .shadow(color: incoming ? .clear : .pink.opacity(0.65), radius: 22)
    }
}
