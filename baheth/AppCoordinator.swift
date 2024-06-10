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
        rootViewController.tabBar.semanticContentAttribute = .forceRightToLeft
        rootViewController.tabBar.backgroundColor = .white

        let transcriptionsTab = TabCoordinator(
            title: "",
            icon: "doc.plaintext",
            url: URL(string: "https://baheth.ieasybooks.com/transcriptions/search")!
        )
        transcriptionsTab.start()

        let hadithsTab = TabCoordinator(
            title: "",
            icon: "text.bubble",
            url: URL(string: "https://baheth.ieasybooks.com/hadiths/search")!
        )
        hadithsTab.start()

        let shamelaTab = TabCoordinator(
            title: "",
            icon: "book.closed",
            url: URL(string: "https://baheth.ieasybooks.com/shamela/search")!
        )
        shamelaTab.start()

        tabCoordinators = [transcriptionsTab, hadithsTab, shamelaTab]
        rootViewController.viewControllers = tabCoordinators.map(\.navigationController)
    }
}
