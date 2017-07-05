class DAOTime: DAOSuper {
    static let BUILDER = DAOTime()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists \(self.GetName())_\(DAOSuper.userID) (id INT64 NOT NULL PRIMARY KEY, content NVARCHAR(128), startTime INT64, appointment INT64, finishTime INT64, state INT, tag INT);")
    }
        
    func Select(query: String) -> [Int64 : DTOTime] {
        var times = [Int64 : DTOTime]()
        let statement = super.PrepareQuery(query: query)
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let time = DTOTime(
                id: (Int64)(sqlite3_column_int64(statement, 0)),
                content: String(cString: sqlite3_column_text(statement, 1)),
                startTime: (Int64)(sqlite3_column_int64(statement, 2)),
                appointment: (Int64)(sqlite3_column_int64(statement, 3)),
                finishTime: (Int64)(sqlite3_column_int64(statement, 4)),
                state: TAG_STATE(rawValue: (Int)(sqlite3_column_int(statement, 5)))!,
                tag: (Int)(sqlite3_column_int(statement, 6))
            )
            times[time.id] = time
        }
        
        sqlite3_finalize(statement)
        return times
    }
    
    func GetTime(with id: Int64) -> DTOTime? {
        return super.Get(withWhere: "id=\(id)") as! DTOTime?
    }
    
    // This method will be used by super class when we get any record from DB
    override func ParseStatement(_ statement: OpaquePointer) -> Any {
        return DTOTime(
            id: (Int64)(sqlite3_column_int64(statement, 0)),
            content: String(cString: sqlite3_column_text(statement, 1)),
            startTime: (Int64)(sqlite3_column_int64(statement, 2)),
            appointment: (Int64)(sqlite3_column_int64(statement, 3)),
            finishTime: (Int64)(sqlite3_column_int64(statement, 4)),
            state: TAG_STATE(rawValue: (Int)(sqlite3_column_int(statement, 5)))!,
            tag: (Int)(sqlite3_column_int(statement, 6))
        )
    }
    
    func GetAll(hasStates: [TAG_STATE]) -> [DTOTime] {
        var condition = "state=\(hasStates[0].rawValue)"
        for iState in 1..<hasStates.count {
            condition += " OR state=\(hasStates[iState].rawValue)"
        }
        return super.GetAll(withWhere: condition) as! [DTOTime]
    }
    
    override func Add(_ value: Any) -> Bool {
        let time = value as! DTOTime
        let query = "INSERT INTO \(self.GetName())_\(DAOSuper.userID) (id, content, startTime, appointment, finishTime, state, tag) VALUES (\(time.id), '\(time.content)', \(time.startTime), \(time.appointment), \(time.finishTime), \(time.state.rawValue), \(time.tag));"
        return super.ExecQuery(query: query)
    }
    
    func Update(time: DTOTime) -> Bool {
        return super.Update(withSet: "content='\(time.content)', startTime=\(time.startTime), appointment=\(time.appointment), finishTime=\(time.finishTime), state=\(time.state.rawValue), tag=\(time.tag)", withWhere: "id=\(time.id)")
    }
    
    func Delete(id: Int64) -> Bool {
        return super.Delete(withWhere: "id=\(id)", id: "\(id)")
    }
}
