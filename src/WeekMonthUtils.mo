import Text "mo:base/Text";
import Int "mo:base/Int";
import { isLeapYear } "DateCreationParsing";

module WeekMonthUtils {

    // Get the start of the week (Monday)
    public func startOfWeek(year : Int, month : Int, day : Int) : async (Int, Int, Int) {
        let dayOfWeek = await getDayOfWeek(year, month, day);
        let diff = if (dayOfWeek == 0) 6 else dayOfWeek - 1; // Convert Sunday (0) to 6, others shift by 1
        return await adjustDate(year, month, day, -diff);
    };

    // Get the end of the week (Sunday)
    public func endOfWeek(year : Int, month : Int, day : Int) : async (Int, Int, Int) {
        let dayOfWeek = await getDayOfWeek(year, month, day);
        let diff = if (dayOfWeek == 0) 0 else 7 - dayOfWeek;
        return await adjustDate(year, month, day, diff);
    };

    // Get the name of a month
    public func getMonthName(month : Int) : async Text {
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        if (month >= 1 and month <= 12) { months[Int.abs(month - 1)] } else {
            "Invalid Month";
        };
    };

    // Get the number of days in a month
    public func getDaysInMonth(year : Int, month : Int) : async Int {
        let days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        if (month == 2 and (await isLeapYear(year))) { 29 } else if (month >= 1 and month <= 12) {
            days[Int.abs(month - 1)];
        } else { 0 };
    };

    // Helper: Get the day of the week (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
    private func getDayOfWeek(year : Int, month : Int, day : Int) : async Int {
        var y = year;
        var m = month;
        if (m < 3) { y -= 1; m += 12 };
        let k = y % 100;
        let j = y / 100;
        (day + ((13 * (m + 1)) / 5) + k + (k / 4) + (j / 4) + (5 * j)) % 7;
    };

    // Helper: Adjust a date by a number of days
    private func adjustDate(year : Int, month : Int, day : Int, diff : Int) : async (Int, Int, Int) {
        var d = day + diff;
        var m = month;
        var y = year;
        while (d > (await getDaysInMonth(y, m))) {
            d -= (await getDaysInMonth(y, m));
            m += 1;
            if (m > 12) { m := 1; y += 1 };
        };
        while (d < 1) {
            m -= 1;
            if (m < 1) { m := 12; y -= 1 };
            d += (await getDaysInMonth(y, m));
        };
        (y, m, d);
    };
};
