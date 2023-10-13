require "test_helper"

module Booking
  class AppointmentTest < ActiveSupport::TestCase
    cover Appointment

    test "propose" do
      appointment = new_appointment
      assert_event appointment_proposed, appointment.propose
    end

    test "cannot propose twice" do
      appointment = new_appointment
      appointment.propose

      assert_raises(Appointment::Error) { appointment.propose }
    end

    test "accept" do
      appointment = new_appointment
      appointment.propose

      assert_event appointment_accepted, appointment.accept
    end

    test "cannot accept without proposal" do
      appointment = new_appointment
      assert_raises(Appointment::Error) { appointment.accept }
    end

    test "cannot accept twice" do
      appointment = new_appointment
      appointment.propose
      appointment.accept

      assert_raises(Appointment::Error) { appointment.accept }
    end

    test "reject" do
      appointment = new_appointment
      appointment.propose

      assert_event appointment_rejected, appointment.reject
    end

    test "cannot reject without proposal" do
      appointment = new_appointment
      assert_raises(Appointment::Error) { appointment.reject }
    end

    test "cannot reject twice" do
      appointment = new_appointment
      appointment.propose
      appointment.reject

      assert_raises(Appointment::Error) { appointment.reject }
    end

    test "cannot reject after accept" do
      appointment = new_appointment
      appointment.propose
      appointment.accept

      assert_raises(Appointment::Error) { appointment.reject }
    end

    test "cannot accept after reject" do
      appointment = new_appointment
      appointment.propose
      appointment.reject

      assert_raises(Appointment::Error) { appointment.accept }
    end

    test "cannot propose after reject" do
      appointment = new_appointment
      appointment.propose
      appointment.reject

      assert_raises(Appointment::Error) { appointment.propose }
    end

    test "cannot propose after accept" do
      appointment = new_appointment
      appointment.propose
      appointment.accept

      assert_raises(Appointment::Error) { appointment.propose }
    end

    test "cancel proposed appointment" do
      appointment = new_appointment
      appointment.propose

      assert_event appointment_cancelled, appointment.cancel
    end

    test "cancel accepted appointment" do
      appointment = new_appointment
      appointment.propose
      appointment.accept

      assert_event appointment_cancelled, appointment.cancel
    end

    test "cannot cancel rejected appointment" do
      appointment = new_appointment
      appointment.propose
      appointment.reject

      assert_raises(Appointment::Error) { appointment.cancel }
    end

    test "cannot cancel without proposal" do
      appointment = new_appointment
      assert_raises(Appointment::Error) { appointment.cancel }
    end

    private

    def appointment_id
      "appointment_id"
    end

    def current_time
      Time.at(0)
    end

    def frozen_clock
      -> { current_time }
    end

    def new_appointment
      Appointment.new(appointment_id, clock: frozen_clock)
    end

    def appointment_proposed
      AppointmentProposed.new(
        data: {
          id: appointment_id,
          proposed_at: current_time
        }
      )
    end

    def appointment_accepted
      AppointmentAccepted.new(
        data: {
          id: appointment_id,
          accepted_at: current_time
        }
      )
    end

    def appointment_rejected
      AppointmentRejected.new(
        data: {
          id: appointment_id,
          rejected_at: current_time
        }
      )
    end

    def appointment_cancelled
      AppointmentCancelled.new(
        data: {
          id: appointment_id,
          cancelled_at: current_time
        }
      )
    end
  end
end
