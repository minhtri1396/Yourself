class DAOTimestamp: DAOSuper {
    static let BUILDER = DAOTimestamp()
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists \(self.GetName())_\(DAOSuper.userID) (id NVARCHAR(128) NOT NULL PRIMARY KEY, timestamp INT64);")
    }
    
    func GetTimestamp(of tableName: String) -> Int64 {
        let timestamp = super.Get(withWhere: "id='\(tableName)'")
        
        if timestamp != nil{
            return (timestamp as! DTOTimestamp).value
        }
        
        return 0
    }
    
    // This method will be used by super class when we get any record from DB
    override func ParseStatement(_ statement: OpaquePointer) -> Any {
        return DTOTimestamp(
            id: String(cString: sqlite3_column_text(statement, 0)),
            value: (Int64)(sqlite3_column_int64(statement, 1))
        )
    }
    
    func UpdateOrInsert(timestamp: DTOTimestamp) {
        if self.IsExisted(id: timestamp.id) {
            let query = "UPDATE \(self.GetName())_\(DAOSuper.userID) SET timestamp=\(timestamp.value) WHERE id='\(timestamp.id)';"
            _ = super.ExecQuery(query: query)
        } else {
            self.Add(timestamp: timestamp)
        }
    }
    
    private func Add(timestamp: DTOTimestamp) {
        let query = "INSERT INTO \(self.GetName())_\(DAOSuper.userID)(id, timestamp) VALUES ('\(timestamp.id)', \(timestamp.value));"
        _ = super.ExecQuery(query: query)
    }
    
    private func IsExisted(id: String) -> Bool {
        let query = "SELECT EXISTS(SELECT 1 FROM \(self.GetName())_\(DAOSuper.userID) WHERE id='\(id)' LIMIT 1);"
        let statement = super.PrepareQuery(query: query)
        if sqlite3_step(statement) == SQLITE_ROW {
            return (Int)(sqlite3_column_int(statement, 0)) == 1
        }
        
        return false
    }
}
