export function getRoundedFutureDateTimeLocalString(minutesAhead: number): string {
  const now = new Date();
  now.setSeconds(0, 0); // Clear seconds and ms
  now.setMinutes(now.getMinutes() + minutesAhead);

  // Round to the next 30-minute mark
  const minutes = now.getMinutes();
  const roundedMinutes = minutes < 30 ? 30 : 0;
  if (roundedMinutes === 0) {
    now.setHours(now.getHours() + 1);
  }
  now.setMinutes(roundedMinutes);

  return now.toISOString().slice(0, 16); // YYYY-MM-DDTHH:MM
}
