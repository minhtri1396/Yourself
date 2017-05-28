import Foundation

class DAOSuper: DB {
    static var userID: String = ""
    static var userFID: String = ""// user's Firebase ID
    
    var isShouldSaveTimestamp = false
    private static var db: OpaquePointer?
    
    //***************** CONNECT TO DATABASE ***********************
    static func Connect(nameDB : String) {
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataPath = docURL.appendingPathComponent(nameDB).path
        
        if sqlite3_open(dataPath, &DAOSuper.db) == SQLITE_OK {
            print("1412573_1412591 -> DB path: \(dataPath)\n")
        } else {
            DAOSuper.db = nil
        }
    }
    
    static func IsConnected() -> Bool {
        return DAOSuper.db != nil
    }
    
    //********************* PREPARE QUERY **********************
    func PrepareQuery(query: String) -> OpaquePointer? {
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(DAOSuper.db!, query, -1, &statement, nil) == SQLITE_OK {
            print("1412573_1412591 -> DONE PREPARING\n")
            return statement!
        }
        
        let errmsg = String(cString: sqlite3_errmsg(DAOSuper.db!))
        print("1412573_1412591 -> ERROR PREPARING QUERY: \(errmsg)\n")
        sqlite3_finalize(statement)
        return nil
    }
    
    //********************* EXECUTE STATEMENT **********************
    private func ExecStatement(statement: inout OpaquePointer) -> Bool {
        if sqlite3_step(statement) == SQLITE_DONE {
            print("1412573_1412591 -> DONE EXECUTING\n")
            sqlite3_finalize(statement)
            return true
        }
        
        let errmsg = String(cString: sqlite3_errmsg(DAOSuper.db!))
        print("1412573_1412591 -> ERROR EXECUTING QUERY: \(errmsg)\n")
        sqlite3_finalize(statement)
        return false
    }
    
    //***************** CREATE TABLE ***********************
    func CreateTable(query: String) {
        print("1412573_1412591 -> EXECUTE CREATING QUERY: \(query)\n")
        if var statement = PrepareQuery(query: query) {
            _ = ExecStatement(statement: &statement)
        }
    }
    
    //**************** INSERT, UPDATE, DELETE ****************
    func ExecQuery(query: String) -> Bool {
        print("1412573_1412591 -> EXECUTE: \(query)\n")
        var statement = PrepareQuery(query: query)
        let result = (statement != nil) && ExecStatement(statement: &statement!)
        
        // Update timestamp when the table changed
        if result && self.isShouldSaveTimestamp {
            DAOTimestamp.BUILDER.UpdateOrInsert(timestamp: DTOTimestamp(
                id: self.GetName(),
                value: Date().ticks
            ))
        }
        
        return result
    }
    
    // Remember close DB when app finished
    func CloseDB() {
        if sqlite3_close(DAOSuper.db!) != SQLITE_OK {
            print("1412573_1412591 -> ERROR CLOSING DATABASE\n")
        }
    }
    
    func Get(withWhere: String, closure: (OpaquePointer) -> Any) -> Any? {
        let query = "SELECT * FROM \(self.GetName())_\(DAOSuper.userID) WHERE \(withWhere);"
        let statement = self.PrepareQuery(query: query)
        
        if sqlite3_step(statement) == SQLITE_ROW {
            return closure(statement!)
        }
        
        sqlite3_finalize(statement)
        return nil
    }
    
    func GetAll(parse: (OpaquePointer) -> Any) -> [Any] {
        let query = "SELECT * FROM \(self.GetName())_\(DAOSuper.userID)"
        let statement = self.PrepareQuery(query: query)
        
        var records = [Any]()
        while sqlite3_step(statement) == SQLITE_ROW {
            let record = parse(statement!)
            records.append(record)
        }
        
        sqlite3_finalize(statement)
        return records
    }
    
    func Update(withSet: String, withWhere: String) -> Bool {
        let query = "UPDATE \(self.GetName())_\(DAOSuper.userID) SET \(withSet) WHERE \(withWhere);"
        return self.ExecQuery(query: query)
    }
    
    func Delete(withWhere: String, id: String) -> Bool {
        let query = "DELETE FROM \(self.GetName())_\(DAOSuper.userID) WHERE \(withWhere);"
        let result = self.ExecQuery(query: query)
        if result {
            _ = DAOTrash.BUILDER.Insert(tableName: self.GetName(), recordID: "\(id)")
        }
        
        return result
    }
    
    func DeleteAll() -> Bool {
        let query = "DELETE FROM \(self.GetName())_\(DAOSuper.userID);"
        return self.ExecQuery(query: query)
    }
    
    // User's information (used when uid changed)
    func Move(to newUID: String) {
        let query = "ALTER TABLE \(self.GetName())_\(DAOSuper.userID) RENAME TO \(self.GetName())_\(newUID);"
        _ = self.ExecQuery(query: query)
    }
    
}
