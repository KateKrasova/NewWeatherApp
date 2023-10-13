//
//  SceneDelegate.swift
//  NewWeatherApp
//
//  Created by Kate on 10.10.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = WeatherViewController(apiService: ApiService())
        window?.makeKeyAndVisible()
    }
}

