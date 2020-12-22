//
//  AppDelegate.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import LanguageManager_iOS

@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window : UIWindow?
    var dataBaseManager: DatabaseManager!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //add api key for google maps
        GMSServices.provideAPIKey(Base.mapsApiKey)
        GMSPlacesClient.provideAPIKey(Base.mapsApiKey)
        FirebaseApp.configure()
        
        dataBaseManager = DatabaseManager()
        LanguageManager.shared.defaultLanguage = .ja
        
        if #available(iOS 13, *) {
            // do only pure app launch stuff, not interface stuff
            print("ios 13 bro")
        } else {
            self.window = UIWindow()
            let vc = MainVc()
            self.window!.rootViewController = vc
            self.window!.makeKeyAndVisible()
            self.window!.backgroundColor = .red
        }
        updateStatus(status: "active")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("on Created")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
      print("discard session")
        updateStatus(status: "inactive")
    }
    
    private func updateStatus(status: String){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            return
        }
        
        dataBaseManager.updateStatus(codeDriver: codeDriver, status: status) { (res) in
            switch res {
            case .failure(let err): print(err)
            case .success(_): print("succes update status driver")
            }
        }
        
    }


}

