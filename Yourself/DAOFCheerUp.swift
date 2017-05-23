import Firebase

class DAOFCheerUp: DAOFSuper {
    static let BUIDER = DAOFCheerUp(connectedDAO: DAOCheerUp.BUILDER)
    
    // Update or insert an CheerUp object to Firebase
    func UpdateOrInsert(cheerUp: DTOCheerUp) {
        let ref = super.GetRef().child("\(cheerUp.timestamp)")
        
        ref.child("content").setValue(cheerUp.content)
        
        super.SetTimestamp(timestamp: Date().ticks)
    }
    
    // This method will be used by super class when we get any record from Firebase
    override func ParseValues(_ values: NSDictionary, with id: String) -> Any? {
        return DTOCheerUp (
            timestamp: Int64(id)!,
            content: values["content"] as! String
        )
    }
}
