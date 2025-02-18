import Time "mo:base/Time";
import Int "mo:base/Int";
import Bool "mo:base/Bool";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
// import Array "mo:base/Array";
// import Error "mo:base/Error";
// import Debug "mo:base/Debug";
// import Iter "mo:base/Iter";

module DateCreationParsing {

    // Get the current date and time (UTC)
    public func now() : async (Int, Int, Int, Int, Int, Int) {
        let timestamp = await system_time();
        return await fromTimestamp(timestamp);
    };

    // Convert a Unix timestamp to a date
    public func fromTimestamp(timestamp : Int) : async (Int, Int, Int, Int, Int, Int) {
        let secondsInDay = 86400;
        var days = timestamp / secondsInDay;
        var remainingSeconds = timestamp % secondsInDay;

        var year = 1970;
        while (days >= (if (await isLeapYear(year)) { 366 } else { 365 })) {
            days -= if (await isLeapYear(year)) { 366 } else { 365 };
            year += 1;
        };

        let monthLengths = [
            31,
            if (await isLeapYear(year)) { 29 } else { 28 },
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

        var month = 1;
        while (days >= monthLengths[month - 1]) {
            days -= monthLengths[month - 1];
            month += 1;
        };

        let day = days + 1;
        let hour = remainingSeconds / 3600;
        let min = (remainingSeconds % 3600) / 60;
        let sec = remainingSeconds % 60;

        return (year, month, day, hour, min, sec);
    };

    // Convert a date to a Unix timestamp
    public func toTimestamp(year : Int, month : Int, day : Int, hour : Int, min : Int, sec : Int) : async Int {
        var totalDays = 0;
        var y = 1970;
        while (y < year) {
            totalDays += if (await isLeapYear(y)) { 366 } else { 365 };
            y += 1;
        };

        let monthLengths = [
            31,
            if (await isLeapYear(year)) { 29 } else { 28 },
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

        var m = 1;
        while (m < month) {
            totalDays += monthLengths[m - 1];
            m += 1;
        };

        totalDays += Int.abs(day - 1);
        return totalDays * 86400 + hour * 3600 + min * 60 + sec;
    };

    // Check if a year is a leap year
    public func isLeapYear(year : Int) : async Bool {
        return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0);
    };

    // Check if a given date is valid
    public func isValidDate(year : Int, month : Int, day : Int) : async Bool {
        if (month < 1 or month > 12 or day < 1) return false;

        let isLeap = await isLeapYear(year);
        let daysInMonth = [
            31,
            if (isLeap) { 29 } else { 28 },
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

        return day <= daysInMonth[Int.abs(month - 1)];
    };

    // Helper function to convert Text to Int
    private func _textToInt(t : Text) : async ?Int {
        switch (Nat.fromText(t)) {
            case (?n) ?Int.abs(n);
            case null null;
        };
    };

    // Mock system time function (to be replaced with actual time retrieval)
    private func system_time() : async Int {
        return Time.now() / 1_000_000_000; // Time in seconds
    };

    // Helper function to pad numbers with zeros
    // private func padNumber(num : Nat, width : Nat) : Text {
    //     let numText = Nat.toText(num);
    //     let textSize = Text.size(numText);
    //     if (textSize >= width) return numText;

    //     // Safe calculation of padding length
    //     let padLength = if (width > textSize) {
    //         Nat.sub(width, textSize);
    //     } else {
    //         0;
    //     };

    //     // Create padding string
    //     var padding = "";
    //     var i = 0;
    //     while (i < padLength) {
    //         padding := padding # "0";
    //         i += 1;
    //     };

    //     padding # numText;
    // };
};
