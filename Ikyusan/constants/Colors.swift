import UIKit

let kBackgroundColor                = UIColor.whiteColor()
let kBaseNavigationColor            = UIColor.whiteColor()
let kBaseNavigationStringColor      = Colors.getUIColorFromRGBValue( 85.0,  85.0,  85.0)
let kTwitterColor                   = Colors.getUIColorFromRGBValue( 85.0, 172.0, 238.0)
let kBaseGrayColor                  = Colors.getUIColorFromRGBValue(189.0, 189.0, 189.0)
let kBaseBlackColor                 = Colors.getUIColorFromRGBValue( 34.0,  34.0,  34.0)

enum GroupColor :Int {
    case Red        = 1
    case Orange     = 2
    case Yellow     = 3
    case Green      = 4
    case LightGreen = 5
    case LightBlue  = 6
    case Blue       = 7
    case Purple     = 8
    case Pink       = 9
    case LightGray  = 10
    case Gray       = 11
    case DarkGray   = 12
    case Default    = 0

    func getColor() -> UIColor {
        switch self {
            case .Red           : return Colors.getUIColorFromRGBValue(255.0,  82.0,  82.0)
            case .Orange        : return Colors.getUIColorFromRGBValue(255.0, 121.0,  69.0)
            case .Yellow        : return Colors.getUIColorFromRGBValue(255.0, 202.0,  47.0)
            case .Green         : return Colors.getUIColorFromRGBValue( 97.0, 191.0,  86.0)
            case .LightGreen    : return Colors.getUIColorFromRGBValue( 32.0, 201.0, 187.0)
            case .LightBlue     : return Colors.getUIColorFromRGBValue(106.0, 175.0, 245.0)
            case .Blue          : return Colors.getUIColorFromRGBValue( 77.0, 121.0, 232.0)
            case .Purple        : return Colors.getUIColorFromRGBValue(126.0, 109.0, 207.0)
            case .Pink          : return Colors.getUIColorFromRGBValue(245.0, 110.0, 155.0)
            case .LightGray     : return Colors.getUIColorFromRGBValue(219.0, 219.0, 219.0)
            case .Gray          : return Colors.getUIColorFromRGBValue(170.0, 170.0, 170.0)
            case .DarkGray      : return Colors.getUIColorFromRGBValue( 85.0,  85.0,  85.0)
            case .Default       : return Colors.getUIColorFromRGBValue(255.0, 255.0, 255.0)
            default             : return UIColor.whiteColor()
        }
    }

}

class Colors {

    /**
        RGBを引数にUIColorを返す
    */
    class func getUIColorFromRGBValue(r :CGFloat, _ g :CGFloat, _ b :CGFloat, _ a :CGFloat = 1.0) -> UIColor {
        return UIColor(
            red:   r/255.0,
            green: g/255.0,
            blue:  b/255.0,
            alpha: a)
    }
   
}
