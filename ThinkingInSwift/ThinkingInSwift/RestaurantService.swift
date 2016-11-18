//
//  RestaurantService.swift
//  ThinkingInSwift
//
//  Created by Keith Moon on 06/11/2016.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import Dispatch

enum RestaurantResult {
    
    case success([Restaurant])
    case failure(Error)
}

enum RestaurantServiceError: Error {
    case noDataReturned
}

class RestaurantService {
    
    var session: URLSession = {
        let protocolClasses: [AnyClass] = [MockProtocol.self]
        let config = URLSessionConfiguration.default
        config.protocolClasses = protocolClasses
        let session = URLSession(configuration: config)
        return session
    }()
    var requestBuilder = RequestBuilder()
    var deserialiser = RestaurantDeserialiser()
    
    func fetchRestaurants(for postcode: String, completeHandler: @escaping (RestaurantResult) -> Void) {
        
        let request = requestBuilder.buildRestaurantsRequest(for: postcode)
        
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            
            guard let `self` = self else { return }
            
            switch (data, response, error) {
                
            case (let data?, _, nil):
                do {
                    let restaurants = try self.deserialiser.deserialiseRestaurants(with: data)
                    
                    DispatchQueue.main.async {
                        completeHandler(.success(restaurants))
                    }
                    
                } catch {
                    
                    DispatchQueue.main.async {
                        completeHandler(.failure(error))
                    }
                }
                
            case (_, _, let error?):
                DispatchQueue.main.async {
                    completeHandler(.failure(error))
                }
                
            case (nil, _, nil):
                DispatchQueue.main.async {
                    completeHandler(.failure(RestaurantServiceError.noDataReturned))
                }
            }
        }
        dataTask.resume()
    }
}
