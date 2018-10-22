//
//  Networking.swift
//  REDacted
//
//  Created by Greazy on 7/28/18.
//  Copyright © 2018 Red. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    enum NetworkManagerErrors {
        case decodeError(with: DecodingError)
        case error
    }
    
    enum Result<T: Codable> {
        case success(T)
        case failure(NetworkManagerErrors)
    }
    
    static func get<T>(_ url: String, paramters: Parameters? = nil, headers: HTTPHeaders?, completionHandler: @escaping (Result<T>) -> ()) {
        Alamofire.request(url, method: .get, parameters: paramters, headers: headers).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                //guard let data = value as? Data else {
                    //completionHandler(.failure(.error))
                    //return
                //}
                print(value)
                do {
                    let decoder = JSONDecoder()
                    print(T.self)
                    completionHandler(.success( try decoder.decode(T.self, from: response.data!)))
                } catch let error as DecodingError {
                    print(error)
                    completionHandler(.failure(.decodeError(with: error)))
                } catch let error as NSError {
                    print(error)
                    completionHandler(.failure(.error))
                }
            case .failure(let error as AFError):
                print(error)
                completionHandler(.failure(.error))
            case .failure(let error as NSError):
                print(error)
                completionHandler(.failure(.error))
                return
            }
            
        }
    }
    
    static func post<T>(_ url: String, parameters: Parameters? = nil, headers: HTTPHeaders?, completionHandler: @escaping (Result<T>) -> ()) {
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    completionHandler(.success( try decoder.decode(T.self, from: response.data!)))
                } catch let error as DecodingError {
                    print(error)
                    completionHandler(.failure(.decodeError(with: error)))
                } catch let error as NSError {
                    print(error)
                    completionHandler(.failure(.error))
                }
            case .failure(let error as AFError):
                print(error)
                completionHandler(.failure(.error))
            case .failure(let error as NSError):
                print(error)
                completionHandler(.failure(.error))
                return
            }
        }
    }
}
