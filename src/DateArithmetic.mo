import Nat "mo:base/Nat";
import { isLeapYear } "DateCreationParsing";

module DateArithmetic {
    
    public func addDays(year : Nat, month : Nat, day : Nat, n : Nat) : async (Nat, Nat, Nat) {
        var d = day + n;
        var m = month;
        var y = year;
        var isLeap = await isLeapYear(y);
        let daysInMonth = [0, 31, (28 + (if (isLeap) 1 else 0)), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        while (d > daysInMonth[m]) {
            d -= daysInMonth[m];
            m += 1;
            if (m > 12) {
                m := 1;
                y += 1;
            };
        };
        (y, m, d);
    };

    public func subtractDays(year : Nat, month : Nat, day : Nat, n : Nat) : async (Nat, Nat, Nat) {
        var d = day;
        var m = month;
        var y = year;
        let isLeap = await isLeapYear(y);
        let daysInMonth = [0, 31, 28 + (if (isLeap) 1 else 0), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        while (d <= n) {
            if (m == 1) {
                m := 12;
                y -= 1;
            } else {
                m -= 1;
            };
            d += daysInMonth[m];
        };
        d -= n;
        return (y, m, d);
    };

    public func addMonths(year : Nat, month : Nat, day : Nat, n : Nat) : async (Nat, Nat, Nat) {
        var y = year + Nat.div(month + n - 1, 12);
        var m = Nat.rem(month + n - 1, 12) + 1;
        let maxDay = await daysInMonth(y, m);
        return (y, m, if (day > maxDay) maxDay else day);
    };

    public func subtractMonths(year : Nat, month : Nat, day : Nat, n : Nat) : async (Nat, Nat, Nat) {
        let yearMonths = year * 12;
        let totalMonths = Nat.sub(Nat.add(yearMonths, month), n);
        var y = totalMonths / 12;
        var m = totalMonths % 12;
        if (m == 0) {
            m := 12;
            y -= 1;
        };
        let maxDay = await daysInMonth(y, m);
        return (y, m, if (day > maxDay) maxDay else day);
    };

    public func addYears(year : Nat, month : Nat, day : Nat, n : Nat) : async (Nat, Nat, Nat) {
        let newYear = year + n;
        let maxDay = await daysInMonth(newYear, month);
        return (newYear, month, if (day > maxDay) maxDay else day);
    };

    public func subtractYears(year : Nat, month : Nat, day : Nat, n : Nat) : async (Nat, Nat, Nat) {
        let newYear = if (year > n) Nat.sub(year, n) else 0;
        let maxDay = await daysInMonth(newYear, month);
        return (newYear, month, if (day > maxDay) maxDay else day);
    };

    public func startOfDay(year : Nat, month : Nat, day : Nat) : async (Nat, Nat, Nat, Nat, Nat, Nat) {
        return (year, month, day, 0, 0, 0);
    };

    public func endOfDay(year : Nat, month : Nat, day : Nat) : async (Nat, Nat, Nat, Nat, Nat, Nat) {
        return (year, month, day, 23, 59, 59);
    };

    private func daysInMonth(year : Nat, month : Nat) : async Nat {
        let days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        if (month == 2 and (await isLeapYear(year))) {
            return 29;
        } else {
            return days[month - 1];
        };
    };
};
