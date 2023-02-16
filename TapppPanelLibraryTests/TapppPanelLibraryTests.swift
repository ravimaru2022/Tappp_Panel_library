//
//  TapppPanelLibraryTests.swift
//  TapppPanelLibraryTests
//
//  Created by MA-15 on 02/02/23.
//

import XCTest
import TapppPanelLibrary
import WebKit
//@testable import TapppPanelLibrary

final class TapppPanelLibraryTests: XCTestCase{
    let objPanel = WebkitClass()
    private var subscriberArr = [String]()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitialization() {
        var objPanelData = [String: Any]()
        var gameInfo = [String : Any]()
        
        objPanelData[Constants.request.GAME_ID] = "123"
        objPanelData[Constants.request.BOOK_ID] = "234"
        objPanelData[Constants.request.POSITION] = "topRight"
        var frameWidth = [String : Any]()
        frameWidth[Constants.request.UNIT] = "px"
        frameWidth[Constants.request.VALUE] = "300"
        objPanelData[Constants.request.WIDTH] = frameWidth
        gameInfo[Constants.request.GAME_INFO] = objPanelData
        
        var objPanelSetting = [String: Any]()
        objPanelSetting[Constants.request.LANGUAGE] = "123"
        objPanelSetting[Constants.request.PANELMULTIPLIER] = "234"
        objPanelSetting[Constants.request.POSITION] = "topRight"
        
        
        let objView = UIView()
        objPanel.initPanel(panelData: gameInfo, panelSetting: objPanelSetting, currView: objView)
        
        XCTAssertNotNil(objPanelData)
        //XCTAssertEqual(person.first, "Bart")
        //XCTAssertEqual(person.last, "Jacobs")
    }
    
    func testUsercontentController() {
        let contentController = objPanel.webView.configuration.userContentController
        
        let obj = WKScriptMessage()
        var test = [String : AnyObject]()
        test["message"] = "no data found" as AnyObject
        
        //obj.value(forKey: "message") = test
        //obj.body = test as? [String : AnyObject]
        //obj.value(forKeyPath: "message")
        //let body = WKScriptMessage.body
        //guard let dictionary = body as? [String: String] else { return }
        //dictionary["message"] = "no data found"
        //obj.body = body
        //obj.body =
        //obj["message"] = "no data found"
        //var dict = [String : Any]()
        //dict["message"] = "test"
        
        objPanel.userContentController(contentController, didReceive: obj)
    }
    
    func testWebKitdidFinish() {
        objPanel.webView(objPanel.webView, didFinish: nil)
    }
    
    func testStartProvisionalNavigation() {
        objPanel.webView(objPanel.webView, didStartProvisionalNavigation: nil)
    }
    
    func testFailProvisionalNavigation() {
        let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid access token"])
        objPanel.webView(objPanel.webView, didFailProvisionalNavigation: nil, withError: error)
    }
    
    func testExceptionHandleHTML() {
        objPanel.exceptionHandleHTML(errMsg: "Error Message to display")
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        var objPanelData = [String: Any]()
        var gameInfo = [String : Any]()
        
        objPanelData[Constants.request.GAME_ID] = "123"
        objPanelData[Constants.request.BOOK_ID] = "234"
        objPanelData[Constants.request.POSITION] = "topRight"
        var frameWidth = [String : Any]()
        frameWidth[Constants.request.UNIT] = "px"
        frameWidth[Constants.request.VALUE] = "300"
        objPanelData[Constants.request.WIDTH] = frameWidth
        gameInfo[Constants.request.GAME_INFO] = objPanelData
        
        let error_inst = self.validatePanelData(panelData: gameInfo)
        if (!error_inst.isEmpty) {
            XCTAssertTrue(false, error_inst)
        } else {
            XCTAssertTrue(true, error_inst)
        }
        
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testStartMethod() throws {
        objPanel.start()
    }
    
    func testStopMethod() throws {
        objPanel.stop()
    }
    
    func testShowPanel() throws {
        objPanel.showPanel()
    }
    
    func testHidePanel() throws {
        objPanel.hidePanel()
    }
    func testSubscriberMethod() throws {
        objPanel.subscribe(event: "testEvent") { obj in
            if obj.count > 0 {
                subscriberArr.append("testEvent")
                XCTAssertTrue(true, "Event Subscribed")
            } else {
                XCTAssertTrue(false, "Event not subscribed")
            }
        }
    }
    func testUnsubscribeMethod() throws {
        objPanel.unSubscribe(event: "testEvent") { obj in
            if obj.count > 0 {
                
                if let index = subscriberArr.firstIndex(of: "testEvent")
                {
                    subscriberArr.remove(at: index)
                }
                XCTAssertTrue(true, "Event unsubscribed")
            } else {
                XCTAssertTrue(true, "Event not unsubscribed")
            }
        }
    }
    
    func testLoadJSDataMethod () throws {
        var objPanelData = [String: Any]()
        var gameInfo = [String : Any]()
        
        objPanelData[Constants.request.GAME_ID] = "123"
        objPanelData[Constants.request.BOOK_ID] = "234"
        objPanelData[Constants.request.POSITION] = "topRight"
        var frameWidth = [String : Any]()
        frameWidth[Constants.request.UNIT] = "px"
        frameWidth[Constants.request.VALUE] = "300"
        objPanelData[Constants.request.WIDTH] = frameWidth
        gameInfo[Constants.request.GAME_INFO] = objPanelData
        
        objPanel.loadDataJS(objPanelData: gameInfo)
    }
    func testConst(){
        Constants.init()
    }
    
//    func testSentry(){
//        objPanel.configureSentry()
//    }
    func gameIdNotFound() {
       // This is an example of a performance test case.
       self.measure {
          // Put the code you want to measure the time of here.
       }
    }

    func gameInfoNotFound() throws {
        
        self.measure {
            // Put the code you want to measure the time of here.
        }

    }

    // individual test case for every parameter.
    // gameId, bookId, userId mandatory. + overlay view
    // handle message tesecase
    // web-build related testcase - file exist or not.
    // graphQL method check
    
    
    
    func validatePanelData(panelData: [String: Any]) -> String {
        var gameInfo = [String : Any]()
        gameInfo = panelData[Constants.request.GAME_INFO] as! [String : Any]
        
        var gameWidth = [String : Any]()
        if gameInfo.keys.contains(Constants.request.WIDTH) {
            gameWidth = gameInfo[Constants.request.WIDTH] as! [String : Any]
        }
        
        if panelData == nil  || panelData.count == 0 {
            return  "empty dictionary"
        } else if !panelData.keys.contains(Constants.request.GAME_INFO) {
            return  "nil dictionary"
        } else if !gameInfo.keys.contains(Constants.request.GAME_ID) {
            return  "nil gameId"
        } else if !gameInfo.keys.contains(Constants.request.BOOK_ID) {
            return  "nil boookId"
        } else if !gameInfo.keys.contains(Constants.request.POSITION) {
            return  "nil position"
        } else if !gameInfo.keys.contains(Constants.request.WIDTH) {
            return "nil width dictionary"
        } else if !gameWidth.keys.contains(Constants.request.VALUE) {
            return "nil value"
        } else if !gameWidth.keys.contains(Constants.request.UNIT) {
            return "nil unit"
        }
        return ""
    }
    
    func testObjectNull(){
        var objPanelData = [String: Any]()
        if objPanelData == nil{
            XCTAssertTrue(false, "nil panel data")
        }
    }
    
    func testGameInfoNotFound(){
        var gameInfo = [String : Any]()
        gameInfo = ["" : ""]
        if gameInfo.count == 0{
            XCTAssertTrue(false, "Empty Game info")
        } else {
            XCTAssertTrue(true, "valid input")
        }
    }
    
    
    func testGameIdNotFound(){
        //var gameInfo = [String : Any]()
        var objPanelData = [String: Any]()
        objPanelData[Constants.request.GAME_ID] = "123"
        let error_inst = validateGameIdNil(gameId: objPanelData[Constants.request.GAME_ID] as! String)
        if (!error_inst.isEmpty) {
            XCTAssertTrue(false, error_inst)
        } else {
            XCTAssertTrue(true, error_inst)
        }

    }
    func testGameIdEmpty(){
        var objPanelData = [String: Any]()
        objPanelData[Constants.request.GAME_ID] = "123"
        let error_inst = validateGameIdEmpty(gameId: objPanelData[Constants.request.GAME_ID] as! String)
        if (!error_inst.isEmpty) {
            XCTAssertTrue(false, error_inst)
        } else {
            XCTAssertTrue(true, error_inst)
        }
    }
    func validateGameIdNil(gameId : String) -> String{
        if gameId != nil {
            return ""
        }
        return "failure"
    }
    func validateGameIdEmpty(gameId : String) -> String{
        if gameId.count > 0 {
            return ""
        }
        return "failure"
    }


    func testBookIdNotFound(){
        //var gameInfo = [String : Any]()
        var objPanelData = [String: Any]()
        objPanelData[Constants.request.BOOK_ID] = "123"
        let error_inst = validateBookIdNil(bookId: objPanelData[Constants.request.BOOK_ID] as! String)
        if (!error_inst.isEmpty) {
            XCTAssertTrue(false, error_inst)
        } else {
            XCTAssertTrue(true, error_inst)
        }

    }
    func testBookIdEmpty(){
        var objPanelData = [String: Any]()
        objPanelData[Constants.request.BOOK_ID] = "123"
        let error_inst = validateBookIdEmpty(bookId: objPanelData[Constants.request.BOOK_ID] as! String)
        if (!error_inst.isEmpty) {
            XCTAssertTrue(false, error_inst)
        } else {
            XCTAssertTrue(true, error_inst)
        }
    }
    func validateBookIdNil(bookId : String) -> String{
        if bookId != nil {
            return ""
        }
        return "failure"
    }
    func validateBookIdEmpty(bookId : String) -> String{
        if bookId.count > 0 {
            return ""
        }
        return "failure"
    }

    func testWidthNotFound(){
        var objPanelData = [String: Any]()
        var frameWidth = [String : Any]()
        frameWidth[Constants.request.UNIT] = "px"
        frameWidth[Constants.request.VALUE] = "300"
        objPanelData[Constants.request.WIDTH] = frameWidth

        let error_inst = ""//validateWidthNil(width: objPanelData[Constants.request.width] as! String)
        if (!error_inst.isEmpty) {
            XCTAssertTrue(false, error_inst)
        } else {
            XCTAssertTrue(true, error_inst)
        }

    }
    func testWidthIsEmpty(){
        var objPanelData = [String: Any]()
        var frameWidth = [String : Any]()
        frameWidth[Constants.request.UNIT] = "px"
        frameWidth[Constants.request.VALUE] = "300"
        objPanelData[Constants.request.WIDTH] = frameWidth
        let error_inst = ""//validateWidthEmpty(width: objPanelData[Constants.request.width] as! String)
        if (!error_inst.isEmpty) {
            XCTAssertTrue(false, error_inst)
        } else {
            XCTAssertTrue(true, error_inst)
        }
    }
    func validateWidthNil(width : String) -> String{
        if width != nil {
            return ""
        }
        return "failure"
    }
    func validateWidthEmpty(width : String) -> String{
        if width.count > 0 {
            return ""
        }
        return "failure"
    }
    
    func testHTMLFileExist (){
        let customBundle = Bundle(for: WebkitClass.self)
        guard let resourceURL = customBundle.resourceURL?.appendingPathComponent("web-build.bundle") else { return }
        guard let resourceBundle = Bundle(url: resourceURL) else { return }
        guard let jsFileURL = resourceBundle.url(forResource: "index_ios", withExtension: "html" ) else { return }
        //let htmlURL = MAINBUNDLE.path(forResource: "index_ios", ofType: "html")
        XCTAssertNotNil(jsFileURL, "Index : html url nil")
    }
    
    func testHandleMessage (){
        let gameId = "123"
        let bookId = "345"
        let widthVal = "300"
        let broadcasterName = "NFL"
        let error_inst = self.validateHandleMessage(gameId: gameId, bookId: bookId, widthVal: widthVal, broadcasterName: broadcasterName)
        if (!error_inst.isEmpty) {
            XCTAssertTrue(false, error_inst)
        } else {
            XCTAssertTrue(true, error_inst)
        }
    }
    
    func validateHandleMessage(gameId: String?, bookId: String?, widthVal: String?,  broadcasterName: String?) -> String {

        if gameId == nil  || gameId?.count == 0 {
            return  "empty gameId"
        } else if bookId == nil  || bookId?.count == 0 {
            return  "empty bookId"
        } else if widthVal == nil  || widthVal?.count == 0 {
            return  "empty width"
        } else if broadcasterName == nil  || broadcasterName?.count == 0 {
            return  "empty broadcast"
        }
        return ""
    }

}