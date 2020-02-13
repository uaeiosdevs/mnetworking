//
//  NetworkApi.swift
//  NetworkLayer
//
//  Created by Mohamed Qasim Mohamed Majeed on 24/11/2019.

import UIKit

class BaseBO: Codable {
    var entityID : Double = 0
    var ID : Int = 0
    var name : String!
    var nameEn : String!
    var nameAr : String!
     var shortName : String!
    var title : String!
    var titleShort : String!
    var isSpecial : Bool = false
    var isGCC : Bool = false
    var image : String!
    var active : Bool = false
    
    
    init() {
        
    }
    
    private enum CodingKeys: String, CodingKey {
         case entityID = "EntityId"
        case ID = "ID"
        case name = "Name"
        case shortName = "ShortName"
        case title = "Title"
        case titleShort = "ShortTitle"
        case isSpecial = "IsSpecial"
        case isGCC = "IsGCC"
        case active = "Active"
        case image = "Image"
        case nameEn = "NameEn"
        case nameAr = "NameAr"
        
        
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(entityID, forKey: .entityID)
        try container.encode(name, forKey: .name)
        try container.encode(shortName, forKey: .shortName)
        try container.encode(ID, forKey: .ID)
        try container.encode(title, forKey: .title)
        try container.encode(titleShort, forKey: .titleShort)
        try container.encode(isSpecial, forKey: .isSpecial)
        try container.encode(isGCC, forKey: .isGCC)
        try container.encode(image, forKey: .image)
        try container.encode(active, forKey: .active)
        try container.encode(nameAr, forKey: .nameAr)
        try container.encode(nameEn, forKey: .nameEn)
       
        
        
        
    }
    
    required public init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let elementValue = try? values.decode(Double.self, forKey: .entityID) {
            entityID = elementValue
        }
        if let elementValue = try? values.decode(String.self, forKey: .name) {
            name = elementValue
        }
        if let elementValue = try? values.decode(String.self, forKey: .shortName) {
            shortName = elementValue
        }
        if let elementValue = try? values.decode(Int.self, forKey: .ID) {
            ID = elementValue
        }
        if let elementValue = try? values.decode(String.self, forKey: .title) {
            title = elementValue
        }
        if let elementValue = try? values.decode(String.self, forKey: .titleShort) {
            titleShort = elementValue
        }
        if let elementValue = try? values.decode(Bool.self, forKey: .isSpecial) {
            isSpecial = elementValue
        }
        if let elementValue = try? values.decode(Bool.self, forKey: .isGCC) {
            isGCC = elementValue
        }
        if let elementValue = try? values.decode(String.self, forKey: .image) {
            image = elementValue
        }
        if let elementValue = try? values.decode(Bool.self, forKey: .active) {
            active = elementValue
        }
        if let elementValue = try? values.decode(String.self, forKey: .nameEn) {
            nameEn = elementValue
        }
        if let elementValue = try? values.decode(String.self, forKey: .nameAr) {
            nameAr = elementValue
        }
        
        
    }
    
}

class ErrorMessage: BaseBO {
    var error : String!
    var errorDescription: String!
    var error_description : LoginErrorEnum = .NONE
    
   private enum CodingKeys: String, CodingKey {
        case error = "error"
        case errorDescription = "Message"
     case error_description = "error_description"
    }
    
    required init(from decoder: Decoder) throws{
        try super.init(from: decoder)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let elementValue = try? values.decode(String.self, forKey: .error) {
            error = elementValue
        }
        if let elementValue = try? values.decode(String.self, forKey: .errorDescription) {
            errorDescription = elementValue
        }
        if let elementValue = try? values.decode(LoginErrorEnum.self, forKey: .error_description) {
            error_description = elementValue
        }
        
    }
    
}

class NetworkApi: NetworkRequest {
    
    var session : URLSession = URLSession.shared
    var currentTask : URLSessionTask!
    var url : URL! //Holds the current request url
    
    init() {
    }
    
    func request<T: Decodable>(_ request : URLRequest, success : @escaping ResultSuccess<T>,failure : @escaping ResultFailure){
        //In order to check the Current request is in work or used...
        print("URL --> \(String(describing: request.url?.absoluteURL))")
        self.cancelTask()
        var networkError : NetworkError = NetworkError()
        self.currentTask = self.session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let _ = error {//Check the client side error
                 networkError.statusCode = Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue)
                if let err =  error as NSError? {
                    networkError.statusCode = err.code
                }
               
                failure(networkError)
            }else{
                guard let httpRespone = response as? HTTPURLResponse, (200...299).contains(httpRespone.statusCode) else {
                    networkError.statusCode = (response as? HTTPURLResponse)?.statusCode
                    if let data = data {
                        //Hanlde data
                       // print(String(decoding: data, as: UTF8.self))
                        if let responseObject = try? JSONDecoder().decode(ErrorMessage.self, from:data) {
                            networkError.errorMessage = responseObject.errorDescription
                            networkError.error_description = responseObject.error_description
                        
                        }
                    }
                    failure(networkError)
                    return
                    
                }
                if let data = data {
                    //Hanlde data
                    print(String(decoding: data, as: UTF8.self))
                    if let responseObject = try? JSONDecoder().decode(T.self, from:data) {
                        success(responseObject)
                    }
                }
                
            }
        })
        self.currentTask.resume()
    }
    
    func cancelTask(){
        if self.currentTask != nil {
            self.currentTask.cancel()
        }
    }
    
    
    
}
