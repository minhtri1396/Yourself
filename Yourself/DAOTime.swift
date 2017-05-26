class DAOTime: DAOSuper {
    static let BUILDER = DAOTime()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists Time_\(DAOSuper.userID)(id INT NOT NULL PRIMARY KEY, content NVARCHAR(128), startTime INT64, appointment INT64, finishTime INT64, state INT, tag INT);")
    }
        
    func Select(query: String) -> [Int64 : DTOTime] {
        var timeTuples = [Int64 : DTOTime]()
        let statement = super.PrepareQuery(query: query)
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let timeTuple = DTOTime(
                id: (Int64)(sqlite3_column_int64(statement, 0)),
                content: String(cString: sqlite3_column_text(statement, 1)),
                startTime: (Int64)(sqlite3_column_int64(statement, 2)),
                appointment: (Int64)(sqlite3_column_int64(statement, 3)),
                finishTime: (Int64)(sqlite3_column_int64(statement, 4)),
                state: TAG_STATE(rawValue: (Int)(sqlite3_column_int(statement, 5)))!,
                tag: TAG(rawValue: (Int)(sqlite3_column_int(statement, 6)))!
            )
            timeTuples[timeTuple.id] = timeTuple
        }
        
        sqlite3_finalize(statement)
        return timeTuples
    }
        
    func Insert(timeTuple: DTOTime) -> Bool {
        let query = "INSERT INTO Time_\(DAOSuper.userID)(id, content, startTime, appointment, finishTime, state, tag) VALUES (\(timeTuple.id), '\(timeTuple.content)', \(timeTuple.startTime), \(timeTuple.appointment), \(timeTuple.finishTime), \(timeTuple.state.rawValue), \(timeTuple.tag.rawValue));"
        return super.ExecQuery(query: query)
    }
    
    func Update(timeTuple: DTOTime) -> Bool {
        let query = "UPDATE Time_\(DAOSuper.userID) SET content='\(timeTuple.content)', startTime=\(timeTuple.startTime), appointment=\(timeTuple.appointment), finishTime=\(timeTuple.finishTime), state=\(timeTuple.state.rawValue), tag=\(timeTuple.tag.rawValue) WHERE id=\(timeTuple.id);"
        return super.ExecQuery(query: query)
    }
    
    func Delete(id: Int64) -> Bool {
        let query = "DELETE FROM Time_\(DAOSuper.userID) WHERE id=\(id);"
        let result = super.ExecQuery(query: query)
        if result {
            _ = DAOTrash.BUILDER.Insert(tableName: super.GetName(), recordID: "\(id)")
        }
        
        return result
    }
    
    // User's information (used when uid changed)
    func Move(to newUID: String) {
        let query = "ALTER TABLE Time_\(DAOSuper.userID) RENAME TO Time_\(newUID);"
        _ = super.ExecQuery(query: query)
    }
}
