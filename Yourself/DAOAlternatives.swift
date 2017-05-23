class DAOAlternatives: DAOSuper {
    static let BUILDER = DAOAlternatives()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists Alternatives_\(DAOSuper.userID)(timestamp INT64 NOT NULL PRIMARY KEY, owner NVARCHAR(4), alts NVARCHAR(4), money Double);")
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
    
    func Insert(altsTuple: DTOAlternatives) -> Bool {
        let query = "INSERT INTO Alternatives_\(DAOSuper.userID)(timestamp, owner, alts, money) VALUES (\(altsTuple.timestamp), \(altsTuple.owner), '\(altsTuple.alts)', \(altsTuple.money));"
        return super.ExecQuery(query: query)
    }
    
    func Update(altsTuple: DTOAlternatives) -> Bool {
        let query = "UPDATE Alternatives_\(DAOSuper.userID) SET owner=\(altsTuple.owner), alts='\(altsTuple.alts)', money=\(altsTuple.money) WHERE timestamp=\(altsTuple.timestamp);"
        return super.ExecQuery(query: query)
    }
    
    func Delete(timestamp: Int64) -> Bool {
        let query = "DELETE FROM Alternatives_\(DAOSuper.userID) WHERE timestamp=\(timestamp);"
        return super.ExecQuery(query: query)
    }
    
    // User's information (used when uid changed)
    func Move(to newUID: String) {
        let query = "ALTER TABLE Alternatives_\(DAOSuper.userID) RENAME TO Alternatives_\(newUID);"
        _ = super.ExecQuery(query: query)
    }
}
