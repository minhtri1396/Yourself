enum TAG: Int {
    case FAMILY = 0, PERSONAL, FRIEND, STUDY, WORK, LOVE, RELAX
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
    var tag: Int
    
    init (id: Int64, content: String, startTime: Int64, appointment: Int64, finishTime: Int64, state: TAG_STATE, tag: Int) {
        self.id = id
        self.content = content
        self.startTime = startTime
        self.appointment = appointment
        self.finishTime = finishTime
        self.state = state
        self.tag = tag
    }
    
    convenience init (id: Int64, content: String, startTime: Int64, appointment: Int64, finishTime: Int64, state: TAG_STATE) {
        self.init(id: id, content: content, startTime: startTime, appointment: appointment, finishTime: finishTime, state: state, tag: 0)
    }
    
    func setTags(tags: [TAG]) {
        for t in tags {
            tag |= 1 << t.rawValue
        }
    }
    
    func getAllTags() -> [TAG] {
        var tags = [TAG]()
        
        var mask = 1
        for iTag in 0..<7 {
            if (tag & mask) == mask {
                tags.append(TAG(rawValue: iTag)!)
            }
            mask <<= 1
        }
        
        return tags
    }
}
