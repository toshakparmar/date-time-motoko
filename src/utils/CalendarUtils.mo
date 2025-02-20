import Int "mo:base/Int";
import Error "mo:base/Error";
import Types "../types/Types";
import { isLeapYear } "../core/DateCreation";

module CalendarUtils {
    private let DAYS_IN_MONTH = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    private let MONTH_NAMES = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
    ];

    public func startOfWeek(date : Types.Date) : async Types.CalendarResult<Types.Date> {
        try {
            let dayOfWeek = getDayOfWeek(date);
            let diff = if (dayOfWeek == 0) 6 else dayOfWeek - 1;
            let result = await adjustDate(date, -diff);
            #Ok(result);
        } catch (e) {
            #Err(#InvalidDate("Error calculating start of week: " # Error.message(e)));
        };
    };

    public func endOfWeek(date : Types.Date) : async Types.CalendarResult<Types.Date> {
        try {
            let dayOfWeek = getDayOfWeek(date);
            let diff = if (dayOfWeek == 0) 0 else 7 - dayOfWeek;
            let result = await adjustDate(date, diff);
            #Ok(result);
        } catch (e) {
            #Err(#InvalidDate("Error calculating end of week: " # Error.message(e)));
        };
    };

    public func getMonthInfo(year : Int, month : Int) : Types.CalendarResult<Types.MonthInfo> {

        if (month < 1 or month > 12) {
            return #Err(#InvalidDate("Month must be between 1 and 12"));
        };

        let firstDay = { year; month; day = 1 };
        let daysInMonth = getDaysInMonth(year, month);
        let lastDay = { year; month; day = daysInMonth };

        let startDayNum = getDayOfWeek(firstDay);
        let endDayNum = getDayOfWeek(lastDay);

        #Ok({
            name = MONTH_NAMES[Int.abs(month - 1)];
            daysCount = daysInMonth;
            startDay = numberToWeekDay(startDayNum);
            endDay = numberToWeekDay(endDayNum);
        });

    };

    public func getDaysInMonth(year : Int, month : Int) : Int {
        if (month == 2 and (isLeapYear(year))) {
            29;
        } else if (month >= 1 and month <= 12) {
            DAYS_IN_MONTH[Int.abs(month - 1)];
        } else {
            0;
        };
    };

    private func getDayOfWeek(date : Types.Date) : Int {
        var y = date.year;
        var m = date.month;
        if (m < 3) {
            y -= 1;
            m += 12;
        };
        let k = y % 100;
        let j = y / 100;
        (date.day + ((13 * (m + 1)) / 5) + k + (k / 4) + (j / 4) + (5 * j)) % 7;
    };

    private func adjustDate(date : Types.Date, diff : Int) : async Types.Date {
        var d = date.day + diff;
        var m = date.month;
        var y = date.year;

        while (d > (getDaysInMonth(y, m))) {
            d -= (getDaysInMonth(y, m));
            m += 1;
            if (m > 12) {
                m := 1;
                y += 1;
            };
        };

        while (d < 1) {
            m -= 1;
            if (m < 1) {
                m := 12;
                y -= 1;
            };
            d += (getDaysInMonth(y, m));
        };

        { year = y; month = m; day = d };
    };

    private func numberToWeekDay(num : Int) : Types.WeekDay {
        switch (num) {
            case 0 { #Sunday };
            case 1 { #Monday };
            case 2 { #Tuesday };
            case 3 { #Wednesday };
            case 4 { #Thursday };
            case 5 { #Friday };
            case _ { #Saturday };
        };
    };
};
