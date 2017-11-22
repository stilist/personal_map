// @param [<Date, string>] targetStart - The time to validate.
// @param [<Date, string>] targetEnd - The time to validate.
// @param [<Date, string>] rangeStart - The start of the valid time range.
// @param [<Date, string>] rangeEnd - The end of the valid time range.
export default function isInTimeRange (targetStart, targetEnd, rangeStart, rangeEnd) {
  if (!targetStart) return false
  if (!targetEnd) return false
  if (!rangeStart) return false
  if (!rangeEnd) return false

  // @see https://stackoverflow.com/a/143568/672403
  return new Date(rangeStart) <= new Date(targetEnd) &&
         new Date(rangeEnd) >= new Date(targetStart)
}
