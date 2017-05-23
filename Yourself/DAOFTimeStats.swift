import Firebase

class DAOFTimeStats: DAOFSuper {
    static let BUIDER = DAOFTimeStats(connectedDAO: DAOTimeStats.BUILDER)
    
    // Update or insert an TimeStats object to Firebase
    // We cast Int64, Int32 to Double cause Firebase will be crashed when we try writting a Int64 or Int32 value
    func UpdateOrInsert(timeStats: DTOTimeStats) {
        let ref = super.GetRef().child("\(timeStats.timestamp)")
        
        ref.child("totalCompletionTime").setValue(Double(timeStats.totalCompletionTime))
        ref.child("numberSuccessNotes").setValue(Double(timeStats.numberSuccessNotes))
        ref.child("numberFailNotes").setValue(Double(timeStats.numberFailNotes))
        ref.child("totalNumberNotes").setValue(Double(timeStats.totalNumberNotes))
        
        super.SetTimestamp(timestamp: Date().ticks)
    }
    
    // This method will be used by super class when we get any record from Firebase
    override func ParseValues(_ values: NSDictionary, with id: String) -> Any? {
        return DTOTimeStats (
            timestamp: Int64(id)!,
            totalCompletionTime: Int64(values["totalCompletionTime"] as! Double),
            numberSuccessNotes: Int32(values["numberSuccessNotes"] as! Double),
            numberFailNotes: Int32(values["numberFailNotes"] as! Double),
            totalNumberNotes: Int32(values["totalNumberNotes"] as! Double)
        )
    }
    
}
