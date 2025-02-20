import Text "mo:base/Text";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Types "../types/Types";

module DateFormat {
  
  private let DAYS_IN_MONTH = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  private let _WEEKDAYS : [Text] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

  private func isLeapYear(year : Int) : Bool {
    (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0);
  };

  private func _getDaysInMonth(year : Int, month : Int) : Types.Result<Int> {
    if (month < 1 or month > 12) {
      return #Err(#InvalidDate("Month must be between 1 and 12"));
    };

    let days = if (month == 2 and isLeapYear(year)) {
      29;
    } else {
      DAYS_IN_MONTH[Int.abs(month - 1)];
    };
    #Ok(days);
  };

  public func formatDate(date : Types.Date, format : Types.DateFormat) : Types.FormattingResult {

    let y = Int.toText(date.year);
    let m = if (date.month < 10) "0" # Int.toText(date.month) else Int.toText(date.month);
    let d = if (date.day < 10) "0" # Int.toText(date.day) else Int.toText(date.day);

    let formatted = switch format {
      case (#ISO) { y # "-" # m # "-" # d };
      case (#Short) { m # "/" # d # "/" # y };
      case (#Long) { d # "-" # m # "-" # y };
      case (#Custom(_pattern)) {
        return #Err(#InvalidFormat("Custom format not implemented"));
      };
    };
    #Ok(formatted);

  };

  public func toISOFormat(date : Types.Date) : Types.FormattingResult {
    formatDate(date, #ISO);
  };

  public func getDayOfYear(date : Types.Date) : Types.CalendarResult<Int> {

    var dayCount = date.day;
    for (i in Iter.range(0, date.month - 2)) {
      dayCount += DAYS_IN_MONTH[i];
    };
    if (date.month > 2 and isLeapYear(date.year)) {
      dayCount += 1;
    };
    #Ok(dayCount);

  };

  public func getWeekday(date : Types.Date) : Types.WeekDayResult {

    let y = if (date.month < 3) { date.year - 1 } else { date.year };
    let m = if (date.month < 3) date.month + 12 else date.month;
    let K = y % 100;
    let J = y / 100;
    let h = (date.day + (13 * (m + 1) / 5) + K + (K / 4) + (J / 4) + (5 * J)) % 7;

    switch (h) {
      case 0 { #Ok(#Saturday) };
      case 1 { #Ok(#Sunday) };
      case 2 { #Ok(#Monday) };
      case 3 { #Ok(#Tuesday) };
      case 4 { #Ok(#Wednesday) };
      case 5 { #Ok(#Thursday) };
      case 6 { #Ok(#Friday) };
      case _ { #Err(#InvalidDate("Invalid weekday calculation")) };
    };

  };
};
