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
    var jsonString = String()

    override public init() {}
    
    public func initPanel(panelData: [String: Any], panelSetting: [String: Any], currView: UIView) {
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        sportsbook = panelData["sportsbook"] as? String ?? ""
        let contentController = self.webView.configuration.userContentController
        contentController.add(self, name: "toggleMessageHandler")
        contentController.add(self, name: "showPanelData")
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
        
        webView.navigationDelegate = self
        
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        
        if let url = Bundle(for: WebkitClass.self).url(forResource: "sample", withExtension: ".html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }

    func loadDataJS (str : String){
        //let payload = "ravi test final"
        self.webView.evaluateJavaScript("handleMessage('\(str)');", completionHandler: { result, error in
            if let val = result as? String {
                print(val)
            }
            else {
                print("result is NIL")
            }
        });
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
    
    public func displayMsg(str : String){
        self.loadDataJS(str: str)
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

extension WebkitClass: WKNavigationDelegate{
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}
