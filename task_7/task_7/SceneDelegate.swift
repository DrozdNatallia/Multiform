//
//  SceneDelegate.swift
//  task_7
//
//  Created by Natalia Drozd on 23.01.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navigationVC = UINavigationController()
        let assemblyBuilder = BuilderClass()
        let router = Router(navigationController: navigationVC, assemblyBuilder: assemblyBuilder)
        router.initialViewController()
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
    }
}
