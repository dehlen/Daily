import Cocoa
import Preferences
import SwiftUI

final class CalendarPreferenceViewController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = Preferences.PaneIdentifier.calendars
    let preferencePaneTitle = "Calendars"
    let toolbarItemIcon = NSImage(systemSymbolName: "calendar", accessibilityDescription: "Calendar preferences")!

    override var nibName: NSNib.Name? { "CalendarPreferenceViewController" }
    
    @IBOutlet private weak var calendarDisplayCheckBox: NSButton!
    @IBOutlet private weak var containerView: NSView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    private func setup() {
        let calendarPreferencesView = CalendarPreferencesView()
            .environmentObject(CalendarStore.shared)
        let hostingView = NSHostingView(rootView: calendarPreferencesView)
        containerView.addSubview(hostingView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            hostingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            hostingView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            hostingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ])
    }
}
