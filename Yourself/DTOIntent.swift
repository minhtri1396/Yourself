enum INTENT_STATE: Int {
    case NOT_YET = 0, DONE
}

class DTOIntent {
    var timestamp: Int64 // primary key
    var type: JARS_TYPE
    var content: String
    var money: Double
    var state: INTENT_STATE
    
    init(timestamp: Int64, type: JARS_TYPE, content: String, money: Double, state: INTENT_STATE) {
        self.timestamp = timestamp
        self.type = type
        self.content = content
        self.money = money
        self.state = state
    }
    
    convenience init(timestamp: Int64, type: JARS_TYPE, content: String, money: Double) {
        self.init(timestamp: timestamp, type: type, content: content, money: money, state: .NOT_YET)
    }
}
