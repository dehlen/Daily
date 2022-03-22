import AppKit

class CaptureWindowController: NSWindowController {
    static let shared = CaptureWindowController(windowNibName: String(describing: CaptureWindowController.self))

    @IBOutlet weak var summaryTextField: NSTextField!
    @IBOutlet weak var detailsTextView: NSTextView!

    override func windowDidLoad() {
        super.windowDidLoad()

        detailsTextView.font = NSFont.systemFont(ofSize: 16)
        detailsTextView.textContainerInset = NSSize(width: 10, height: 10)
    }

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        restoreDefaults()
    }

    private func restoreDefaults() {
        summaryTextField.stringValue = ""
        detailsTextView.string = ""
        focusSummaryTextField(nil)
    }

    @IBAction func focusSummaryTextField(_ sender: AnyObject?) {
        window?.makeFirstResponder(summaryTextField)
    }

    @IBAction func saveButtonClicked(_ sender: AnyObject?) {
        window?.close()
        NSApp.hide(nil)

        let settings = LogStore.Settings(
            summary: summaryTextField.stringValue,
            details: detailsTextView.string
        )

        // Delay to the next run loop so the window closes before screenshots are taken.
        DispatchQueue.main.async {
            LogStore.shared.capture(settings: settings)
        }
    }

    @IBAction func cancelButtonClicked(_ sender: AnyObject?) {
        window?.close()
        NSApp.hide(nil)
    }
}
