//
//  CurrencyService.swift
//  Currency
//
//  Created by admin on 12/18/15.
//  Copyright © 2015 __ASIAINFO__. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum CurrencySymbol: Int {
    case CNY 
    case USD 
    case JPY 
    case HKD 
//    case EUR 
    case GBP
    
    func symbolString() -> String {
        switch self {
        case .CNY:
            return "CNY"
        case .USD:
            return "USD"
        case .JPY:
            return "JPY"
        case .HKD:
            return "HKD"
//        case .EUR:
//            return "EUR"
        case .GBP:
            return "GBP"
        }

    }
    
    func chineseLocaleName()->String {
        switch self {
        case .CNY:
            return "人民币"
        case .USD:
            return "美元"
        case .JPY:
            return "日元"
        case .HKD:
            return "港币"
//        case .EUR:
//            return "欧元"
        case .GBP:
            return "英镑"
        }

    }
}

typealias Success = (AnyObject)->()
typealias Fail = (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> ()

class CurrencyService: NSObject {
    
    
    static func getLatestCurrency(success success:Success? = nil, fail:Fail? = nil) {
        let url = "http://api.fixer.io/latest"
        Alamofire.request(.GET, url, parameters: nil)
            .response { request, response, data, error in
                
                if data != nil {
                    
                    let result = JSON(data: data!)
                    if result.type != Type.Null {
                        success?(result.object)
                    } else {
                        fail?(request,response,data,error)
                    }
                    
                } else {
                    
                    fail?(request,response,data,error)
                    
                }
                
        }
    }
    
    static func getCurrencyBySymbols(symbols:(CurrencySymbol,CurrencySymbol), success:Success? = nil, fail:Fail? = nil) {
        
        let url = "http://api.fixer.io/latest?symbols=\(symbols.0.symbolString()),\(symbols.1.symbolString())"
        
        Alamofire.request(.GET, url, parameters: nil)
            .response { request, response, data, error in
                
                if data != nil {
                    
                    let result = JSON(data: data!)
                    if result.type != Type.Null {
                        success?(result.object)
                    } else {
                        fail?(request,response,data,error)
                    }
                    
                } else {
                    
                    fail?(request,response,data,error)
                    
                }
                
        }
    }
}
