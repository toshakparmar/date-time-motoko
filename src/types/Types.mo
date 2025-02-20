import Time "mo:base/Time";
import Int "mo:base/Int";

module Types {
    // Core types
    public type Date = {
        year : Int; // Valid range: 1970..
        month : Int; // Valid range: 1..12
        day : Int; // Valid range: 1..31
    };

    public type Time = {
        hour : Int; // Valid range: 0..23
        minute : Int; // Valid range: 0..59
        second : Int; // Valid range: 0..59
    };

    public type DateTime = {
        date : Date;
        time : Time;
    };

    // Error handling
    public type DateTimeError = {
        #InvalidDate : Text;
        #InvalidTime : Text;
        #InvalidFormat : Text;
        #InvalidTimezone : Text;
        #OutOfRange : Text;
        #ParseError : Text;
    };

    public type Result<T> = {
        #Ok : T;
        #Err : DateTimeError;
    };

    // Enums
    public type Month = {
        #Jan;
        #Feb;
        #Mar;
        #Apr;
        #May;
        #Jun;
        #Jul;
        #Aug;
        #Sep;
        #Oct;
        #Nov;
        #Dec;
    };

    public type WeekDay = {
        #Sunday;
        #Monday;
        #Tuesday;
        #Wednesday;
        #Thursday;
        #Friday;
        #Saturday;
    };

    public type TimeUnit = {
        #Millisecond;
        #Second;
        #Minute;
        #Hour;
        #Day;
        #Week;
        #Month;
        #Quarter;
        #Year;
    };

    // Formatting
    public type DateFormat = {
        #ISO; // YYYY-MM-DD
        #Short; // MM/DD/YY
        #Long; // Month DD, YYYY
        #Custom : Text;
    };

    public type TimeFormat = {
        #Hour12;
        #Hour24;
    };

    // Timezone and Locale
    public type TimezoneInfo = {
        name : Text;
        offsetSeconds : Int;
        abbreviation : Text;
    };

    public type Locale = {
        language : Text;
        region : ?Text;
        calendar : Text;
    };

    // Operation types
    public type DateOperation = {
        date : Date;
        amount : Int;
        unit : TimeUnit;
    };

    public type ComparisonResult = {
        isBefore : Bool;
        isAfter : Bool;
        isEqual : Bool;
    };

    public type DateDifference = {
        years : Int;
        months : Int;
        days : Int;
    };

    // Calendar types
    public type MonthInfo = {
        name : Text;
        daysCount : Int;
        startDay : WeekDay;
        endDay : WeekDay;
    };

    public type DateRange = {
        start : Date;
        end : Date;
        inclusive : Bool;
    };

    // Specific result types
    public type DateTimeComponents = {
        year : Int;
        month : Int;
        day : Int;
        hour : Int;
        minute : Int;
        second : Int;
    };

    public type RelativeTimeStyle = {
        #Numeric;
        #Calendar;
        #AutoStyle;
    };

    public type TimeResult = Result<{ hour : Int; minute : Int; second : Int; format : TimeFormat; timezone : ?TimezoneInfo }>;

    public type DateTimeStringResult = Result<{ date : Text; time : Text; timezone : ?TimezoneInfo }>;

    // Utility result types
    public type CalendarResult<T> = Result<T>;
    public type DateResult = Result<DateTimeComponents>;
    public type FormattingResult = Result<Text>;
    public type WeekDayResult = Result<WeekDay>;
    public type ArithmeticResult = Result<Date>;
};
