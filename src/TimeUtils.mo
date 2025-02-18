import Time "mo:base/Time";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Int "mo:base/Int";
import Option "mo:base/Option";
import DateCreationParsing "DateCreationParsing";

module {

    // Static array of timezones and their offsets (in seconds)
    private let timezones : [(Text, Int)] = [
        ("UTC", 0),
        ("IST", 19800), // IST: UTC+05:30
        ("EST", -18000), // EST: UTC-05:00
        ("PST", -28800), // PST: UTC-08:00
        ("CET", 3600), // CET: UTC+01:00
        ("JST", 32400), // JST: UTC+09:00
        ("AEST", 36000) // AEST: UTC+10:00
    ];

    // Get current time in UTC with format option
    public func getCurrentTime(use12Hour : ?Bool) : async Text {
        formatTimestamp(Time.now(), 0, Option.get(use12Hour, false));
    };

    // Get time in specific timezone with format option
    public func getTimeInTimezone(timezone : Text, use12Hour : ?Bool) : async Text {
        let time = Time.now();
        let offset = switch (findTimezoneOffset(timezone)) {
            case (?offset) offset;
            case null 0; // Default to UTC if timezone not found
        };
        formatTimestamp(time, offset, Option.get(use12Hour, false));
    };

    // Get date and time in specific timezone with format option
    public func getDateTimeInTimezone(timezone : Text, use12Hour : ?Bool) : async Text {
        let time = Time.now();
        let offset = switch (findTimezoneOffset(timezone)) {
            case (?offset) offset;
            case null 0; // Default to UTC if timezone not found
        };
        let (year, month, day, _hour, _min, _sec) = await DateCreationParsing.now();
        let formattedDate = Text.join("/", Array.vals([Nat.toText(Int.abs(year)), Nat.toText(Int.abs(month)), Nat.toText(Int.abs(day))]));
        let formattedTime = formatTimestamp(time, offset, Option.get(use12Hour, false));
        Text.join(" ", Array.vals([formattedDate, formattedTime]));
    };

    // Helper function to find the offset for a timezone
    private func findTimezoneOffset(timezone : Text) : ?Int {
        // Iterate through the list and find the matching timezone
        let found = Array.find<(Text, Int)>(timezones, func(pair) { Text.equal(pair.0, timezone) });
        switch found {
            case (?(_, offset)) ?offset;
            case null null;
        };
    };

    // Updated format timestamp function to handle 12/24 hour format
    private func formatTimestamp(timestamp : Time.Time, offsetSeconds : Int, use12Hour : Bool) : Text {
        let totalSeconds = timestamp / 1_000_000_000 + offsetSeconds;
        var hours = Int.abs((totalSeconds % 86400) / 3600);
        let minutes = Int.abs((totalSeconds % 3600) / 60);
        let seconds = Int.abs(totalSeconds % 60);

        var meridiem = "";
        if (use12Hour) {
            if (hours >= 12) {
                meridiem := " PM";
                if (hours > 12) {
                    hours -= 12;
                };
            } else {
                meridiem := " AM";
                if (hours == 0) {
                    hours := 12;
                };
            };
        };

        Text.join("", Array.vals([padNumber(hours), ":", padNumber(minutes), ":", padNumber(seconds), meridiem]));
    };

    // Helper function to pad numbers with leading zeros
    private func padNumber(num : Int) : Text {
        let numText = Int.toText(Int.abs(num));
        if (Text.size(numText) < 2) {
            "0" # numText;
        } else {
            numText;
        };
    };

    // Public function to get available timezones
    public func getAvailableTimezones() : async [Text] {
        let keys = Array.map<(Text, Int), Text>(timezones, func(pair) { pair.0 });
        keys;
    };
};
