import Text "mo:base/Text";
import Int "mo:base/Int";
import Iter "mo:base/Iter";

module DateFormatting {
  private let daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  private let weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

  private func isLeapYear(year : Int) : async Bool {
    (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0);
  };

  private func _daysInGivenMonth(year : Int, month : Int) : async Int {
    let isLeap = await isLeapYear(year);
    if (month == 2 and isLeap) { 29 } else {
      daysInMonth[Int.abs(month - 1)];
    };
  };

  public func formatDate(year : Int, month : Int, day : Int, format : Text) : async Text {
    let y = Int.toText(year);
    let m = if (month < 10) "0" # Int.toText(month) else Int.toText(month);
    let d = if (day < 10) "0" # Int.toText(day) else Int.toText(day);
    switch format {
      case "YYYY-MM-DD" { y # "-" # m # "-" # d };
      case "MM/DD/YYYY" { m # "/" # d # "/" # y };
      case "DD-MM-YYYY" { d # "-" # m # "-" # y };
      case _ { "Invalid Format" };
    };
  };

  public func toISOFormat(year : Int, month : Int, day : Int) : async Text {
    await formatDate(year, month, day, "YYYY-MM-DD");
  };

  public func getWeekday(year : Int, month : Int, day : Int) : async Text {
    let y = if (month < 3) { year - 1 } else { year };
    let m = if (month < 3) month + 12 else month;
    let K = y % 100;
    let J = y / 100;
    let h = (day + (13 * (m + 1) / 5) + K + (K / 4) + (J / 4) + (5 * J)) % 7;
    weekdays[Int.abs(h)];
  };

  public func getDayOfYear(year : Int, month : Int, day : Int) : async Int {
    var dayCount = day;
    for (i in Iter.range(0, month - 2)) {
      dayCount += daysInMonth[i];
    };
    let isLeap = await isLeapYear(year);
    if (month > 2 and isLeap) {
      dayCount += 1;
    };
    dayCount;
  };
};
