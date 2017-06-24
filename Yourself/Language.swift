import UIKit

enum LangType: Int {
    case ENG = 0, VNI
}

class LangTitles: ViewEnum {
    public static let ENG = LangTitles(id: 0)
    public static let VNI = LangTitles(id: 1)
}

enum Group: Int {
    case OPTIONS = 0, BUTTON, TITLE, TABLE_MENU, MESSAGE_TITLE, MESSAGE, PLACEHOLDER, REMINDING, LANGUAGE
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
    
    /* Choose box to swap money */
    
    public static let NEC = MessageTitle(id: 6)
    public static let FRA = MessageTitle(id: 7)
    public static let LTS = MessageTitle(id: 8)
    public static let EDU = MessageTitle(id: 9)
    public static let PLAY = MessageTitle(id: 10)
    public static let GIVE = MessageTitle(id: 11)
    
    public static let DEFAULT = MessageTitle(id: 12)
}

class TitleViews: ViewEnum {
    public static let LOGIN_OFFLINE_TITLE = TitleViews(id: 0)
    public static let SPENDING_NOTE_TITLE = TitleViews(id: 1)
    public static let TIME_NOTE_TITLE = TitleViews(id: 2)
    public static let SETTINGS_TITLE = TitleViews(id: 3)
    public static let ADD_SPENDING_NOTE_TITLE = TitleViews(id: 4)
    public static let MONEY_ADDING_TITLE = TitleViews(id: 5)
}

class TableMenuViews: ViewEnum {
    public static let MONEY_ADDING = TableMenuViews(id: 0)
    public static let STATISTIC = TableMenuViews(id: 1)
    public static let SYNCHRONUS = TableMenuViews(id: 2)
    public static let SETTINGS = TableMenuViews(id: 3)
    public static let LOGOUT = TableMenuViews(id: 4)
}


class MessageTitle: ViewEnum {
    public static let NOTICE = MessageTitle(id: 0)
    public static let WARNING_MONEY = MessageTitle(id: 1)
    public static let SWAP_MONEY = MessageTitle(id: 2)
}

class Message: ViewEnum {
    public static let EMPTY_EMAIL = MessageTitle(id: 0)
    public static let INVALID_EMAIL = MessageTitle(id: 1)
    public static let ALLBOX_NOMONEY = MessageTitle(id: 2)
    public static let BOXCHOOED_NOMONEY = MessageTitle(id: 3)
    public static let CHOOSEBOX_SWAPMONEY = MessageTitle(id: 4)
    
}

class PlaceholderViews: ViewEnum {
    public static let GMAIL_LOGIN_OFFLINE = MessageTitle(id: 0)
    public static let TYPE_MONEY = MessageTitle(id: 1)
    public static let TYPE_NOTE = MessageTitle(id: 2)
    public static let TYPE_MONEY_JARS = MessageTitle(id: 3)
}

class RemindingViews: ViewEnum {
    public static let LOGIN = MessageTitle(id: 0)
    public static let GMAIL_LOGIN_OFFLINE = MessageTitle(id: 1)
}

class Language {
    
    private static let TEXT: [[[String]]] = [
        [
            ["Statistics", "Settings"], // OPTIONS
            ["Login Offline" ,"Login by Google" ,"Login" ,"Back", "Photo library", "Done", "Necessities", "Financial Freedom Account", "Long Term Savings", "Education", "Play", "Give", "Default"], // BUTTON
            ["Login Offline", "Spending Notes", "Time Notes", "Settings", "Spending Note", "Add money"], // TITLE
            ["Add money", "Statistics", "Synchrocus", "Settings", "Log out"], //TABLE_MENU
            ["Notice", "Warning", "Swap money"], // MESSAGE_TITLE
            ["Email is not allowned empty!\nPlease try again!", "Your email is invalid!\nPlease check again!", "Your all box is no money", "Box which is choosed is no money", "Choose one box to swap money"], // MESSAGE
            ["Your google account(gmail)", "Type money which needs using", "Type note", "Type money to add to jar(s)"], // PLACEHOLDER
            ["Application exclusively for you", "This email will be used when you sync your data to Cloud (If you needed it). So, you should enter the correct email you intend to use in this app (it should be gmail account)." ], // REMINDING
            ["English", "Vietnamese"] // LANGUAGE
        ],
        [
            ["Thống kê", "Thiết lập"], // OPTIONS
            ["Đăng nhập OFFline", "Đăng nhập bằng Google" ,"Đăng nhập" ,"Quay lại", "Kho hình ảnh", "Xong", "Cần thiết", "Đầu tư", "Tiết kiệm dài hạn", "Giáo dục", "Giải trí", "Tiêu dùng", "Mặc định"], // BUTTON
            ["Đăng nhập OFFLINE", "Ghi chú tài chính", "Ghi chú thời gian", "Cài đặt", "Ghi chú tiền", "Thêm tiền"], // TITLE
            ["Thêm tiền", "Thống kê", "Đồng bộ", "Cài đặt", "Đăng xuất"], //TABLE_MENU
            ["Chú ý", "Cảnh báo", "Chuyển tiền"], // MESSAGE_TITLE
            ["Email không được bỏ trống!\nVui lòng thử lại", "Email của bạn không tồn tại!\nVui lòng kiểm tra lại!", "Tất cả các hũ hiện không có tiền", "Hũ bạn chọn hiện không có tiền", "Chọn 1 hủ để chuyển tiền sang"], //MESSAGE
            ["Tài khoản google(gmail) của bạn", "Nhập số tiền cần dùng", "Thêm ghi chú cho lần lấy tiền này", "Nhập tiền và chọn hủ"], // PLACEHOLDER
            ["Ứng dụng dành riêng cho bạn", "Email này sẽ được dùng khi bạn đồng bộ dữ liệu lên Cloud (nếu bạn cần). Do đó, bạn nên nhập đúng email mà bạn dự định dùng trong ứng dụng này (Nên dùng tài khoản gmail)."  ], // REMINDING
            ["Tiếng Anh", "Tiếng Việt"] // LANGUAGE
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
