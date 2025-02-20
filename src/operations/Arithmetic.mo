import Types "../types/Types";
import Int "mo:base/Int";
import { isLeapYear } "../core/DateCreation";

module Arthmetic {
    private let DAYS_IN_MONTH = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    public func addTimes (time1 : Types.Time, time2 : Types.Time) : Types.Result<Types.Time> {
        let totalSeconds = time1.second + time2.second;
        let s = totalSeconds % 60;
        let m = time1.minute + time2.minute + totalSeconds / 60;
        let h = time1.hour + time2.hour + m / 60;
        #Ok({
            hour = h % 24;
            minute = m % 60;
            second = s;
        });
    };

    public func addDays(date : Types.Date, n : Int) : Types.ArithmeticResult {

        var d = date.day + n;
        var m = date.month;
        var y = date.year;
        let _isLeap = isLeapYear(y);
        let daysInMonth = getDaysInMonthArray(y);

        while (d > daysInMonth[Int.abs(m - 1)]) {
            d -= daysInMonth[Int.abs(m - 1)];
            m += 1;
            if (m > 12) {
                m := 1;
                y += 1;
            };
        };

        #Ok({ year = y; month = m; day = d });

    };

    public func subtractDays(date : Types.Date, n : Int) : Types.ArithmeticResult {

        var d = date.day;
        var m = date.month;
        var y = date.year;

        while (d <= n) {
            if (m == 1) {
                m := 12;
                y -= 1;
            } else {
                m -= 1;
            };
            d += getDaysInMonth(y, m);
        };
        d -= n;

        #Ok({ year = y; month = m; day = d });

    };

    public func addMonths(date : Types.Date, n : Int) : Types.ArithmeticResult {

        let totalMonths = date.year * 12 + (date.month + n);
        let y = totalMonths / 12;
        let m = totalMonths % 12;
        let maxDay = getDaysInMonth(y, if (m == 0) 12 else m);
        let d = Int.min(date.day, maxDay);

        #Ok({
            year = y;
            month = if (m == 0) 12 else m;
            day = d;
        });

    };

    public func subtractTime(time1: Types.Time, time2: Types.Time) : Types.Result<Types.Time> {
        let totalSeconds = time1.second - time2.second;
        let s = Int.abs(totalSeconds % 60);
        let m = time1.minute - time2.minute + totalSeconds / 60;
        let h = time1.hour - time2.hour + m / 60;
        #Ok({
            hour = h % 24;
            minute = m % 60;
            second = s;
        });
    };

    public func subtractMonths(date : Types.Date, n : Int) : Types.ArithmeticResult {

        let totalMonths = date.year * 12 + (date.month - n);
        let y = totalMonths / 12;
        let m = totalMonths % 12;
        let maxDay = getDaysInMonth(y, if (m == 0) 12 else m);
        let d = Int.min(date.day, maxDay);

        #Ok({
            year = y;
            month = if (m == 0) 12 else m;
            day = d;
        });
    };

    public func addYears(date : Types.Date, n : Int) : Types.ArithmeticResult {
        #Ok({
            year = date.year + n;
            month = date.month;
            day = date.day;
        });
    };

    public func subtractYears(date : Types.Date, n : Int) : Types.ArithmeticResult {
        #Ok({
            year = date.year - n;
            month = date.month;
            day = date.day;
        });
    };

    public func modifyDateTime(operation : Types.DateOperation) : async Types.ArithmeticResult {
        switch (operation.unit) {
            case (#Day) { addDays(operation.date, operation.amount) };
            case (#Month) { addMonths(operation.date, operation.amount) };
            case (#Year) {
                addMonths(operation.date, operation.amount * 12);
            };
            case (_) {
                #Err(#InvalidDate("Unsupported time unit"));
            };
        };
    };

    private func getDaysInMonth(year : Int, month : Int) : Int {
        if (month == 2 and (isLeapYear(year))) {
            29;
        } else {
            DAYS_IN_MONTH[Int.abs(month - 1)];
        };
    };

    private func getDaysInMonthArray(year : Int) : [Int] {
        [
            31,
            if (isLeapYear(year)) 29 else 28,
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
};
