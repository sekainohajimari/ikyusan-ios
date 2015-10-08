import UIKit
//import RealmSwift

class AccountHelper {

    //singleton
    class var sharedInstance : AccountHelper {
        struct Static {
            static let instance : AccountHelper = AccountHelper()
        }
        return Static.instance
    }

    func deleteAll() {
        var userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.removeObjectForKey("identifier")
        userDefault.removeObjectForKey("token")
        userDefault.removeObjectForKey("display_id")
        userDefault.removeObjectForKey("display_name")
        userDefault.removeObjectForKey("icon_url")
    }

    func setProfile(data :Profile) {
        var userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setValue(data.displayId.value,   forKey: "display_id")
        userDefault.setValue(data.displayName.value, forKey: "display_name")
        if data.inUseDefaultIcon.value {
            userDefault.setValue(data.defaultIconUrl.value, forKey: "icon_url")
        } else {
            userDefault.setValue(data.iconUrl.value,        forKey: "icon_url")
        }
    }

    func setSingUp(data :Signup) {
        var userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setValue(data.identifier.value,          forKey: "identifier")
        userDefault.setValue(data.token.value,               forKey: "token")
        userDefault.setValue(data.profile.displayId.value,   forKey: "display_id")
        userDefault.setValue(data.profile.displayName.value, forKey: "display_name")
        userDefault.setValue(data.profile.iconUrl.value,     forKey: "icon_url")
    }

    func getUserId() -> Int? {
        var userDefault = NSUserDefaults.standardUserDefaults()
        return userDefault.valueForKey("identifier") as? Int
    }

    func getAccessToken() -> String? {
        var userDefault = NSUserDefaults.standardUserDefaults()
        if let token = userDefault.valueForKey("token") as? String {
            return "Token token=\"" + token + "\""
        }
        return nil
    }

    func deleteAccessToken() {
        var userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.removeObjectForKey("token")
    }

    func getDisplayId() -> String? {
        var userDefault = NSUserDefaults.standardUserDefaults()
        return userDefault.valueForKey("display_id") as? String
    }

    func getDisplayName() -> String? {
        var userDefault = NSUserDefaults.standardUserDefaults()
        return userDefault.valueForKey("display_name") as? String
    }

    func getIconUrl() -> String? {
        var userDefault = NSUserDefaults.standardUserDefaults()
        return userDefault.valueForKey("icon_url") as? String
    }

}
