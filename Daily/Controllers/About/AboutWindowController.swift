import Cocoa

class AboutWindowController: NSWindowController {
    @IBOutlet var versionLabel: NSTextField!
    @IBOutlet var appIconImageView: NSImageView!
    
    struct Constants {
        static let contactMail = "dehlen@me.com"
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        versionLabel.stringValue = "v\(Bundle.versionString)"
        appIconImageView.image = NSApp.applicationIconImage
    }

    @IBAction func supportPressed(_ sender: Any) {
        guard let sharingService = contactSupportService else {
            showAlert(message: "No email account configured. Please send a mail to \(Constants.contactMail).")
            return
        }
        
        sharingService.perform(withItems: [])
    }

    private var contactSupportService: NSSharingService? {
        let versionString = Bundle.versionString
        let sharingService = NSSharingService(named: .composeEmail)
        sharingService?.recipients = [Constants.contactMail]
        sharingService?.subject = "\(Bundle.appName) v\(versionString) Feedback"
        return sharingService
    }
}
