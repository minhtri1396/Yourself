import Firebase

class DAOFAlternatives: DAOFSuper {
    static let BUIDER = DAOFAlternatives(connectedDAO: DAOAlternatives.BUILDER)
    
    // Update or insert an Alternatives object to Firebase
    override func UpdateOrInsert(_ record: Any) {
        let alternatives = record as! DTOAlternatives
        let ref = super.GetRef().child("\(alternatives.timestamp)_\(alternatives.owner.rawValue)_\(alternatives.alts.rawValue)")
        
        ref.child("owner").setValue(alternatives.owner.rawValue)
        ref.child("alts").setValue(alternatives.alts.rawValue)
        ref.child("money").setValue(alternatives.money)
        
        super.SetTimestamp(timestamp: Date().ticks)
    }
    
    // This method will be used by super class when we get any record from Firebase
    override func ParseValues(_ values: NSDictionary, with id: String) -> Any? {
        let components = id.components(separatedBy: "_")
        return DTOAlternatives (
            timestamp: Int64(components[0])!,
            owner: JARS_TYPE(rawValue: values["owner"] as! String)!,
            alts: JARS_TYPE(rawValue: values["alts"] as! String)!,
            money: values["money"] as! Double
        )
    }
}
