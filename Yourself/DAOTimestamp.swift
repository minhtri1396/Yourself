class DAOTimestamp: DAOSuper {
    static let BUILDER = DAOTimestamp()
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists Timestamp_\(DAOSuper.userID)(id NVARCHAR(128) NOT NULL PRIMARY KEY, timestamp INT64);")
    }
    
    func GetAll() -> [Timestamp] {
        let query = "SELECT * FROM Timestamp_\(DAOSuper.userID);"
        let statement = super.PrepareQuery(query: query)
        
        var timestamps = [Timestamp]()
        while sqlite3_step(statement) == SQLITE_ROW {
            let timestamp = Timestamp(
                id: String(cString: sqlite3_column_text(statement, 0)),
                value: (Int64)(sqlite3_column_int64(statement, 1))
            )
            timestamps.append(timestamp)
        }
        
        sqlite3_finalize(statement)
        return timestamps
    }
    
    func UpdateOrInsert(timestamp: Timestamp) {
        if self.IsExisted(id: timestamp.id) {
            let query = "UPDATE Timestamp_\(DAOSuper.userID) SET timestamp=\(timestamp.value) WHERE id='\(timestamp.id)';"
            _ = super.ExecQuery(query: query)
        } else {
            self.Insert(timestamp: timestamp)
        }
    }
    
    private func Insert(timestamp: Timestamp) {
        let query = "INSERT INTO Timestamp_\(DAOSuper.userID)(id, timestamp) VALUES ('\(timestamp.id)', \(timestamp.value));"
        _ = super.ExecQuery(query: query)
    }
    
    private func IsExisted(id: String) -> Bool {
        let query = "SELECT EXISTS(SELECT 1 FROM Timestamp_\(DAOSuper.userID) WHERE id='\(id)' LIMIT 1);"
        let statement = super.PrepareQuery(query: query)
        if sqlite3_step(statement) == SQLITE_ROW {
            return (Int)(sqlite3_column_int(statement, 0)) == 1
        }
        
        return false
    }
    
    // User's information (used when uid changed)
    func Move(to newUID: String) {
        let query = "ALTER TABLE Timestamp_\(DAOSuper.userID) RENAME TO Timestamp_\(newUID);"
        _ = super.ExecQuery(query: query)
    }
}
