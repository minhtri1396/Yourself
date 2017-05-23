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
    
    //********************* EXECUTE QUERY **********************
    func ExecStatement(statement: OpaquePointer) -> Bool {
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
        if let statement = PrepareQuery(query: query) {
            _ = ExecStatement(statement: statement)
        }
    }
    
    //**************** INSERT, UPDATE, DELETE ****************
    func ExecQuery(query: String) -> Bool {
        print("1412573_1412591 -> EXECUTE: \(query)\n")
        let statement = PrepareQuery(query: query)
        let result = (statement != nil) && ExecStatement(statement: statement!)
        
        // Update timestamp when the table changed
        if result && self.isShouldSaveTimestamp {
            DAOTimestamp.BUILDER.UpdateOrInsert(timestamp: Timestamp(
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
    
}
