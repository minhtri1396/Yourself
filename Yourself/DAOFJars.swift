import Firebase

class DAOFJars: DAOFSuper {
    static let BUIDER = DAOFJars(connectedDAO: DAOJars.BUILDER)
    
    // Update or insert an Jars object to Firebase
    func UpdateOrInsert(jars: DTOJars) {
        let ref = super.GetRef().child(jars.type.rawValue)
        
        ref.child("money").setValue(jars.money)
        ref.child("percent").setValue(jars.percent)
        
        super.SetTimestamp(timestamp: Date().ticks)
    }
    
    // This method will be used by super class when we get any record from Firebase
    override func ParseValues(_ values: NSDictionary, with id: String) -> Any? {
        let jars = DTOJars (
            type: JARS_TYPE(rawValue: id)!,
            money: values["money"] as! Double
        )
        jars.percent = values["percent"] as! Double
        
        return jars
    }
}
