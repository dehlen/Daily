import AppKit
import EventKit

final class CalendarStore: NSObject, ObservableObject {
    let eventStore = EKEventStore()
    let defaults = UserDefaults.standard
    
    struct Key {
        static let selectedCalendardIDs = "selectedCalendardIDs"
    }
    
    @Published private(set) var selectedCalendardIDs: [String] = []
    
    var all: [String: [EKCalendar]] {
        let calendars = eventStore.calendars(for: .event)
        return Dictionary(grouping: calendars) { $0.source.title }
    }
    
    override init() {
        super.init()
        load()
    }
    
    func requestAccess(completion: @escaping EKEventStoreRequestAccessCompletionHandler) {
        eventStore.requestAccess(to: .event) { (accessGranted, error) in
            completion(accessGranted, error)
        }
    }
    
    var authorizationStatus: EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .event)
    }
    
    func isSelected(calendarID: String) -> Bool {
        return selectedCalendardIDs.contains(calendarID)
    }
    
    func select(calendarID: String) {
        self.selectedCalendardIDs.append(calendarID)
        save()
    }
    
    func deselect(calendarID: String) {
        self.selectedCalendardIDs.removeAll { $0 == calendarID }
        save()
    }
        
    func fetchEvents(date: Date) -> [EKEvent] {
        let dayMidnight = Calendar.current.startOfDay(for: date)
        let nextDayMidnight = Calendar.current.date(byAdding: .day, value: 1, to: dayMidnight)!

        let predicate = eventStore.predicateForEvents(withStart: dayMidnight, end: nextDayMidnight, calendars: currentlySelectedCalendars)
        return eventStore.events(matching: predicate).filter { Calendar.current.isDate($0.startDate, inSameDayAs: dayMidnight) }
    }
    
    private var currentlySelectedCalendars: [EKCalendar] {
        return eventStore
            .calendars(for: .event)
            .filter { calendar in
                selectedCalendardIDs.contains(calendar.calendarIdentifier)
            }
    }
    
    private func load() {
        self.selectedCalendardIDs = defaults.object(forKey: Key.selectedCalendardIDs) as? [String] ?? [String]()
    }
    
    private func save() {
        defaults.set(selectedCalendardIDs, forKey: Key.selectedCalendardIDs)
    }
}
