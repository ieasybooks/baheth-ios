//
//  CustomVisitableViewController.swift
//  baheth
//
//  Created by علي فاضل on 14/07/2023.
//

import Turbo

class CustomVisitableViewController: VisitableViewController {
    override func visitableDidRender() {
        navigationItem.title = visitableView.webView?.title
    }
}
