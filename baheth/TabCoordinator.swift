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

    private func visit(url: URL, action: VisitAction = .advance) {
        let viewController = VisitableViewController(url: url)

        if session.activeVisitable?.visitableURL == url {
            replaceLastController(with: viewController)
        } else if action == .advance {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            replaceLastController(with: viewController)
        }

        session.visit(viewController)
    }

    private func replaceLastController(with controller: UIViewController) {
        let viewControllers = navigationController.viewControllers.dropLast()
        navigationController.setViewControllers(viewControllers + [controller], animated: false)
    }

    private lazy var session: Session = {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "Turbo Native iOS"
        configuration.allowsInlineMediaPlayback = true

        let session = Session(webViewConfiguration: configuration)
        session.delegate = self
        session.webView.allowsLinkPreview = false
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
