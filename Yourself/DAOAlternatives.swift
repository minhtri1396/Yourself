class DAOAlternatives: DAOSuper {
    static let BUILDER = DAOAlternatives()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists \(self.GetName())_\(DAOSuper.userID) (timestamp INT64 NOT NULL PRIMARY KEY, owner NVARCHAR(4), alts NVARCHAR(4), money Double);")
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
    
    func GetAlternative(with timestamp: Int64) -> DTOAlternatives? {
        return super.Get(withWhere: "timestamp=\(timestamp)") as! DTOAlternatives?
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
        return super.Update(withSet: "owner='\(alts.owner)', alts='\(alts.alts)', money=\(alts.money)", withWhere: "timestamp=\(alts.timestamp)")
    }
    
    func Delete(timestamp: Int64) -> Bool {
        return super.Delete(withWhere: "timestamp=\(timestamp)", id: "\(timestamp)")
    }
}
