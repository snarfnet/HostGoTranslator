import SwiftUI
import UIKit

@MainActor
struct ShareImageRenderer {
    func render(input: String, output: String, character: HostCharacter, isNightMode: Bool) -> UIImage? {
        let view = ShareCardView(input: input, output: output, character: character, isNightMode: isNightMode)
            .frame(width: 1080, height: 1350)

        let renderer = ImageRenderer(content: view)
        renderer.scale = 1
        return renderer.uiImage
    }
}
