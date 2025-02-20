import Time "mo:base/Time";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Int "mo:base/Int";
import Int64 "mo:base/Int64";
import Option "mo:base/Option";
import DateCreation "../core/DateCreation";
import Types "../types/Types";
import Error "mo:base/Error";

module TimeUtils {
    // Timezone database with additional information
    private let TIMEZONE_DB : [Types.TimezoneInfo] = [
        { name = "UTC"; offsetSeconds = 0; abbreviation = "UTC" },
        { name = "IST"; offsetSeconds = 19800; abbreviation = "IST" }, // UTC+05:30
        { name = "EST"; offsetSeconds = -18000; abbreviation = "EST" }, // UTC-05:00
        { name = "PST"; offsetSeconds = -28800; abbreviation = "PST" }, // UTC-08:00
        { name = "CET"; offsetSeconds = 3600; abbreviation = "CET" }, // UTC+01:00
        { name = "JST"; offsetSeconds = 32400; abbreviation = "JST" }, // UTC+09:00
        { name = "AEST"; offsetSeconds = 36000; abbreviation = "AEST" } // UTC+10:00
    ];

    public func getCurrentTime(format : ?Types.TimeFormat) : async Types.TimeResult {
        formatTime(Time.now(), 0, format);
    };

    public func getTimeInTimezone(timezone : Text, format : ?Types.TimeFormat) : async Types.TimeResult {
        switch (findTimezone(timezone)) {
            case (?tz) {
                formatTime(Time.now(), tz.offsetSeconds, format);
            };
            case null {
                #Err(#InvalidTimezone("Timezone not found: " # timezone));
            };
        };
    };

    public func getDateTimeInTimezone(timezone : Text, format : ?Types.TimeFormat) : async Types.DateTimeStringResult {
        try {
            let tz = switch (findTimezone(timezone)) {
                case (?tz) { tz };
                case null {
                    return #Err(#InvalidTimezone("Timezone not found: " # timezone));
                };
            };

            let timestamp = Time.now();
            switch (formatTime(timestamp, tz.offsetSeconds, format)) {
                case (#Ok(timeResult)) {
                    let date = await formatDateFromTimestamp(timestamp, tz.offsetSeconds);
                    #Ok({
                        date = date;
                        time = formatTimeString(timeResult);
                        timezone = ?tz;
                    });
                };
                case (#Err(err)) { #Err(err) };
            };
        } catch (e) {
            #Err(#InvalidTime("Error formatting datetime: " # Error.message(e)));
        };
    };

    private func formatTime(timestamp : Time.Time, offsetSeconds : Int, format : ?Types.TimeFormat) : Types.TimeResult {
        let totalSeconds = timestamp / 1_000_000_000 + offsetSeconds;
        var hours = Int.abs((totalSeconds % 86400) / 3600);
        let minutes = Int.abs((totalSeconds % 3600) / 60);
        let seconds = Int.abs(totalSeconds % 60);

        let timeFormat = Option.get(format, #Hour24);
        let adjustedHours = switch (timeFormat) {
            case (#Hour12) {
                if (hours > 12) { Int.max(0, hours - 12) } else if (hours == 0) { 12 } else {
                    hours;
                };
            };
            case (#Hour24) { hours };
        };

        #Ok({
            hour = adjustedHours;
            minute = minutes;
            second = seconds;
            format = timeFormat;
            timezone = null;
        });
    };

    private func formatTimeString(
        time : {
            hour : Int;
            minute : Int;
            second : Int;
            format : Types.TimeFormat;
            timezone : ?Types.TimezoneInfo;
        }
    ) : Text {
        let meridiem = switch (time.format) {
            case (#Hour12) {
                if (time.hour >= 12) " PM" else " AM";
            };
            case (#Hour24) { "" };
        };

        Text.join("", Array.vals([padNumber(time.hour), ":", padNumber(time.minute), ":", padNumber(time.second), meridiem]));
    };

    private func formatDateFromTimestamp(timestamp : Time.Time, offsetSeconds : Int) : async Text {
        let adjustedTimestamp = Int64.toInt(Int64.fromInt(timestamp) + (Int64.fromInt(offsetSeconds) * 1_000_000_000));
        switch (DateCreation.fromTimestamp(adjustedTimestamp)) {
            case (#Ok(dateTime)) {
                let { year; month; day; } = dateTime;
                Text.join("/", Array.vals([Nat.toText(Int.abs(year)), Nat.toText(Int.abs(month)), Nat.toText(Int.abs(day))]));
            };
            case (#Err(_error)) {
                "Error getting date";
            };
        };
    };

    private func findTimezone(timezone : Text) : ?Types.TimezoneInfo {
        Array.find<Types.TimezoneInfo>(TIMEZONE_DB, func(tz) { Text.equal(tz.name, timezone) });
    };

    private func padNumber(num : Int) : Text {
        let numText = Int.toText(Int.abs(num));
        if (Text.size(numText) < 2) {
            "0" # numText;
        } else {
            numText;
        };
    };

    public func getAvailableTimezones() : async [Text] {
        Array.map<Types.TimezoneInfo, Text>(TIMEZONE_DB, func(tz) { tz.name });
    };
};
