class DaySchedule
  CannotReserve = Class.new(StandardError)

  def initialize
    @reserved_slots = Set.new
  end

  def reserve(time_range)
    cannot_reserve if reserved_slots.any?(covers?(time_range))
    reserved_slots << time_range
    visit_scheduled(time_range)
  end

  private
  attr_reader :reserved_slots

  def visit_scheduled(time_range)
    VisitScheduled.new(data: {
      scheduled_at: time_range.first,
      duration: time_range.last - time_range.first
    })
  end

  def covers?(time_range)
    ->(slot) { slot.cover?(time_range.first) || slot.cover?(time_range.last) }
  end

  def cannot_reserve
    raise CannotReserve.new
  end
end
