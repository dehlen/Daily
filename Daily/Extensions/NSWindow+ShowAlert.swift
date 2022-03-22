import Cocoa

func showAlert(message: String, style: NSAlert.Style = .warning) {
    let alert = NSAlert()
    alert.messageText = message
    alert.alertStyle = style
    alert.addButton(withTitle: "OK")
    _ = alert.runModal() == .alertFirstButtonReturn
}
