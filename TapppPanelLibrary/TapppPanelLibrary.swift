//
//  TapppPanelLibrary.swift
//  TapppPanelLibrary
//
//  Created by MA-15 on 20/12/22.
//

import Foundation
import WebKit

public class WebkitClass: NSObject {

    override public init() {}
    public lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    public func configureWebview (view: UIView){
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])
        let contentController = self.webView.configuration.userContentController
        contentController.add(self, name: "toggleMessageHandler")
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false

        let customBundle = Bundle(for: WebkitClass.self)
        guard let resourceURL = customBundle.resourceURL?.appendingPathComponent("web-build.bundle") else { return }
        guard let resourceBundle = Bundle(url: resourceURL) else { return }
        guard let jsFileURL = resourceBundle.url(forResource: "index", withExtension: "html" ) else { return }
        webView.loadFileURL(jsFileURL, allowingReadAccessTo: jsFileURL.deletingLastPathComponent())

        /*let url = URL(string: "http://tappp-web-build.s3-website.us-east-2.amazonaws.com/")
        let requestObj = URLRequest(url: url! as URL)
        webView.load(requestObj)*/
    }
}

extension WebkitClass: WKScriptMessageHandler {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let dict = message.body as? [String : AnyObject] else {
            return
        }

        print(dict)
    }
}

