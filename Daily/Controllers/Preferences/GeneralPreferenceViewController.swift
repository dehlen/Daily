import Cocoa
import MASShortcut
import Preferences

let kShowShortcut = "kShowShortcut"
let kCapturePath = "kCapturePath"

final class GeneralPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = Preferences.PaneIdentifier.general
    let preferencePaneTitle = "General"
    let toolbarItemIcon = NSImage(systemSymbolName: "gearshape", accessibilityDescription: "General preferences")!

    @IBOutlet weak var showShortcutKeyView: MASShortcutView!
    @IBOutlet weak var captureFolderPathControl: NSPathControl!
    
    override var nibName: NSNib.Name? { "GeneralPreferenceViewController" }

    override func viewDidLoad() {
        super.viewDidLoad()

        showShortcutKeyView.associatedUserDefaultsKey = kShowShortcut
        captureFolderPathControl.url = UserDefaults.standard.url(forKey: kCapturePath)
    }
    
    @IBAction func chooseCaptureFolder(_ sender: AnyObject?) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = true
        panel.runModal()
        if let url = panel.url {
            captureFolderPathControl.url = url
            UserDefaults.standard.set(url, forKey: kCapturePath)
        }
    }
}
