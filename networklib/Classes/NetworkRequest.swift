//
//  NetworkRequest.swift
//  NetworkLayer
//
//  Created by Mohamed Qasim Mohamed Majeed on 24/11/2019.


import UIKit

typealias ResultSuccess<T> = (T) -> Void
typealias ResultFailure = (NetworkError)  -> Void

protocol NetworkRequest {
    
    func request<T: Decodable>(_ request : URLRequest, success : @escaping ResultSuccess<T>,failure : @escaping ResultFailure)
    
}
