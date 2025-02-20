import Time "mo:base/Time";
import Int "mo:base/Int";
import Bool "mo:base/Bool";
import Types "../types/Types";

module DateCreation {
    private let SECONDS_IN_DAY : Int = 86400;
    private let EPOCH_YEAR : Int = 1970;

    // Get the current date and time (UTC)
    public func now() : async Types.DateResult {
        let timestamp = await system_time();
        return fromTimestamp(timestamp);
    };

    // Convert a Unix timestamp to a date
    public func fromTimestamp(timestamp : Int) : Types.DateResult {
        var days = timestamp / SECONDS_IN_DAY;
        var remainingSeconds = timestamp % SECONDS_IN_DAY;

        var year = EPOCH_YEAR;
        while (days >= (if (_isLeapYear(year)) { 366 } else { 365 })) {
            days -= if (_isLeapYear(year)) { 366 } else { 365 };
            year += 1;
        };

        let monthLengths = getMonthLengths(year);
        var month = 1;

        while (days >= monthLengths[month - 1]) {
            days -= monthLengths[month - 1];
            month += 1;
        };

        let components : Types.DateTimeComponents = {
            year = year;
            month = month;
            day = days + 1;
            hour = remainingSeconds / 3600;
            minute = (remainingSeconds % 3600) / 60;
            second = remainingSeconds % 60;
        };

        #Ok(components);
    };

    // Convert a date to a Unix timestamp
    public func toTimestamp(components : Types.DateTimeComponents) : Types.Result<Int> {

        var totalDays = 0;
        var y = EPOCH_YEAR;
        while (y < components.year) {
            totalDays += if (isLeapYear(y)) { 366 } else { 365 };
            y += 1;
        };

        let monthLengths = getMonthLengths(components.year);
        var m = 1;
        while (m < components.month) {
            totalDays += Int.abs(monthLengths[m - 1]);
            m += 1;
        };

        totalDays += Int.abs(components.day - 1);
        let timestamp = totalDays * SECONDS_IN_DAY + components.hour * 3600 + components.minute * 60 + components.second;

        #Ok(timestamp);

    };

    // Check if a year is a leap year
    public func isLeapYear(year : Int) : Bool {
        _isLeapYear(year);
    };

    // Internal synchronous helper for leap year calculation
    private func _isLeapYear(year : Int) : Bool {
        (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0);
    };

    // Check if a given date is valid
    public func isValidDate(date : Types.Date) : Types.Result<Bool> {

        if (date.month < 1 or date.month > 12 or date.day < 1) {
            return #Err(#InvalidDate("Invalid month or day range"));
        };

        let monthLengths = getMonthLengths(date.year);
        if (date.day <= monthLengths[Int.abs(date.month - 1)]) {
            #Ok(true);
        } else {
            #Err(#InvalidDate("Day exceeds month length"));
        };

    };

    // Helper function to get month lengths for a year
    private func getMonthLengths(year : Int) : [Int] {
        [
            31,
            if ((year % 4 == 0 and year % 100 != 0) or year % 400 == 0) { 29 } else {
                28;
            },
            31,
            30,
            31,
            30,
            31,
            31,
            30,
            31,
            30,
            31,
        ];
    };

    private func system_time() : async Int {
        Time.now() / 1_000_000_000;
    };
};
