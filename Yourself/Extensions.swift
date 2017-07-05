import Foundation

extension Date {
    var ticks: Int64 {
        return Int64((self.timeIntervalSince1970) * 10) // millisecond (can plus 62_135_596_800 (01/01/0001))
    }
    
    static func getMonth(date: Date)->Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: date)
    }
    
    static func getYear(date: Date)->Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
    
    static func convertDateToDateString(date: Date) -> String {
        return convertDateToDateString(date: date, withFormat: "dd-MM-yyyy")
    }
    
    static func convertDateToDateString(date: Date, withFormat: String) -> String {
        // convert date to string (format: dd-MM-yyyy)s
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
//        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = withFormat //Specify your format that you want
        return dateFormatter.string(from: date)
    }
    
    static func convertTimestampToDateString(timeStamp: Int64) -> String {
        // convert timestamp to date
        return convertDateToDateString(date: Date(timeIntervalSince1970: TimeInterval(timeStamp)))
    }
    
    static func convertTimestampToDateString(timeStamp: Int64, withFormat: String) -> String {
        // convert timestamp to date
        return convertDateToDateString(date: Date(timeIntervalSince1970: TimeInterval(timeStamp)), withFormat: withFormat)
    }
}

extension Double {
    var clean: String {
        return self.remainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
//    var formattedWithSeparator: String {
//        let decimal = self.round(numberOfDecimal: 0) as! Int
//        var res = decimal.formattedWithSeparator
//        
//        var numAsStr = self.clean
//        
//        return res
//    }
    
    func round(numberOfDecimal: Int) -> Double {
        let multiplier = pow(10.0, Double(numberOfDecimal))
        var cloned = self
        cloned.multiply(by: multiplier)
        cloned.round()
        cloned.divide(by: multiplier)
        return cloned
    }
}

//extension Formatter {
//    static let withSeparator: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.groupingSeparator = ","
//        formatter.numberStyle = .decimal
//        return formatter
//    }()
//}
//
//extension Integer {
//    var formattedWithSeparator: String {
//        return Formatter.withSeparator.string(for: self) ?? ""
//    }
//}
