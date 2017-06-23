import UIKit


enum EXRATE_TYPE: String {
    case VND,
    DOLLAR,
    EURO
}



class ExchangeRate {
    static let BUILDER = ExchangeRate()
    private var type: EXRATE_TYPE!
    private var rate: Double! // compare with USD
    
    var isRateChanged: Bool = false
    
    var RateType: EXRATE_TYPE {
        get {
            return type
        }
        set {
            if type != newValue {
                UserDefaults.standard.set(newValue.rawValue, forKey: "RateType")
                type = newValue
            }
        }
    }
    
    var Rate: Double {
        get {
            return rate
        }
        set {
            if rate != newValue {
                isRateChanged = true
                UserDefaults.standard.set(newValue, forKey: "Rate")
                rate = newValue
            }
        }
    }
    
    private init() {
        let typeAsString = UserDefaults.standard.value(forKey: "RateType") as? String
        if typeAsString == nil {
            UserDefaults.standard.set(EXRATE_TYPE.DOLLAR.rawValue, forKey: "RateType")
            type = EXRATE_TYPE.DOLLAR
        } else {
            type = EXRATE_TYPE.init(rawValue: typeAsString!)
        }
        
        rate = UserDefaults.standard.value(forKey: "Rate") as? Double
        if rate == nil {
            UserDefaults.standard.set(1, forKey: "Rate")
            rate = 1
        }
    }
    
    func transfer(price: Double) -> Double {
        return (rate! * price).round(numberOfDecimal: 2)
    }
}
