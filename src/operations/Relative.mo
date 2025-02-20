import Int "mo:base/Int";
import Text "mo:base/Text";
import Types "../types/Types";
import DateCreation "../core/DateCreation";
import Error "mo:base/Error";

module Relative {
    // Helper function to get current date
    private func currentDate() : async Types.Date {
        switch (await DateCreation.now()) {
            case (#Ok(components)) {
                {
                    year = components.year;
                    month = components.month;
                    day = components.day;
                };
            };
            case (#Err(error)) {
                throw Error.reject("Failed to get current date: " # debug_show (error));
            };
        };
    };

    // Calculate difference between dates in days
    private func dateDifference(date : Types.Date) : async Int {
        let current = await currentDate();
        let totalDays1 = date.year * 365 + date.month * 30 + date.day;
        let totalDays2 = current.year * 365 + current.month * 30 + current.day;
        totalDays2 - totalDays1;
    };

    // Format relative time in the past
    public func timeAgo(date : Types.Date, style : Types.RelativeTimeStyle) : async Types.FormattingResult {
        try {
            let diff = await dateDifference(date);
            let text = switch (style, diff) {
                case (#Calendar, 0) { "Today" };
                case (#Calendar, 1) { "Yesterday" };
                case (#Calendar, d) {
                    if (d <= 7) Text.concat(Int.toText(d), " days ago") else "Invalid date";
                };
                case (#Numeric, d) {
                    if (d > 0) Text.concat(Int.toText(d), " days ago") else "Invalid date";
                };
                case (#AutoStyle, 0) { "Today" };
                case (#AutoStyle, 1) { "Yesterday" };
                case (#AutoStyle, d) {
                    if (d > 1) Text.concat(Int.toText(d), " days ago") else "Invalid date";
                };
            };
            #Ok(text);
        } catch (e) {
            #Err(#InvalidDate("Error calculating time ago: " # Error.message(e)));
        };
    };

    // Format relative time in the future
    public func timeUntil(date : Types.Date, style : Types.RelativeTimeStyle) : async Types.FormattingResult {
        try {
            let diff = -(await dateDifference(date));
            let text = switch (style, diff) {
                case (#Calendar, 0) { "Today" };
                case (#Calendar, 1) { "Tomorrow" };
                case (#Calendar, d) {
                    if (d <= 7) Text.concat("In ", Text.concat(Int.toText(d), " days")) else "Invalid date";
                };
                case (#Numeric, d) {
                    if (d > 0) Text.concat("In ", Text.concat(Int.toText(d), " days")) else "Invalid date";
                };
                case (#AutoStyle, 0) { "Today" };
                case (#AutoStyle, 1) { "Tomorrow" };
                case (#AutoStyle, d) {
                    if (d > 1) Text.concat("In ", Text.concat(Int.toText(d), " days")) else "Invalid date";
                };
            };
            #Ok(text);
        } catch (e) {
            #Err(#InvalidDate("Error calculating time until: " # Error.message(e)));
        };
    };

    // Format date according to locale
    public func toLocaleString(date : Types.Date, locale : Types.Locale) : async Types.FormattingResult {
        try {
            let text = switch (locale.language) {
                case "en" {
                    Text.concat(
                        Text.concat(
                            Text.concat(
                                Text.concat(
                                    Text.concat(
                                        Int.toText(date.year),
                                        "-",
                                    ),
                                    Int.toText(date.month),
                                ),
                                "-",
                            ),
                            Int.toText(date.day),
                        ),
                        "",
                    );
                };
                case "fr" {
                    Text.concat(
                        Text.concat(
                            Text.concat(
                                Text.concat(
                                    Text.concat(
                                        Int.toText(date.day),
                                        "/",
                                    ),
                                    Int.toText(date.month),
                                ),
                                "/",
                            ),
                            Int.toText(date.year),
                        ),
                        "",
                    );
                };
                case _ {
                    return #Err(#InvalidFormat("Unsupported locale"));
                };
            };
            #Ok(text);
        } catch (e) {
            #Err(#InvalidFormat("Error formatting date: " # Error.message(e)));
        };
    };
};
