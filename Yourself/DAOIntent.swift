class DAOIntent: DAOSuper {
    static let BUILDER = DAOIntent()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists \(self.GetName())_\(DAOSuper.userID) (timestamp INT64 NOT NULL PRIMARY KEY, type NVARCHAR(4) NOT NULL PRIMARY KEY, content NVARCHAR(128), money Double);")
    }
    
    func GetIntent(with timestamp: Int64, type: JARS_TYPE) -> DTOIntent? {
        return super.Get(withWhere: "timestamp=\(timestamp) AND type='\(type)'") as! DTOIntent?
    }
    
    // This method will be used by super class when we get any record from DB
    override func ParseStatement(_ statement: OpaquePointer) -> Any {
        return DTOIntent(
            timestamp: (Int64)(sqlite3_column_int64(statement, 0)),
            type: JARS_TYPE(rawValue: String(cString: sqlite3_column_text(statement, 1)))!,
            content: String(cString: sqlite3_column_text(statement, 2)),
            money: (Double)(sqlite3_column_double(statement, 3))
        )
    }
    
    override func Add(_ value: Any) -> Bool {
        let intent = value as! DTOIntent
        let query = "INSERT INTO \(self.GetName())_\(DAOSuper.userID) (timestamp, type, content, money) VALUES (\(intent.timestamp), '\(intent.type)', '\(intent.content)', \(intent.money));"
        return super.ExecQuery(query: query)
    }
    
    func Update(intent: DTOIntent) -> Bool {
        return super.Update(withSet: "content='\(intent.content)', money=\(intent.money)", withWhere: "timestamp=\(intent.timestamp) AND type='\(intent.type)'")
    }
    
    func Delete(timestamp: Int64) -> Bool {
        return super.Delete(withWhere: "timestamp=\(timestamp)", id: "\(timestamp)")
    }
}
