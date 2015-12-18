//
//  ViewController.swift
//  Currency
//
//  Created by admin on 12/18/15.
//  Copyright © 2015 __ASIAINFO__. All rights reserved.
//

import UIKit
import SnapKit
import OAStackView

class CurrencyTextField: UITextField {
    var currencySymbol:CurrencySymbol?
}

class ViewController: UIViewController {
    
    var textFields: [CurrencyTextField] = [CurrencyTextField]()
    var cachedRates: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CurrencyService.getLatestCurrency(success: { result in
            print(result)
            self.cachedRates = (result as? NSDictionary)?["rates"] as? NSDictionary
            
        })
        
        let stackView = OAStackView()
        stackView.distribution = .EqualSpacing
        view.addSubview(stackView)
        stackView.axis = .Vertical
        stackView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        
        var rawValue = 0

        
        repeat {
            let symbol = CurrencySymbol(rawValue: rawValue)
            let textField = CurrencyTextField()
            textField.keyboardType = .NumberPad
            textField.borderStyle = .RoundedRect
            view.addSubview(textField)
            let label = UILabel()
            textField.currencySymbol = symbol
            label.text = symbol?.chineseLocaleName()
            label.font = UIFont.systemFontOfSize(14)
            label.sizeToFit()
            
            textField.delegate = self
            
            textField.leftView = label
            textField.leftViewMode = .Always
            textField.clearButtonMode = .WhileEditing
            textFields.append(textField)
            stackView.addArrangedSubview(textField)
            
            rawValue++
        } while CurrencySymbol(rawValue: rawValue) != nil
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        let t = textField as! CurrencyTextField
        if let number = Float(t.text!) {
            for ct in textFields {
                if ct == t {
                    continue
                }
                
                let tSymbolString:String! = t.currencySymbol?.symbolString()
                let ctSymbolString:String! = ct.currencySymbol?.symbolString()
                
                if let cachedRatesAbsolute = cachedRates {
                    let rate = (cachedRatesAbsolute[ctSymbolString]!.floatValue)! / (cachedRatesAbsolute[tSymbolString]!.floatValue)!
                   
                    
                    ct.text = "\(number * rate)"
                }
                
            }
        }

    }
}

