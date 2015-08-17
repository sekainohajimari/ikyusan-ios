import UIKit
import SDWebImage

extension UIImageView {

    func setImageWithUrl(urlStr: String, block: (image:UIImage) -> Void) {
        self.alpha = 0.0
        var url = NSURL(string: urlStr)
        self.sd_setImageWithURL(url!,
            placeholderImage: nil, completed: { (img, err, type, url) -> Void in
                if img == nil {
                    return
                }
                if type != SDImageCacheType.Memory {
                    UIView.animateWithDuration(
                        0.35,
                        delay: 0.0,
                        options: UIViewAnimationOptions.CurveEaseIn,
                        animations: {
                            self.alpha = 1.0
                        },
                        completion:{
                            (value: Bool) in
                            block(image: img)
                        }
                    )
                } else {
                    self.alpha = 1.0
                    block(image: img)
                }
            }
        )
    }
}
