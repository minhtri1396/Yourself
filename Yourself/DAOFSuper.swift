import Firebase

// We should verify account (gmail) before using this class
// This class was built for saving data on Firebase
class DAOFSuper: DB {
    static var firebase_ref: FIRDatabaseReference? {
        return FIRDatabase.database().reference()
    }
    
    let connectedDAO: DAOSuper // each DAOFirebase will be connected to a DAOOffline
    
    init(connectedDAO: DAOSuper) {
        self.connectedDAO = connectedDAO
    }
    
    func SetTimestamp(timestamp: Int64) {
        DAOFSuper.firebase_ref!
            .child("timestamps")
            .child(DAOSuper.userFID)
            .child(self.connectedDAO.GetName())
            .setValue(Double(timestamp)) // we cast timestamp to Double cause Firebase will be crashed when we try writting a Int64 value
    }
    
    func GetTimestamp(closure: @escaping (Timestamp) -> Void) {
        let daoName = self.connectedDAO.GetName()
        
        let timestampRef = DAOFSuper.firebase_ref!
            .child("timestamps")
            .child(DAOSuper.userFID)
            .child(daoName)
        
        timestampRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let timestamp = snapshot.value as? Int {
                closure(Timestamp(
                    id: daoName,
                    value: (Int64)(timestamp)
                ))
            } else {
                closure(Timestamp(
                    id: daoName,
                    value: 0
                ))
            }
        }) { (error) in
            print("1412573_1412591 -> ERROR GETTING TIMESTAMP OF \(daoName)\n")
            closure(Timestamp(
                id: daoName,
                value: 0
            ))
        }
    }
    
    // Get a specific Intent object
    // The Intent will be returned via a closure
    func Get(id: String, closure: @escaping (Any?) -> Void) {
        let ref = self.GetRef().child("\(id)")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let values = snapshot.value as? NSDictionary {
                closure(self.ParseValues(values, with: id))
            } else {
                closure(nil)
            }
        }) { (error) in
            print("1412573_1412591 -> ERROR GETTING DATA OF \(self.connectedDAO.GetName())\n")
            closure(nil)
        }
    }
    
    // Get all of Intent objects saved on Firebase
    // Return a list of Intent objects or nil (if it can't get anything)
    // The list of Intent objects will be returned via a closure
    func GetAll(closure: @escaping ([Any]?) -> Void) {
        let ref = self.GetRef()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let values = snapshot.value as? NSDictionary {
                var records = [Any]()
                
                for dict in values {
                    if let record = dict.value as? NSDictionary {
                        records.append(self.ParseValues(record, with: dict.key as! String))
                    }
                }
                
                closure(records)
            } else {
                closure(nil)
            }
        }) { (error) in
            print("1412573_1412591 -> ERROR GETTING ALL DATA OF DAOFIntent\n")
            closure(nil)
        }
    }
    
    // We use this method to get a reference to the user's directory on Firebase
    func GetRef() -> FIRDatabaseReference {
        return DAOFSuper.firebase_ref!
            .child("users")
            .child(DAOSuper.userFID)
            .child(self.connectedDAO.GetName())
    }
    
    // Every subclass should override this method
    // This method is necessary when we need to get any record from Firebase
    func ParseValues(_ values: NSDictionary, with id: String) -> Any? {
        return nil
    }
    
    func Remove(at name: String) {
        DAOFSuper.firebase_ref!
            .child("users")
            .child(DAOSuper.userFID)
            .child(self.connectedDAO.GetName())
            .child(name)
            .setValue(nil)
        
        self.SetTimestamp(timestamp: Date().ticks)
    }
    
    func RemoveAll() {
        DAOFSuper.firebase_ref!
            .child("users")
            .child(DAOSuper.userFID)
            .child(self.connectedDAO.GetName())
            .setValue(nil)
        
        self.SetTimestamp(timestamp: Date().ticks)
    }
}
