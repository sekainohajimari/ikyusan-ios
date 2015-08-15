import Foundation

// TODO: refactor

class DateHelper {

    class func getDateString(dateString :String) -> String {

        if dateString == "" {
            return ""
        }

        print("FDSAFDSAFDSA:" + dateString)

        var now = NSDate()
        var target = getDateFromString(dateString)

        var seconds = now.timeIntervalSinceDate(target)

        if seconds < 60 {
            return "たった今"
        } else if seconds < 60 * 60 {
            return String(format: "%d分前", Int(seconds / 60.0))
        } else if seconds < 60 * 60 * 24 {
            return String(format: "%d時間前", Int(seconds / 60.0 / 60.0))
        } else if seconds < 60 * 60 * 24 * 2 {
            return String(format: "昨日 %@", convertSQLDateFormat_HHmm(target))
        } else {
            if getDateComponents(now).year == getDateComponents(target).year {
                return convertSQLDateFormat_MMddHHmm(target)
            } else {
                return convertSQLDateFormat_yyyyMMddHHmm(target)
            }
        }
    }

    // MARK: - private

    private class func convertSQLDateFormat_HHmm(date :NSDate) -> String {
        var dateComps = getDateComponents(date)
        return String(format: "%@:%@",
            addZeroForDate(String(dateComps.hour)),
            addZeroForDate(String(dateComps.minute))
        )
    }

    private class func convertSQLDateFormat_MMddHHmm(date :NSDate) -> String {
        var dateComps = getDateComponents(date)
        return String(format: "%@月%@日 %@:%@",
            addZeroForDate(String(dateComps.month)),
            addZeroForDate(String(dateComps.day)),
            addZeroForDate(String(dateComps.hour)),
            addZeroForDate(String(dateComps.minute))
        )
    }

    private class func convertSQLDateFormat_yyyyMMddHHmm(date :NSDate) -> String {
        var dateComps = getDateComponents(date)
        return String(format: "%@年%@月%@日 %@:%@", String(dateComps.year),
            addZeroForDate(String(dateComps.month)),
            addZeroForDate(String(dateComps.day)),
            addZeroForDate(String(dateComps.hour)),
            addZeroForDate(String(dateComps.minute))
        )
    }

    private class func getDateComponents(date :NSDate) -> NSDateComponents {
        return NSCalendar.currentCalendar().components(
            NSCalendarUnit.CalendarUnitYear |
                NSCalendarUnit.CalendarUnitMonth |
                NSCalendarUnit.CalendarUnitDay |
                NSCalendarUnit.CalendarUnitHour |
                NSCalendarUnit.CalendarUnitMinute
            , fromDate: date) as NSDateComponents
    }

    private class func addZeroForDate(dateString :String) -> String {
        var len = (dateString as NSString).length
        if len != 1 {
            return dateString
        }
        return "0" + dateString
    }

    private class func getDateFromString(dateString :String) -> NSDate {
        var str = dateString as NSString
//        str = str.stringByReplacingOccurrencesOfString(":", withString: "",
//            options: NSStringCompareOptions.allZeros, range: NSMakeRange(str.length - 5, 5))
        print("fdsafdsairi:" + (str as String))
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var date = formatter.dateFromString(str as String)
        return date!
    }
}