//
//  AppDelegate.swift
//  Gems Game Testing
//
//  Created by vLinkD on 15/02/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//
//

import UIKit
import Firebase
let emailId = "tejuchahar@gmail.com"
let obsId = "tejuchahar"
let obsId1 = "tejuchahar65"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        authWithFireBase()
        return true
    }
    
    func authWithFireBase() {
        
        Auth.auth().createUser(withEmail: emailId, password: "123456") { authResult, error in
            print(authResult, error)
            if error != nil {
                self.loginWithFirebase()
            }
        }
        
    }
    
    func loginWithFirebase() {
        Auth.auth().signIn(withEmail: emailId, password: "123456") { [weak self] authResult, error in
            guard let strongSelf = self else { return }
           print(authResult?.user)
            // ...
        }
    }
    
    
}

