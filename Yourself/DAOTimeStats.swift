class DAOTimeStats: DAOSuper {
    static let BUILDER = DAOTimeStats()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists \(self.GetName())_\(DAOSuper.userID) (timestamp INT64 NOT NULL PRIMARY KEY, totalCompletionTime INT64, numberSuccessNotes INT, numberFailNotes INT, totalNumberNotes INT);")
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
    
    func GetTimeStats(with timestamp: Int64) -> DTOTimeStats? {
        return super.Get(withWhere: "timestamp=\(timestamp)") as! DTOTimeStats?
    }
    
    // This method will be used by super class when we get any record from DB
    override func ParseStatement(_ statement: OpaquePointer) -> Any {
        return DTOTimeStats(
            timestamp: (Int64)(sqlite3_column_int64(statement, 0)),
            totalCompletionTime: (Int64)(sqlite3_column_int64(statement, 1)),
            numberSuccessNotes: (Int32)(sqlite3_column_int(statement, 2)),
            numberFailNotes: (Int32)(sqlite3_column_int(statement, 3)),
            totalNumberNotes: (Int32)(sqlite3_column_int(statement, 4))
        )
    }
    
    override func Add(_ value: Any) -> Bool {
        let timeStats = value as! DTOTimeStats
        let query = "INSERT INTO \(self.GetName())_\(DAOSuper.userID) (timestamp, totalCompletionTime, numberSuccessNotes, numberFailNotes, totalNumberNotes) VALUES (\(timeStats.timestamp), \(timeStats.totalCompletionTime), \(timeStats.numberSuccessNotes), \(timeStats.numberFailNotes), \(timeStats.totalNumberNotes));"
        return super.ExecQuery(query: query)
    }
    
    func Update(timeStatsTuple: DTOTimeStats) -> Bool {
        return super.Update(withSet: "totalCompletionTime=\(timeStatsTuple.totalCompletionTime), numberSuccessNotes=\(timeStatsTuple.numberSuccessNotes), numberFailNotes=\(timeStatsTuple.numberFailNotes), totalNumberNotes=\(timeStatsTuple.totalNumberNotes)", withWhere: "timestamp=\(timeStatsTuple.timestamp)")
    }
    
    func Delete(timestamp: Int64) -> Bool {
        return super.Delete(withWhere: "timestamp=\(timestamp)", id: "\(timestamp)")
    }
}
