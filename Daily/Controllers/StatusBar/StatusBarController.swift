import AppKit

protocol StatusBarControllerDelegate: AnyObject {
    func statusBarControllerDidSelectNewItem(_ statusBarController: StatusBarController)
    func statusBarControllerDidSelectDailyStandup(_ statusBarController: StatusBarController)
    func statusBarControllerDidSelectPreferences(_ statusBarController: StatusBarController)
    func statusBarControllerDidSelectAbout(_ statusBarController: StatusBarController)
}

final class StatusBarController: NSObject {
    private var statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var menuIsOpen = false

    weak var delegate: StatusBarControllerDelegate?
    
    private lazy var menu: NSMenu = {
        let menu = NSMenu()
        let newItem = NSMenuItem(title: "New Item...", action: #selector(createNewItem), keyEquivalent: "n")
        newItem.target = self
        menu.addItem(newItem)
        
        let showStandupItem = NSMenuItem(title: "Daily Standup...", action: #selector(showStandupPanel), keyEquivalent: "D")
        showStandupItem.target = self
        menu.addItem(showStandupItem)
        
        menu.addItem(.separator())
        
        let aboutItem = NSMenuItem(title: "About Daily", action: #selector(openAboutPanel), keyEquivalent: "")
        aboutItem.target = self
        menu.addItem(aboutItem)
        
        let preferencesItem = NSMenuItem(title: "Preferences...", action: #selector(openPreferences), keyEquivalent: ",")
        preferencesItem.target = self
        menu.addItem(preferencesItem)
        
        let quitItem = NSMenuItem(title: "Quit Daily", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        return menu
    }()

    override init() {
        super.init()
        statusItem.menu = menu
        statusItem.button?.image = NSImage(named: "StatusBarIconTemplate")!
        statusItem.button?.image?.isTemplate = true
        statusItem.button?.title = ""
    }
    
    deinit {
        NSStatusBar.system.removeStatusItem(statusItem)
    }

    @objc func createNewItem() {
        delegate?.statusBarControllerDidSelectNewItem(self)
    }
    
    @objc func showStandupPanel() {
        delegate?.statusBarControllerDidSelectDailyStandup(self)
    }
    
    @objc func openAboutPanel() {
        delegate?.statusBarControllerDidSelectAbout(self)
    }
    
    @objc func openPreferences() {
        delegate?.statusBarControllerDidSelectPreferences(self)
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
}
