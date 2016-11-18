//
//  CuisinePickerViewController.swift
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

import UIKit

class CuisinePickerViewController: UITableViewController {
    
    var filter: SearchFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Cell
        
        let cellNib = UINib(nibName: "CuisineCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "CuisineCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let existingCuisine = filter.cuisine {
            
            let selectedIndexPath = IndexPath(row: existingCuisine.rawValue, section: 0)
            tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cuisine.caseCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CuisineCell", for: indexPath) as! CuisineCell
        cell.textLabel?.text = Cuisine(rawValue: indexPath.row)?.displayString
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCuisine = Cuisine(rawValue: indexPath.row)
        
        if let selectedCuisine = selectedCuisine, filter.cuisine == selectedCuisine {
            tableView.deselectRow(at: indexPath, animated: true)
            filter.cuisine = nil
        } else {
            filter.cuisine = selectedCuisine
        }
    }
}
