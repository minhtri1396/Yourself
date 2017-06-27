import Foundation

class DB {
    
    private static var mask: [Bool]!
    private static var isSycning = false
    private static var callback: ((Bool) -> Void)!
    
    static func Sync(closure: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            GAccount.Instance.Verify() {
                (email, result) in
                if !isSycning {
                    isSycning = true
                    callback = closure
                    if result {
                        DB.mask = [false, false, false, false, false, false];
                        DAOFJars.BUIDER.Sync(id: 0, closure: DoneSync)
                        DAOFIntent.BUIDER.Sync(id: 1, closure: DoneSync)
                        DAOFAlternatives.BUIDER.Sync(id: 2, closure: DoneSync)
                        DAOFTime.BUIDER.Sync(id: 3, closure: DoneSync)
                        DAOFCheerUp.BUIDER.Sync(id: 4, closure: DoneSync)
                        DAOFTimeStats.BUIDER.Sync(id: 5, closure: DoneSync)
                    } else {
                        closure(false)
                    }
                }
            }
        }
    }
    
    static func DoneSync(id: Int) {
        DB.mask[id] = true
        for m in DB.mask {
            if !m {
                return
            }
        }
        isSycning = false
        callback(true)
    }
    
    func GetName() -> String {
        let className = String(describing: self)
        let range: Range<String.Index> = className.range(of: ".")!
        return className.substring(from: range.upperBound)
    }
}
