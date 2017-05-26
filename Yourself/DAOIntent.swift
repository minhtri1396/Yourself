class DAOIntent: DAOSuper {
    static let BUILDER = DAOIntent()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists Intent_\(DAOSuper.userID)(timestamp INT64 NOT NULL PRIMARY KEY, type NVARCHAR(4), content NVARCHAR(128), money Double);")
    }
    
    func Select(query: String) -> [Int64 : DTOIntent] {
        var intentTuples = [Int64 : DTOIntent]()
        let statement = super.PrepareQuery(query: query)
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let intentTuple = DTOIntent(
                timestamp: (Int64)(sqlite3_column_int64(statement, 0)),
                type: JARS_TYPE(rawValue: String(cString: sqlite3_column_text(statement, 1)))!,
                content: String(cString: sqlite3_column_text(statement, 2)),
                money: (Double)(sqlite3_column_double(statement, 3))
            )
            intentTuples[intentTuple.timestamp] = intentTuple
        }
        
        sqlite3_finalize(statement)
        return intentTuples
    }
    
    func Insert(intentTuple: DTOIntent) -> Bool {
        let query = "INSERT INTO Intent_\(DAOSuper.userID)(timestamp, type, content, money) VALUES (\(intentTuple.timestamp), \(intentTuple.type), '\(intentTuple.content)', \(intentTuple.money));"
        return super.ExecQuery(query: query)
    }
    
    func Update(intentTuple: DTOIntent) -> Bool {
        let query = "UPDATE Intent_\(DAOSuper.userID) SET type=\(intentTuple.type), content='\(intentTuple.content)', money=\(intentTuple.money) WHERE timestamp=\(intentTuple.timestamp);"
        return super.ExecQuery(query: query)
    }
    
    func Delete(timestamp: Int64) -> Bool {
        let query = "DELETE FROM Intent_\(DAOSuper.userID) WHERE timestamp=\(timestamp);"
        let result = super.ExecQuery(query: query)
        if result {
            _ = DAOTrash.BUILDER.Insert(tableName: super.GetName(), recordID: "\(timestamp)")
        }
        
        return result
    }
    
    // User's information (used when uid changed)
    func Move(to newUID: String) {
        let query = "ALTER TABLE Intent_\(DAOSuper.userID) RENAME TO Intent_\(newUID);"
        _ = super.ExecQuery(query: query)
    }
}
