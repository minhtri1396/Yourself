enum JARS_TYPE: String {
    case NEC, // Necessities
    FFA, // Financial Freedom Account
    LTSS, // Long Term Savings
    EDU, // Education
    PLAY,
    GIVE
}


class DTOJars {
    
    static let DEFAULT: [JARS_TYPE: Double] = [
        .NEC: 0.55,
        .FFA: 0.1,
        .LTSS: 0.1,
        .EDU: 0.1,
        .PLAY: 0.1,
        .GIVE: 0.05
    ]
    
    let type: JARS_TYPE
    var percent: Double
    var money:Double
    
    init(type: JARS_TYPE, money: Double) {
        self.type = type
        self.money = money
        self.percent = DTOJars.DEFAULT[type]!
    }
    
    convenience init(type: JARS_TYPE) {
        self.init(type: type, money: 0)
    }
    
}
