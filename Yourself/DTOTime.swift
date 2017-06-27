enum TAG: Int {
    case FAMILY = 0, PERSONAL, FRIEND, STUDY, WORK, LOVE, RELAX, OTHERS
}

enum TAG_STATE: Int {
    case NOT_TIME = 0, NOT_YET, DOING, DONE
}

class DTOTime {
    let id: Int64 // primary key
    var content: String
    var startTime: Int64
    var appointment: Int64
    var finishTime: Int64
    var state: TAG_STATE
    var tag: TAG
    
    init (id: Int64, content: String, startTime: Int64, appointment: Int64, finishTime: Int64, state: TAG_STATE, tag: TAG) {
        self.id = id
        self.content = content
        self.startTime = startTime
        self.appointment = appointment
        self.finishTime = finishTime
        self.state = state
        self.tag = tag
    }
}
