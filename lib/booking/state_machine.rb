module Booking
  class StateMachine
    def initialize(states)
      states.each do |state|
        define_singleton_method "#{state}?" do
          @state == state
        end

        define_singleton_method "to_#{state}" do
          @state = state
        end
      end
    end

    def initial?
      @state.nil?
    end
  end
end
