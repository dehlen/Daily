import Cocoa
import MASShortcut
import Preferences

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private var isLaunching = true
    private let statusBarController = StatusBarController()
    
    private lazy var preferencesWindowController = PreferencesWindowController(
        preferencePanes: [
            GeneralPreferenceViewController(),
            CalendarPreferenceViewController()
        ]
    )

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarController.delegate = self
        UserDefaults.standard.addObserver(self, forKeyPath: kShowShortcut, options: NSKeyValueObservingOptions.init(), context: nil)
        shortcutsDidChange()

        // Always show the prefs window until we have picked a capture folder...
        if UserDefaults.standard.url(forKey: kCapturePath) == nil {
            showPrefs(nil)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == kShowShortcut {
            shortcutsDidChange()
        }
    }

    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
        guard !isLaunching else {
            isLaunching = false
            return false
        }

        showCaptureWindow()
        return false
    }

    @objc func shortcutsDidChange() {
        MASShortcutBinder.shared()?.breakBinding(withDefaultsKey: kShowShortcut)
        MASShortcutBinder.shared()?.bindShortcut(withDefaultsKey: kShowShortcut, toAction: { [weak self] in
            self?.handleHotkey()
        })
    }

    @IBAction func showPrefs(_ sender: AnyObject?) {
        preferencesWindowController.show()
    }

    @IBAction func newCapture(_ sender: AnyObject?) {
        showCaptureWindow()
    }
    
    @IBAction func openCaptureFolder(_ sender: AnyObject?) {
        if let url = LogStore.shared.currentFileURL?.deletingLastPathComponent() {
            NSWorkspace.shared.activateFileViewerSelecting([url])
        }
    }

    @IBAction func showStandupPanel(_ sender: AnyObject?) {
        StandupWindowController.shared.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func handleHotkey() {
        showCaptureWindow()
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func showCaptureWindow() {
        // Always show the prefs window until we have picked a capture folder...
        guard UserDefaults.standard.url(forKey: kCapturePath) != nil else {
            showPrefs(nil)
            return
        }

        CaptureWindowController.shared.showWindow(nil)
    }
}

extension AppDelegate: StatusBarControllerDelegate {
    func statusBarControllerDidSelectNewItem(_ statusBarController: StatusBarController) {
        self.showCaptureWindow()
    }
    
    func statusBarControllerDidSelectDailyStandup(_ statusBarController: StatusBarController) {
        self.showStandupPanel(nil)
    }
    
    func statusBarControllerDidSelectPreferences(_ statusBarController: StatusBarController) {
        self.showPrefs(nil)
    }
}
