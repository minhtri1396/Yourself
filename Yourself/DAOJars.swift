class DAOJars: DAOSuper {
    static let BUILDER = DAOJars()
    
    override init() {
        super.init()
        super.isShouldSaveTimestamp = true
    }
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists \(self.GetName())_\(DAOSuper.userID) (type NVARCHAR(4) NOT NULL PRIMARY KEY, money DOUBLE, per DOUBLE);")
    }
    
    func GetJARS(with type: JARS_TYPE) -> DTOJars? {
        return super.Get(withWhere: "type='\(type.rawValue)'") {
            statement in
            let jars = DTOJars(
                type: JARS_TYPE(rawValue: String(cString: sqlite3_column_text(statement, 0)))!,
                money: (Double)(sqlite3_column_double(statement, 1))
            )
            jars.percent = (Double)(sqlite3_column_double(statement, 2))
            
            return jars
        } as! DTOJars?
    }
    
    func GetAll() -> [DTOJars] {
        let records = super.GetAll() {
            statement in
            let jars = DTOJars(
                type: JARS_TYPE(rawValue: String(cString: sqlite3_column_text(statement, 0)))!,
                money: (Double)(sqlite3_column_double(statement, 1))
            )
            jars.percent = (Double)(sqlite3_column_double(statement, 2))
            
            return jars
        }
        
        return records as! [DTOJars]
    }
    
    func Add(jars: DTOJars) -> Bool {
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
