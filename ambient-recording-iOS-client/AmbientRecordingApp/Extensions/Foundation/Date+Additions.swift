import Foundation

extension Date {

    /// example: `2024-02-04T20:00:00+0000`
    static func fromISODate(_ isoDate: String?) -> Self? {
        guard let isoDate else {
            return nil
        }
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: isoDate)
        return date
    }

    func round(precision: TimeInterval) -> Date {
        return round(precision: precision, rule: .toNearestOrAwayFromZero)
    }

    func ceil(precision: TimeInterval) -> Date {
        return round(precision: precision, rule: .up)
    }

    func floor(precision: TimeInterval) -> Date {
        return round(precision: precision, rule: .down)
    }

    // Round date with precision and rule
    func round(precision: TimeInterval, rule: FloatingPointRoundingRule) -> Date {
        guard precision > 0  else {
            return self
        }

        let seconds = (self.timeIntervalSinceReferenceDate / precision)
            .rounded(rule) *  precision;
        return Date(timeIntervalSinceReferenceDate: seconds)
    }
}
