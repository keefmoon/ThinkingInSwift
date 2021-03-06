//
//  Cuisine.swift
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

enum Cuisine: Int, CaseCountable {
    
    case american
    case bangladeshi
    case breakfast
    case british
    case burgers
    case caribbean
    case chicken
    case chinese
    case curry
    case desserts
    case english
    case european
    case gourmet
    case grill
    case halal
    case indian
    case italian
    case jamaican
    case japanese
    case kebab
    case mexican
    case milkshakes
    case nepalese
    case oriental
    case periPeri
    case pizza
    case polish
    case russian
    case sandwiches
    case spanish
    case sushi
    case thai
    case turkish
    
    init?(string: String) {
        
        for index in 0..<Cuisine.caseCount {
            
            if let cuisine = Cuisine(rawValue: index), cuisine.displayString == string {
                self = cuisine
                return
            }
        }
        return nil
    }
    
    var displayString: String {
        return String(describing: self).capitalized
    }
}
