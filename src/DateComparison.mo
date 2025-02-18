import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Int "mo:base/Int";
import Bool "mo:base/Bool";

module DateComparison {

  public func isBefore(year1 : Int, month1 : Int, day1 : Int, year2 : Int, month2 : Int, day2 : Int) : async Bool {
    if (year1 < year2) return true;
    if (year1 > year2) return false;
    if (month1 < month2) return true;
    if (month1 > month2) return false;
    return day1 < day2;
  };

  public func isAfter(year1 : Int, month1 : Int, day1 : Int, year2 : Int, month2 : Int, day2 : Int) : async Bool {
    if (year1 > year2) return true;
    if (year1 < year2) return false;
    if (month1 > month2) return true;
    if (month1 < month2) return false;
    return day1 > day2;
  };

  public func isEqual(year1 : Int, month1 : Int, day1 : Int, year2 : Int, month2 : Int, day2 : Int) : async Bool {
    return (year1, month1, day1) == (year2, month2, day2);
  };

  public func dateDifference(year1 : Int, month1 : Int, day1 : Int, year2 : Int, month2 : Int, day2 : Int, unit : Text) : async Int {
    let yDiff = year2 - year1;
    let mDiff = (year2 * 12 + month2) - (year1 * 12 + month1);
    let dDiff = await daysBetween(year1, month1, day1, year2, month2, day2);

    switch unit {
      case "years" { yDiff };
      case "months" { mDiff };
      case "days" { dDiff };
      case _ { 0 }; // Default case for invalid input
    };
  };

  // Helper function to calculate days between two dates (naive approach, does not consider leap years accurately)
  private func daysBetween(y1 : Int, m1 : Int, d1 : Int, y2 : Int, m2 : Int, d2 : Int) : async Int {
    let daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    var totalDays1 = y1 * 365 + d1;
    var totalDays2 = y2 * 365 + d2;

    for (i in Iter.range(0, m1 - 2)) { totalDays1 += daysInMonth[i] };
    for (i in Iter.range(0, m2 - 2)) { totalDays2 += daysInMonth[i] };

    return totalDays2 - totalDays1;
  };
};
