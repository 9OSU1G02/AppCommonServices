

import GoogleMobileAds
import UIKit
class BeachViewController: UIViewController {
    @IBOutlet private var adView: UIView!
    private var adLoader: GADAdLoader!

    override func viewDidLoad() {
        super.viewDidLoad()
        adLoader = GADAdLoader(
            adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: self,
            adTypes: [.native], options: [])
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
}

extension BeachViewController: GADAdLoaderDelegate, GADNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        let nibView = Bundle.main.loadNibNamed("UnifiedNativeAdView", owner: nil, options: nil)?.first
          let nativeAdView = nibView as! GADNativeAdView
        adView.addSubview(nativeAdView)
        nativeAdView.frame = adView.bounds
          // Create and place ad in view hierarchy.
          // Populate the native ad view with the native ad assets.
          // The headline and mediaContent are guaranteed to be present in every native ad.
          (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
          nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

          // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
          // ratio of the media it displays.
          if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
            let heightConstraint = NSLayoutConstraint(
              item: mediaView,
              attribute: .height,
              relatedBy: .equal,
              toItem: mediaView,
              attribute: .width,
              multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
              constant: 0)
            heightConstraint.isActive = true
          }

          // These assets are not guaranteed to be present. Check that they are before
          // showing or hiding them.
          (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
          nativeAdView.bodyView?.isHidden = nativeAd.body == nil

          (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
          nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

          (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
          nativeAdView.iconView?.isHidden = nativeAd.icon == nil

//          (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(
//            fromStarRating: nativeAd.starRating)
          nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil

          (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
          nativeAdView.storeView?.isHidden = nativeAd.store == nil

          (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
          nativeAdView.priceView?.isHidden = nativeAd.price == nil

          (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
          nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

          // In order for the SDK to process touch events properly, user interaction should be disabled.
          nativeAdView.callToActionView?.isUserInteractionEnabled = false

          // Associate the native ad view with the native ad object. This is
          // required to make the ad clickable.
          // Note: this should always be done after populating the ad views.
          nativeAdView.nativeAd = nativeAd
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print(error.localizedDescription)
    }
}
