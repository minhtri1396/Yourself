class DAOCheerUp: DAOSuper {
    static let BUILDER = DAOCheerUp()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists \(self.GetName())_\(DAOSuper.userID) (timestamp INT64 NOT NULL PRIMARY KEY, content NVARCHAR(128));")
    }
    
    func Select(query: String) -> [Int64 : DTOCheerUp] {
        var cheerUpTuples = [Int64 : DTOCheerUp]()
        let statement = super.PrepareQuery(query: query)
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let cheerUpTuple = DTOCheerUp(
                timestamp: (Int64)(sqlite3_column_int64(statement, 0)),
                content: String(cString: sqlite3_column_text(statement, 1))
            )
            cheerUpTuples[cheerUpTuple.timestamp] = cheerUpTuple
        }
        
        sqlite3_finalize(statement)
        return cheerUpTuples
    }
    
    func GetCheerUp(with timestamp: Int64) -> DTOCheerUp? {
        return super.Get(withWhere: "timestamp=\(timestamp)") {
            statement in
            return DTOCheerUp(
                timestamp: (Int64)(sqlite3_column_int64(statement, 0)),
                content: String(cString: sqlite3_column_text(statement, 1))
            )
        } as! DTOCheerUp?
    }
    
    func GetAll() -> [DTOCheerUp] {
        let records = super.GetAll() {
            statement in
            return DTOCheerUp(
                timestamp: (Int64)(sqlite3_column_int64(statement, 0)),
                content: String(cString: sqlite3_column_text(statement, 1))
            )
        }
        
        return records as! [DTOCheerUp]
    }
    
    func Add(cheerUpTuple: DTOCheerUp) -> Bool {
        let query = "INSERT INTO \(self.GetName())_\(DAOSuper.userID) (timestamp, content) VALUES (\(cheerUpTuple.timestamp), '\(cheerUpTuple.content)');"
        return super.ExecQuery(query: query)
    }
    
    func Update(cheerUpTuple: DTOCheerUp) -> Bool {
        return super.Update(withSet: "content='\(cheerUpTuple.content)'", withWhere: "timestamp=\(cheerUpTuple.timestamp)")
    }
    
    func Delete(timestamp: Int64) -> Bool {
        return super.Delete(withWhere: "timestamp=\(timestamp)", id: "\(timestamp)")
    }
}
