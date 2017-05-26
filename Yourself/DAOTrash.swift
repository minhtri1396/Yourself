class DAOTrash: DAOSuper {
    static let BUILDER = DAOTrash()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists Trash_\(DAOSuper.userID)(tableName NVARCHAR(50) NOT NULL, recordID NVARCHAR(50) NOT NULL, PRIMARY KEY (tableName, recordID));")
    }
    
    func Select(tableName: String, recordID: String) -> [String] {
        let query = "SELECT recordID FROM Trash_\(DAOSuper.userID) WHERE tableName='\(tableName)' AND recordID='\(recordID)'"
        let statement = super.PrepareQuery(query: query)
        
        var records = [String]()
        while sqlite3_step(statement) == SQLITE_ROW {
            records.append(String(cString: sqlite3_column_text(statement, 0)))
        }
        
        sqlite3_finalize(statement)
        return records
    }
    
    func Insert(tableName: String, recordID: String) -> Bool {
        let query = "INSERT INTO Trash_\(DAOSuper.userID)(tableName, recordID) VALUES (\(tableName), \(recordID));"
        return super.ExecQuery(query: query)
    }
    
    func DeleteAll() -> Bool {
        let query = "DELETE FROM Trash_\(DAOSuper.userID);"
        return super.ExecQuery(query: query)
    }
    
    // User's information (used when uid changed)
    func Move(to newUID: String) {
        let query = "ALTER TABLE Trash_\(DAOSuper.userID) RENAME TO Trash_\(newUID);"
        _ = super.ExecQuery(query: query)
    }
}
