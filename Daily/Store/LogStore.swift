import AppKit

final class LogStore: ObservableObject {
    static let shared = LogStore()
    
    @Published private(set) var todaysLogs: String?
    @Published private(set) var previousWorkdayLogs: String?

    struct Settings {
        var summary: String
        var details: String
    }
    
    var currentFileURL: URL? {
       fileURL(forDate: Date())
    }
    
    init() {
        load()
    }
    
    private func load() {
        self.todaysLogs = fetchLogs(date: Date())
        self.previousWorkdayLogs = fetchLogs(date: Date().previousWorkDay)
    }
    
    private func fileURL(forDate date: Date) -> URL? {
        guard let captureFolderURL = UserDefaults.standard.url(forKey: kCapturePath) else { return nil }

        let directoryDateFormatter = DateFormatter()
        directoryDateFormatter.dateFormat = "y/MM/"
        let dateDir = directoryDateFormatter.string(from: date)

        let dfFilename = DateFormatter()
        dfFilename.dateFormat = "y-MM-dd EEEE"
        let dateFilename = dfFilename.string(from: date)

        var url = captureFolderURL.appendingPathComponent(dateDir)

        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return nil
            }
        }

        url.appendPathComponent(dateFilename)
        url.appendPathExtension("md")
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try ("" as NSString).write(to: url, atomically: false, encoding: String.Encoding.utf8.rawValue)
            } catch {
                return nil
            }
        }

        return url
    }
    
    func fetchLogs(date: Date) -> String? {
        do {
            guard let fileURL = self.fileURL(forDate: date) else { return nil }
            let content = try String(contentsOf: fileURL)
            if content.isEmpty { return nil }
            return content
        } catch {
            debugPrint("Could not fetch logs due to error: \(error.localizedDescription)")
            return nil
        }
    }
}

extension LogStore {
    func capture(settings: Settings) {
        var output = makeHeader(summary: settings.summary, details: settings.details)

        output += "\n* * * * *\n\n"

        writeToFile(string: output)
        load()
    }

    private func makeHeader(summary: String, details: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let dateStr = dateFormatter.string(from: Date())

        let trimmedSummary = summary.trimmingCharacters(in: .whitespacesAndNewlines)

        var outStr = "# \(dateStr)\n"
        outStr += trimmedSummary + "\n"
        outStr += "----------\n"

        if details.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            outStr += details + "\n\n"
        }

        return outStr
    }

    private func writeToFile(string: String) {
        guard let fileURL = currentFileURL else { return }

        do {
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            try fileHandle.seekToEnd()
            if let data = string.data(using: .utf8) {
                fileHandle.write(data)
            }
            try fileHandle.close()
        } catch {
            debugPrint("Could not write to file due to error: \(error.localizedDescription)")
        }
    }
}
