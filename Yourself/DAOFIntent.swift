import Firebase

class DAOFIntent: DAOFSuper {
    static let BUIDER = DAOFIntent(connectedDAO: DAOIntent.BUILDER)
    
    // Update or insert an Intent object to Firebase
    override func UpdateOrInsert(_ record: Any) {
        let intent = record as! DTOIntent
        let ref = super.GetRef().child("\(intent.timestamp)_\(intent.type.rawValue)")
        
        ref.child("type").setValue(intent.type.rawValue)
        ref.child("content").setValue(intent.content)
        ref.child("money").setValue(intent.money)
        ref.child("state").setValue(intent.state.rawValue)
        
        super.SetTimestamp(timestamp: Date().ticks)
    }
    
    // This method will be used by super class when we get any record from Firebase
    override func ParseValues(_ values: NSDictionary, with id: String) -> Any? {
        let components = id.components(separatedBy: "_")
        return DTOIntent (
            timestamp: Int64(components[0])!,
            type: JARS_TYPE(rawValue: values["type"] as! String)!,
            content: values["content"] as! String,
            money: values["money"] as! Double,
            state: INTENT_STATE(rawValue: values["state"] as! Int)!
        )
    }
}
