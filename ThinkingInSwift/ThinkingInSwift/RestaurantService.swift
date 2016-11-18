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
    
    func fetchRestaurants(for postcode: String, completeHandler: @escaping ([Restaurant]?, Error?) -> Void) {
        
        let request = requestBuilder.buildRestaurantsRequest(for: postcode)
        
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            
            guard let `self` = self else { return }
            
            if let error = error {
                
                DispatchQueue.main.async {
                    completeHandler(nil, error)
                }
                
            } else if let data = data {
                
                do {
                    let restaurants = try self.deserialiser.deserialiseRestaurants(with: data)
                    
                    DispatchQueue.main.async {
                        completeHandler(restaurants, nil)
                    }
                    
                } catch {
                    
                    DispatchQueue.main.async {
                        completeHandler(nil, error)
                    }
                }
            }
            
        }
        dataTask.resume()
    }
    
}
