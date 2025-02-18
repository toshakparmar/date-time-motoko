import Int "mo:base/Int";
import Text "mo:base/Text";
import DateCreationParsing "DateCreationParsing";

module RelativeTime {
    /// Helper function to get the current date
    func currentDate() : async (Int, Int, Int) {
        let (year, month, day, _hour, _min, _sec) = await DateCreationParsing.now();
        (year, month, day);
    };

    /// Calculate the relative time difference in days
    func dateDifference(y : Int, m : Int, d : Int) : async Int {
        let (cy, cm, cd) = await currentDate();
        let totalDays1 = y * 365 + m * 30 + d;
        let totalDays2 = cy * 365 + cm * 30 + cd;
        totalDays2 - totalDays1;
    };

    /// Returns a human-readable relative time format (e.g., "2 days ago")
    public func timeAgo(y : Int, m : Int, d : Int) : async Text {
        let diff = await dateDifference(y, m, d);
        if (diff == 0) {
            "Today";
        } else if (diff == 1) {
            "Yesterday";
        } else if (diff > 1) {
            "" # Int.toText(diff) # " days ago";
        } else {
            "Invalid past date";
        };
    };

    /// Returns time left until a future date (e.g., "In 5 days")
    public func timeUntil(y : Int, m : Int, d : Int) : async Text {
        let diff = -(await dateDifference(y, m, d));
        if (diff == 0) {
            "Today";
        } else if (diff == 1) {
            "Tomorrow";
        } else if (diff > 1) {
            "In " # Int.toText(diff) # " days";
        } else {
            "Date is in the past";
        };
    };

    /// Converts a date to a localized string format (Simple format for demonstration)
    public func toLocaleString(y : Int, m : Int, d : Int, locale : Text) : async Text {
        switch locale {
            case "en" {
                Int.toText(y) # "-" # Int.toText(m) # "-" # Int.toText(d);
            };
            case "fr" {
                Int.toText(d) # "/" # Int.toText(m) # "/" # Int.toText(y);
            };
            case "de" {
                Int.toText(d) # "." # Int.toText(m) # "." # Int.toText(y);
            };
            case _ { "Unsupported locale" };
        };
    };
};
