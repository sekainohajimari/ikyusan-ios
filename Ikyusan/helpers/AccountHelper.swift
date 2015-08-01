//
//  AccountHelper.swift
//  Ikyusan
//
//  Created by SatoShunsuke on 2015/05/03.
//  Copyright (c) 2015年 moguraproject. All rights reserved.
//

import UIKit
import RealmSwift

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
        userDefault.setValue(data.identifier.value, forKey: "identifier")
        userDefault.setValue(data.token.value, forKey: "token")
        userDefault.setValue(data.profile.displayId.value, forKey: "display_id")
        userDefault.setValue(data.profile.displayName.value, forKey: "display_name")
        userDefault.setValue(data.profile.iconUrl.value, forKey: "icon_url")
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

    func setTestId(testId :Int) {
        let realm = Realm()
        let test = LocalStore()
        test.identifier = testId

        realm.write { () -> Void in
            realm.add(test, update: true)
            return
        }
    }

    func getTestId() -> Int? {
        let stores = Realm().objects(LocalStore)
        if stores.count == 1 {
            return stores[0].identifier
        }
        return nil
    }

/*
    let primaryKey = 99999999


    func setSignUp(data :Signup) {

    }

    
    func getUserId() -> Int? {
        var localStore = self.getStore()
        if let store = localStore {
            return store.identifier
        }
        return nil
    }
    
    func setUserId(userId :Int) {
        var localStore = self.getStore()
        if let store = localStore {
            store.identifier = userId
            self.updateLocalStore(store)
        } else {
            var l = LocalStore()
            l.identifier = userId
            self.createLocalStore(l)
        }
    }
    
    func getAccessToken() -> String? {
        var localStore = self.getStore()
        if let store = localStore {
            return "Token token=\"" + store.token + "\""
        }
        return nil
        //        return "Token token=\"c9ccf7b8ecd186792829f0e1d54c67741feb7f467a39902cc158ef83e9e458423166804258971f13\""
    }
    
    func setAccessToken(token :String) {
        var localStore = self.getStore()
        if localStore != nil {
            localStore!.token = token
            self.updateLocalStore(localStore!)
        } else {
            let l = LocalStore()
            l.token = token
            self.createLocalStore(l)
        }
    }

    func delete(userId :Int) {
        var localStore = self.getStore()
        if let store = localStore {
            realm.beginWriteTransaction()
            realm.deleteObject(store)
            realm.commitWriteTransaction()
        }


        let book = LocalStore()
        book.serialId = 5
        book.identifier = 1234
        book.token = "tesssst"

        realm.transactionWithBlock { () -> Void in
            self.realm.addObject(book)
        }

        let staff = LocalStore(forPrimaryKey:5)

        // 先ほどのBookオブジェクトを取得
        // Class.allObjectsで全オブジェクト取得.
        for realmBook in LocalStore.allObjects() {
            // book name:realm sample
            println("book name:\((realmBook as! LocalStore).identifier)")
            println("book name:\((realmBook as! LocalStore).token)")
        }








        var a = self.getStore()



        self.setAccessToken("test")
        self.setUserId(5)
//        self.setAccessToken("test")
    }

    // MARK: - XXXXX

    private func createLocalStore(store :LocalStore) {
        realm.beginWriteTransaction()
        realm.addObject(store)
        realm.commitWriteTransaction()
    }

    private func updateLocalStore(store :LocalStore) {
        realm.beginWriteTransaction()
        realm.addOrUpdateObject(store)
        realm.commitWriteTransaction()
    }

    private func getStore() -> LocalStore? {
        if LocalStore.allObjects().count == 0 {
            return nil
        } else if LocalStore.allObjects().count == 1 {
//            for realmBook in LocalStore.allObjects() {
//                println("book name:\((realmBook as! LocalStore).identifier)")
//                println("book name:\((realmBook as! LocalStore).token)")
//            }
//            if let books = LocalStore.allObjects() {
//                return books.firstObject() as? LocalStore
//            }
//            return LocalStore.allObjects().firstObject() as? LocalStore
            if let book = LocalStore(forPrimaryKey: 1234) {
                return book
            }
            return LocalStore.allObjects().firstObject() as? LocalStore
        } else {
            print("LocalStoreの数がおかしい")
            realm.beginWriteTransaction()
            realm.deleteObjects(LocalStore.allObjects())
            realm.commitWriteTransaction()
            return nil
        }

    }
*/
    
}
