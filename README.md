# Date and Time Utilities Mops Package

## Overview

This Mops package provides a comprehensive set of functions for working with date and time, allowing developers to create, format, manipulate, compare, and handle various time-related operations. It includes modules for date creation, formatting, arithmetic, comparison, week/month handling, relative time, utilities, and timezone support.

---

## Use Cases

This package is ideal for:

- **Date and Time Formatting**: When you need to display or store date-time information in a specific format (e.g., ISO format, weekdays, day of the year).
- **Date Arithmetic**: Performing arithmetic operations on dates such as adding/subtracting days, months, or years.
- **Date Comparisons**: Comparing dates to check if one is before, after, or equal to another, or calculating the difference between them.
- **Timezone Support**: Working with timezones and converting dates/times accordingly.
- **Week and Month Utilities**: Getting the start and end of weeks and months, or determining the number of days in a given month.
- **Relative Time**: Displaying dates in terms of relative time (e.g., "5 days ago" or "in 2 weeks").
- **Utility Functions**: Handling tasks such as cloning dates, finding the earliest/latest date in a list, or checking if a given date is a weekend.

---

## Advantages

- **Modular and Extensible**: Each module (e.g., `DateCreationParsing`, `DateFormatting`) is designed to be self-contained, making it easy to integrate into different applications.
- **Comprehensive Functionality**: From basic date parsing to advanced operations like date differences and timezone handling, this package covers all your date-time needs.
- **Error Handling**: The functions ensure proper handling of invalid inputs, leap years, and time zone discrepancies.
- **Ease of Use**: Simple API functions designed to be used without complicated setup.

---

## Installation

To install and use this package, follow these steps:

1. **Install the Mops Package**:
   - Add this package as a dependency in your project by using the appropriate package manager for Motoko.
2. **Import the Package**:
   ```motoko
   import DateCreationParsing "./DateCreationParsing";
   import DateFormatting "./DateFormatting";
   import DateArithmetic "./DateArithmetic";
   import DateComparison "./DateComparison";
   import WeekMonthHandling "./WeekMonthUtils";
   import RelativeTime "./RelativeTime";
   import DateUtils "./DateUtils";
   import TimeUtils "./TimeUtils";
   ```

---

## How to Use

You can call the functions as needed for different date and time operations. Here is an example of how to use a few of the functions:

```motoko
actor {

    public func now() : async Text {
        let currentTime = await DateCreationParsing.now();
        let (year, month, day, hour, minute, second) = currentTime;
        return "Current time: " # Int.toText(year) # "-" # Int.toText(month) # "-" # Int.toText(day) # " " # Int.toText(hour) # ":" # Int.toText(minute) # ":" # Int.toText(second);
    };

    public func addDays({ year : Nat; month : Nat; day : Nat; n : Nat }) : async Date {
        return await DateArithmetic.addDays(year, month, day, n);
    };

    public func isValidDate({ year : Int; month : Int; day : Int }) : async Bool {
        return await DateCreationParsing.isValidDate(year, month, day);
    };

};
```

---

## Function Overview

### Date Creation and Parsing

- **now**: Retrieves the current date and time.
- **fromTimestamp**: Converts a Unix timestamp to a date.
- **toTimestamp**: Converts a date to a Unix timestamp.
- **isValidDate**: Checks if a date is valid.
- **isLeapYear**: Determines if a year is a leap year.

### Date Formatting

- **formatDate**: Formats a date into a specific format.
- **toISOFormat**: Converts a date to ISO 8601 format.
- **getWeekday**: Returns the weekday name for a given date.
- **getDayOfYear**: Returns the day of the year for a given date.

### Date Arithmetic

- **addDays**: Adds a specified number of days to a date.
- **subtractDays**: Subtracts a specified number of days from a date.
- **addMonths**: Adds a specified number of months to a date.
- **subtractMonths**: Subtracts a specified number of months from a date.
- **addYears**: Adds a specified number of years to a date.
- **subtractYears**: Subtracts a specified number of years from a date.
- **startOfDay**: Retrieves the start of the day for a date.
- **endOfDay**: Retrieves the end of the day for a date.

### Date Comparison

- **isBefore**: Checks if one date is before another.
- **isAfter**: Checks if one date is after another.
- **isEqual**: Checks if two dates are equal.
- **dateDifference**: Calculates the difference between two dates in a specified unit (days, months, years, etc.).

### Week and Month Handling

- **startOfWeek**: Returns the start date of the week.
- **endOfWeek**: Returns the end date of the week.
- **getMonthName**: Retrieves the name of a given month.
- **getDaysInMonth**: Returns the number of days in a month for a specific year.

### Relative Time

- **timeUntil**: Returns a string describing the time until a given date.
- **toLocaleString**: Converts a date to a locale-specific string.
- **timeAgo**: Returns a string describing how long ago a date was.

### Date Utilities

- **cloneDate**: Creates a clone of a given date.
- **minDate**: Finds the earliest date from a list of dates.
- **maxDate**: Finds the latest date from a list of dates.
- **isWeekend**: Checks if a date falls on a weekend.

### Time Utilities

- **getCurrentTime**: Retrieves the current time, optionally in 12-hour format.
- **getTimeInTimezone**: Retrieves the current time in a specified timezone.
- **getDateTimeInTimezone**: Retrieves the current date and time in a specified timezone.
- **getAvailableTimezones**: Lists all available timezones.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Conclusion

This Mops package provides a versatile and comprehensive set of date and time utilities, perfect for handling all your time-related needs. Whether you need simple date formatting or complex date arithmetic, this package makes it easy to work with dates in Motoko.
