class DAOCheerUp: DAOSuper {
    static let BUILDER = DAOCheerUp()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists CheerUp_\(DAOSuper.userID)(timestamp INT64 NOT NULL PRIMARY KEY, content NVARCHAR(128));")
    }
    
    func Select(query: String) -> [Int64 : DTOCheerUp] {
        var cheerUpTuples = [Int64 : DTOCheerUp]()
        let statement = super.PrepareQuery(query: query)
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let cheerUpTuple = DTOCheerUp(
                timestamp: (Int64)(sqlite3_column_int64(statement, 0)),
                content: String(cString: sqlite3_column_text(statement, 1))
            )
            cheerUpTuples[cheerUpTuple.timestamp] = cheerUpTuple
        }
        
        sqlite3_finalize(statement)
        return cheerUpTuples
    }
    
    func Insert(cheerUpTuple: DTOCheerUp) -> Bool {
        let query = "INSERT INTO CheerUp_\(DAOSuper.userID)(timestamp, content) VALUES (\(cheerUpTuple.timestamp), '\(cheerUpTuple.content)');"
        return super.ExecQuery(query: query)
    }
    
    func Update(cheerUpTuple: DTOCheerUp) -> Bool {
        let query = "UPDATE CheerUp_\(DAOSuper.userID) SET content='\(cheerUpTuple.content)' WHERE timestamp=\(cheerUpTuple.timestamp);"
        return super.ExecQuery(query: query)
    }
    
    func Delete(timestamp: Int64) -> Bool {
        let query = "DELETE FROM CheerUp_\(DAOSuper.userID) WHERE timestamp=\(timestamp);"
        let result = super.ExecQuery(query: query)
        if result {
            _ = DAOTrash.BUILDER.Insert(tableName: super.GetName(), recordID: "\(timestamp)")
        }
        
        return result
    }
    
    // User's information (used when uid changed)
    func Move(to newUID: String) {
        let query = "ALTER TABLE CheerUp_\(DAOSuper.userID) RENAME TO CheerUp_\(newUID);"
        _ = super.ExecQuery(query: query)
    }
}
