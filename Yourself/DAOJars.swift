class DAOJars: DAOSuper {
    static let BUILDER = DAOJars()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists \(self.GetName())_\(DAOSuper.userID) (type NVARCHAR(4) NOT NULL PRIMARY KEY, money DOUBLE, per DOUBLE);")
    }
    
    func GetJARS(with type: JARS_TYPE) -> DTOJars {
        let jar = super.Get(withWhere: "type='\(type.rawValue)'")
        if jar == nil {
            return DTOJars(type: type, money: 0)
        }
        
        return jar as! DTOJars
    }
    
    // This method will be used by super class when we get any record from DB
    override func ParseStatement(_ statement: OpaquePointer) -> Any {
        let jars = DTOJars(
            type: JARS_TYPE(rawValue: String(cString: sqlite3_column_text(statement, 0)))!,
            money: (Double)(sqlite3_column_double(statement, 1))
        )
        jars.percent = (Double)(sqlite3_column_double(statement, 2))
        
        return jars
    }
    
    override func Add(_ value: Any) -> Bool {
        let jars = value as! DTOJars
        let query = "INSERT INTO \(self.GetName())_\(DAOSuper.userID) (type, money, per) VALUES ('\(jars.type.rawValue)', \(jars.money), \(jars.percent));"
        
        return super.ExecQuery(query: query)
    }
    
    func UpdateMoney(type: JARS_TYPE, money: Double) -> Bool {
        return super.Update(withSet: "money=\(money)", withWhere: "type='\(type.rawValue)'")
    }
    
    func UpdatePercent(type: JARS_TYPE, percent: Double) -> Bool {
        return super.Update(withSet: "per=\(percent)", withWhere: "type='\(type.rawValue)'")
    }
    
    func Delete(type: JARS_TYPE) -> Bool {
        return super.Delete(withWhere: "type='\(type.rawValue)'", id: "'\(type.rawValue)'")
    }
}
