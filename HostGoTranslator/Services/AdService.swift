import SwiftUI
import GoogleMobileAds

protocol AdServing {
    func registerTranslation()
    func showRewardedAd(completion: @escaping () -> Void)
    var shouldShowInterstitialHint: Bool { get }
}

@MainActor
final class AdMobService: NSObject, ObservableObject, AdServing, GADFullScreenContentDelegate {
    @Published private(set) var translationCount = 0
    @Published private(set) var isRewardedAdLoaded = false

    private var rewardedAd: GADRewardedAd?
    private var pendingRewardCompletion: (() -> Void)?

    private let rewardedAdUnitID = "ca-app-pub-9404799280370656/4549790143"

    override init() {
        super.init()
        loadRewardedAd()
    }

    var shouldShowInterstitialHint: Bool {
        translationCount > 0 && translationCount.isMultiple(of: 5)
    }

    func registerTranslation() {
        translationCount += 1
    }

    func loadRewardedAd() {
        Task { @MainActor in
            do {
                let ad = try await GADRewardedAd.load(
                    withAdUnitID: rewardedAdUnitID,
                    request: GADRequest()
                )
                rewardedAd = ad
                rewardedAd?.fullScreenContentDelegate = self
                isRewardedAdLoaded = true
            } catch {
                isRewardedAdLoaded = false
            }
        }
    }

    func showRewardedAd(completion: @escaping () -> Void) {
        guard let ad = rewardedAd,
              let rootVC = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?.rootViewController else {
            completion()
            return
        }
        pendingRewardCompletion = completion
        ad.present(fromRootViewController: rootVC) { [weak self] in
            self?.pendingRewardCompletion?()
            self?.pendingRewardCompletion = nil
        }
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        isRewardedAdLoaded = false
        loadRewardedAd()
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        pendingRewardCompletion?()
        pendingRewardCompletion = nil
        loadRewardedAd()
    }
}

struct RewardedAdButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: "play.rectangle.fill")
                    .font(.title3.weight(.black))
                VStack(alignment: .leading, spacing: 2) {
                    Text("広告を見てガチャを回す")
                        .font(.headline.weight(.black))
                    Text("SSRホスト解放チャンス")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.black.opacity(0.65))
                }
                Spacer()
                Image(systemName: "gift.fill")
                    .font(.title3.weight(.black))
            }
            .padding(14)
            .background(LinearGradient(colors: [.yellow, .pink], startPoint: .leading, endPoint: .trailing), in: RoundedRectangle(cornerRadius: 8))
            .foregroundStyle(.black)
        }
        .buttonStyle(.plain)
    }
}

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String

    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        banner.adUnitID = adUnitID
        banner.rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController
        banner.load(GADRequest())
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {}
}
