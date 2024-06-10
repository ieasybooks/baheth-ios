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
    let pathConfiguration = PathConfiguration(sources: [
        .file(Bundle.main.url(forResource: "path-configuration", withExtension: "json")!)
    ])

    init(title: String, icon: String, url: URL) {
        self.title = title
        self.icon = icon
        self.url = url
        
        super.init()
        
        navigationController.setNavigationBarHidden(true, animated: true)
    }

    func start() {
        visit(url: url)

        navigationController.navigationBar.semanticContentAttribute = .forceRightToLeft
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(systemName: icon)
        navigationController.tabBarItem.selectedImage = UIImage(systemName: icon)?.withTintColor(UIColor(red: 0.40, green: 0.64, blue: 0.05, alpha: 1.00), renderingMode: .alwaysOriginal)
        navigationController.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor(red: 0.40, green: 0.64, blue: 0.05, alpha: 1.00)], for: .selected)
    }

    private func visit(url: URL, action: VisitAction = .advance, properties: PathProperties = [:]) {
        let viewController = VisitableViewController(url: url)
        viewController.visitableView.allowsPullToRefresh = false

        if(properties["presentation"] as? String == "modal") {
            navigationController.present(viewController, animated: true)

            modalSession.visit(viewController)
        } else {
            if session.activeVisitable?.visitableURL == url {
                replaceLastController(with: viewController)
            } else if action == .advance {
                navigationController.pushViewController(viewController, animated: true)
            } else {
                replaceLastController(with: viewController)
            }

            session.visit(viewController)
        }
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
        session.pathConfiguration = pathConfiguration
        return session
    }()
    
    private lazy var modalSession: Session = {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "Turbo Native iOS - Modal"

        let session = Session(webViewConfiguration: configuration)
        session.delegate = self
        session.pathConfiguration = pathConfiguration
        return session
    }()
}

extension TabCoordinator: SessionDelegate {
    func session(_ session: Session, didProposeVisit proposal: VisitProposal) {
        visit(url: proposal.url, action: proposal.options.action, properties: proposal.properties)
    }

    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, error: Error) {
        print("didFailRequestForVisitable: \(error)")
    }

    func sessionWebViewProcessDidTerminate(_ session: Session) {
        session.reload()
    }
}
