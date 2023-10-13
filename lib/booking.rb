module Booking
  ScheduleReleased = Data.define(:scheduled_at, :duration)
  ScheduleReserved = Data.define(:scheduled_at, :duration)

  AppointmentProposed = Data.define(:id, :proposed_at)
  AppointmentAccepted = Data.define(:id, :accepted_at)
  AppointmentRejected = Data.define(:id, :rejected_at)
  AppointmentCancelled = Data.define(:id, :cancelled_at)
end
