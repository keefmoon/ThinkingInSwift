//
//  RestaurantsViewController.swift
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

import UIKit

class RestaurantsViewController: UIViewController {
    
    enum SegueType: String {
        case showCuisinePicker
        case showBasket
    }
    
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var postcodeField: UITextField!
    @IBOutlet fileprivate var cuisineBarButtonItem: UIBarButtonItem!
    
    var restaurantService = RestaurantService()
    
    var allRestaurants: [Restaurant] = []
    var visibleRestaurants: [Restaurant] = []
    var currentFilter = SearchFilter()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier, let segueType = SegueType(rawValue: identifier) else { return }
        
        let relevantVC = segue.destination.relevant
        
        switch (segueType, relevantVC, sender) {
            
        case (.showCuisinePicker, let cuisinePickerVC as CuisinePickerViewController, _):
            cuisinePickerVC.filter = currentFilter
            
        case (.showBasket, let basketVC as BasketViewController, let cell as RestaurantCell):
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            basketVC.restaurant = visibleRestaurants[indexPath.row]
            
        default:
            break
            
        }
    }
    
    @IBAction func unwindToRestaurants(sender: UIStoryboardSegue) {
        filterRestaurants()
        tableView.reloadData()
    }
    
    private func filterRestaurants() {
        
        visibleRestaurants = allRestaurants.filter { restaurant -> Bool in
            
            if let selectedCuisine = currentFilter.cuisine {
                return restaurant.cuisines.contains(selectedCuisine)
            } else {
                return true
            }
        }
        
        tableView.reloadData()
    }
}

extension RestaurantsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let restaurant = visibleRestaurants[indexPath.row]
        let cell: RestaurantCell = tableView.dequeue(forIndexPath: indexPath)
        cell.textLabel?.text = restaurant.name
        cell.detailTextLabel?.text = restaurant.cuisineDisplayString
        
        return cell
    }
}

extension RestaurantsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        currentFilter.postcode = postcodeField.text
        
        guard let postcode = currentFilter.postcode else { return true }
        
        restaurantService.fetchRestaurants(for: postcode) { [weak self] result in
            
            guard let `self` = self else { return }
            
            switch result {
                
            case .success(let fetchedRestaurants):
                self.allRestaurants = fetchedRestaurants
                self.visibleRestaurants = fetchedRestaurants
                self.tableView.reloadData()
                
            case .failure(let error):
                // Handle Error
                print(error)
            }
        }
        return true
    }
}
