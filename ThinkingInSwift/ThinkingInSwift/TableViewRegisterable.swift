//
//  CellImplementation.swift
//  ThinkingInSwift
//
//  Created by Francisco Ruano on 20/07/2016.
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

/// Defines something that can be dequeued from a table view using a reuseIdentifier
/// A cell that is defined in a storyboard should implement this.
protocol TableViewDequeuable: class {
    
    static var reuseIdentifier: String { get }
}

extension TableViewDequeuable {

    /// Default implementation of reuseIndentifier is to use the class name, 
    /// this can be specifically implemented for difference behaviour
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

/// Defines something that can be registered with a table view, using the reuseIdentifer
/// A cell that is laid out programmically or in a nib (that also implements NibLoadable) should implement this
protocol TableViewRegisterable: TableViewDequeuable {
    
}
