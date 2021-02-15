//
//  AppDelegate.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FirebaseCore
import LanguageManager_iOS
import FirebaseMessaging
import UserNotifications

@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window : UIWindow?
    var dataBaseManager: DatabaseManager!
    
    let gcmMessageIDKey = "gcm.Message_ID"
    
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
        print("On Load View Ready")
        
        //firebase notification
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("on Created")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("discard session")
        updateStatus(status: "inactive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("discard session")
        updateStatus(status: "inactive")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("sceneDidBecomeActive")
        updateStatus(status: "active")
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground")
        updateStatus(status: "active")
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print("sceneDidDisconnect")
        updateStatus(status: "inactive")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive")
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
    
    private func updateToken(token: String){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            return
        }
        
        dataBaseManager.updateToken(codeDriver: codeDriver, token: token) { (res) in
            switch res {
            case .failure(let err): print(err)
            case .success(_): print("succes update token fcm driver")
            }
        }
        
    }
    
    //MARK: - FCM
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      print("userInfo", userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }
        
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }


}


@available(iOS 13.0, *)
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("TOKEN FCM: \(String(describing: fcmToken))")
        updateToken(token: fcmToken!)
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}


@available(iOS 13, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    print(userInfo)

    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    print(userInfo)

    completionHandler()
  }
}
