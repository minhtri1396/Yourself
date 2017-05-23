import Foundation

extension Date {
    var ticks: Int64 {
        return Int64((self.timeIntervalSince1970) * 10) // millisecond (can plus 62_135_596_800 (01/01/0001))
    }
}
