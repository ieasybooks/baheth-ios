//
//  AppCoordinator.swift
//  baheth
//
//  Created by علي فاضل on 14/07/2023.
//

import Foundation
import UIKit

class AppCoordinator: NSObject {
    lazy var rootViewController = UITabBarController()
    var tabCoordinators: [TabCoordinator] = []

    func start() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
        }

        rootViewController.tabBar.semanticContentAttribute = .forceRightToLeft

        let homeTab = TabCoordinator(
            title: "الرئيسية",
            icon: "house",
            url: URL(string: "https://baheth.ieasybooks.com")!
        )
        homeTab.start()

        let speakersTab = TabCoordinator(
            title: "المتحدّثون",
            icon: "person.2.fill",
            url: URL(string: "https://baheth.ieasybooks.com/speakers")!
        )
        speakersTab.start()

        let playlistsTab = TabCoordinator(
            title: "قوائم التشغيل",
            icon: "play.rectangle.on.rectangle.fill",
            url: URL(string: "https://baheth.ieasybooks.com/playlists")!
        )
        playlistsTab.start()

        tabCoordinators = [homeTab, speakersTab, playlistsTab]
        rootViewController.viewControllers = tabCoordinators.map(\.navigationController)
    }
}
