//
//  SceneDelegate.swift
//  GoWalk
//
//  Created by jae hoon lee on 1/7/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = Test(networkManager: RXNetworkManager())
        window.makeKeyAndVisible()
        self.window = window
    }
}
