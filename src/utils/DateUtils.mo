import Array "mo:base/Array";
import Types "../types/Types";
import Int "mo:base/Int";

module DateUtils {

    /// Clone a date with validation
    public func cloneDate(date : Types.Date) : Types.Result<Types.Date> {

        if (not isValidDate(date.year, date.month, date.day)) {
            return #Err(#InvalidDate("Invalid date parameters"));
        };
        #Ok({
            year = date.year;
            month = date.month;
            day = date.day;
        });

    };

    /// Find minimum date from an array
    public func minDate(dates : [Types.Date]) : Types.Result<?Types.Date> {
        if (dates.size() == 0) return #Ok(null);
        let minDate = Array.foldLeft<Types.Date, Types.Date>(
            dates,
            dates[0],
            func(min : Types.Date, current : Types.Date) : Types.Date {
                if (compareDates(current, min) < 0) current else min;
            },
        );
        #Ok(?minDate);
    };

    /// Find maximum date from an array
    public func maxDate(dates : [Types.Date]) : Types.Result<?Types.Date> {
        if (dates.size() == 0) return #Ok(null);

        let maxDate = Array.foldLeft<Types.Date, Types.Date>(
            dates,
            dates[0],
            func(max : Types.Date, current : Types.Date) : Types.Date {
                if (compareDates(current, max) > 0) current else max;
            },
        );
        #Ok(?maxDate);

    };

    /// Check if a date falls on a weekend
    public func isWeekend(date : Types.Date) : Types.Result<?Bool> {

        if (not isValidDate(date.year, date.month, date.day)) {
            return #Err(#InvalidDate("Invalid date parameters"));
        };

        let weekday = getWeekday(date.year, date.month, date.day);
        switch (weekday) {
            case (?wd) #Ok(?(wd == 6 or wd == 7)); // 6 = Saturday, 7 = Sunday
            case (null) #Ok(null);
        };
    };

    /// Compare two dates (-1 if a < b, 0 if a == b, 1 if a > b)
    private func compareDates(a : Types.Date, b : Types.Date) : Int {
        if (a.year < b.year) return -1;
        if (a.year > b.year) return 1;
        if (a.month < b.month) return -1;
        if (a.month > b.month) return 1;
        if (a.day < b.day) return -1;
        if (a.day > b.day) return 1;
        0;
    };

    /// Get weekday number for a given date (1 = Monday, ..., 7 = Sunday)
    private func getWeekday(year : Int, month : Int, day : Int) : ?Int {
        if (not isValidDate(year, month, day)) return null;

        let adjustedMonth = if (month < 3) month + 12 else month;
        let adjustedYear = if (month < 3) year - 1 else year;
        let K = adjustedYear % 100;
        let J = adjustedYear / 100;
        let weekday = (day + (13 * (adjustedMonth + 1)) / 5 + K + (K / 4) + (J / 4) + (5 * J)) % 7;
        ?((weekday + 5) % 7 + 1);
    };

    /// Validate date parameters
    private func isValidDate(year : Int, month : Int, day : Int) : Bool {
        if (month < 1 or month > 12) return false;
        if (day < 1 or day > 31) return false;
        if (month == 2) {
            let isLeap = (year % 4 == 0 and year % 100 != 0) or year % 400 == 0;
            if (day > (if (isLeap) 29 else 28)) return false;
        };
        if ((month == 4 or month == 6 or month == 9 or month == 11) and day > 30) {
            return false;
        };
        true;
    };
};
