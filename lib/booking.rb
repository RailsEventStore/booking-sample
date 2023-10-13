module Booking
  Event = Data.define(:data, :event_type) do
    def initialize(data: Hash.new)
      super(data: data, event_type: self.class.name)
    end
  end

  ScheduleReleased = Class.new(Event)
  ScheduleReserved = Class.new(Event)

  AppointmentProposed = Class.new(Event)
  AppointmentAccepted = Class.new(Event)
  AppointmentRejected = Class.new(Event)
  AppointmentCancelled = Class.new(Event)
end
