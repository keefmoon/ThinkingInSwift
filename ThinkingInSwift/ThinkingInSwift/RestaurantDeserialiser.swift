//
//  RestaurantDeserialiser.swift
//  ThinkingInSwift
//
//  Created by Keith Moon on 07/11/2016.
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

class RestaurantDeserialiser {
    
    enum DeserialiseError: Error {
        case unexpectedJSON
    }
    
    func deserialiseRestaurants(with data: Data) throws -> [Restaurant] {
        
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let jsonDictionary = json as? [String: Any],
            let openRestaurants = jsonDictionary["OpenRestaurants"] as? [[String: Any]],
            let closedRestaurants = jsonDictionary["ClosedRestaurants"] as? [[String: Any]] else {
            throw DeserialiseError.unexpectedJSON
        }
        let restaurantsArray = openRestaurants + closedRestaurants
        
        return restaurantsArray.flatMap { deserialiseRestaurant(with: $0) }
    }
    
    private func deserialiseRestaurant(with dictionary: [String: Any]) -> Restaurant? {
        
        guard let name = dictionary["Name"] as? String, let cuisines = dictionary["Cuisines"] as? [[String: String]] else {
            return nil
        }
        
        let cuisineArray: [Cuisine] = cuisines.flatMap {
            
            if let cuisineName = $0["Name"] {
                return Cuisine(string: cuisineName)
            } else {
                return nil
            }
        }
        return Restaurant(name: name, cuisines: cuisineArray)
    }
    
}
