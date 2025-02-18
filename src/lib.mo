import Nat "mo:base/Nat";
import Int "mo:base/Int";
import DateCreationParsing "./DateCreationParsing";
import DateFormatting "./DateFormatting";
import DateArithmetic "./DateArithmetic";
import DateComparison "./DateComparison";
import WeekMonthHandling "./WeekMonthUtils";
import RelativeTime "./RelativeTime";
import DateUtils "./DateUtils";
import TimeUtils "./TimeUtils";

actor {

    public type Date = (Int, Int, Int);

    // Test Functions of DateCreationParsing Module
    public func now() : async Text {
        let currentTime = await DateCreationParsing.now();
        let (year, month, day, hour, minute, second) = currentTime;
        return "now(): " # Int.toText(year) # "-" # Int.toText(month) # "-" # Int.toText(day) # " " # Int.toText(hour) # ":" # Int.toText(minute) # ":" # Int.toText(second);
    };
    public func fromTimestamp({ timestamp : Int }) : async (Int, Int, Int, Int, Int, Int) {
        await DateCreationParsing.fromTimestamp(timestamp);
    };
    public func toTimestamp({
        year : Int;
        month : Int;
        day : Int;
        hour : Int;
        min : Int;
        sec : Int;
    }) : async Int {
        await DateCreationParsing.toTimestamp(year, month, day, hour, min, sec);
    };

    public func isValidDate({ year : Int; month : Int; day : Int }) : async Bool {
        await DateCreationParsing.isValidDate(year, month, day);
    };
    public func isLeapYear({ year : Int }) : async Bool {
        await DateCreationParsing.isLeapYear(year);
    };

    // Test Functions of DateFormatting Module
    public func formatDate({ year : Int; month : Int; day : Int; format : Text }) : async Text {
        await DateFormatting.formatDate(year, month, day, format);
    };
    public func toISOFormat({ year : Int; month : Int; day : Int }) : async Text {
        await DateFormatting.toISOFormat(year, month, day);
    };
    public func getWeekday({ year : Int; month : Int; day : Int }) : async Text {
        await DateFormatting.getWeekday(year, month, day);
    };
    public func getDayOfYear({ year : Int; month : Int; day : Int }) : async Int {
        await DateFormatting.getDayOfYear(year, month, day);
    };

    // Test Functions of DateArithmetic Module
    public func addDays({ year : Nat; month : Nat; day : Nat; n : Nat }) : async Date {
        await DateArithmetic.addDays(year, month, day, n);
    };
    public func subtractDays({ year : Nat; month : Nat; day : Nat; n : Nat }) : async Date {
        await DateArithmetic.subtractDays(year, month, day, n);
    };
    public func addMonths({ year : Nat; month : Nat; day : Nat; n : Nat }) : async Date {
        await DateArithmetic.addMonths(year, month, day, n);
    };
    public func subtractMonths({ year : Nat; month : Nat; day : Nat; n : Nat }) : async Date {
        await DateArithmetic.subtractMonths(year, month, day, n);
    };
    public func addYears({ year : Nat; month : Nat; day : Nat; n : Nat }) : async Date {
        await DateArithmetic.addYears(year, month, day, n);
    };
    public func subtractYears({ year : Nat; month : Nat; day : Nat; n : Nat }) : async Date {
        await DateArithmetic.subtractYears(year, month, day, n);
    };
    public func startOfDays({ year : Nat; month : Nat; day : Nat }) : async (Nat, Nat, Nat, Nat, Nat, Nat) {
        await DateArithmetic.startOfDay(year, month, day);
    };
    public func endOfDays({ year : Nat; month : Nat; day : Nat }) : async (Nat, Nat, Nat, Nat, Nat, Nat) {
        await DateArithmetic.endOfDay(year, month, day);
    };

    // Test Functions of DateComparison Module
    public func isBefore({
        year1 : Int;
        month1 : Int;
        day1 : Int;
        year2 : Int;
        month2 : Int;
        day2 : Int;
    }) : async Bool {
        await DateComparison.isBefore(year1, month1, day1, year2, month2, day2);
    };
    public func isAfter({
        year1 : Int;
        month1 : Int;
        day1 : Int;
        year2 : Int;
        month2 : Int;
        day2 : Int;
    }) : async Bool {
        await DateComparison.isAfter(year1, month1, day1, year2, month2, day2);
    };
    public func isEqual({
        year1 : Int;
        month1 : Int;
        day1 : Int;
        year2 : Int;
        month2 : Int;
        day2 : Int;
    }) : async Bool {
        await DateComparison.isEqual(year1, month1, day1, year2, month2, day2);
    };
    public func dateDifference({
        year1 : Int;
        month1 : Int;
        day1 : Int;
        year2 : Int;
        month2 : Int;
        day2 : Int;
        unit : Text;
    }) : async Int {
        await DateComparison.dateDifference(year1, month1, day1, year2, month2, day2, unit);
    };

    // Test Functions of WeekMonthHandling Module
    public func startOfWeek({ year : Int; month : Int; day : Int }) : async Date {
        await WeekMonthHandling.startOfWeek(year, month, day);
    };
    public func endOfWeek({ year : Int; month : Int; day : Int }) : async Date {
        await WeekMonthHandling.endOfWeek(year, month, day);
    };
    public func getMonthName({ month : Int }) : async Text {
        await WeekMonthHandling.getMonthName(month);
    };
    public func getDaysInMonthUtil({ year : Int; month : Int }) : async Int {
        await WeekMonthHandling.getDaysInMonth(year, month);
    };

    // Test Functions of RelativeTime Module
    public func timeUntil({ year : Int; month : Int; day : Int }) : async Text {
        await RelativeTime.timeUntil(year, month, day);
    };
    public func toLocaleString({
        year : Int;
        month : Int;
        day : Int;
        locale : Text;
    }) : async Text {
        await RelativeTime.toLocaleString(year, month, day, locale);
    };
    public func timeAgo({ year : Int; month : Int; day : Int }) : async Text {
        await RelativeTime.timeAgo(year, month, day);
    };

    // Test Functions of DateUtils Module
    public func cloneDate({ year : Int; month : Int; day : Int }) : async Date {
        await DateUtils.cloneDate(year, month, day);
    };
    public func minDate({ dates : [(Int, Int, Int)] }) : async ?Date {
        await DateUtils.minDate(dates);
    };
    public func maxDate({ dates : [(Int, Int, Int)] }) : async ?Date {
        await DateUtils.maxDate(dates);
    };
    public func isWeekend({ year : Int; month : Int; day : Int }) : async ?Bool {
        await DateUtils.isWeekend(year, month, day);
    };

    // Test Functions of TimeUtils Module
    public func getCurrentTime(use12Hour : ?Bool) : async Text {
        await TimeUtils.getCurrentTime(use12Hour);
    };
    public func getTimeInTimezone({ timezone : Text; use12Hour : ?Bool }) : async Text {
        await TimeUtils.getTimeInTimezone(timezone, use12Hour);
    };
    public func getDateTimeInTimezone({ timezone : Text; use12Hour : ?Bool }) : async Text {
        await TimeUtils.getDateTimeInTimezone(timezone, use12Hour);
    };
    public func getAvailableTimezones() : async [Text] {
        await TimeUtils.getAvailableTimezones();
    };
};
