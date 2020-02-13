//
//  NetworkError.swift
//  NetworkLayer
//
//  Created by Mohamed Qasim Mohamed Majeed on 24/11/2019.

import UIKit

enum LoginErrorEnum: String,Codable {
    case NONE = "-1"
    case MISSING_USER_NAME_OR_PASSWORD = "1"
    case INVALID_USER_NAME_OR_PASSWORD = "2"
    case INVALID_ANSWER = "3"
    case USER_IS_LOCKED = "4"
    case INVALID_GRANT = "5"
    case MISSING_QUESTION = "6"
    case MUST_RESET_PASSWORD = "7"
    case UNAUTHORIZED = "8"
    case SMARTPASS_INVALID_ID_TOKEN = "9"
    case SMARTPASS_INVALID_ACCESS_TOKEN = "10"
    case SMARTPASS_USER_NOT_FOUND = "11"
    case SMARTPASS_NOT_VERIFIED = "12"
    case SMARTPASS_USER_PERSON_INVALID_PERSON_CODE_OR_PASSPORT = "13"
    case SMARTPASS_USER_INVALID_USER_NAME_OR_PASSWORD = "14"
    case SMARTPASS_USER_ONLY_EMPLOYER_ALLOWED = "15"
    
}
//SessionTimeout
struct NetworkError {
    var statusCode : Int! {
        didSet{

            
        }
    }
    var errorMessage : String!
    var title : String!
    var error_description : LoginErrorEnum = .NONE
    
    
}
