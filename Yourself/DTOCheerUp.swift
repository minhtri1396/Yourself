class DTOCheerUp {
    let timestamp: Int64 // primary key
    var content: String
    
    init(timestamp: Int64, content: String) {
        self.timestamp = timestamp
        self.content = content
    }
}
