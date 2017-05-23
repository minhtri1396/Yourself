class Timestamp {
    let id: String
    var value: Int64
    
    convenience init(id: String) {
        self.init(id: id, value: 0)
    }
    
    init(id: String, value: Int64) {
        self.id = id
        self.value = value
    }
}
