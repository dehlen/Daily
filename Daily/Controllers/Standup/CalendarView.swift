import EventKit
import SwiftUI

struct CalendarView: View {
    @EnvironmentObject private var calendarStore: CalendarStore

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(calendarStore.todaysEvents, id: \.eventIdentifier) { event in
                CalendarEventRow(event: event)
            }
        }
    }
}

struct CalendarEventRow: View {
    let event: EKEvent
    
    var body: some View {
        if event.isAllDay {
            Text("All day")
                .bold()
            + Text(" ")
            + Text(event.title)
        } else {
            time
                .bold()
            + Text(" ")
            + Text(event.title)
        }
    }
    
    private var time: Text {
        Text(event.startDate, style: .time)
            + Text(" - ")
            + Text(event.endDate, style: .time)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(CalendarStore())
    }
}
