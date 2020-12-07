//
//  SceneDelegate.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var dataBaseManager: DatabaseManager!


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let winScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: winScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainVc()
        dataBaseManager = DatabaseManager()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("sceneDidDisconnect")
        updateStatus(status: "inactive")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("sceneDidBecomeActive")
        updateStatus(status: "idle")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive")
        updateStatus(status: "inactive")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground")
        updateStatus(status: "idle")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground")
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

