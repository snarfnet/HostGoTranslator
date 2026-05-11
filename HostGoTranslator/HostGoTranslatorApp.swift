import SwiftUI
import GoogleMobileAds

@main
struct HostGoTranslatorApp: App {
    @StateObject private var viewModel = TranslatorViewModel()

    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
