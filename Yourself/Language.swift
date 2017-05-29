import UIKit

enum LangType: Int {
    case ENG = 0, VNI
}

enum Group: Int {
    case OPTIONS = 0, BUTTON, TITLE, TABLE_MENU, MESSAGE_TITLE, MESSAGE, PLACEHOLDER, REMINDING
}

class ViewEnum {
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func getRawValue() -> Int {
        return id
    }
}

class OptionViews: ViewEnum {
    public static let STATS_BUTTON = ListViews(id: 0)
    public static let SETTINGS_BUTTON = ListViews(id: 1)
}

class ListViews: ViewEnum {
    public static let EMPTY_LIST = ListViews(id: 0)
}

class ButtonViews: ViewEnum {
    public static let LOGIN_OFFLINE = ListViews(id: 0)
    public static let LOGIN_GOOGLE = ListViews(id: 1)
    public static let LOGIN_BUTTON = ListViews(id: 2)
    public static let BACK_BUTTON = ListViews(id: 3)
    public static let PHOTO_LIB_BUTTON = ListViews(id: 4)
    public static let DONE = ListViews(id: 5)
}

class TitleViews: ViewEnum {
    public static let LOGIN_OFFLINE_TITLE = TitleViews(id: 0)
    public static let SPENDING_NOTE_TITLE = TitleViews(id: 1)
    public static let TIME_NOTE_TITLE = TitleViews(id: 2)
    public static let SETTINGS_TITLE = TitleViews(id: 3)
    public static let LANGUAGE_TITLE = TitleViews(id: 4)
    public static let DIFERENCE_SETTINGS_TITLE = TitleViews(id: 5)
}

class TableMenuViews: ViewEnum {
    public static let STATISTIC = TableMenuViews(id: 0)
    public static let SYNCHRONUS = TableMenuViews(id: 1)
    public static let SETTINGS = TableMenuViews(id: 2)
    public static let LOGOUT = TableMenuViews(id: 3)
}


class MessageTitle: ViewEnum {
    public static let NOTICE = MessageTitle(id: 0)
}

class Message: ViewEnum {
    public static let EMPTY_EMAIL = MessageTitle(id: 0)
    public static let INVALID_EMAIL = MessageTitle(id: 1)
}

class PlaceholderViews: ViewEnum {
    public static let GMAIL_LOGIN_OFFLINE = MessageTitle(id: 0)
}

class RemindingViews: ViewEnum {
    public static let LOGIN = MessageTitle(id: 0)
    public static let GMAIL_LOGIN_OFFLINE = MessageTitle(id: 1)
}

class Language {
    
    private static let TEXT: [[[String]]] = [
        [
            ["Statistics", "Settings"], // OPTIONS
            ["Login Offline" ,"Login by Google" ,"Login" ,"Back", "Photo library", "Done"], // BUTTON
            ["Login Offline", "Spending Notes", "Time Notes", "Settings", "Language", "More Settings"], // TITLE
            ["Statistics", "Synchrocus", "Settings", "Log out"], //TABLE_MENU
            ["Notice"], // MESSAGE_TITLE
            ["Email is not allowned empty!\nPlease try again!", "Your email is invalid!\nPlease check again!"], // MESSAGE
            ["Your google account(gmail)"], // PLACEHOLDER
            ["Application exclusively for you", "This email will be used when you sync your data to Cloud (If you needed it). So, you should enter the correct email you intend to use in this app (it should be gmail account)." ] // REMINDING
        ],
        [
            ["Thống kê", "Thiết lập"], // OPTIONS
            ["Đăng nhập OFFline", "Đăng nhập bằng Google" ,"Đăng nhập" ,"Quay lại", "Kho hình ảnh", "Xong"], // BUTTON
            ["Đăng nhập OFFLINE", "Ghi chú tài chính", "Ghi chú thời gian", "Cài đặt", "Ngôn ngữ", "Cài đặt khác"], // TITLE
            ["Thống kê", "Đồng bộ", "Cài đặt", "Đăng xuất"], //TABLE_MENU
            ["Thông báo", "Bàn ăn", "Khu vực", "Thức ăn", "Nước uống"], // MESSAGE_TITLE
            ["Email không được bỏ trống!\nVui lòng thử lại", "Email của bạn không tồn tại!\nVui lòng kiểm tra lại!"], //MESSAGE
            ["Tài khoản google(gmail) của bạn"], // PLACEHOLDER
            ["Ứng dụng dành riêng cho bạn", "Email này sẽ được dùng khi bạn đồng bộ dữ liệu lên Cloud (nếu bạn cần). Do đó, bạn nên nhập đúng email mà bạn dự định dùng trong ứng dụng này (Nên dùng tài khoản gmail)."  ] // REMINDING
        ]
    ]
    
    private var type: LangType?
    
    var isLanguageChanged: Bool = false
    
    var Lang: LangType {
        get {
            return type!
        }
        set {
            if newValue != type {
                isLanguageChanged = true
                UserDefaults.standard.set(newValue.rawValue, forKey: "LANGUAGE")
                type = newValue
            }
        }
    }
    
    static let BUILDER = Language()
    
    private init() {
        if let rawValue = UserDefaults.standard.value(forKey: "LANGUAGE") {
            type = LangType(rawValue: rawValue as! Int)
        } else {
            UserDefaults.standard.set(LangType.VNI.rawValue, forKey: "LANGUAGE")
            type = LangType.VNI
        }
    }
    
    func get(group: Group, view: ViewEnum) -> String {
        return Language.TEXT[(type?.rawValue)!][group.rawValue][view.getRawValue()]
    }
    
}
