//
//  BasketViewController.swift
//  ThinkingInSwift
//
//  Created by Keith Moon on 11/11/2016.
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

class BasketViewController: UIViewController {
    
    @IBOutlet fileprivate var tableView: UITableView!
    var restaurant: Restaurant!
    
    // MARK: Model Storage
    
    var basketItems = [BasketItem]()
    var discountVouchers = [DiscountVoucher]() // TODO: Make a set
    var availableItems = [BasketItem]()
    
    // MARK: Computed Values
    
    var unusedVouchers: [DiscountVoucher] {
        return discountVouchers.filter({ voucher -> Bool in
            return !voucher.used
        })
    }
    
    // MARK: Formatters
    
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    // MARK: Services
    
    let basketItemService = BasketItemService()
    let discountVoucherService = DiscountVoucherService()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        availableItems = basketItemService.basketItems(for: restaurant)
        discountVouchers = discountVoucherService.discountVouchers()
        
        tableView.register(BasketItemCell.self)
        updateTitle()
    }
    
    fileprivate func updateTitle() {
        title = "Vouchers Available: \(unusedVouchers.count)"
    }
    
    // MARK: Action Methods
    
    @IBAction private func showItems() {
        
        let actionSheet = UIAlertController(title: "Add to your basket", message: nil, preferredStyle: .actionSheet)
        for item in availableItems {
            
            let action = UIAlertAction(title: item.name, style: .default) { [weak self] action in
                self?.basketItems.append(item)
                self?.tableView.reloadData()
            }
            actionSheet.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }
}

extension BasketViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let basketItem = basketItems[indexPath.row]
        let cell: BasketItemCell = tableView.dequeue(forIndexPath: indexPath)
        cell.textLabel?.text = basketItem.name
        cell.detailTextLabel?.text = currencyFormatter.string(for: basketItem.price - basketItem.discount)
        return cell
    }
}

extension BasketViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let voucher = unusedVouchers.first {
            
            let alert = UIAlertController(title: "Apply Discount Voucher", message: "Would you like to apply your \(voucher.percentage)% discount?", preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default) { [weak self] action in
                
                self?.basketItems[indexPath.row].apply(discountVoucher: voucher)
                tableView.reloadData()
                self?.updateTitle()
            }
            let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(yes)
            alert.addAction(no)
            present(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "No Discount Voucher Available", message: "You have no more discount vouchers available", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
