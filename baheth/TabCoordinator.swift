//
//  AppCoordinator.swift
//  baheth
//
//  Created by علي فاضل on 14/07/2023.
//

import UIKit
import Turbo
import WebKit

class TabCoordinator: NSObject {
    lazy var navigationController = UINavigationController()
    let title: String
    let icon: String
    let url: URL

    init(title: String, icon: String, url: URL) {
        self.title = title
        self.icon = icon
        self.url = url
    }

    func start() {
        visit(url: url)

        if #available(iOS 15, *) {
            UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
        }
        
        navigationController.navigationBar.semanticContentAttribute = .forceRightToLeft
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(systemName: icon)
    }

    private func visit(url: URL) {
        let viewController = CustomVisitableViewController(url: url)
        navigationController.pushViewController(viewController, animated: true)

        session.visit(viewController)
    }

    private lazy var session: Session = {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "Turbo Native iOS"
        configuration.allowsInlineMediaPlayback = true

        let session = Session(webViewConfiguration: configuration)
        session.delegate = self
        return session
    }()
}

extension TabCoordinator: SessionDelegate {
    func session(_ session: Session, didProposeVisit proposal: VisitProposal) {
        visit(url: proposal.url)
    }

    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, error: Error) {
        print("didFailRequestForVisitable: \(error)")
    }

    func sessionWebViewProcessDidTerminate(_ session: Session) {
        session.reload()
    }
}
