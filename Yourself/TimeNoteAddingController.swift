import UIKit

class TimeNoteAddingController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    // MARK: *** Local variables
    
    private var tagMasks: [Bool]!
    private var keyboard: Keyboard?
    private var isShow = 0
    private var isTextViewEmpty: Bool!
    
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
            dateFormatter.dateFormat = "dd-mm-yyyy"
            let startTime = dateFormatter.date(from: startDateTextField.text!)!.ticks
            let appointmentTime = dateFormatter.date(from: appointmentDateTextField.text!)!.ticks
            
            let dtoTime = DTOTime(id: Date().ticks, content: contentTextView.text, startTime: startTime, appointment: appointmentTime, finishTime: 0, state: TAG_STATE.NOT_TIME)
            dtoTime.setTags(tags: self.getAllChosenTags())
            
            _ = DAOTime.BUILDER.Add(dtoTime) // save to DB
            
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
            textView.text = "Nhập nội dung ghi chú"
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
        
        self.contentTextView.text = "Nhập nội dung ghi chú"
        self.contentTextView.textColor = UIColor.lightGray
        self.contentTextView.delegate = self
        
        // keyboard
        
        keyboard = Keyboard(arrTextField: [self.startTimeTextField, self.appointmentTimeTextField])
        keyboard?.createDoneButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        // Set contentTextView's border
        let borderColor = UIColor(colorLiteralRed: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        self.contentTextView.layer.borderWidth = 1
        self.contentTextView.layer.borderColor = borderColor
        
        setGestureRecognizers()
        
        tagMasks = [false, false, false, false, false, false, false]
    }
    
    private func setGestureRecognizers() {
        self.familyTag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tagTapped(sender:))))
        self.familyUntag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(untagTapped(sender:))))
        
        self.friendTag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tagTapped(sender:))))
        self.friendUntag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(untagTapped(sender:))))
        
        self.personalTag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tagTapped(sender:))))
        self.personalUntag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(untagTapped(sender:))))
        
        self.workTag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tagTapped(sender:))))
        self.workUntag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(untagTapped(sender:))))
        
        self.relaxTag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tagTapped(sender:))))
        self.relaxUntag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(untagTapped(sender:))))
        
        self.studyTag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tagTapped(sender:))))
        self.studyUntag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(untagTapped(sender:))))
        
        self.loveTag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tagTapped(sender:))))
        self.loveUntag.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(untagTapped(sender:))))
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
            Alert.show(type: ALERT_TYPE.INFO, title: "", msg: "Ban can dien noi dung ghi chu")
            return false
        }
        
        if (startDateTextField.text?.isEmpty)! {
            Alert.show(type: ALERT_TYPE.INFO, title: "", msg: "Ban can xac dinh ngay bat dau ghi chu")
            return false
        }
        
        if (startTimeTextField.text?.isEmpty)! {
            Alert.show(type: ALERT_TYPE.INFO, title: "", msg: "Ban can xac dinh thoi diem bat dau ghi chu")
            return false
        }
        
        if (appointmentDateTextField.text?.isEmpty)! {
            Alert.show(type: ALERT_TYPE.INFO, title: "", msg: "Ban can xac dinh ngay ket thuc ghi chu")
            return false
        }
        
        if (appointmentTimeTextField.text?.isEmpty)! {
            Alert.show(type: ALERT_TYPE.INFO, title: "", msg: "Ban can xac dinh thoi diem ket thuc ghi chu")
            return false
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        if let startDate = dateFormatter.date(from: startDateTextField.text! + " " + startTimeTextField.text!) {
            if let appointmentDate = dateFormatter.date(from: appointmentDateTextField.text! + " " + appointmentTimeTextField.text!) {
                if startDate.ticks > appointmentDate.ticks {
                    Alert.show(type: ALERT_TYPE.INFO, title: "", msg: "Ngay bat dau can phai truoc ngay ket thuc")
                    return false
                }
            } else {
                Alert.show(type: ALERT_TYPE.INFO, title: "", msg: "Ngay ket thuc khong hop le")
                return false
            }
        } else {
            Alert.show(type: ALERT_TYPE.INFO, title: "", msg: "Ngay bat dau khong hop le")
            return false
        }
        
        for tagMask in tagMasks {
            if tagMask {
                return true
            }
        }
        
        Alert.show(type: ALERT_TYPE.INFO, title: "", msg: "Ban can xac dinh (cac) tag cho ghi chu")
        return false
    }
    
}
