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
    
    // MARK: *** UI events
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
    }
    
}
