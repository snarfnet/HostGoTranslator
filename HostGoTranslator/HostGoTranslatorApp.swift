import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

@main
struct HostGoTranslatorApp: App {
    @StateObject private var viewModel = TranslatorViewModel()
    @Environment(\.scenePhase) private var scenePhase

    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                requestTrackingPermission()
            }
        }
    }

    private func requestTrackingPermission() {
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ATTrackingManager.requestTrackingAuthorization { _ in }
        }
    }
}
