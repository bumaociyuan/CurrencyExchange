//
//  ViewController.swift
//  CurrencyExchange-Mac
//
//  Created by admin on 12/18/15.
//  Copyright © 2015 __ASIAINFO__. All rights reserved.
//

import Cocoa

class CurrencyTextField: NSTextField {
    var currencySymbol:CurrencySymbol?
}

class ViewController: NSViewController {

    var textFields: [CurrencyTextField] = [CurrencyTextField]()
    var cachedRates: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CurrencyService.getLatestCurrency(success: { result in
            print(result)
            self.cachedRates = (result as? NSDictionary)?["rates"] as? NSDictionary
            
        })
        

        var rawValue = 0
        
        
        repeat {
            let symbol = CurrencySymbol(rawValue: rawValue)
            let textField = CurrencyTextField()
//            textField.keyboardType = .NumberPad
//            textField.borderStyle = .RoundedRect
            view.addSubview(textField)
            let label = NSTextField()
            textField.currencySymbol = symbol
            label.stringValue = (symbol?.chineseLocaleName())!
//            label.font = UIFont.systemFontOfSize(14)
            label.sizeToFit()
            
//            textField.delegate = self
            
//            textField.leftView = label
//            textField.leftViewMode = .Always
//            textField.clearButtonMode = .WhileEditing
            textFields.append(textField)

            
            rawValue++
        } while CurrencySymbol(rawValue: rawValue) != nil
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

