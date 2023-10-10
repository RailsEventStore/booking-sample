require "test_helper"

class DayScheduleTest < ActiveSupport::TestCase
  test "happy path" do
    day_schedule = DaySchedule.new

    assert_event visit_scheduled(at_12_00..at_13_00),
                 day_schedule.reserve(at_12_00..at_13_00)
  end

  test "cannot reserve same slot twice" do
    day_schedule = DaySchedule.new
    day_schedule.reserve(at_12_00..at_13_00)

    assert_raises DaySchedule::CannotReserve do
      day_schedule.reserve(at_12_00..at_13_00)
    end
  end

  test "cannot reserve partially covered slot" do
    day_schedule = DaySchedule.new
    day_schedule.reserve(at_12_00..at_13_00)

    assert_raises DaySchedule::CannotReserve do
      day_schedule.reserve(at_12_45..at_13_45)
    end
  end

  test "can reserve non-intersecting slots" do
    day_schedule = DaySchedule.new
    day_schedule.reserve(at_12_00..at_12_45)

    assert_event visit_scheduled(at_13_00..at_13_45),
                 day_schedule.reserve(at_13_00..at_13_45)
  end

  private

  def visit_scheduled(time_range)
    VisitScheduled.new(
      data: {
        scheduled_at: time_range.first,
        duration: time_range.last - time_range.first
      }
    )
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
end
