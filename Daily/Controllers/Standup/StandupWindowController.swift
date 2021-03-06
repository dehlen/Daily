import AppKit
import SwiftUI

class StandupWindowController: NSWindowController {
    static let shared = StandupWindowController(windowNibName: String(describing: StandupWindowController.self))

    @IBOutlet weak var containerView: NSView!
        
    override func windowDidLoad() {
        super.windowDidLoad()
        
        setup()
    }
    
    private func setup() {
        let standupView = StandupView()
            .environmentObject(CalendarStore.shared)
            .environmentObject(LogStore.shared)

        let hostingView = NSHostingView(rootView: standupView)
        containerView.addSubview(hostingView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            hostingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            hostingView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            hostingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ])
    }
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        NotificationCenter.default.post(name: .shouldUpdateStandupView, object: nil)
    }
}
