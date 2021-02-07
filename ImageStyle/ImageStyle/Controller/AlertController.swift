//
//  AlertController.swift


import Foundation

/// This is used to define the alert dialog type
enum AlertDialogType {
    case popup
    case confirm
}


/// This is an alert controller, which is used to manage all the global used alert pop up
class AlertController: ObservableObject {
    
    /// Used to indicate whether we need to show alert or not
    @Published var presentAlert: Bool = false
    
    public var type: AlertDialogType = .popup
    
    /// Alert Title
    public var title: String?
    
    /// Alert Message
    public var message = ""
    
    public var confirmButtonText = "Yes"
    public var cancelButtonText = "No"
    public var confirm:(() -> Void)?
    public var cancel:(() -> Void)?
    
    
    /// Alert Controller shared instance
    public static var shared: AlertController = {
        let mgr = AlertController()
        return mgr
    }()
    
    /// Present an alert globally with title and message
    public static func presentAlert(title: String?, message: String?){
        shared.title = title ?? ""
        shared.message = message ?? ""
        shared.type = .popup
        DispatchQueue.main.async {
            shared.presentAlert = true
        }
    }
    
    /// Present an confirm globally with title, message and callback button
    public static func presentConfirm(title: String?, message: String?, confirmButtonText: String? = nil,  confirm:(()->Void)? = nil, cancelButtonText: String? = nil, cancel:(()->Void)? = nil){
        shared.title = title ?? ""
        shared.message = message ?? ""
        shared.confirm = confirm
        shared.cancel = cancel
        shared.confirmButtonText = confirmButtonText ?? "Yes"
        shared.cancelButtonText = cancelButtonText ?? "No"
        shared.type = .confirm
        DispatchQueue.main.async {
            shared.presentAlert = true
        }
    }
}
