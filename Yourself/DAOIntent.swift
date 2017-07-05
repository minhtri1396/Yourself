class DAOIntent: DAOSuper {
    static let BUILDER = DAOIntent()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists \(self.GetName())_\(DAOSuper.userID) (timestamp INT64 NOT NULL, type NVARCHAR(4) NOT NULL, content NVARCHAR(128), money Double, state Int, PRIMARY KEY(timestamp, type));")
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
            money: (Double)(sqlite3_column_double(statement, 3)),
            state: INTENT_STATE(rawValue: (Int)(sqlite3_column_int(statement, 4)))!
        )
    }
    
    func GetAll(hasState: INTENT_STATE) -> [DTOIntent] {
        return super.GetAll(withWhere: "state=\(hasState.rawValue)") as! [DTOIntent]
    }
    
    override func Add(_ value: Any) -> Bool {
        let intent = value as! DTOIntent
        let query = "INSERT INTO \(self.GetName())_\(DAOSuper.userID) (timestamp, type, content, money, state) VALUES (\(intent.timestamp), '\(intent.type)', '\(intent.content)', \(intent.money), \(intent.state.rawValue));"
        return super.ExecQuery(query: query)
    }
    
    func Update(intent: DTOIntent) -> Bool {
        return super.Update(withSet: "content='\(intent.content)', money=\(intent.money), state=\(intent.state.rawValue)", withWhere: "timestamp=\(intent.timestamp) AND type='\(intent.type)'")
    }
    
    func Delete(timestamp: Int64) -> Bool {
        return super.Delete(withWhere: "timestamp=\(timestamp)", id: "\(timestamp)")
    }
}
