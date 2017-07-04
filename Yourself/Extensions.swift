import Foundation

extension Date {
    var ticks: Int64 {
        return Int64((self.timeIntervalSince1970) * 10) // millisecond (can plus 62_135_596_800 (01/01/0001))
    }
    
    static func getMonth(date: Date)->Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: date)
    }
    
    static func convertDateToDateString(date: Date)->String {
        // convert date to string (format: dd-MM-yyyy)s
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy" //Specify your format that you want
        return dateFormatter.string(from: date)
    }
    
    static func convertTimestampToDateString(timeStamp: Int64)->String {
        // convert timestamp to date
        return convertDateToDateString(date: Date(timeIntervalSince1970: TimeInterval(timeStamp)))
    }
}

extension Double {
    var clean: String {
        return self.remainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    func round(numberOfDecimal: Int) -> Double {
        let multiplier = pow(10.0, Double(numberOfDecimal))
        var cloned = self
        cloned.multiply(by: multiplier)
        cloned.round()
        cloned.divide(by: multiplier)
        return cloned
    }
}
