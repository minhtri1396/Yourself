class DAOJars: DAOSuper {
    static let BUILDER = DAOJars()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists JARSManagement_\(DAOSuper.userID)(type NVARCHAR(4) NOT NULL PRIMARY KEY, money DOUBLE, per DOUBLE);")
    }
    
    func GetAll() -> [DTOJars] {
        let query = "SELECT * FROM JARSManagement_\(DAOSuper.userID)"
        let statement = super.PrepareQuery(query: query)
        
        var jarsTuples = [DTOJars]()
        while sqlite3_step(statement) == SQLITE_ROW {
            let jars = DTOJars(
                type: JARS_TYPE(rawValue: String(cString: sqlite3_column_text(statement, 0)))!,
                money: (Double)(sqlite3_column_double(statement, 1))
            )
            jars.percent = (Double)(sqlite3_column_double(statement, 2))
            jarsTuples.append(jars)
        }
        
        sqlite3_finalize(statement)
        return jarsTuples
    }
    
    func Insert(jars: DTOJars) -> Bool {
        let query = "INSERT INTO JARSManagement_\(DAOSuper.userID)(type, money, per) VALUES (?, ?, ?);"
        let statement = super.PrepareQuery(query: query)
        
        sqlite3_bind_text(statement, 1, jars.type.rawValue, -1, nil)
        sqlite3_bind_double(statement, 2, jars.money)
        sqlite3_bind_double(statement, 3, jars.percent)
        
        return super.ExecQuery(query: query)
    }
    
    func UpdateMoney(type: JARS_TYPE, money: Double) -> Bool {
        let query = "UPDATE JARSManagement_\(DAOSuper.userID) SET money=\(money) WHERE type=\(type.rawValue);"
        return super.ExecQuery(query: query)
    }
    
    func UpdatePercent(type: JARS_TYPE, percent: Double) -> Bool {
        let query = "UPDATE JARSManagement_\(DAOSuper.userID) SET per=\(percent) WHERE type=\(type.rawValue);"
        return super.ExecQuery(query: query)
    }
    
    func Delete(type: JARS_TYPE) -> Bool {
        let query = "DELETE FROM JARSManagement_\(DAOSuper.userID) WHERE type=\(type.rawValue);"
        return super.ExecQuery(query: query)
    }
    
    // User's information (used when uid changed)
    func Move(to newUID: String) {
        let query = "ALTER TABLE JARSManagement_\(DAOSuper.userID) RENAME TO JARSManagement_\(newUID);"
        _ = super.ExecQuery(query: query)
    }
}
