module Booking
  class Appointment
    Error = Class.new(StandardError)

    STATE = [
      PROPOSED = "proposed",
      ACCEPTED = "accepted",
      REJECTED = "rejected",
      CANCELLED = "cancelled"
    ]

    def initialize(id, clock:)
      @id = id
      @clock = clock
    end

    def propose
      invalid_state if @state
      @state = PROPOSED
      AppointmentProposed.new(data: { id: @id, proposed_at: @clock.call })
    end

    def accept
      invalid_state unless @state == PROPOSED
      @state = ACCEPTED
      AppointmentAccepted.new(data: { id: @id, accepted_at: @clock.call })
    end

    def reject
      invalid_state unless @state == PROPOSED
      @state = REJECTED
      AppointmentRejected.new(data: { id: @id, rejected_at: @clock.call })
    end

    def cancel
      invalid_state unless [PROPOSED, ACCEPTED].include?(@state)
      AppointmentCancelled.new(data: { id: @id, cancelled_at: @clock.call })
    end

    private

    def invalid_state
      raise Error
    end
  end
end
