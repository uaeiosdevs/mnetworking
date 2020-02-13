//
//  NetworkConfig.swift
//  NetworkLayer
//
//  Created by Mohamed Qasim Mohamed Majeed on 24/11/2019.


import UIKit


let kCharsetUTF8Value = "application/x-www-form-urlencoded"
let kJSONValue = "application/json"
let kMultiPartValue = "multipart/form-data"
let kContentTypeHeader  = "Content-Type"
let kContentLengthHeader = "Content-Length"
let kRequestParamInfo = "X-RequestParamInfo"
let kAcceptLanguage = "Accept-Language"
let kRequestTimeOut = "30"
let kAuthorizationKey = "Authorization"
let kRequestParam = "param"

protocol EndPointType {
    var baseUrl : String! {get}
    var path : String! {get}
    var httpMethod : HttpMethod! {get}
    var httpRequest : URLRequest! {get}
    var paramters : [String : Any]! {get}
}

enum Enviroment : String {
    case Testing
    case Stagging
    case Live
}


final class NetworkConfiguration {
    static func enviroment () -> Enviroment { return .Stagging }
}
