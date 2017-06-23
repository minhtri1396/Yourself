import Foundation

extension Date {
    var ticks: Int64 {
        return Int64((self.timeIntervalSince1970) * 10) // millisecond (can plus 62_135_596_800 (01/01/0001))
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
