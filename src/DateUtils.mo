import Array "mo:base/Array";

module DateUtils {

    public type Date = (Int, Int, Int); // (year, month, day)

    /// Clone a date.
    public func cloneDate(year : Int, month : Int, day : Int) : async Date {
        return (year, month, day);
    };

    public func minDate(dates : [Date]) : async ?Date {
        if (dates.size() == 0) return null;
        return ?Array.foldLeft<Date, Date>(
            dates,
            dates[0],
            func(min : Date, current : Date) : Date {
                let compareDate = compareDates(current, min);
                if (compareDate < 0) current else min;
            },
        );
    };

    /// Get the latest date from a list.
    public func maxDate(dates : [Date]) : async ?Date {
        if (dates.size() == 0) return null;
        return ?Array.foldLeft<Date, Date>(
            dates,
            dates[0],
            func(max, current) {
                let compareDate = compareDates(current, max);
                if (compareDate > 0) current else max;
            },
        );
    };

    /// Check if a date falls on a weekend.
    public func isWeekend(year : Int, month : Int, day : Int) : async ?Bool {
        let weekday = await getWeekday(year, month, day);
        switch (weekday) {
            case (?wd) ?(wd == 6 or wd == 7); // 6 = Saturday, 7 = Sunday
            case (null) null;
        };
    };

    /// Compare two dates (-1 if a < b, 0 if a == b, 1 if a > b)
    private func compareDates(a : Date, b : Date) : Int {
        let (y1, m1, d1) = a;
        let (y2, m2, d2) = b;
        if (y1 < y2) -1 else if (y1 > y2) 1 else if (m1 < m2) -1 else if (m1 > m2) 1 else if (d1 < d2) -1 else if (d1 > d2) 1 else 0;
    };

    /// Get weekday number for a given date (1 = Monday, ..., 7 = Sunday)
    private func getWeekday(year : Int, month : Int, day : Int) : async ?Int {
        if (month < 1 or month > 12 or day < 1 or day > 31) return null;
        let adjustedMonth = if (month < 3) month + 12 else month;
        let adjustedYear = if (month < 3) year - 1 else year;
        let K = adjustedYear % 100;
        let J = adjustedYear / 100;
        let weekday = (day + (13 * (adjustedMonth + 1)) / 5 + K + (K / 4) + (J / 4) + (5 * J)) % 7;
        return ?((weekday + 5) % 7 + 1);
    };
};
