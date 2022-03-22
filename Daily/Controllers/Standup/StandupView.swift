import SwiftUI
import MarkdownUI

struct StandupView: View {
    @EnvironmentObject private var calendarStore: CalendarStore
    @EnvironmentObject private var logStore: LogStore
    @AppStorage("displayCalendarEvents") private var displayCalendarEvents = false

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd EEEE"
        return formatter
    }()
    
    var body: some View {
        VStack {
            if displayCalendarEvents, calendarStore.authorizationStatus == .authorized {
                CalendarView()
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.thickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            Spacer()
            ScrollView(.vertical) {
                Spacer().frame(height: 40)
                Text("\(Date().previousWorkDay, formatter: Self.dateFormatter)")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                if let previousWorkdayLogsDocument = try? Document(markdown: logStore.previousWorkdayLogs ?? "No entries") {
                    Markdown(previousWorkdayLogsDocument)
                        .markdownStyle(markdownStyle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text(logStore.previousWorkdayLogs ?? "No entries")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer().frame(height: 40)
                Text("Today")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                if let todaysLogsDocument = try? Document(markdown: logStore.todaysLogs ?? "No entries") {
                    Markdown(todaysLogsDocument)
                        .markdownStyle(markdownStyle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text(logStore.todaysLogs ?? "No entries")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            Spacer()
        }
        .padding()
        .frame(minWidth: 400, minHeight: 533)
    }
    
    var markdownStyle: MarkdownStyle {
        MarkdownStyle(
            font: .body,
            foregroundColor: .primary,
            measurements: .init(
                headingScales: .init(
                    h1: 1,
                    h2: 0.83,
                    h3: 0.67,
                    h4: 0.5,
                    h5: 0.4,
                    h6: 0.33
                )
            )
        )
    }
}

struct StandupView_Previews: PreviewProvider {
    static var previews: some View {
        StandupView()
            .environmentObject(CalendarStore())
            .environmentObject(LogStore.shared)
    }
}
