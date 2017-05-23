class DTOTimeStats {
    let timestamp: Int64 // primary key
    var totalCompletionTime: Int64
    var numberSuccessNotes: Int32
    var numberFailNotes: Int32
    var totalNumberNotes: Int32
    
    init(timestamp: Int64, totalCompletionTime: Int64, numberSuccessNotes: Int32, numberFailNotes: Int32, totalNumberNotes: Int32) {
        self.timestamp = timestamp
        self.totalCompletionTime = totalCompletionTime
        self.numberSuccessNotes = numberSuccessNotes
        self.numberFailNotes = numberFailNotes
        self.totalNumberNotes = totalNumberNotes
    }
}
