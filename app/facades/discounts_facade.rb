class DiscountsFacade
  def holidays
    holiday_data = HolidayService.new.holiday
    next_three = holiday_data[0..2]
    @holidays = next_three.map do |holiday|
      Holiday.new(holiday)
    end
  end
end
