//
//  TapppPanelLibrary.swift
//  TapppPanelLibrary
//
//  Created by MA-15 on 20/12/22.
//

import Foundation
import WebKit

public protocol alertDelegate: class {
    func myVCDidFinish( text: String)
}

public class WebkitClass: NSObject {

    public lazy var webView = WKWebView()
    public var delegate: alertDelegate?
    private var sportsbook = ""
    private var subscriberArr = [String]()
    var view = UIView()
    
    override public init() {}
    
    public func initPanel(panelData: [String: Any], panelSetting: [String: Any], currView: UIView) {
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        sportsbook = panelData["sportsbook"] as? String ?? ""
        let contentController = self.webView.configuration.userContentController
        contentController.add(self, name: "toggleMessageHandler")

        view = currView
    }

    public func start(){
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])
        
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        
        if let url = Bundle(for: WebkitClass.self).url(forResource: "sample", withExtension: ".html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }

        /*let customBundle = Bundle(for: WebkitClass.self)
        guard let resourceURL = customBundle.resourceURL?.appendingPathComponent("web-build.bundle") else { return }
        guard let resourceBundle = Bundle(url: resourceURL) else { return }
        guard let jsFileURL = resourceBundle.url(forResource: "index", withExtension: "html" ) else { return }
        webView.loadFileURL(jsFileURL, allowingReadAccessTo: jsFileURL.deletingLastPathComponent())*/
    }
    
    public func subscribe(event: String, completion: (String)->()){
        subscriberArr.append(event)
        print(subscriberArr)
        completion("subscriber configured")
    }
    public func unSubscribe(event: String, completion: (String)->()){

        if let index = subscriberArr.firstIndex(of: event)
        {
            subscriberArr.remove(at: index)
        }
        print(subscriberArr)
        completion("unSubscriber configured")
    }


    public func stop(){
        if #available(iOS 14.0, *) {
            webView.configuration.userContentController.removeAllScriptMessageHandlers()
        } else {
            // Fallback on earlier versions
        }
        webView.removeFromSuperview()
    }
    // conditional code based on API.
    public func showPanel(){
        self.start()
    }
    public func hidePanel(){
        self.stop()
    }
}

extension WebkitClass: WKScriptMessageHandler {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let dict = message.body as? [String : AnyObject] else {
            return
        }

        print("received detail:", dict["message"])
        if message.name == "toggleMessageHandler", let dict = message.body as? NSDictionary {
            let userName = dict["message"] as! String
            if subscriberArr.contains(where: {$0 == "toastDisplay"}){
                delegate?.myVCDidFinish(text: userName)
            }
        } else if message.name == "showPanelData"{

        }
    }
}

