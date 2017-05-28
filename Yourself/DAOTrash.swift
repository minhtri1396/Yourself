class DAOTrash: DAOSuper {
    static let BUILDER = DAOTrash()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists \(self.GetName())_\(DAOSuper.userID) (tableName NVARCHAR(50) NOT NULL, recordID NVARCHAR(50) NOT NULL, PRIMARY KEY (tableName, recordID));")
    }
    
    func GetTrash(tableName: String) -> [String] {
        let query = "SELECT recordID FROM \(self.GetName())_\(DAOSuper.userID) WHERE tableName='\(tableName)';"
        let statement = super.PrepareQuery(query: query)
        
        var records = [String]()
        while sqlite3_step(statement) == SQLITE_ROW {
            records.append(String(cString: sqlite3_column_text(statement, 0)))
        }
        
        sqlite3_finalize(statement)
        return records
    }
    
    func Insert(tableName: String, recordID: String) -> Bool {
        let query = "INSERT INTO \(self.GetName())_\(DAOSuper.userID)(tableName, recordID) VALUES ('\(tableName)', '\(recordID)');"
        return super.ExecQuery(query: query)
    }
}
