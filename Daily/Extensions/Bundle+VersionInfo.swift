import Foundation

extension Bundle {
    static var versionString: String {
        var version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
        version += " (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""))"
        return version
    }
}
