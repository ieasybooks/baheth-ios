//
//  SceneDelegate.swift
//  baheth
//
//  Created by علي فاضل on 11/06/2023.
//

import UIKit
import Turbo
import WebKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private lazy var navigationController = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        window!.rootViewController = navigationController
        visit(url: URL(string: "https://baheth.ieasybooks.com")!)
    }

    private func visit(url: URL) {
        let viewController = VisitableViewController(url: url)
        navigationController.pushViewController(viewController, animated: true)
        navigationController.setNavigationBarHidden(true, animated: false)
        session.visit(viewController)
    }

    private lazy var session: Session = {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "Turbo Native iOS"

        let session = Session(webViewConfiguration: configuration)
        session.delegate = self
        return session
    }()
}

extension SceneDelegate: SessionDelegate {
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
