//
//  SceneDelegate.swift
//  baheth
//
//  Created by علي فاضل on 11/06/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let appCoordinator = AppCoordinator()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        window!.rootViewController = appCoordinator.rootViewController
        appCoordinator.start()
    }
}
