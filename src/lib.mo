import Int "mo:base/Int";
import Option "mo:base/Option";
import Array "mo:base/Array";
import DateCreation "core/DateCreation";
import DateFormat "core/DateFormat";
import Arithmetic "operations/Arithmetic";
import Comparision "operations/Comparision";
import Relative "operations/Relative";
import DateUtils "utils/DateUtils";
import TimeUtils "utils/TimeUtils";
import CalendarUtils "utils/CalendarUtils";
import Types "types/Types";

module {
    public class DateTime() {

        // Date Creation Operations
        public func now() : async Types.DateResult {
            await DateCreation.now();
        };

        public func fromTimestamp(timestamp : Int) : Types.DateResult {
            DateCreation.fromTimestamp(timestamp);
        };

        public func toTimestamp(date : Types.DateTimeComponents) : Types.Result<Int> {
            DateCreation.toTimestamp(date);
        };

        public func isValidDate(date : Types.Date) : Types.Result<Bool> {
            DateCreation.isValidDate(date);
        };

        public func isLeapYear(year : Int) : Bool {
            DateCreation.isLeapYear(year);
        };


        // Formatting Operations
        public func format(
            params : {
                date : Types.Date;
                format : Types.DateFormat;
            }
        ) : Types.FormattingResult {
            DateFormat.formatDate(params.date, params.format);
        };

        public func toISO(date : Types.Date) : Types.FormattingResult {
            DateFormat.toISOFormat(date);
        };

        public func getWeekday(date : Types.Date) : Types.WeekDayResult {
            DateFormat.getWeekday(date);
        };

        public func getDayOfYear(date : Types.Date) : Types.Result<Int> {
            DateFormat.getDayOfYear(date);
        };

        // Arithmetic Operations
        public func addTime(
            params : {
                time1: Types.Time;
                time2: Types.Time;
            }
        ) : Types.TimeResult {
            switch (Arithmetic.addTimes(params.time1, params.time2)) {
                case (#Ok(time)) #Ok({
                    hour = time.hour;
                    minute = time.minute;
                    second = time.second;
                    format = #Hour24;
                    timezone = null;
                });
                case (#Err(e)) #Err(e);
            };
        };

        public func add(
            params : {
                date : Types.Date;
                amount : Int;
                unit : Types.TimeUnit;
            }
        ) : Types.ArithmeticResult {
            switch (params.unit) {
                case (#Day) Arithmetic.addDays(params.date, params.amount);
                case (#Month) Arithmetic.addMonths(params.date, params.amount);
                case (#Year) Arithmetic.addYears(params.date, params.amount);
                case _ #Err(#InvalidDate("Unsupported time unit"));
            };
        };

        public func subtractTimes(time1: Types.Time, time2: Types.Time) : Types.Result<Types.Time> {
            switch (Arithmetic.subtractTime(time1, time2)) {
                case (#Ok(time)) #Ok(time);
                case (#Err(e)) #Err(e);
            };
        };

        public func subtract(
            params : {
                date : Types.Date;
                amount : Int;
                unit : Types.TimeUnit;
            }
        ) : Types.ArithmeticResult {
           switch (params.unit) {
                case (#Day) Arithmetic.subtractDays(params.date, params.amount);
                case (#Month) Arithmetic.subtractMonths(params.date, params.amount);
                case (#Year) Arithmetic.subtractYears(params.date, params.amount);
                case _ #Err(#InvalidDate("Unsupported time unit"));
            };
        };

        public func modify(
            params : {
                date : Types.Date;
                amount : Int;
                unit : Types.TimeUnit;
            }
        ) : async Types.ArithmeticResult {
            switch (params.unit) {
                case (#Day) Arithmetic.addDays(params.date, params.amount);
                case (#Month) Arithmetic.addMonths(params.date, params.amount);
                case (#Year) Arithmetic.addYears(params.date, params.amount);
                case _ #Err(#InvalidDate("Unsupported time unit"));
            };
        };


        // Comparison Operations
        public func compare(date1 : Types.Date, date2 : Types.Date) : Types.ComparisonResult {
            Comparision.compare(date1, date2);
        };

        public func difference(date1 : Types.Date, date2 : Types.Date) : Types.DateDifference {
            Comparision.getDifference(date1, date2);
        };

        public func dateDifference(
            params : {
                date1 : Types.Date;
                date2 : Types.Date;
                unit : Types.TimeUnit;
            }
        ) : Int {
            Comparision.dateDifference(params.date1, params.date2, params.unit);
        };

        public func isBefore(date1 : Types.Date, date2 : Types.Date) : Bool {
            Comparision.isBefore(date1, date2);
        };

        public func isAfter(date1 : Types.Date, date2 : Types.Date) : Bool {
            Comparision.isAfter(date1, date2);
        };

        public func isEqual(date1 : Types.Date, date2 : Types.Date) : Bool {
            Comparision.isEqual(date1, date2);
        };


        // Calendar Utility Operations
        public func weekBounds(date : Types.Date) : async {
            start : Types.CalendarResult<Types.Date>;
            end : Types.CalendarResult<Types.Date>;
        } {
            {
                start = await CalendarUtils.startOfWeek(date);
                end = await CalendarUtils.endOfWeek(date);
            };
        };

        public func monthInfo(year : Int, month : Int) : Types.CalendarResult<Types.MonthInfo> {
            CalendarUtils.getMonthInfo(year, month);
        };

        public func daysInMonth(year : Int, month : Int) : Int {
            CalendarUtils.getDaysInMonth(year, month);
        };


        // Relative Time Operations
        public func timeAgo(
            params : {
                date : Types.Date;
                style : ?Types.RelativeTimeStyle;
            }
        ) : async Types.Result<Text> {
            await Relative.timeAgo(params.date, Option.get(params.style, #AutoStyle));
        };

        public func timeUntil(
            params : {
                date : Types.Date;
                style : ?Types.RelativeTimeStyle;
            }
        ) : async Types.Result<Text> {
            await Relative.timeUntil(params.date, Option.get(params.style, #AutoStyle));
        };

        public func toLocaleString(
            params : {
                date : Types.Date;
                locale : Types.Locale;
            }
        ) : async Types.Result<Text> {
            await Relative.toLocaleString(params.date, params.locale);
        };


        // Time Operations
        public func getCurrentTime(format : ?Types.TimeFormat) : async Types.TimeResult {
            await TimeUtils.getCurrentTime(format);
        };

        public func getTimeInZone(
            params : {
                timezone : Text;
                format : ?Types.TimeFormat;
            }
        ) : async Types.TimeResult {
            await TimeUtils.getTimeInTimezone(params.timezone, params.format);
        };

        public func getDateTimeInZone(
            params : {
                timezone : Text;
                format : ?Types.TimeFormat;
            }
        ) : async Types.DateTimeStringResult {
            await TimeUtils.getDateTimeInTimezone(params.timezone, params.format);
        };

        public func timezones() : async [Types.TimezoneInfo] {
            let zones = await TimeUtils.getAvailableTimezones();
            Array.map(zones, func(zone : Text) : Types.TimezoneInfo = { abbreviation = zone; name = zone; offsetSeconds = 0 });
        };

        // Date Utility Operations
        public func findMinMaxDates(dates : [Types.Date]) : {
            min : Types.Result<Types.Date>;
            max : Types.Result<Types.Date>;
        } {
            {
                min = switch (DateUtils.minDate(dates)) {
                    case (#Ok(null)) #Err(#InvalidDate("No minimum date found"));
                    case (#Ok(?date)) #Ok(date);
                    case (#Err(e)) #Err(e);
                };
                max = switch (DateUtils.maxDate(dates)) {
                    case (#Ok(null)) #Err(#InvalidDate("No maximum date found"));
                    case (#Ok(?date)) #Ok(date);
                    case (#Err(e)) #Err(e);
                };
            };
        };

        public func isWeekend(date : Types.Date) : Types.Result<Bool> {
            switch (DateUtils.isWeekend(date)) {
                case (#Ok(?value)) #Ok(value);
                case (#Ok(null)) #Err(#InvalidDate("Unable to determine weekend status"));
                case (#Err(e)) #Err(e);
            };
        };

        public func cloneDate(date : Types.Date) : async Types.Result<Types.Date> {
            DateUtils.cloneDate(date);
        };
    };
};
