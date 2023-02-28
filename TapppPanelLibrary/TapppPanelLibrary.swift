import Foundation
import WebKit
//import Amplify
//import AWSPluginsCore
//import AmplifyPlugins
// import Sentry

public protocol alertDelegate: class {
    func myVCDidFinish( text: String)
}
public protocol hidePanelView{
    func hidePanelfromLibrary()
}

enum ValidationState {
    case valid
    case invalid(String)
}

public class WebkitClass: NSObject {
    
    public lazy var webView = WKWebView()
    public var delegate: alertDelegate?
    public var delegateHide: hidePanelView?

    private var sportsbook = ""
    private var subscriberArr = [String]()
    var view = UIView()
    var jsonString = String()
    var objectPanelData = [String: Any]()
    var isPanelAvailable = false

    
    override public init() {}
    
    public func initPanel(panelData: [String: Any], currView: UIView) {
        //        configureAmplify()
                // configureSentry()
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        //webView.contentMode = .scaleToFill
        print(panelData)
        // var internalPaneldata = [String : Any]()
        
        if checkNilInputParam(panelData: panelData, currView: currView) {
            switch checkPanelDataParam(panelData: panelData, currView: currView){
            case .valid:
                print("valid input")
                print("~~~~objectPanelData=", objectPanelData)
                
                print("frame:", currView.frame.width)
                
                let contentController = self.webView.configuration.userContentController
                contentController.add(self, name: "toggleMessageHandler")
                contentController.add(self, name: "showPanelData")
                view = currView
                //proceed further
            case .invalid(let err):
                self.exceptionHandleHTML(errMsg: err)
                
                let error = NSError(domain: "MethodName: init : \(err) \(panelData.description)" , code: 0, userInfo: nil)
                // SentrySDK.capture(error: error)
            }
        } else {
            let error = NSError(domain: "Nil Input parameter in init." , code: 0, userInfo: nil)
            // SentrySDK.capture(error: error)
        }
    }
    
    /*func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
            print("Amplify configured 🥳")
        } catch {
            print("Failed to configure Amplify", error)
        }
    }*/
    // public func configureSentry(){
    //     SentrySDK.start { options in
    //         options.dsn = "https://a638edd3fe44489a86353e40ed587b66@o4504648544026624.ingest.sentry.io/4504653998981120"
    //         options.debug = true // Enabled debug when first installing is always helpful

    //         // Enable all experimental features
    //         options.enablePreWarmedAppStartTracing = true
    //         options.attachScreenshot = true
    //         options.attachViewHierarchy = true
    //         if #available(iOS 15.0, *) {
    //             options.enableMetricKit = true
    //         } else {
    //             // Fallback on earlier versions
    //         }
    //         options.enableAutoBreadcrumbTracking = false
    //         options.enableNetworkTracking = false
    //         options.enableNetworkBreadcrumbs = false
    //     }
    // }
    
    public func checkNilInputParam(panelData: [String: Any]?, currView: UIView?) -> Bool {
        if currView == nil {
            return false
        }
        if panelData == nil {
            return false
        }
        // if panelSetting == nil {
        //     return false
        // }
        return true
    }
    
    func checkPanelDataParam(panelData: [String: Any]?, currView: UIView?)-> ValidationState {
        var internalPaneldata = [String : Any]()
        
        if let pData = panelData?[TapppContext.request.GAME_INFO] as? [String: Any] {
            internalPaneldata = pData
        } else {
            return .invalid(TapppContext.errorMessage.GAMEINFO_OBJECT_NOT_FOUND)
        }
        
        if let gId = internalPaneldata[TapppContext.request.GAME_ID] as? String{
            if gId.count > 0 {
            } else {
                return .invalid(TapppContext.errorMessage.GAMEID_NULL_EMPTY)
            }
        } else {
            return .invalid(TapppContext.errorMessage.GAMEID_NOT_FOUND)
        }
        if let bId = internalPaneldata[TapppContext.request.BOOK_ID] as? String{
            if bId.count > 0 {
            } else {
                self.exceptionHandleHTML(errMsg: TapppContext.errorMessage.BOOKID_NULL_EMPTY)
                internalPaneldata[TapppContext.request.BOOK_ID] = "1000009"
            }
        } else {
            self.exceptionHandleHTML(errMsg: TapppContext.errorMessage.BOOKID_NOT_FOUND)
            internalPaneldata[TapppContext.request.BOOK_ID] = "1000009"
        }
        
        if let widthInfo = internalPaneldata[TapppContext.request.WIDTH] as? [String: Any]{
            if let val = widthInfo[TapppContext.request.VALUE] as? String, val.count > 0 {
                print("From reference app val", val)
            } else {
                var widthInfoUD = [String : Any]()
                widthInfoUD[TapppContext.request.UNIT] = "px"
                widthInfoUD[TapppContext.request.VALUE] = "\(currView?.frame.width ?? 0)"
                internalPaneldata[TapppContext.request.WIDTH] = widthInfoUD
            }
        } else {
            var widthInfoUD = [String : Any]()
            widthInfoUD[TapppContext.request.UNIT] = "px"
            widthInfoUD[TapppContext.request.VALUE] = "\(currView?.frame.width ?? 0)"
            internalPaneldata[TapppContext.request.WIDTH] = widthInfoUD
        }
        
        objectPanelData[TapppContext.request.GAME_INFO] = internalPaneldata
        return .valid
    }
    
    public func exceptionHandleHTML(errMsg: String){
        //FIXME: need to setup for duplicate width key.
    }
    
    public func start(){
        
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        webView.navigationDelegate = self
        
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        
        let customBundle = Bundle(for: WebkitClass.self)
        guard let resourceURL = customBundle.resourceURL?.appendingPathComponent("dist.bundle") else { return }
        guard let resourceBundle = Bundle(url: resourceURL) else { return }
        guard let jsFileURL = resourceBundle.url(forResource: "index", withExtension: "html" ) else { return }
        
        webView.loadFileURL(jsFileURL, allowingReadAccessTo: jsFileURL.deletingLastPathComponent())
        
        // if let url = Bundle(for: WebkitClass.self).url(forResource: "index", withExtension: ".html") {
        //         webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        //     }
        isPanelAvailable = true
        webView.configuration.preferences.javaScriptEnabled = true
    }
    
    public func loadDataJS (objPanelData : [String: Any]){
        // print("...~~~~objectPanelData at loadDataJS=", objPanelData)
        guard let dict = objPanelData[TapppContext.request.GAME_INFO] as? [String:Any] else {
            return
        }
        
        guard let widthDict = dict[TapppContext.request.WIDTH] as? [String:Any] else {
            return
        }
        guard let broadcasterName = dict[TapppContext.request.BROADCASTER_NAME] as? String  else {
            return
        }
        let widthVal = widthDict[TapppContext.request.VALUE] as! String
        let gameId = dict[TapppContext.request.GAME_ID] as! String
        let bookId = dict[TapppContext.request.BOOK_ID] as! String
//        let broadcasterName = dict[Constants.request.BROADCASTER_NAME] as! String
        let userId = dict[TapppContext.request.USER_ID] as! String
        let widthUnit = "px"
        print("...^^^^gameId=", gameId)
        print("...^^^^bookId=", bookId)
        print("...^^^^widthVal=", widthVal)
        print("...^^^^broadcasterName=", broadcasterName)
        
        self.webView.evaluateJavaScript("handleMessage('\(gameId)', '\(bookId)', '\(widthVal)', '\(broadcasterName)', '\(userId)', '\(widthUnit)');", completionHandler: { result, error in
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
        if isPanelAvailable {
            isPanelAvailable = false
            delegateHide?.hidePanelfromLibrary()
        } else {
            let error = NSError(domain: "Error in hide panel. Trying to hide invisible panel." , code: 0, userInfo: nil)
            // SentrySDK.capture(error: error)
        }
    }

    /*public func displayMsg(str : String){
     //        self.loadDataJS(str: str)
     }*/
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
        self.loadDataJS(objPanelData: self.objectPanelData)
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        let error = NSError(domain: "Webview failed loading \(error.localizedDescription)" , code: 0, userInfo: nil)
        // SentrySDK.capture(error: error)
    }
}

/*
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

extension WebkitClass {
    
    public func getGameInfoAPI () {
        do {
            if #available(iOS 13.0, *) {
                Task {
                    let data = try await Amplify.API.query(request: .getGameInfo(bookId: "1000009", broadcastName: "NFL", gameId: "067d2ebf-5dbe-4281-bca7-7a2820784fc9"))
                    print("getGameInfoAPI \(data) .")
                }
            } else {
                // Fallback on earlier versions
            }
        } catch {
            print("Fetching images failed with error \(error)")
        }
    }
    /*
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
    }*/

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
