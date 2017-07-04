import Firebase

class DAOFTime: DAOFSuper {
    static let BUIDER = DAOFTime(connectedDAO: DAOTime.BUILDER)
    
    // Update or insert an Time object to Firebase
    // We cast Int64 to Double cause Firebase will be crashed when we try writting a Int64 value
    override func UpdateOrInsert(_ record: Any) {
        let time = record as! DTOTime
        let ref = super.GetRef().child("\(time.id)")
        
        ref.child("content").setValue(time.content)
        ref.child("startTime").setValue(Double(time.startTime))
        ref.child("appointment").setValue(Double(time.appointment))
        ref.child("finishTime").setValue(Double(time.finishTime))
        ref.child("state").setValue(time.state.rawValue)
        ref.child("tag").setValue(time.tag)
        
        super.SetTimestamp(timestamp: Date().ticks)
    }
    
    // This method will be used by super class when we get any record from Firebase
    override func ParseValues(_ values: NSDictionary, with id: String) -> Any? {
        return DTOTime (
            id: Int64(id)!,
            content: values["content"] as! String,
            startTime: Int64(values["startTime"] as! Double),
            appointment: Int64(values["appointment"] as! Double),
            finishTime: Int64(values["finishTime"] as! Double),
            state: TAG_STATE(rawValue: values["state"] as! Int)!,
            tag: values["tag"] as! Int
        )
    }
    
}
