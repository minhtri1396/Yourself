import Firebase

class DAOFIntent: DAOFSuper {
    static let BUIDER = DAOFIntent(connectedDAO: DAOIntent.BUILDER)
    
    // Update or insert an Intent object to Firebase
    override func UpdateOrInsert(_ record: Any) {
        let intent = record as! DTOIntent
        let ref = super.GetRef().child("\(intent.timestamp)")
        
        ref.child("type").setValue(intent.type.rawValue)
        ref.child("content").setValue(intent.content)
        ref.child("money").setValue(intent.money)
        
        super.SetTimestamp(timestamp: Date().ticks)
    }
    
    // This method will be used by super class when we get any record from Firebase
    override func ParseValues(_ values: NSDictionary, with id: String) -> Any? {
        return DTOIntent (
            timestamp: Int64(id)!,
            type: JARS_TYPE(rawValue: values["type"] as! String)!,
            content: values["content"] as! String,
            money: values["money"] as! Double
        )
    }
}
