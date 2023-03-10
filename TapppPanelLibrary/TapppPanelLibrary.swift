import Foundation
import WebKit
//import Sentry

public protocol alertDelegate: class {
    func myVCDidFinish( text: String)
}
public protocol hidePanelView{
    func hidePanelfromLibrary()
}

public enum ValidationState {
    case valid
    case invalid(String)
}

public class WebkitClass: BaseClass {
    
    public lazy var webView = WKWebView()
    public var delegate: alertDelegate?
    public var delegateHide: hidePanelView?

    private var sportsbook = ""
    private var subscriberArr = [String]()
    var view = UIView()
    var jsonString = String()
    var isPanelAvailable = false

    
    override public init() {}
    
    public func initPanel(gameInfo: [String: Any], currView: UIView) {
        
        //configureAmplify()
        //configureSentry()
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        if checkNilInputParam(panelData: gameInfo, currView: currView) {
            switch checkPanelDataParam(panelData: gameInfo, currView: currView){
            case .valid:
                print("valid input")
                print("~~~~objectPanelData=", objectPanelData)
                
                print("frame:", currView.frame.width)
                
                let contentController = self.webView.configuration.userContentController
                contentController.add(self, name: "toggleMessageHandler")
                contentController.add(self, name: "showPanelData")
                view = currView
                //proceed further
                //objectPanelData : API Call
                //TapppContext.Sports.BROADCASTER_NAME
                //TapppContext.Environment.ENVIRONMENT
                let inputURL: String = String(format: "https://dev-betapi.tappp.com/registry-service/registry?broadcasterName=%@&device=web&environment=%@&appVersion=1.1", TapppContext.Sports.BROADCASTER_NAME, TapppContext.Environment.ENVIRONMENT)
                self.geRegistryServiceDetail(inputURL: inputURL) { responseURL in
                    print("responseURL",responseURL!)
                    self.appURL = responseURL!
                }
                /*self.geRegistryServiceDetail(inputURL: "https://dev-betapi.tappp.com/registry-service/registry?broadcasterName=TRN&device=web&environment=dev&appVersion=1.1") { responseURL in
                    print("responseURL",responseURL!)
                    self.appURL = responseURL!
                }*/
            case .invalid(let err):
                self.exceptionHandleHTML(errMsg: err)
                
                let error = NSError(domain: "MethodName: init : \(err) \(gameInfo.description)" , code: 0, userInfo: nil)
                //SentrySDK.capture(error: error)
            }
        } else {
            let error = NSError(domain: "Nil Input parameter in init." , code: 0, userInfo: nil)
            //SentrySDK.capture(error: error)
        }
    }
    
    
    public func startPanel(){
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            print("timer executed...")
            if self.appURL.count > 0 {
                timer.invalidate()
                self.view.addSubview(self.webView)
                NSLayoutConstraint.activate([
                    self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                    self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                    self.webView.topAnchor.constraint(equalTo: self.view.topAnchor)
                ])
                
                self.webView.navigationDelegate = self
                
                self.webView.backgroundColor = UIColor.clear
                self.webView.isOpaque = false
                
                let customBundle = Bundle(for: WebkitClass.self)
                guard let resourceURL = customBundle.resourceURL?.appendingPathComponent("dist.bundle") else { return }
                guard let resourceBundle = Bundle(url: resourceURL) else { return }
                guard let jsFileURL = resourceBundle.url(forResource: "index", withExtension: "html" ) else { return }
                
                self.webView.loadFileURL(jsFileURL, allowingReadAccessTo: jsFileURL.deletingLastPathComponent())

                self.isPanelAvailable = true
                self.webView.configuration.preferences.javaScriptEnabled = true
            }
        }

        
    }
    
    public func loadDataJS (objPanelData : [String: Any]){
        guard let dict = objPanelData[TapppContext.Sports.Context] as? [String:Any] else {
            return
        }
        
        guard let widthDict = dict[TapppContext.Request.WIDTH] as? [String:Any] else {
            return
        }
        guard let broadcasterName = dict[TapppContext.Sports.BROADCASTER_NAME] as? String  else {
            return
        }
        let widthVal = widthDict[TapppContext.Request.VALUE] as! String
        let gameId = dict[TapppContext.Sports.GAME_ID] as! String
        let bookId = dict[TapppContext.Sports.BOOK_ID] as! String
        let userId = dict[TapppContext.User.USER_ID] as! String
        //appURL = "https://sandbox-mlr.tappp.com/mobile/bundle.js"
        //appURL = "https://sandbox-mlr.tappp.com/bundle.js"
        self.webView.evaluateJavaScript("handleMessage('\(gameId)', '\(bookId)', '\(widthVal)', '\(broadcasterName)', '\(userId)', '\(frameUnit)', '\(appURL)');", completionHandler: { result, error in
            if let val = result as? String {
                //                print(val)
            }
            else {
                //                print("result is NIL")
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
    
    
    public func stopPanel(){
        if #available(iOS 14.0, *) {
            webView.configuration.userContentController.removeAllScriptMessageHandlers()
        } else {
            // Fallback on earlier versions
        }
        webView.removeFromSuperview()
    }
    // conditional code based on API.
    public func showPanel(){
        self.startPanel()
    }
    public func hidePanel(){
        if isPanelAvailable {
            isPanelAvailable = false
            delegateHide?.hidePanelfromLibrary()
        } else {
            let error = NSError(domain: "Error in hide panel. Trying to hide invisible panel." , code: 0, userInfo: nil)
            //SentrySDK.capture(error: error)
        }
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
        self.loadDataJS(objPanelData: self.objectPanelData)
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        let error = NSError(domain: "Webview failed loading \(error.localizedDescription)" , code: 0, userInfo: nil)
        //SentrySDK.capture(error: error)
    }
}
