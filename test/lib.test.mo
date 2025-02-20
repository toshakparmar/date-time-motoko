import Debug "mo:base/Debug";
import Error "mo:base/Error";
import DateTime "../src/lib";
import Types "../src/types/Types";

actor {
    let dateTime = DateTime.DateTime();

    // Helper function to create a test date
    private func createTestDate() : Types.Date {
        {
            year = 2024;
            month = 2;
            day = 20;
        };
    };

    // Date Creation Tests
    public func testDateCreation() : async () {
        try {
            // Test now()
            let nowResult = await dateTime.now();
            switch (nowResult) {
                case (#Ok(components)) {
                    assert (components.year >= 2024);
                };
                case (#Err(_)) { assert (false) };
            };

            // Test fromTimestamp
            let timestamp = 1708444800; // 2024-02-20
            let fromTimestampResult = dateTime.fromTimestamp(timestamp);
            switch (fromTimestampResult) {
                case (#Ok(components)) {
                    assert (components.year == 2024);
                    assert (components.month == 2);
                    assert (components.day == 20);
                };
                case (#Err(_)) { assert (false) };
            };

            // Test validation functions
            let testDate = createTestDate();
            let isValidResult = dateTime.isValidDate(testDate);
            assert (switch (isValidResult) { case (#Ok(valid)) valid; case (#Err(_)) false });

            assert (dateTime.isLeapYear(2024) == true);
            assert (dateTime.isLeapYear(2023) == false);
        } catch (e) {
            Debug.print("Date Creation Tests Failed: " # Error.message(e));
            assert (false);
        };
    };

    // Formatting Tests
    public func testFormatting() : async () {
        try {
            let testDate = createTestDate();

            // Test format
            let formatResult = dateTime.format({
                date = testDate;
                format = #ISO;
            });
            switch (formatResult) {
                case (#Ok(formatted)) {
                    assert (formatted == "2024-02-20");
                };
                case (#Err(_)) { assert (false) };
            };

            // Test ISO format
            let isoResult = dateTime.toISO(testDate);
            switch (isoResult) {
                case (#Ok(iso)) {
                    assert (iso == "2024-02-20");
                };
                case (#Err(_)) { assert (false) };
            };

            // Test weekday
            let weekdayResult = dateTime.getWeekday(testDate);
            switch (weekdayResult) {
                case (#Ok(weekday)) {
                    assert (weekday == #Tuesday);
                };
                case (#Err(_)) { assert (false) };
            };
        } catch (e) {
            Debug.print("Formatting Tests Failed: " # Error.message(e));
            assert (false);
        };
    };

    // Arithmetic Tests
    public func testArithmetic() : async () {
        try {
            let testDate = createTestDate();

            // Test add days
            let addResult = dateTime.add({
                date = testDate;
                amount = 1;
                unit = #Day;
            });
            switch (addResult) {
                case (#Ok(result)) {
                    assert (result.day == 21);
                };
                case (#Err(_)) { assert (false) };
            };

            // Test subtract days
            let subtractResult = dateTime.subtract({
                date = testDate;
                amount = 1;
                unit = #Day;
            });
            switch (subtractResult) {
                case (#Ok(result)) {
                    assert (result.day == 19);
                };
                case (#Err(_)) { assert (false) };
            };
        } catch (e) {
            Debug.print("Arithmetic Tests Failed: " # Error.message(e));
            assert (false);
        };
    };

    // Comparison Tests
    public func testComparison() : async () {
        try {
            let date1 = createTestDate();
            let date2 = {
                year = 2024;
                month = 2;
                day = 21;
            };

            let compareResult = dateTime.compare(date1, date2);
            assert (compareResult.isBefore == true);
            assert (compareResult.isAfter == false);
            assert (compareResult.isEqual == false);

            assert (dateTime.isBefore(date1, date2) == true);
            assert (dateTime.isAfter(date1, date2) == false);
            assert (dateTime.isEqual(date1, date1) == true);
        } catch (e) {
            Debug.print("Comparison Tests Failed: " # Error.message(e));
            assert (false);
        };
    };

    // Calendar Tests
    public func testCalendar() : async () {
        try {
            let testDate = createTestDate();

            // Test week bounds
            let bounds = await dateTime.weekBounds(testDate);
            switch (bounds.start) {
                case (#Ok(start)) {
                    assert (start.day == 18); // Monday
                };
                case (#Err(_)) { assert (false) };
            };

            // Test month info
            let monthInfo = dateTime.monthInfo(2024, 2);
            switch (monthInfo) {
                case (#Ok(info)) {
                    assert (info.name == "February");
                    assert (info.daysCount == 29);
                };
                case (#Err(_)) { assert (false) };
            };
        } catch (e) {
            Debug.print("Calendar Tests Failed: " # Error.message(e));
            assert (false);
        };
    };

    // Time Tests
    public func testTime() : async () {
        try {
            // Test current time
            let currentTime = await dateTime.getCurrentTime(null);
            switch (currentTime) {
                case (#Ok(time)) {
                    assert (time.hour >= 0 and time.hour < 24);
                };
                case (#Err(_)) { assert (false) };
            };

            // Test timezone
            let tzTime = await dateTime.getTimeInZone({
                timezone = "UTC";
                format = ?#Hour24;
            });
            switch (tzTime) {
                case (#Ok(_)) { assert (true) };
                case (#Err(_)) { assert (false) };
            };
        } catch (e) {
            Debug.print("Time Tests Failed: " # Error.message(e));
            assert (false);
        };
    };

    // Utility Tests
    public func testUtilities() : async () {
        try {
            let testDate = createTestDate();

            // Test weekend check
            let weekendResult = dateTime.isWeekend(testDate);
            switch (weekendResult) {
                case (#Ok(isWeekend)) {
                    assert (isWeekend == false); // Feb 20, 2024 is Tuesday
                };
                case (#Err(_)) { assert (false) };
            };

            // Test min/max dates
            let dates = [
                testDate,
                {
                    year = 2024;
                    month = 2;
                    day = 21;
                },
            ];
            let minMax = dateTime.findMinMaxDates(dates);
            switch (minMax.min) {
                case (#Ok(min)) {
                    assert (min.day == 20);
                };
                case (#Err(_)) { assert (false) };
            };
        } catch (e) {
            Debug.print("Utility Tests Failed: " # Error.message(e));
            assert (false);
        };
    };

    // Run all tests
    public func runTests() : async () {
        await testDateCreation();
        await testFormatting();
        await testArithmetic();
        await testComparison();
        await testCalendar();
        await testTime();
        await testUtilities();
        Debug.print("All tests completed successfully!");
    };
};
