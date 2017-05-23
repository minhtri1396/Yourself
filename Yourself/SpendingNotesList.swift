import UIKit

// http://ashishkakkad.com/2015/09/create-your-own-slider-menu drawer-in-swift/
class SpedingNotesList: UIViewController {
    // MARK: *** Local variables
    
    // MARK: *** Data model
    
    // MARK: *** UI events
    @IBAction func StatsButton_Tapped(_ sender: AnyObject) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let spendingStatistics = storyBoard.instantiateViewController(withIdentifier: "SpendingStatistics")
        self.present(spendingStatistics, animated: true, completion: nil)
    }
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DAOFTime.BUIDER.GetAll() {
            times in
            if let times = times as? [DTOTime] {
                for time in times {
                    print("DMT id: \(time.id)\n")
                    print("DMT content: \(time.content)\n")
                    print("DMT startTime: \(time.startTime)\n")
                    print("DMT appointment: \(time.appointment)\n")
                    print("DMT finishTime: \(time.finishTime)\n")
                    print("DMT state: \(time.state)\n")
                    print("DMT tag: \(time.tag)\n\n")
                }
            }
        }
    }
    
}
