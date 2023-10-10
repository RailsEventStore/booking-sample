require "test_helper"

module Booking
  class DayScheduleTest < ActiveSupport::TestCase
    cover DaySchedule

    test "happy path" do
      day_schedule = DaySchedule.new(open_hours)

      assert_event visit_scheduled(at_12_00..at_13_00),
                   day_schedule.reserve(at_12_00..at_13_00)
    end

    test "cannot reserve same slot twice" do
      day_schedule = DaySchedule.new(open_hours)
      day_schedule.reserve(at_12_00..at_13_00)

      assert_raises DaySchedule::CannotReserve do
        day_schedule.reserve(at_12_00..at_13_00)
      end
    end

    test "cannot reserve partially covered slot" do
      day_schedule = DaySchedule.new(open_hours)
      day_schedule.reserve(at_12_00..at_13_00)

      assert_raises DaySchedule::CannotReserve do
        day_schedule.reserve(at_12_45..at_13_45)
      end
    end

    test "cannot reserve partially covered slot, again" do
      day_schedule = DaySchedule.new(open_hours)
      day_schedule.reserve(at_12_00..at_13_00)

      assert_raises DaySchedule::CannotReserve do
        day_schedule.reserve(at_11_45..at_12_45)
      end
    end

    test "can reserve non-intersecting slots" do
      day_schedule = DaySchedule.new(open_hours)
      day_schedule.reserve(at_12_00..at_12_45)

      assert_event visit_scheduled(at_13_00..at_13_45),
                   day_schedule.reserve(at_13_00..at_13_45)
    end

    test "cannot reserve outside of open hours" do
      day_schedule = DaySchedule.new(open_hours)
      open_at, close_at = open_hours.first, open_hours.last

      assert_raises { day_schedule.reserve(open_at..(close_at + 1.hour)) }
    end

    private

    def open_hours
      at_11_00..at_19_00
    end

    def visit_scheduled(time_range)
      VisitScheduled.new(
        data: {
          scheduled_at: time_range.first,
          duration: time_range.last - time_range.first
        }
      )
    end

    def at_11_00
      Time.new(2023, 10, 10, 11, 00)
    end

    def at_11_45
      Time.new(2023, 10, 10, 11, 45)
    end

    def at_12_00
      Time.new(2023, 10, 10, 12, 00)
    end

    def at_12_45
      Time.new(2023, 10, 10, 12, 45)
    end

    def at_13_00
      Time.new(2023, 10, 10, 13, 00)
    end

    def at_13_45
      Time.new(2023, 10, 10, 13, 45)
    end

    def at_19_00
      Time.new(2023, 10, 10, 19, 00)
    end
  end
end
