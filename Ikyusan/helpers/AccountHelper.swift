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

//    func setTestId(testId :Int) {
//        let realm = Realm()
//        let test = LocalStore()
//        test.identifier = testId
//
//        realm.write { () -> Void in
//            realm.add(test, update: true)
//            return
//        }
//    }
//
//    func getTestId() -> Int? {
//        let stores = Realm().objects(LocalStore)
//        print("store count = " + String(stores.count))
//        if stores.count == 1 {
//            return stores[0].identifier
//        }
//        return nil
//    }

}
