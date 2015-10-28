import Foundation

// TODO: refactor

class DateHelper {

    class func getDateString(dateString :String) -> String {

        if dateString == "" {
            return ""
        }

        let now = NSDate()
        let target = getDateFromString(dateString)

        let seconds = now.timeIntervalSinceDate(target)

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
        let dateComps = getDateComponents(date)
        return String(format: "%@:%@",
            addZeroForDate(String(dateComps.hour)),
            addZeroForDate(String(dateComps.minute))
        )
    }

    private class func convertSQLDateFormat_MMddHHmm(date :NSDate) -> String {
        let dateComps = getDateComponents(date)
        return String(format: "%@月%@日 %@:%@",
            addZeroForDate(String(dateComps.month)),
            addZeroForDate(String(dateComps.day)),
            addZeroForDate(String(dateComps.hour)),
            addZeroForDate(String(dateComps.minute))
        )
    }

    private class func convertSQLDateFormat_yyyyMMddHHmm(date :NSDate) -> String {
        let dateComps = getDateComponents(date)
        return String(format: "%@年%@月%@日 %@:%@", String(dateComps.year),
            addZeroForDate(String(dateComps.month)),
            addZeroForDate(String(dateComps.day)),
            addZeroForDate(String(dateComps.hour)),
            addZeroForDate(String(dateComps.minute))
        )
    }

    private class func getDateComponents(date :NSDate) -> NSDateComponents {
        return NSCalendar.currentCalendar().components([
                NSCalendarUnit.Year,
                NSCalendarUnit.Month,
                NSCalendarUnit.Day,
                NSCalendarUnit.Hour,
                NSCalendarUnit.Minute
            ], fromDate: date) as NSDateComponents
    }

    private class func addZeroForDate(dateString :String) -> String {
        let len = (dateString as NSString).length
        if len != 1 {
            return dateString
        }
        return "0" + dateString
    }

    private class func getDateFromString(dateString :String) -> NSDate {
        let str = dateString as NSString
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.dateFromString(str as String)
        return date!
    }
}