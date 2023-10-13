module Booking
  class Appointment
    Error = Class.new(StandardError)

    def initialize(id, clock:)
      @id = id
      @clock = clock
      @state = StateMachine.new(%w[proposed accepted rejected])
    end

    def propose
      invalid_state unless @state.initial?
      @state.to_proposed
      AppointmentProposed.new(data: { id: @id, proposed_at: @clock.call })
    end

    def accept
      invalid_state unless @state.proposed?
      @state.to_accepted
      AppointmentAccepted.new(data: { id: @id, accepted_at: @clock.call })
    end

    def reject
      invalid_state unless @state.proposed?
      @state.to_rejected
      AppointmentRejected.new(data: { id: @id, rejected_at: @clock.call })
    end

    def cancel
      invalid_state unless @state.accepted? || @state.proposed?
      AppointmentCancelled.new(data: { id: @id, cancelled_at: @clock.call })
    end

    private

    def invalid_state
      raise Error
    end
  end
end
