import AVFoundation
import CoreHaptics
import SwiftUI
import UIKit

final class FeedbackService {
    private var audioPlayer: AVAudioPlayer?

    func playTranslateFeedback() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        AudioServicesPlaySystemSound(1108)
    }

    func playCopyFeedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        AudioServicesPlaySystemSound(1004)
    }

    func prepareHaptics() {
        _ = CHHapticEngine.capabilitiesForHardware()
    }
}
