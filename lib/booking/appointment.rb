module Booking
  class Appointment
    Error = Class.new(StandardError)

    def initialize(id, clock:)
      @id = id
      @clock = clock
      @state =
        StateMachine.new(
          {
            proposed: %i[accepted rejected cancelled],
            accepted: [:cancelled],
            rejected: [],
            cancelled: []
          },
          method(:invalid_transition)
        )
    end

    def propose
      @state.to_proposed
      AppointmentProposed.new(id: @id, proposed_at: @clock.call)
    end

    def accept
      @state.to_accepted
      AppointmentAccepted.new(id: @id, accepted_at: @clock.call)
    end

    def reject
      @state.to_rejected
      AppointmentRejected.new(id: @id, rejected_at: @clock.call)
    end

    def cancel
      @state.to_cancelled
      AppointmentCancelled.new(id: @id, cancelled_at: @clock.call)
    end

    private

    def invalid_transition
      raise Error
    end
  end
end
