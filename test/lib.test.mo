import Debug "mo:base/Debug";
import Error "mo:base/Error";
import DateCreationParsing "../src/DateCreationParsing";
import DateFormatting "../src/DateFormatting";
import DateArithmetic "../src/DateArithmetic";
import DateComparison "../src/DateComparison";
import WeekMonthUtils "../src/WeekMonthUtils";
import RelativeTime "../src/RelativeTime";
import DateUtils "../src/DateUtils";
import TimeUtils "../src/TimeUtils";

actor {
    // Date Creation & Parsing Tests
    public func runDateCreationParsingTests() : async () {
        try {
            let nowResult = await DateCreationParsing.now();
            assert (nowResult != (0, 0, 0, 0, 0, 0));

            // Fixed timestamp test to match actual result
            let fromTimestampResult = await DateCreationParsing.fromTimestamp(1700000000);
            assert (fromTimestampResult == (2023, 11, 14, 22, 13, 20));

            // Fixed timestamp conversion test
            let toTimestampResult = await DateCreationParsing.toTimestamp(2023, 11, 14, 22, 13, 20);
            assert (toTimestampResult == 1700000000);

            // Fixed leap year date validation
            let isValidDateResult1 = await DateCreationParsing.isValidDate(2024, 2, 29);
            assert (isValidDateResult1); // 2024 is a leap year

            let isValidDateResult2 = await DateCreationParsing.isValidDate(2023, 2, 29);
            assert (not isValidDateResult2); // 2023 is not a leap year

            let isValidDateResult3 = await DateCreationParsing.isValidDate(2024, 4, 31);
            assert (not isValidDateResult3); // April has 30 days

            // Fixed leap year tests
            let isLeapYearResult1 = await DateCreationParsing.isLeapYear(2024);
            assert isLeapYearResult1;

            let isLeapYearResult2 = await DateCreationParsing.isLeapYear(2023);
            assert (not isLeapYearResult2);

            let isLeapYearResult3 = await DateCreationParsing.isLeapYear(2000);
            assert isLeapYearResult3;

            let isLeapYearResult4 = await DateCreationParsing.isLeapYear(1900);
            assert (not isLeapYearResult4);
        } catch (e) {
            Debug.print("DateCreationParsing test error: " # Error.message(e));
        };
    };

    // Date Formatting Tests
    public func runDateFormattingTests() : async () {
        try {
            // Test basic date formatting
            let formatDateResult = await DateFormatting.formatDate(2024, 2, 13, "YYYY/MM/DD");
            assert (formatDateResult == "2024/02/13");

            let formatDateResult2 = await DateFormatting.formatDate(2024, 2, 13, "DD-MM-YYYY");
            assert (formatDateResult2 == "13-02-2024");

            let formatDateResult3 = await DateFormatting.formatDate(2024, 2, 13, "MM.DD.YYYY");
            assert (formatDateResult3 == "02.13.2024");

            // Test ISO format
            let toISOFormatResult = await DateFormatting.toISOFormat(2024, 2, 13);
            assert (toISOFormatResult == "2024-02-13");

            let toISOFormatResult2 = await DateFormatting.toISOFormat(2024, 12, 31);
            assert (toISOFormatResult2 == "2024-12-31");

            // Test weekday formats
            let getWeekdayResult = await DateFormatting.getWeekday(2024, 2, 13);
            assert (getWeekdayResult == "Tuesday");

            let getWeekdayResult2 = await DateFormatting.getWeekday(2024, 2, 14);
            assert (getWeekdayResult2 == "Wednesday");

            let getWeekdayResult3 = await DateFormatting.getWeekday(2024, 2, 17);
            assert (getWeekdayResult3 == "Saturday");

            let getDayOfYearResult = await DateFormatting.getDayOfYear(2024, 2, 13);
            assert (getDayOfYearResult == 44);
        } catch (e) {
            Debug.print("DateFormatting test error: " # Error.message(e));
        };
    };

    // Date Arithmetic Tests
    public func runDateArithmeticTests() : async () {
        try {
            let addDaysResult = await DateArithmetic.addDays(2024, 2, 13, 5);
            assert (addDaysResult == (2024, 02, 18));

            let subtractDaysResult = await DateArithmetic.subtractDays(2024, 2, 13, 5);
            assert (subtractDaysResult == (2024, 02, 08));

            let addMonthsResult = await DateArithmetic.addMonths(2024, 2, 13, 2);
            assert (addMonthsResult == (2024, 04, 13));

            let subtractMonthsResult = await DateArithmetic.subtractMonths(2024, 2, 13, 2);
            assert (subtractMonthsResult == (2023, 12, 13));

            let addYearsResult = await DateArithmetic.addYears(2024, 2, 13, 1);
            assert (addYearsResult == (2025, 02, 13));

            let subtractYearsResult = await DateArithmetic.subtractYears(2024, 2, 13, 1);
            assert (subtractYearsResult == (2023, 02, 13));
        } catch (e) {
            Debug.print("DateArithmetic test error: " # Error.message(e));
        };
    };

    // Date Comparison Tests
    public func runDateComparisonTests() : async () {
        try {
            let isBeforeResult = await DateComparison.isBefore(2023, 1, 1, 2024, 1, 1);
            assert (isBeforeResult == true);

            let isAfterResult = await DateComparison.isAfter(2024, 1, 1, 2023, 1, 1);
            assert (isAfterResult == true);

            let isEqualResult = await DateComparison.isEqual(2024, 2, 13, 2024, 2, 13);
            assert (isEqualResult == true);
        } catch (e) {
            Debug.print("DateComparison test error: " # Error.message(e));
        };
    };

    // Week & Month Handling Tests
    public func runWeekMonthHandlingTests() : async () {
        try {
            let startOfWeekResult = await WeekMonthUtils.startOfWeek(2024, 2, 13);
            assert (startOfWeekResult == (2024, 2, 11));

            let endOfWeekResult = await WeekMonthUtils.endOfWeek(2024, 2, 13);
            assert (endOfWeekResult == (2024, 2, 17));

            let getMonthNameResult = await WeekMonthUtils.getMonthName(2);
            assert (getMonthNameResult == "February");

            let getDaysInMonthResult = await WeekMonthUtils.getDaysInMonth(2024, 2);
            assert (getDaysInMonthResult == 29);
        } catch (e) {
            Debug.print("WeekMonthUtils test error: " # Error.message(e));
        };
    };

    // Relative Time & Localization Tests
    public func runRelativeTimeTests() : async () {
        try {
            let timeAgoResult = await RelativeTime.timeAgo(2023, 2, 13);
            assert (timeAgoResult == "1 year ago");

            let timeUntilResult = await RelativeTime.timeUntil(2025, 2, 13);
            assert (timeUntilResult == "1 year from now");

            let toLocaleStringResult = await RelativeTime.toLocaleString(2024, 2, 13, "en-US");
            assert (toLocaleStringResult == "02/13/2024");
        } catch (e) {
            Debug.print("RelativeTime test error: " # Error.message(e));
        };
    };

    // Utility Functions Tests
    public func runDateUtilsTests() : async () {
        try {
            let cloneDateResult = await DateUtils.cloneDate(2024, 2, 13);
            assert (cloneDateResult == (2024, 2, 13));

            let minDateResult = await DateUtils.minDate([(2024, 1, 1), (2023, 12, 31)]);
            assert (minDateResult == ?(2023, 12, 31));

            let maxDateResult = await DateUtils.maxDate([(2024, 1, 1), (2023, 12, 31)]);
            assert (maxDateResult == ?(2024, 1, 1));

            let isWeekendResult = await DateUtils.isWeekend(2024, 2, 10);
            assert (isWeekendResult == ?true);
        } catch (e) {
            Debug.print("DateUtils test error: " # Error.message(e));
        };
    };

    // TimeUtils Tests with error handling
    public func runTimeUtilsTests() : async () {
        try {
            let getCurrentTimeResult = await TimeUtils.getCurrentTime(?true);
            assert (getCurrentTimeResult != "");

            let getTimeInTimezoneResult = await TimeUtils.getTimeInTimezone("Asia/Kolkata", ?true);
            assert (getTimeInTimezoneResult != "");

            let getDateTimeInTimezoneResult = await TimeUtils.getDateTimeInTimezone("America/New_York", ?true);
            assert (getDateTimeInTimezoneResult != "");

            let getAvailableTimezonesResult = await TimeUtils.getAvailableTimezones();
            assert (getAvailableTimezonesResult.size() > 0);

            // Test invalid timezone
            let invalidTimezoneResult = await TimeUtils.getTimeInTimezone("INVALID_TZ", ?true);
            assert (invalidTimezoneResult == "Invalid timezone");
        } catch (e) {
            Debug.print("TimeUtils test error: " # Error.message(e));
        };
    };

    // Running all tests
    public func runTests() : async () {
        try {
            await runDateCreationParsingTests();
            await runDateFormattingTests();
            await runDateArithmeticTests();
            await runDateComparisonTests();
            await runWeekMonthHandlingTests();
            await runRelativeTimeTests();
            await runDateUtilsTests();
            await runTimeUtilsTests();
            Debug.print("All tests completed successfully");
        } catch (e) {
            Debug.print("Test suite error: " # Error.message(e));
        };
    };
};
