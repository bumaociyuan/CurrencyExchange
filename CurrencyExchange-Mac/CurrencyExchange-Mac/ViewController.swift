//
//  ViewController.swift
//  CurrencyExchange-Mac
//
//  Created by admin on 12/18/15.
//  Copyright © 2015 __ASIAINFO__. All rights reserved.
//

import Cocoa

class CurrencyTextField: NSTextField {
	var currencySymbol: CurrencySymbol?
}

class ViewController: NSViewController {
	
	var textFields: [CurrencyTextField] = [CurrencyTextField]()
	var cachedRates: NSDictionary?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		CurrencyService.getLatestCurrency(success: {result in
				print(result)
				self.cachedRates = (result as? NSDictionary)?["rates"] as? NSDictionary
			})
		
		var rawValue = 0
		view.wantsLayer = true
		view.layer?.backgroundColor = NSColor.redColor().CGColor
		var previousView: NSView = view
		repeat {
			let symbol = CurrencySymbol(rawValue: rawValue)
			let textField = CurrencyTextField()
			textField.delegate = self
			view.addSubview(textField)
			let label = NSTextField()
			view.addSubview(label)
			label.editable = false
			label.bordered = false
			label.backgroundColor = NSColor.redColor()
			textField.currencySymbol = symbol
			label.stringValue = (symbol?.chineseLocaleName())!
			label.sizeToFit()
			
			label.mas_makeConstraints({(make) -> Void in
					make.leading.equalTo()(self.view)
					make.height.equalTo()(20)
					make.width.equalTo()(50)
					if previousView == self.view {
						make.top.equalTo()(self.view)
					} else {
						make.top.equalTo()(previousView.mas_bottom).offset()(20)
					}
				})
			textField.mas_makeConstraints({(make) -> Void in
					make.top.equalTo()(label)
					make.leading.equalTo()(label.mas_trailing)
					make.bottom.equalTo()(label)
					make.trailing.equalTo()(self.view)
				})
			
			textFields.append(textField)
			
			previousView = label
			rawValue++
		} while CurrencySymbol(rawValue: rawValue) != nil
		
		
		
	}
	
	override func mouseDown(theEvent: NSEvent) {
		view.window?.endEditingFor(nil)
	}
	
	override var representedObject: AnyObject? {
		didSet {
			// Update the view, if already loaded.
		}
	}
}


extension ViewController: NSTextFieldDelegate {
	override func controlTextDidEndEditing(obj: NSNotification) {
		let t = obj.object as! CurrencyTextField
		if let number = Float(t.stringValue) {
			for ct in textFields {
				if ct == t {
					continue
				}
				
				let tSymbolString: String! = t.currencySymbol?.symbolString()
				let ctSymbolString: String! = ct.currencySymbol?.symbolString()
				
				if let cachedRatesAbsolute = cachedRates {
					let rate = (cachedRatesAbsolute[ctSymbolString]!.floatValue)! / (cachedRatesAbsolute[tSymbolString]!.floatValue)!
					ct.stringValue = "\(number * rate)"
				}
				
			}
		}
	}
}
