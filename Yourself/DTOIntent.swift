class DTOIntent {
    var timestamp: Int64 // primary key
    var type: JARS_TYPE
    var content: String
    var money: Double
    
    init(timestamp: Int64, type: JARS_TYPE, content: String, money: Double) {
        self.timestamp = timestamp
        self.type = type
        self.content = content
        self.money = money
    }
}
