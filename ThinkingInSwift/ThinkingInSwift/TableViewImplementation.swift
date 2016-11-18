//
//  TableViewImplementation.swift
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

import UIKit

extension UITableView {
    
    func dequeue<T: UITableViewCell> (forIndexPath indexPath: IndexPath) -> T where T: TableViewDequeuable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier \(T.reuseIdentifier)")
        }
        return cell
    }
    
    func dequeue<T: UITableViewHeaderFooterView> () -> T? where T: TableViewDequeuable {
        return dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T
    }
    
    func register<T: UITableViewCell>(_ cellType: T.Type) where T: TableViewRegisterable {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UITableViewCell>(_ cellType: T.Type) where T: TableViewRegisterable, T: NibLoadable {
        register(T.nib(), forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(_ headerFooterType: T.Type) where T: TableViewRegisterable {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(_ headerFooterType: T.Type) where T: TableViewRegisterable, T: NibLoadable {
        register(T.nib(), forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
}

extension TableViewRegisterable where Self: UITableViewHeaderFooterView {
    
    var reuseIdentifier: String? {
        return Self.reuseIdentifier
    }
}
