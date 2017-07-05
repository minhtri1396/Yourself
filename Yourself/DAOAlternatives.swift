class DAOAlternatives: DAOSuper {
    static let BUILDER = DAOAlternatives()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists \(self.GetName())_\(DAOSuper.userID) (timestamp INT64 NOT NULL, owner NVARCHAR(4) NOT NULL, alts NVARCHAR(4) NOT NULL, money Double, PRIMARY KEY(timestamp, owner, alts));")
    }
    
    func Select(query: String) -> [Int64 : DTOAlternatives] {
        var altTuples = [Int64 : DTOAlternatives]()
        let statement = super.PrepareQuery(query: query)
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let altsTuple = DTOAlternatives(
                timestamp: (Int64)(sqlite3_column_int64(statement, 0)),
                owner: JARS_TYPE(rawValue: String(cString: sqlite3_column_text(statement, 1)))!,
                alts: JARS_TYPE(rawValue: String(cString: sqlite3_column_text(statement, 1)))!,
                money: (Double)(sqlite3_column_double(statement, 3))
            )
            altTuples[altsTuple.timestamp] = altsTuple
        }
        
        sqlite3_finalize(statement)
        return altTuples
    }
    
    func GetAlternative(with timestamp: Int64, ownerType: JARS_TYPE, altsType: JARS_TYPE) -> DTOAlternatives? {
        return super.Get(withWhere: "timestamp=\(timestamp) AND owner='\(ownerType)' AND alts='\(altsType)'") as! DTOAlternatives?
    }
    
    func GetAlternative(with timestamp: Int64, ownerType: JARS_TYPE) -> [DTOAlternatives] {
        return super.GetAll(withWhere: "timestamp=\(timestamp) AND owner='\(ownerType)' AND owner!=alts") as! [DTOAlternatives]
    }
    
    // This method will be used by super class when we get any record from DB
    override func ParseStatement(_ statement: OpaquePointer) -> Any {
        return DTOAlternatives(
            timestamp: (Int64)(sqlite3_column_int64(statement, 0)),
            owner: JARS_TYPE(rawValue: String(cString: sqlite3_column_text(statement, 1)))!,
            alts: JARS_TYPE(rawValue: String(cString: sqlite3_column_text(statement, 2)))!,
            money: (Double)(sqlite3_column_double(statement, 3))
        )
    }
    
    override func Add(_ value: Any) -> Bool {
        let alts = value as! DTOAlternatives
        let query = "INSERT INTO \(self.GetName())_\(DAOSuper.userID) (timestamp, owner, alts, money) VALUES (\(alts.timestamp), '\(alts.owner)', '\(alts.alts)', \(alts.money));"
        return super.ExecQuery(query: query)
    }
    
    func Update(alts: DTOAlternatives) -> Bool {
        return super.Update(withSet: "money=\(alts.money)", withWhere: "timestamp=\(alts.timestamp) AND owner='\(alts.owner)' AND alts='\(alts.alts)'")
    }
    
    func Delete(timestamp: Int64) -> Bool {
        let alts = GetAll(withWhere: "timestamp=\(timestamp)") as! [DTOAlternatives]
        
        for alt in alts {
            _ = super.Delete(withWhere: "timestamp=\(timestamp)", id: "\(timestamp)_\(alt.owner.rawValue)_\(alt.alts.rawValue)")
        }
        
        return true
    }
}
