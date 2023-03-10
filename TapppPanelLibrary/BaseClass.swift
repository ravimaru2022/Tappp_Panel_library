//
//  BaseClass.swift
//  TapppPanelLibrary
//
//  Created by MA-15 on 01/03/23.
//
import Foundation
import UIKit

public class BaseClass: NSObject {
    var frameUnit = ""
    var objectPanelData = [String: Any]()
    var appURL = ""
}

// MARK - Data Validations
extension BaseClass {
    public func checkNilInputParam(panelData: [String: Any]?, currView: UIView?) -> Bool {
        if currView == nil {
            return false
        }
        if panelData == nil {
            return false
        }
        return true
    }
    
    public func checkPanelDataParam(panelData: [String: Any]?, currView: UIView?)-> ValidationState {
        var internalPaneldata = [String : Any]()
        
        if let pData = panelData?[TapppContext.Sports.Context] as? [String: Any] {
            internalPaneldata = pData
        } else {
            return .invalid(TapppContext.errorMessage.GAMEINFO_OBJECT_NOT_FOUND)
        }
        
        if let gId = internalPaneldata[TapppContext.Sports.GAME_ID] as? String{
            if gId.count > 0 {
            } else {
                return .invalid(TapppContext.errorMessage.GAMEID_NULL_EMPTY)
            }
        } else {
            return .invalid(TapppContext.errorMessage.GAMEID_NOT_FOUND)
        }
        if let bId = internalPaneldata[TapppContext.Sports.BOOK_ID] as? String{
            if bId.count > 0 {
            } else {
                self.exceptionHandleHTML(errMsg: TapppContext.errorMessage.BOOKID_NULL_EMPTY)
                internalPaneldata[TapppContext.Sports.BOOK_ID] = "1000009"
            }
        } else {
            self.exceptionHandleHTML(errMsg: TapppContext.errorMessage.BOOKID_NOT_FOUND)
            internalPaneldata[TapppContext.Sports.BOOK_ID] = "1000009"
        }
        if let env = internalPaneldata[TapppContext.Environment.ENVIRONMENT] as? String{
            if env.count == 0 {
                internalPaneldata[TapppContext.Environment.ENVIRONMENT] = TapppContext.Environment.DEV
            }
        } else {
            internalPaneldata[TapppContext.Environment.ENVIRONMENT] = TapppContext.Environment.DEV
        }
        //objPanelData[TapppContext.Environment.ENVIRONMENT] = TapppContext.Environment.DEV
        if let widthInfo = internalPaneldata[TapppContext.Request.WIDTH] as? [String: Any]{
            if let unit = widthInfo[TapppContext.Request.UNIT] as? String, unit.count > 0{
                frameUnit = unit
            } else {
                frameUnit = TapppContext.Request.UNIT_VAL
            }
            if let val = widthInfo[TapppContext.Request.VALUE] as? String, val.count > 0 {
                print("From reference app val", val)
            } else {
                var widthInfoUD = [String : Any]()
                widthInfoUD[TapppContext.Request.UNIT] = "px"
                widthInfoUD[TapppContext.Request.VALUE] = "\(currView?.frame.width ?? 0)"
                internalPaneldata[TapppContext.Request.WIDTH] = widthInfoUD
            }
        } else {
            var widthInfoUD = [String : Any]()
            widthInfoUD[TapppContext.Request.UNIT] = "px"
            widthInfoUD[TapppContext.Request.VALUE] = "\(currView?.frame.width ?? 0)"
            internalPaneldata[TapppContext.Request.WIDTH] = widthInfoUD
        }
        
        objectPanelData[TapppContext.Sports.Context] = internalPaneldata
        return .valid
    }
    
    public func exceptionHandleHTML(errMsg: String){
        //FIXME: need to setup for duplicate width key.
    }
}


// MARK - GraphQL APIs.
extension BaseClass {
    public func getGameAwards(inputURL: String){
        let url = URL(string:inputURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let status = json?["code"] as? Int, status == 200 {
                        if let urlDict = json?["data"] as? [[String: Any]], let urlAddr = urlDict.first{
                            print(urlAddr)
                            //self.playVideo()
                        }
                    }
                } catch {
                    print(error)
                }
                //let image = UIImage(data: data)
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
    
    public func geRegistryServiceDetail(inputURL: String, completion: @escaping (String?)->Void) {
        let url = URL(string:inputURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let status = json?["code"] as? Int, status == 200 {
                        if let urlDict = json?["data"] as? [[String: Any]], let urlAddr = urlDict.first{
                            let appDict = urlAddr["appInfo"] as? [String: Any]
                            let microAppList = appDict?["microAppList"]as? [[String:Any]]

                            print(microAppList?.first?["chanelList"])
                            
                            if let chanelList = microAppList?.first?["chanelList"] as? [[String:Any]]
                            {
                                print(chanelList)
                                for obj in chanelList{
                                    if obj["chanelName"] as! String == "smartApp"{ // webApp , smartApp
                                        print(obj["appURL"])
                                        completion(obj["appURL"] as! String)
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print(error)
                }
                //let image = UIImage(data: data)
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()

    }
    
    /*public func getAppInfoAPI (bName: String){
        do {
            if #available(iOS 13.0, *) {
                Task {
                    let data = try await Amplify.API.query(request:.getAppInfo(broadcastName: bName, deviceType: "web"))
                    print("getAppInfo \(data) .")
                }
            } else {
                // Fallback on earlier versions
            }
        } catch {
            print("Fetching images failed with error \(error)")
        }
    }*/

   /* public func getGameInfoAPI () {
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
    }*/
}
/*extension GraphQLRequest {
    
    static func getAppInfo(broadcastName: String, deviceType: String) -> GraphQLRequest<String> {
        
        let operationName = "getAppInfo"
        let query =
            """
            {
              getAppInfo(broadcasterName: "\(broadcastName)", deviceType: "\(deviceType)", lang: "en") {
                status
                code
                message
                requestURI
                data
              }
            }
            """
        return GraphQLRequest<String>(
            document: query,
            variables: ["": ""],
            responseType: String.self,
            decodePath: operationName
        )
    }
}*/
    /*
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

}*/
/*extension GraphQLRequest {
    
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
}*/
    /*
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
    }*/
//}


