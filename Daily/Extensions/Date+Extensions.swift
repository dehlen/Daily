import Foundation

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    var previousWorkDay: Date {
        if !Calendar.current.isDateInWeekend(yesterday) { return yesterday }
        return yesterday.previousWorkDay
    }
}
