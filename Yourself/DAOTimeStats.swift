class DAOTimeStats: DAOSuper {
    static let BUILDER = DAOTimeStats()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists TimeStats_\(DAOSuper.userID)(timestamp INT64 NOT NULL PRIMARY KEY, totalCompletionTime INT64, numberSuccessNotes INT, numberFailNotes INT, totalNumberNotes INT);")
    }
    
    func Select(query: String) -> [Int64 : DTOTimeStats] {
        var timeStatsTuples = [Int64 : DTOTimeStats]()
        let statement = super.PrepareQuery(query: query)
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let timeStatsTuple = DTOTimeStats(
                timestamp: (Int64)(sqlite3_column_int64(statement, 0)),
                totalCompletionTime: (Int64)(sqlite3_column_int64(statement, 1)),
                numberSuccessNotes: (Int32)(sqlite3_column_int(statement, 2)),
                numberFailNotes: (Int32)(sqlite3_column_int(statement, 3)),
                totalNumberNotes: (Int32)(sqlite3_column_int(statement, 4))
            )
            timeStatsTuples[timeStatsTuple.timestamp] = timeStatsTuple
        }
        
        sqlite3_finalize(statement)
        return timeStatsTuples
    }
    
    func Insert(timeStatsTuple: DTOTimeStats) -> Bool {
        let query = "INSERT INTO TimeStats_\(DAOSuper.userID)(timestamp, totalCompletionTime, numberSuccessNotes, numberFailNotes, totalNumberNotes) VALUES (\(timeStatsTuple.timestamp), \(timeStatsTuple.totalCompletionTime), \(timeStatsTuple.numberSuccessNotes), \(timeStatsTuple.numberFailNotes), \(timeStatsTuple.totalNumberNotes));"
        return super.ExecQuery(query: query)
    }
    
    func Update(timeStatsTuple: DTOTimeStats) -> Bool {
        let query = "UPDATE TimeStats_\(DAOSuper.userID) SET totalCompletionTime=\(timeStatsTuple.totalCompletionTime), numberSuccessNotes=\(timeStatsTuple.numberSuccessNotes), numberFailNotes=\(timeStatsTuple.numberFailNotes), totalNumberNotes=\(timeStatsTuple.totalNumberNotes)   WHERE timestamp=\(timeStatsTuple.timestamp);"
        return super.ExecQuery(query: query)
    }
    
    func Delete(timestamp: Int64) -> Bool {
        let query = "DELETE FROM TimeStats_\(DAOSuper.userID) WHERE timestamp=\(timestamp);"
        let result = super.ExecQuery(query: query)
        if result {
            _ = DAOTrash.BUILDER.Insert(tableName: super.GetName(), recordID: "\(timestamp)")
        }
        
        return result
    }
    
    // User's information (used when uid changed)
    func Move(to newUID: String) {
        let query = "ALTER TABLE TimeStats_\(DAOSuper.userID) RENAME TO TimeStats_\(newUID);"
        _ = super.ExecQuery(query: query)
    }
}
