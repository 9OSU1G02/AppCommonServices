//
//                       _oo0oo_
//                      o8888888o
//                      88" . "88
//                      (| -_- |)
//                      0\  =  /0
//                    ___/`---'\___
//                  .' \\|     |// '.
//                 / \\|||  :  |||// \
//                / _||||| -:- |||||- \
//               |   | \\\  -  /// |   |
//               | \_|  ''\---/''  |_/ |
//               \  .-\__  '-'  ___/-. /
//             ___'. .'  /--.--\  `. .'___
//          ."" '<  `.___\_<|>_/___.' >' "".
//         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//         \  \ `_.   \_ __\ /__ _/   .-` /  /
//     =====`-.____`.___ \_____/___.-`___.-'=====
		

import UIKit
import GoogleMobileAds
class GADViewController: UIViewController {
    private var rewardedAd: GADRewardedAd?
    var bannerView: GADBannerView!
    private var interstitial: GADInterstitialAd?
    private var rewardedInterstitialAd: GADRewardedInterstitialAd?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBannerAd()
    }
    
    
    @IBAction private func onTapShowInterAd() {
            loadInterAd()
         interstitial?.present(fromRootViewController: self)
    }
    
    @IBAction private func onTapShowRewardAd() {
        loadRewardedAd()
         showRewardAd()
    }
    
    @IBAction private func onTapShowRewardInterAd() {
        loadRewardedInterAd()
        showRewardInterAd()
    }
    
    func loadBannerAd() {
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(.init())
        addBannerViewToView(bannerView)
    }

    func loadInterAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910",
                               request: request,
                               completionHandler: { [self] ad, error in
                                   if let error = error {
                                       print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                       return
                                   }
                                   interstitial = ad
                               })
    }

    func loadRewardedInterAd() {
        GADRewardedInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/6978759866",
                                       request: GADRequest())
        { ad, error in
            if let error = error {
                return print("Failed to load rewarded interstitial ad with error: \(error.localizedDescription)")
            }

            self.rewardedInterstitialAd = ad
        }
    }

    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)])
    }
    
    func loadRewardedAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313",
                           request: request,
                           completionHandler: { [self] ad, error in
                               if let error = error {
                                   print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                                   return
                               }
                               rewardedAd = ad
                               print("Rewarded ad loaded.")
                           })
    }

    func showRewardAd() {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: self) {
                let reward = ad.adReward
                print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                // TODO: Reward the user.
            }
        } else {
            print("Ad wasn't ready")
        }
    }

    func showRewardInterAd() {
        guard let rewardedInterstitialAd = rewardedInterstitialAd else {
            return print("Ad wasn't ready.")
        }

        rewardedInterstitialAd.present(fromRootViewController: self) {
            let reward = rewardedInterstitialAd.adReward
            // TODO: Reward the user!
        }
    }
}
