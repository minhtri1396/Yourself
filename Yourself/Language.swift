import UIKit

enum LangType: Int {
    case ENG = 0, VNI
}

class LangTitles: ViewEnum {
    public static let ENG = LangTitles(id: 0)
    public static let VNI = LangTitles(id: 1)
}

enum Group: Int {
    case OPTIONS = 0, BUTTON, TITLE, TABLE_MENU, MESSAGE_TITLE, MESSAGE, PLACEHOLDER, REMINDING, LANGUAGE, TIME_TAG
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
    public static let CANCEL = MessageTitle(id: 13)
}

class TitleViews: ViewEnum {
    public static let LOGIN_OFFLINE_TITLE = TitleViews(id: 0)
    public static let SPENDING_NOTE_TITLE = TitleViews(id: 1)
    public static let TIME_NOTE_TITLE = TitleViews(id: 2)
    public static let SETTINGS_TITLE = TitleViews(id: 3)
    public static let ADD_SPENDING_NOTE_TITLE = TitleViews(id: 4)
    public static let MONEY_ADDING_TITLE = TitleViews(id: 5)
    public static let REPLACE = TitleViews(id: 6)
    public static let STATS_DAY = TitleViews(id: 7)
    public static let STATS_MONTH = TitleViews(id: 8)
    public static let STATS_YEAR = TitleViews(id: 9)
    public static let MONEY_GIVING = TitleViews(id: 10)
    public static let MONEY_REPLACING = TitleViews(id: 11)
    public static let SPENDING_LIST = TitleViews(id: 12)
    public static let NOTES_LIST = TitleViews(id: 13)
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
    public static let CHOOSE_MONTH = MessageTitle(id: 3)
    public static let SO_SAD = MessageTitle(id: 4)
}

class Message: ViewEnum {
    public static let EMPTY_EMAIL = Message(id: 0)
    public static let INVALID_EMAIL = Message(id: 1)
    public static let ALLBOX_NOMONEY = Message(id: 2)
    public static let BOXCHOOED_NOMONEY = Message(id: 3)
    public static let CHOOSEBOX_SWAPMONEY = Message(id: 4)
    public static let GIVINGMONEY_EMPTY = Message(id: 5)
    public static let NOTEGIVINGMONEY_EMPTY = Message(id: 6)
    public static let CHOOSE_JAR = Message(id: 7)
    public static let SET_MONEY = Message(id: 8)
    public static let SYNC_SUCCESS = Message(id: 9)
    public static let SYNC_FAIL = Message(id: 10)
    public static let NOT_DONE = Message(id: 11)
    public static let NO_DATA_CHARTS = Message(id: 12)
    public static let MONTH_STATS = Message(id: 13)
    public static let GIVING_DETAIL = Message(id: 14)
    public static let NO_NOTE = Message(id: 15)
    public static let COUNT_DAY = Message(id: 16)
    public static let NOT_EXIST_DAY = Message(id: 17)
    public static let NOT_ENOUGH_MONEY = Message(id: 18)
    public static let NOT_CHOOSE_BOX = Message(id: 19)
    public static let NOT_ADD_DATE = Message(id: 20)
    public static let NOT_FILL_NOTE = Message(id: 21)
    public static let NOT_START_DAY = Message(id: 22)
    public static let OVERTIME_NOTE = Message(id: 23)
    public static let NOT_END_DAY = Message(id: 24)
    public static let NOT_TIME_START = Message(id: 25)
    public static let NOT_TIME_END = Message(id: 26)
    public static let ERROR_DAY_ONE = Message(id: 27)
    public static let ERROR_DAY_TWO = Message(id: 28)
    public static let ERROR_DAY_THREE = Message(id: 29)
    public static let NO_CHOOSE_TAG = Message(id: 30)
}

class PlaceholderViews: ViewEnum {
    public static let GMAIL_LOGIN_OFFLINE = PlaceholderViews(id: 0)
    public static let TYPE_MONEY = PlaceholderViews(id: 1)
    public static let TYPE_NOTE = PlaceholderViews(id: 2)
    public static let TYPE_MONEY_JARS = PlaceholderViews(id: 3)
    public static let DATE_USE_MONEY = PlaceholderViews(id: 4)
    public static let DATE_ON_MONTH = PlaceholderViews(id: 5)
    public static let INPUT_MONTH = PlaceholderViews(id: 6)
    public static let STR_DAY = PlaceholderViews(id: 7)
    public static let END_DAY = PlaceholderViews(id: 8)
    public static let NOTE_CONTENT = PlaceholderViews(id: 9)
}

class RemindingViews: ViewEnum {
    public static let LOGIN = RemindingViews(id: 0)
    public static let GMAIL_LOGIN_OFFLINE = RemindingViews(id: 1)
}

class TimeTags: ViewEnum {
    public static let FAMILY = TimeTags(id: TAG.FAMILY.rawValue)
    public static let PERSONAL = TimeTags(id: TAG.PERSONAL.rawValue)
    public static let FRIEND = TimeTags(id: TAG.FRIEND.rawValue)
    public static let STUDY = TimeTags(id: TAG.STUDY.rawValue)
    public static let WORK = TimeTags(id: TAG.WORK.rawValue)
    public static let LOVE = TimeTags(id: TAG.LOVE.rawValue)
    public static let RELAX = TimeTags(id: TAG.RELAX.rawValue)
}

class Language {
    
    private static let TEXT: [[[String]]] = [
        [
            ["Statistics", "Settings"], // OPTIONS
            ["Login Offline" ,"Login by Google" ,"Login" ,"Back", "Photo library", "Done", "Necessities", "Financial Freedom Account", "Long Term Savings", "Education", "Play", "Give", "Default", "Cancel"], // BUTTON
            ["Login Offline", "Money Notes", "Time Notes", "Settings", "Money Note", "Add money", "Box which is reaplaced is: ", "Day Statistic", "Month Statistic", "Year Statistic", "Money giving", "Money replacing", "EXPENSE LIST", "NOTES LIST"], // TITLE
            ["Add money", "Statistics", "Synchrocus", "Settings", "Log out"], //TABLE_MENU
            ["Notice", "Warning", "Swap money", "Choose month", "So sad"], // MESSAGE_TITLE
            ["Email is not allowned empty!\nPlease try again!", "Your email is invalid!\nPlease check again!", "Your all box is no money", "Box which is choosed is no money", "Choose one box to swap money", "Giving money is not allow to empty", "Note for giving money is not allow to empty", "You must choose jar(s) which you want to set money for!", "You must set money before continuing!", "Sync completed!", "Sync failed!", "You don't complete your job!!!", "No data available to darw chart", "Choose month to show statistic", "Giving money details", "No note", "Day of ", "is not exist", "Not enough money", "You should choose box", "You should add date using money", "You should fill note content", "You should define starting day", "This note is overtime", "You should define end day", "You should define starting time", "You should define end time", "End day don't be bigger than staring day", "End day is not invalid", "Starting day is not invalid", "You should choose tag"      ], // MESSAGE
            ["Your google account(gmail)", "Type money which needs using", "Type note", "Type money to add to jar(s)", "Date using money", "Input day on month", "Input month", "Starting day", "End day", "Input note content" ], // PLACEHOLDER
            ["Application exclusively for you", "This email will be used when you sync your data to Cloud (If you needed it). So, you should enter the correct email you intend to use in this app (it should be gmail account)." ], // REMINDING
            ["English", "Vietnamese"], // LANGUAGE
            ["Family", "Personal", "Friend", "Study", "Work", "Love", "Relax"] // TIME_TAG
        ],
        [
            ["Thống kê", "Thiết lập"], // OPTIONS
            ["Đăng nhập OFFline", "Đăng nhập bằng Google" ,"Đăng nhập" ,"Quay lại", "Kho hình ảnh", "Xong", "Cần thiết", "Đầu tư", "Tiết kiệm dài hạn", "Giáo dục", "Giải trí", "Tiêu dùng", "Mặc định", "Huỷ" ], // BUTTON
            ["Đăng nhập OFFLINE", "Ghi chú tài chính", "Ghi chú thời gian", "Cài đặt", "Ghi chú tiền", "Thêm tiền", "Hũ mượn tiền: ", "Theo ngày", "Theo tháng", "Theo năm", "Chi tiền", "Lấy tiền để thay thế", "DS ghi chú tiền", "Các ghi chú"   ], // TITLE
            ["Thêm tiền", "Thống kê", "Đồng bộ", "Cài đặt", "Đăng xuất"], //TABLE_MENU
            ["Chú ý", "Cảnh báo", "Chuyển tiền", "Chọn 1 tháng", "Chia buồn"], // MESSAGE_TITLE
            ["Email không được bỏ trống!\nVui lòng thử lại", "Email của bạn không tồn tại!\nVui lòng kiểm tra lại!", "Tất cả các hũ hiện không có tiền", "Hũ bạn chọn hiện không có tiền", "Bạn cần chọn 1 hủ để chuyển tiền sang", "Tiền chi không được rỗng", "Ghi chú chi tiền không được rỗng", "Bạn chưa chọn (các) hủ cần thêm tiền!", "Bạn chưa nhập số tiền cần thêm!","Đồng bộ thành công", "Đồng bộ thất bại", "Bạn chưa hoàn thành công việc đã chọn xong!!!", "Không có dữ liệu để vẽ biểu đồ", "Chọn 1 tháng để xem thống kê", "Chi tiết chi tiền", "Không có ghi chú" , "Ngày của tháng ", "ngày không tồn tại", "Không có hủ nao có đủ tiền", "Bạn nên chọn hu4 để lấy tiền", "Bạn nên thêm ngày sử dụng tiền", "Bạn cần điền nội dung ghi chú", "Bạn cần xác định ngày bắt đầu ghi chú", "Nội dung ghi chú này đã qua thời hạn thực hiện!", "Bạn cần xác định ngày kết thúc", "Bạn cần xác đinh thời điểm bắt đầu", "Bạn cần xác định thời điểm kết thúc", "Ngày kết thúc không được lớn hơn ngày bắt đầu", "Ngày két thúc không hợp lệ", "Ngày bắt đầu không hợp lệ", "Bạn phải chọn tag"        ], //MESSAGE
            ["Tài khoản google(gmail) của bạn", "Nhập số tiền cần dùng", "Thêm ghi chú cho lần lấy tiền này", "Nhập tiền và chọn hủ", "Ngày dùng tiền", "Nhập ngày trong tháng", "Nhập vào tháng", "Ngày bắt đầu", "Ngày kết thúc", "Nhập nội dung ghi chú" ], // PLACEHOLDER
            ["Ứng dụng dành riêng cho bạn", "Email này sẽ được dùng khi bạn đồng bộ dữ liệu lên Cloud (nếu bạn cần). Do đó, bạn nên nhập đúng email mà bạn dự định dùng trong ứng dụng này (Nên dùng tài khoản gmail)."  ], // REMINDING
            ["Tiếng Anh", "Tiếng Việt"], // LANGUAGE
            ["Gia đình", "Cá nhân", "Bạn bè", "Học tập", "Công việc", "Tình cảm", "Giải trí"] // TIME_TAG
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
