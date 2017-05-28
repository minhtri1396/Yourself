class DAOUser: DAOSuper {
    static let BUILDER = DAOUser()
    
    func CreateTable() {
        super.CreateTable(query: "CREATE TABLE if not exists User(uid NVARCHAR(128) NOT NULL PRIMARY KEY, fid NVARCHAR(128), email NVARCHAR(128), verified INT);")
    }
    
    func Insert(userTuple: DTOUser) -> Bool {
        let query = "INSERT INTO User(uid, fid, email, verified) VALUES ('\(userTuple.uid)', '\(userTuple.fid)', '\(userTuple.email)', \(userTuple.verified ? 1 : 0));"
        return super.ExecQuery(query: query)
    }
    
    func IsEmailExisted(email: String) -> Bool {
        let query = "SELECT 1 FROM User WHERE email='\(email)'"
        let statement = super.PrepareQuery(query: query)
        
        if sqlite3_step(statement) == SQLITE_ROW {
            sqlite3_finalize(statement)
            return true
        }
        
        sqlite3_finalize(statement)
        return false
    }
    
    func IsUIDExisted(uid: String) -> Bool {
        let query = "SELECT 1 FROM User WHERE uid='\(uid)'"
        let statement = super.PrepareQuery(query: query)
        
        if sqlite3_step(statement) == SQLITE_ROW {
            sqlite3_finalize(statement)
            return true
        }
        
        sqlite3_finalize(statement)
        return false
    }
    
    // DAOUser won't use this method
    override func Get(withWhere: String, closure: (OpaquePointer) -> Any) -> Any? {
        return nil
    }
    
    // DAOUser won't use this method
    override func GetAll(parse: (OpaquePointer) -> Any) -> [Any] {
        return []
    }
    
    // DAOUser won't use this method
    override  func Update(withSet: String, withWhere: String) -> Bool {
        return false
    }
    
    // DAOUser won't use this method
    override func Delete(withWhere: String, id: String) -> Bool {
        return false
    }
    
    // DAOUser won't use this method
    override func DeleteAll() -> Bool {
        return false
    }
    
    func GetUser(by email: String) -> DTOUser? {
        let query = "SELECT * FROM User WHERE email='\(email)'"
        let statement = super.PrepareQuery(query: query)
        
        if sqlite3_step(statement) == SQLITE_ROW {
            let userTuple = DTOUser(
                uid: String(cString: sqlite3_column_text(statement, 0)),
                fid: String(cString: sqlite3_column_text(statement, 1)),
                email: String(cString: sqlite3_column_text(statement, 2)),
                verified: ((Int)(sqlite3_column_int(statement, 3))) == 1 ? true : false
            )
            
            sqlite3_finalize(statement)
            return userTuple
        }
        
        sqlite3_finalize(statement)
        return nil
    }
    
    // Update user ID in DB
    func UpdateUID(uid: String) -> Bool {
        let query = "UPDATE User SET uid='\(uid)' WHERE uid='\(DAOSuper.userID)';"
        return super.ExecQuery(query: query)
    }
    
    // Update firebase ID in DB
    func UpdateFID(fid: String) -> Bool {
        let query = "UPDATE User SET fid='\(fid)' WHERE uid='\(DAOSuper.userID)';"
        return super.ExecQuery(query: query)
    }
    
    func UpdateEmail(email: String) -> Bool {
        let query = "UPDATE User SET email='\(email)' WHERE uid='\(DAOSuper.userID)';"
        return super.ExecQuery(query: query)
    }
    
    func UpdateVerified(verified: Bool) -> Bool {
        let query = "UPDATE User SET verified=\(verified ? 1 : 0) WHERE uid='\(DAOSuper.userID)';"
        return super.ExecQuery(query: query)
    }
    
    func DeleteCurrentUser() {
        let tableNames = ["DAOJARSManagement_\(DAOSuper.userID)", "DAOIntent_\(DAOSuper.userID)", "DAOAlternatives_\(DAOSuper.userID)", "DAOTime_\(DAOSuper.userID)", "DAOCheerUp_\(DAOSuper.userID)", "DAOTimeStats_\(DAOSuper.userID)", "DAOTimestamp_\(DAOSuper.userID)", "DAOTrash_\(DAOSuper.userID)"]
        for tableName in tableNames {
            _ = super.ExecQuery(query: "DELETE TABLE \(tableName)")
        }
    }
    
    // User's information (used when uid changed)
    // Note: after invoking this method, remember change value of DAOSuper.userID to newUID manually
    override func Move(to newUID: String) {
        DAOJars.BUILDER.Move(to: newUID)
        DAOIntent.BUILDER.Move(to: newUID)
        DAOAlternatives.BUILDER.Move(to: newUID)
        DAOTime.BUILDER.Move(to: newUID)
        DAOCheerUp.BUILDER.Move(to: newUID)
        DAOTimeStats.BUILDER.Move(to: newUID)
        DAOTimestamp.BUILDER.Move(to: newUID)
        DAOTrash.BUILDER.Move(to: newUID)
    }
}
