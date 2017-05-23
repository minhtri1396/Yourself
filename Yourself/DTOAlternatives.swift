class DTOAlternatives {
    let timestamp: Int64 // primary key
    var owner: JARS_TYPE
    var alts: JARS_TYPE
    var money: Double
    
    init(timestamp: Int64, owner: JARS_TYPE, alts: JARS_TYPE, money: Double) {
        self.timestamp = timestamp
        self.owner = owner
        self.alts = alts
        self.money = money
    }
}
