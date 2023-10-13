module Booking
  class StateMachine
    INITIAL = Data.define

    def initialize(states, on_error)
      @states = states
      @current_state = INITIAL

      states.each_key do |state|
        define_singleton_method "to_#{state}" do
          on_error.call unless valid_transition?(state)
          @current_state = state
        end
      end
    end

    private

    attr_reader :current_state

    def valid_transition?(next_state)
      if current_state == INITIAL
        @states.keys.first == next_state
      else
        @states.fetch(current_state).include?(next_state)
      end
    end
  end
end
