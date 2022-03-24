import EventKit
import SwiftUI

struct CalendarPreferencesView: View {
    @EnvironmentObject private var calendarStore: CalendarStore

    var body: some View {
        Group {
            switch calendarStore.authorizationStatus {
            case .authorized:
                CalendarListView()
            case .notDetermined:
                CalendarAccessScreen()
            case .denied, .restricted:
                CalendarDeniedAccessScreen()
            @unknown default:
                CalendarDeniedAccessScreen()
            }
        }
    }
}

struct CalendarListView: View {
    @EnvironmentObject private var calendarStore: CalendarStore
    @State private var calendarsBySource: [String: [EKCalendar]] = [:]
    @State private var showingAddAcountModal = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: self.loadCalendarList) {
                    let image = Image(nsImage: NSImage(named: NSImage.refreshTemplateName)!)
                    if #available(OSX 11.0, *) {
                        image.offset(x: 0.0, y: 2.0)
                    }
                }
            }
            VStack(alignment: .leading, spacing: 15) {
                Form {
                    Section {
                        List {
                            ForEach(Array(calendarsBySource.keys), id: \.self) { source in
                                Section(header: Text(source)) {
                                    ForEach(self.calendarsBySource[source]!, id: \.self) { calendar in
                                        CalendarRow(title: calendar.title, isSelected: calendarStore.isSelected(calendarID: calendar.calendarIdentifier), color: Color(calendar.color)) {
                                            if calendarStore.isSelected(calendarID: calendar.calendarIdentifier) {
                                                calendarStore.deselect(calendarID: calendar.calendarIdentifier)
                                            } else {
                                                calendarStore.select(calendarID: calendar.calendarIdentifier)
                                            }
                                        }
                                    }
                                }
                            }
                        }.listStyle(SidebarListStyle())
                    }
                }
            }.border(Color.gray)
            HStack {
                Text("Can't find the calendar you need?")
                Button("Add account") { self.showingAddAcountModal.toggle() }
                    .sheet(isPresented: $showingAddAcountModal) {
                        AddAccountModal()
                    }
                Spacer()
            }
        }
        .onAppear(perform: self.loadCalendarList)
        .padding()
        .frame(minHeight: 450)
    }
    
    func loadCalendarList() {
        calendarsBySource = calendarStore.all
    }
}

struct AddAccountModal: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                Text("To add external calendars:\n1. Open the default calendar app\n2. Click 'Add Account' in the menu\n3. Choose and connect your account")
            }
            Spacer()
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                }
            }
        }.padding().frame(width: 400, height: 200)
    }
}

struct CalendarRow: View {
    var title: String
    var isSelected: Bool
    var color: Color
    var action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: self.action) {
                Section {
                    if self.isSelected {
                        Image(nsImage: NSImage(named: NSImage.menuOnStateTemplateName)!)
                    } else {
                        Image(nsImage: NSImage(named: NSImage.addTemplateName)!)
                    }
                }.frame(width: 20, height: 17)
            }
            Circle().fill(self.color).frame(width: 8, height: 8)
            Text(self.title)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct CalendarAccessScreen: View {
    @EnvironmentObject private var calendarStore: CalendarStore
    @State private var isRequestingAccess = false

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            if isRequestingAccess {
                Text("Requesting access to calendars...")
                Text("")
                Text("Click \"OK\" in the macOS popup.")
            } else {
                Text("It looks like Daily does not have access to your calendars.")
                Button(action: self.requestAccess) {
                    Text("Request Access")
                }
            }
            Spacer()
        }
    }
    
    private func requestAccess() {
        self.isRequestingAccess = true
        calendarStore.requestAccess { granted, _ in
            self.isRequestingAccess = false
        }
    }
}

struct CalendarDeniedAccessScreen: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("It looks like Daily does not have access to your calendars.")
            Spacer()
            Text("Go to")
            Button("System Preferences", action: self.openSystemCalendarPreferences)
            Text("and select the checkbox near Daily.")
            Spacer()
        }
    }

    private func openSystemCalendarPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars")!
        NSWorkspace.shared.open(url)
    }
}
