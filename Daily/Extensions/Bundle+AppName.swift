import Foundation

extension Bundle {
    static var appName: String {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "GitLab Status"
    }
}
