import Types "../types/Types";
import Iter "mo:base/Iter";
import Int "mo:base/Int";

module Comparision {
  public func compare(date1 : Types.Date, date2 : Types.Date) : Types.ComparisonResult {
    {
      isBefore = isBefore(date1, date2);
      isAfter = isAfter(date1, date2);
      isEqual = isEqual(date1, date2);
    };
  };

  public func isBefore(date1 : Types.Date, date2 : Types.Date) : Bool {
    if (date1.year < date2.year) return true;
    if (date1.year > date2.year) return false;
    if (date1.month < date2.month) return true;
    if (date1.month > date2.month) return false;
    date1.day < date2.day;
  };

  public func isAfter(date1 : Types.Date, date2 : Types.Date) : Bool {
    if (date1.year > date2.year) return true;
    if (date1.year < date2.year) return false;
    if (date1.month > date2.month) return true;
    if (date1.month < date2.month) return false;
    date1.day > date2.day;
  };

  public func isEqual(date1 : Types.Date, date2 : Types.Date) : Bool {
    date1.year == date2.year and date1.month == date2.month and date1.day == date2.day
  };

  public func dateDifference(date1 : Types.Date, date2 : Types.Date, unit : Types.TimeUnit) : Int {
    let yDiff = date2.year - date1.year;
    let mDiff = (date2.year * 12 + date2.month) - (date1.year * 12 + date1.month);
    let dDiff = daysBetween(date1, date2);

    switch (unit) {
      case (#Year) { yDiff };
      case (#Month) { mDiff };
      case (#Day) { dDiff };
      case _ { 0 };
    };
  };

  public func getDifference(date1 : Types.Date, date2 : Types.Date) : Types.DateDifference {
    {
      years = dateDifference(date1, date2, #Year);
      months = dateDifference(date1, date2, #Month);
      days = dateDifference(date1, date2, #Day);
    };
  };

  private func daysBetween(date1 : Types.Date, date2 : Types.Date) : Int {
    let daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    var totalDays1 = date1.year * 365 + date1.day;
    var totalDays2 = date2.year * 365 + date2.day;

    // Add days for months
    for (i in Iter.range(0, date1.month - 2)) {
      totalDays1 += daysInMonth[i];
    };
    for (i in Iter.range(0, date2.month - 2)) {
      totalDays2 += daysInMonth[i];
    };

    // Add leap years
    totalDays1 += leapYearsCount(date1.year);
    totalDays2 += leapYearsCount(date2.year);

    totalDays2 - totalDays1;
  };

  private func leapYearsCount(year : Int) : Int {
    year / 4 - year / 100 + year / 400;
  };
};
