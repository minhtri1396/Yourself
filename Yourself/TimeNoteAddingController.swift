import UIKit

class TimeNoteAddingController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    // MARK: *** Local variables
    
    private var tagMasks: [Bool]!
    private var keyboard: Keyboard?
    private var isShow = 0
    private var isTextViewEmpty: Bool!
    private var timeNote: DTOTime?
    
    // MARK: *** Data model
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var appointmentDateTextField: UITextField!
    @IBOutlet weak var appointmentTimeTextField: UITextField!
    @IBOutlet weak var toLabel: UIView!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var familyTag: UIView!
    @IBOutlet weak var familyTagLabel: UILabel!
    @IBOutlet weak var familyUntag: UIView!
    
    @IBOutlet weak var friendTag: UIView!
    @IBOutlet weak var friendTagLabel: UILabel!
    @IBOutlet weak var friendUntag: UIView!
    
    @IBOutlet weak var personalTag: UIView!
    @IBOutlet weak var personalTagLabel: UILabel!
    @IBOutlet weak var personalUntag: UIView!
    
    @IBOutlet weak var workTag: UIView!
    @IBOutlet weak var workTagLabel: UILabel!
    @IBOutlet weak var workUntag: UIView!
    
    @IBOutlet weak var relaxTag: UIView!
    @IBOutlet weak var relaxTagLabel: UILabel!
    @IBOutlet weak var relaxUntag: UIView!
    
    @IBOutlet weak var studyTag: UIView!
    @IBOutlet weak var studyTagLabel: UILabel!
    @IBOutlet weak var studyUntag: UIView!
    
    @IBOutlet weak var loveTag: UIView!
    @IBOutlet weak var loveTagLabel: UILabel!
    @IBOutlet weak var loveUntag: UIView!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: *** UI events
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        if isFilledCompletely() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let startTime = dateFormatter.date(from: "\(startDateTextField.text!) \(startTimeTextField.text!)")!.ticks
            let appointmentTime = dateFormatter.date(from: "\(appointmentDateTextField.text!) \(appointmentTimeTextField.text!)")!.ticks
            
            var state: TAG_STATE
            let curTime = Date().ticks
            if curTime > appointmentTime {
                state = .NOT_YET
            } else if curTime < startTime {
                state = .NOT_TIME
            } else {
                state = .DOING
            }
            
            if let timeNote = timeNote {
                timeNote.content = contentTextView.text
                timeNote.startTime = startTime
                timeNote.appointment = appointmentTime
                timeNote.state = state
                timeNote.setTags(tags: self.getAllChosenTags())
                _ = DAOTime.BUILDER.Update(time: timeNote) // update on DB
            } else {
                let dtoTime = DTOTime(id: Date().ticks, content: contentTextView.text, startTime: startTime, appointment: appointmentTime, finishTime: 0, state: state)
                dtoTime.setTags(tags: self.getAllChosenTags())
                _ = DAOTime.BUILDER.Add(dtoTime) // save to DB
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tagTapped(sender: UITapGestureRecognizer) {
        if sender.view == familyTag {
            tagMasks[TAG.FAMILY.rawValue] = false
            familyUntag.isHidden = false
        } else if sender.view == friendTag {
            tagMasks[TAG.FRIEND.rawValue] = false
            friendUntag.isHidden = false
        } else if sender.view == personalTag {
            tagMasks[TAG.PERSONAL.rawValue] = false
            personalUntag.isHidden = false
        } else if sender.view == workTag {
            tagMasks[TAG.WORK.rawValue] = false
            workUntag.isHidden = false
        } else if sender.view == relaxTag {
            tagMasks[TAG.RELAX.rawValue] = false
            relaxUntag.isHidden = false
        } else if sender.view == studyTag {
            tagMasks[TAG.STUDY.rawValue] = false
            studyUntag.isHidden = false
        } else if sender.view == loveTag {
            tagMasks[TAG.LOVE.rawValue] = false
            loveUntag.isHidden = false
        }
    }
    
    func untagTapped(sender: UITapGestureRecognizer) {
        if sender.view == familyUntag {
            tagMasks[TAG.FAMILY.rawValue] = true
            familyUntag.isHidden = true
        } else if sender.view == friendUntag {
            tagMasks[TAG.FRIEND.rawValue] = true
            friendUntag.isHidden = true
        } else if sender.view == personalUntag {
            tagMasks[TAG.PERSONAL.rawValue] = true
            personalUntag.isHidden = true
        } else if sender.view == workUntag {
            tagMasks[TAG.WORK.rawValue] = true
            workUntag.isHidden = true
        } else if sender.view == relaxUntag {
            tagMasks[TAG.RELAX.rawValue] = true
            relaxUntag.isHidden = true
        } else if sender.view == studyUntag {
            tagMasks[TAG.STUDY.rawValue] = true
            studyUntag.isHidden = true
        } else if sender.view == loveUntag {
            tagMasks[TAG.LOVE.rawValue] = true
            loveUntag.isHidden = true
        }
    }
    
    // Format Date dd-MM-yyyy or hh:mm
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !(string == "") && Int(string) == nil {
            return false
        }
        
        if (textField == startDateTextField) || (textField == appointmentDateTextField) {
            // check the chars length dd -->2 at the same time calculate the dd-MM --> 5
            if (textField.text?.characters.count == 2) || (textField.text?.characters.count == 5) {
                //Handle backspace being pressed
                if !(string == "") {
                    textField.text = (textField.text)! + "-" // append the text
                }
            }
            // check the condition not exceed 9 chars
            return !(textField.text!.characters.count > 9 && (string.characters.count ) > range.length)
        } else {
            if (textField.text?.characters.count == 2) {
                if !(string == "") {
                    textField.text = (textField.text)! + ":" // append the text
                }
            }
            return !(textField.text!.characters.count > 4 && (string.characters.count ) > range.length)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        isTextViewEmpty = textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            isTextViewEmpty = true
            textView.text = Language.BUILDER.get(group: Group.PLACEHOLDER, view: PlaceholderViews.NOTE_CONTENT)
            textView.textColor = UIColor.lightGray
        } else {
            isTextViewEmpty = false
        }
    }
    
    /* Key board event */
    
    func keyboardWillShow(notification: Notification) {
        if let contentInset = keyboard?.catchEventOfKeyboard(isScroll: true, notification: notification) {
            if isShow == 0 {
                isShow = 1
                self.scrollView.setContentOffset(contentInset, animated: true)
            }
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        if let contentInset = keyboard?.catchEventOfKeyboard(isScroll: false, notification: notification) {
            isShow = 0
            self.scrollView.setContentOffset(contentInset, animated: true)
        }
    }
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.startDateTextField.delegate = self
        self.appointmentDateTextField.delegate = self
        self.startTimeTextField.delegate = self
        self.appointmentTimeTextField.delegate = self
        
        isTextViewEmpty = true
        
        self.contentTextView.text = Language.BUILDER.get(group: Group.PLACEHOLDER, view: PlaceholderViews.NOTE_CONTENT)
        self.contentTextView.textColor = UIColor.lightGray
        self.contentTextView.delegate = self
        
        // keyboard
        
        keyboard = Keyboard(arrTextField: [self.startTimeTextField, self.startDateTextField, self.appointmentTimeTextField, self.appointmentDateTextField], arrTextView: [self.contentTextView])
        keyboard?.createDoneButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        // Set contentTextView's border
        let borderColor = UIColor(colorLiteralRed: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        self.contentTextView.layer.borderWidth = 1
        self.contentTextView.layer.borderColor = borderColor
        
        setGestureRecognizers()
        tagMasks = [false, false, false, false, false, false, false]
        
        setContents() // if can, used for updating case
    }
    
    private func setGestureRecognizers() {
        self.familyTag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tagTapped(sender:))))
        self.familyUntag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(untagTapped(sender:))))
        self.familyTagLabel.text = getTagName(tag: .FAMILY)
        
        self.friendTag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tagTapped(sender:))))
        self.friendUntag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(untagTapped(sender:))))
        self.friendTagLabel.text = getTagName(tag: .FRIEND)
        
        self.personalTag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tagTapped(sender:))))
        self.personalUntag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(untagTapped(sender:))))
        self.personalTagLabel.text = getTagName(tag: .PERSONAL)
        
        self.workTag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tagTapped(sender:))))
        self.workUntag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(untagTapped(sender:))))
        self.workTagLabel.text = getTagName(tag: .WORK)
        
        self.relaxTag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tagTapped(sender:))))
        self.relaxUntag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(untagTapped(sender:))))
        self.relaxTagLabel.text = getTagName(tag: .RELAX)
        
        self.studyTag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tagTapped(sender:))))
        self.studyUntag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(untagTapped(sender:))))
        self.studyTagLabel.text = getTagName(tag: .STUDY)
        
        self.loveTag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tagTapped(sender:))))
        self.loveUntag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(untagTapped(sender:))))
        self.loveTagLabel.text = getTagName(tag: .LOVE)
    }
    
    private func getTagName(tag: TAG) -> String {
        var tagView: TimeTags
        switch tag {
        case .FAMILY:
            tagView = TimeTags.FAMILY
            break;
        case .PERSONAL:
            tagView = TimeTags.PERSONAL
            break;
        case .FRIEND:
            tagView = TimeTags.FRIEND
            break;
        case .STUDY:
            tagView = TimeTags.STUDY
            break;
        case .WORK:
            tagView = TimeTags.WORK
            break;
        case .LOVE:
            tagView = TimeTags.LOVE
            break;
        default:
            tagView = TimeTags.RELAX
        }
        
        return Language.BUILDER.get(group: .TIME_TAG, view: tagView)
    }
    
    private func getAllChosenTags() -> [TAG] {
        var tags = [TAG](), iTag = 0
        
        for tagMask in tagMasks {
            if tagMask {
                tags.append(TAG(rawValue: iTag)!)
            }
            iTag += 1
        }
        
        return tags
    }
    
    private func isFilledCompletely() -> Bool {
        if isTextViewEmpty == true {
            Alert.show(type: ALERT_TYPE.INFO, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.NOT_FILL_NOTE))
            return false
        }
        
        if (startDateTextField.text?.isEmpty)! {
            Alert.show(type: ALERT_TYPE.INFO, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.NOT_START_DAY))
            return false
        }
        
        if (startTimeTextField.text?.isEmpty)! {
            Alert.show(type: ALERT_TYPE.INFO, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.NOT_END_DAY))
            return false
        }
        
        if (appointmentDateTextField.text?.isEmpty)! {
            Alert.show(type: ALERT_TYPE.INFO, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.NOT_TIME_START))
            return false
        }
        
        if (appointmentTimeTextField.text?.isEmpty)! {
            Alert.show(type: ALERT_TYPE.INFO, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.NOT_TIME_END))
            return false
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        if let startDate = dateFormatter.date(from: startDateTextField.text! + " " + startTimeTextField.text!) {
            if let appointmentDate = dateFormatter.date(from: appointmentDateTextField.text! + " " + appointmentTimeTextField.text!) {
                if startDate.ticks > appointmentDate.ticks {
                    Alert.show(type: ALERT_TYPE.INFO, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.ERROR_DAY_ONE))
                    return false
                }
            } else {
                Alert.show(type: ALERT_TYPE.INFO, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.ERROR_DAY_TWO))
                return false
            }
        } else {
            Alert.show(type: ALERT_TYPE.INFO, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.ERROR_DAY_THREE))
            return false
        }
        
        for tagMask in tagMasks {
            if tagMask {
                return true
            }
        }
        
        Alert.show(type: ALERT_TYPE.INFO, title: Language.BUILDER.get(group: Group.MESSAGE_TITLE, view: MessageTitle.NOTICE), msg: Language.BUILDER.get(group: Group.MESSAGE, view: Message.NO_CHOOSE_TAG))
        return false
    }
    
    func setTimeNote(timeNote: DTOTime) {
        self.timeNote = timeNote
    }
    
    private func setContents() {
        if let timeNote = timeNote {
            let tags = timeNote.getAllTags()
            
            for tag in tags {
                if tag == TAG.FAMILY{
                    tagMasks[TAG.FAMILY.rawValue] = true
                    familyUntag.isHidden = true
                } else if tag == TAG.FRIEND {
                    tagMasks[TAG.FRIEND.rawValue] = true
                    friendUntag.isHidden = true
                } else if tag == TAG.PERSONAL {
                    tagMasks[TAG.PERSONAL.rawValue] = true
                    personalUntag.isHidden = true
                } else if tag == TAG.WORK {
                    tagMasks[TAG.WORK.rawValue] = true
                    workUntag.isHidden = true
                } else if tag == TAG.RELAX {
                    tagMasks[TAG.RELAX.rawValue] = true
                    relaxUntag.isHidden = true
                } else if tag == TAG.STUDY {
                    tagMasks[TAG.STUDY.rawValue] = true
                    studyUntag.isHidden = true
                } else if tag == TAG.LOVE {
                    tagMasks[TAG.LOVE.rawValue] = true
                    loveUntag.isHidden = true
                }
            }
            
            contentTextView.text = timeNote.content
            isTextViewEmpty = contentTextView.text.isEmpty
            if !isTextViewEmpty {
                contentTextView.textColor = UIColor.black
            }
            
            startDateTextField.text = Date.convertTimestampToDateString(timeStamp: timeNote.startTime/10, withFormat: "dd-MM-yyyy")
            startTimeTextField.text = Date.convertTimestampToDateString(timeStamp: timeNote.startTime/10, withFormat: "HH:mm")
            
            appointmentDateTextField.text = Date.convertTimestampToDateString(timeStamp: timeNote.appointment/10, withFormat: "dd-MM-yyyy")
            appointmentTimeTextField.text = Date.convertTimestampToDateString(timeStamp: timeNote.appointment/10, withFormat: "HH:mm")
            
        }
    }
    
}
