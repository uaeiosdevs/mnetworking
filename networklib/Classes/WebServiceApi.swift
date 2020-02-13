//
//  WebServiceApi.swift
//  NetworkLayer
//
//  Created by Mohamed Qasim Mohamed Majeed on 24/11/2019.



import UIKit

extension String {
    static func isStringValid(_ string: String?) -> Bool {
        if  string == nil{
            return false
        }
        
        var flage:Bool = false
        if !(string ?? "").isEmpty {
            flage = true
        }
        
        return flage
    }
}

extension Dictionary {
    
    var jsonString:String {
        var jsonString : String = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            jsonString = String(data: jsonData, encoding: String.Encoding.utf8)! as String
        } catch {
            print(error.localizedDescription)
        }
        return jsonString
    }
    
    
    var queryString: String {
        var finalString: String = ""
        for (key,value) in self {
            finalString +=  "\(key)=\(value)&"
        }
        finalString = String(finalString.dropLast())
        if finalString == "=" {
            finalString = ""
        }
        return finalString
    }
}

typealias onFailure = (NetworkError?) -> Void

class WebServiceApi:  EndPointType {
    var network : NetworkApi!
    
    init(network : NetworkApi = NetworkApi()) {
        self.network = network
    }
    
    var baseUrl: String! { return nil }
    
    var path: String!{ return "" }
    var httpMethod: HttpMethod!{ .get }
    
    private var httpBody:Data? {
        if (self.paramters[kRequestParam] is [String : String]) {
            let parm =  self.paramters[kRequestParam] as! [String : String]
            return parm.queryString.data(using: .utf8)
            
        }else{
            return ((self.paramters[kRequestParam])! as! String).data(using: .utf8)
        }
        
    }
    
    var httpRequest: URLRequest! {
        var request : URLRequest = URLRequest.init(url: URL.init(string: self.url)!)
        
        if self.httpMethod == .post {
            if let body = httpBody {
                request.httpBody = body
            }
            request.setValue(kJSONValue, forHTTPHeaderField: kContentTypeHeader)
            
        } else if self.httpMethod == .delete {
            
        } else {
            request.setValue(kCharsetUTF8Value, forHTTPHeaderField: kContentTypeHeader)
        }
        
        request.httpMethod = self.httpMethod.rawValue
        request.cachePolicy = .reloadIgnoringCacheData
        request.timeoutInterval = 30
        return request
    }
    
    var url:String {
        var urlString  = self.baseUrl + self.path
        if self.httpMethod == .get {
            if String.isStringValid( self.paramters.queryString){
                urlString += "?" + self.paramters.queryString
            }
            
        }
        return urlString
    }
    
    var paramters: [String : Any]! { ["":""] }
    
    func cancelService(){
        if self.network != nil {
            self.network.cancelTask()
        }
    }
    
    deinit {
        print("deinit network")
    }
}

