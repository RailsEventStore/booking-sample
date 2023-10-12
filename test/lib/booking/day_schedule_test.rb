require "test_helper"

module Booking
  class DayScheduleTest < ActiveSupport::TestCase
    cover DaySchedule

    test "happy path" do
      day_schedule = DaySchedule.new(open_hours)

      assert_event visit_scheduled(slot), day_schedule.reserve(slot)
    end

    test "cannot reserve same slot twice" do
      day_schedule = DaySchedule.new(open_hours)
      day_schedule.reserve(slot)

      assert_raises DaySchedule::CannotReserve do
        day_schedule.reserve(slot)
      end
    end

    test "cannot reserve partially covered slot" do
      day_schedule = DaySchedule.new(open_hours)
      day_schedule.reserve(slot)

      assert_raises DaySchedule::CannotReserve do
        day_schedule.reserve(delay_by(45.minutes, slot))
      end
    end

    test "cannot reserve partially covered slot, again" do
      day_schedule = DaySchedule.new(open_hours)
      day_schedule.reserve(slot)

      assert_raises DaySchedule::CannotReserve do
        day_schedule.reserve(rush_by(15.minutes, slot))
      end
    end

    test "can reserve non-intersecting slots" do
      day_schedule = DaySchedule.new(open_hours)
      day_schedule.reserve(rush_by(1.hour, slot))

      assert_event visit_scheduled(slot), day_schedule.reserve(slot)
    end

    test "cannot reserve outside of open hours" do
      day_schedule = DaySchedule.new(open_hours)

      assert_raises { day_schedule.reserve(delay_by(1.hour, open_hours)) }
    end

    private

    def slot
      Time.new(2023, 10, 10, 12, 00)...Time.new(2023, 10, 10, 13, 00)
    end

    def open_hours
      Time.new(2023, 10, 10, 11, 00)...Time.new(2023, 10, 10, 19, 00)
    end

    def delay_by(seconds, slot)
      (slot.first + seconds)...(slot.last + seconds)
    end

    def rush_by(seconds, slot)
      (slot.first - seconds)...(slot.last - seconds)
    end

    def visit_scheduled(time_range)
      VisitScheduled.new(
        data: {
          scheduled_at: time_range.first,
          duration: time_range.last - time_range.first
        }
      )
    end
  end
end
