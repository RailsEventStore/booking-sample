module Booking
  class DaySchedule
    CannotReserve = Class.new(StandardError)
    CannotRelease = Class.new(StandardError)

    def initialize(allowed_time_range)
      @reserved_slots = Set.new
      @allowed_time_range = allowed_time_range
    end

    def reserve(time_range)
      cannot_reserve unless allowed_time_range.cover?(time_range)
      cannot_reserve if reserved_slots.any?(cover?(time_range))
      reserved_slots.add(time_range)
      visit_scheduled(time_range)
    end

    def release(time_range)
      reserved_slots.delete?(time_range) or cannot_release
      visit_released(time_range)
    end

    private

    attr_reader :reserved_slots, :allowed_time_range

    def visit_scheduled(time_range)
      ScheduleReserved.new(
        data: {
          scheduled_at: time_range.first,
          duration: time_range.last - time_range.first
        }
      )
    end

    def visit_released(time_range)
      ScheduleReleased.new(
        data: {
          scheduled_at: time_range.first,
          duration: time_range.last - time_range.first
        }
      )
    end

    def cover?(time_range)
      ->(slot) { slot.cover?(time_range.first) || slot.cover?(time_range.last) }
    end

    def cannot_reserve
      raise CannotReserve
    end

    def cannot_release
      raise CannotRelease
    end
  end
end
