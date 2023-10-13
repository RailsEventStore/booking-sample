module Booking
  ScheduleReleased = Class.new(RailsEventStore::Event)
  ScheduleReserved = Class.new(RailsEventStore::Event)

  AppointmentProposed = Class.new(RailsEventStore::Event)
  AppointmentAccepted = Class.new(RailsEventStore::Event)
  AppointmentRejected = Class.new(RailsEventStore::Event)
  AppointmentCancelled = Class.new(RailsEventStore::Event)
end
