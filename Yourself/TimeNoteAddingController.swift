import UIKit

class TimeNoteAddingController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    // MARK: *** Local variables
    
    // MARK: *** Data model
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var startTimeTextField: UITextField!
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
    
    // MARK: *** UI events
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tagTapped(sender: UITapGestureRecognizer) {
        if sender.view == familyTag {
            familyUntag.isHidden = false
        } else if sender.view == friendTag {
            friendUntag.isHidden = false
        } else if sender.view == personalTag {
            personalUntag.isHidden = false
        } else if sender.view == workTag {
            workUntag.isHidden = false
        } else if sender.view == relaxTag {
            relaxUntag.isHidden = false
        } else if sender.view == studyTag {
            studyUntag.isHidden = false
        } else if sender.view == loveTag {
            loveUntag.isHidden = false
        }
    }
    
    func untagTapped(sender: UITapGestureRecognizer) {
        if sender.view == familyUntag {
            familyUntag.isHidden = true
        } else if sender.view == friendUntag {
            friendUntag.isHidden = true
        } else if sender.view == personalUntag {
            personalUntag.isHidden = true
        } else if sender.view == workUntag {
            workUntag.isHidden = true
        } else if sender.view == relaxUntag {
            relaxUntag.isHidden = true
        } else if sender.view == studyUntag {
            studyUntag.isHidden = true
        } else if sender.view == loveUntag {
            loveUntag.isHidden = true
        }
    }
    
    // Format Date dd-MM-yyyy
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !(string == "") && Int(string) == nil {
            return false
        }
        
        // check the chars length dd -->2 at the same time calculate the dd-MM --> 5
        if (textField.text?.characters.count == 2) || (textField.text?.characters.count == 5) {
            //Handle backspace being pressed
            if !(string == "") {
                textField.text = (textField.text)! + "-" // append the text
            }
        }
        // check the condition not exceed 9 chars
        return !(textField.text!.characters.count > 9 && (string.characters.count ) > range.length)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Nhập nội dung ghi chú"
            textView.textColor = UIColor.lightGray
        }
    }
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startTimeTextField.delegate = self
        appointmentTimeTextField.delegate = self
        
        contentTextView.text = "Nhập nội dung ghi chú"
        contentTextView.textColor = UIColor.lightGray
        contentTextView.delegate = self
        
        // Set contentTextView's border
        let borderColor = UIColor(colorLiteralRed: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor
        self.contentTextView.layer.borderWidth = 1
        self.contentTextView.layer.borderColor = borderColor
        
        setGestureRecognizers()
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
    
}
