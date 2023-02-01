//
//  TapppPanelLibrary.swift
//  TapppPanelLibrary
//
//  Created by MA-15 on 20/12/22.
//

import Foundation
import WebKit
//import Amplify
//import AWSAPIPlugin

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
        //configureAmplify()

        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        sportsbook = panelData["sportsbook"] as? String ?? ""
        let contentController = self.webView.configuration.userContentController
        contentController.add(self, name: "toggleMessageHandler")
        contentController.add(self, name: "showPanelData")
        view = currView
    }
    
   /* func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
            print("Amplify configured 🥳")
        } catch {
            print("Failed to configure Amplify", error)
        }
    }*/

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

        let customBundle = Bundle(for: WebkitClass.self)
        guard let resourceURL = customBundle.resourceURL?.appendingPathComponent("web-build.bundle") else { return }
        guard let resourceBundle = Bundle(url: resourceURL) else { return }
        guard let jsFileURL = resourceBundle.url(forResource: "index", withExtension: "html" ) else { return }
        webView.loadFileURL(jsFileURL, allowingReadAccessTo: jsFileURL.deletingLastPathComponent())

        webView.configuration.preferences.javaScriptEnabled = true
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
/*
extension WebkitClass {
    
    public func getGameInfoAPI () {
        do {
            Task {
                let data = try await Amplify.API.query(request: .getGameInfo(bookId: "1000009", broadcastName: "NFL", gameId: "067d2ebf-5dbe-4281-bca7-7a2820784fc9"))
                print("getGameInfoAPI \(data) .")
            }
        } catch {
            print("Fetching images failed with error \(error)")
        }
    }
    
    public func callcommandSubscriptionAPI () {
        do {
            Task {//gameId : 067d2ebf-5dbe-4281-bca7-7a2820784fc9
                  /*commandSubscribe: {bookId: "1000009", command: "OPEN", gameId: "1444309", type: "panelCommand"}*/
                let data = try await Amplify.API.subscribe(request: .commandSubscribe(bookId: "1000009", gameId: "1444309"))
                print("callcommandSubscriptionAPI \(data) .")
                Task {
                    do {
                        for try await obj in data{
                            switch obj {
                            case .connection(let subscriptionConnectionState):
                                print("Subscription connect state is \(subscriptionConnectionState)")
                            case .data(let result):
                                switch result {
                                case .success(let createdTodo):
                                    print("Successfully got todo from subscription: \(createdTodo)")
                                case .failure(let error):
                                    print("Got failed result with \(error.errorDescription)")
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("Fetching images failed with error \(error)")
        }
    }
    
    public func callMutationSendPanelCommandAPI (){
        do {
            Task {
                let data = try await Amplify.API.mutate(request: .mutationSendPanelCommand(bookId: "100009", gameId: "213123"))
                switch data {
                case .success(let todo):
                    print("Successfully created todo: \(todo)")
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
                print("callMutationPlaceBetAPI \(data) .")
            }
        } catch {
            print("Fetching images failed with error \(error)")
        }
    }

}
extension GraphQLRequest {
    
    static func getGameInfo(bookId: String, broadcastName: String, gameId: String) -> GraphQLRequest<String> {
        
        let operationName = "getGameInfo"
        let query =
            """
            {
                getGameInfo(bookId: "\(bookId)", broadcasterName: "\(broadcastName)", gameId: "\(gameId)", lang: "english"){
                            code
                            message
                            requestURI
                            status
                            data {
                              broadcasterGameId
                              isGameLive
                              providerGameId
                              startDate
                            }
                }
            }
            """
        return GraphQLRequest<String>(
            document: query,
            variables: ["bookId": bookId],
            responseType: String.self,
            decodePath: operationName
        )
    }
    
    static func commandSubscribe(bookId: String, gameId: String) -> GraphQLRequest<String> {
        
        let operationName = "commandSubscribe"
        
        /*commandSubscribe: {bookId: "1000009", command: "OPEN", gameId: "1444309", type: "panelCommand"}*/
        
        let query =
            """
            subscription commandSubscription {
                commandSubscribe(bookId: "\(bookId)", gameId: "\(gameId)") {
                    bookId
                    command
                    gameId
                    type
                }
            }
            """
        return GraphQLRequest<String>(
            document: query,
            variables: [:],
            responseType: String.self,
            decodePath: operationName
        )
    }
    
    static func mutationSendPanelCommand(bookId: String, gameId: String)-> GraphQLRequest<String> {
        let operationName = "sendPanelCommand"
        let query =
            """
            mutation sendPanelCommand {
                sendPanelCommand(bookId: "\(bookId)", gameId: "\(gameId)", input: {command: "CLOSE_PANEL", type: "panelCommand"}) {
                    bookId
                    command
                    gameId
                    type
                }
            }
            """
        return GraphQLRequest<String>(
            document: query,
            variables: [:],
            responseType: String.self,
            decodePath: operationName
        )
    }
}
*/
