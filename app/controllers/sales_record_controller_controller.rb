class SalesRecordControllerController < ApplicationController
  def index
    record = SalesRecord.all
    @date_revenue = record.select([:created_date, :revenue]).group('created_date').sum(:revenue)
    @date_revenue = Hash[@date_revenue.sort]
  end

  def show
    @date = params[:id]
    @datas = Hash.new
    records = SalesRecord.all
    courses = Course.all.select(:title)
    
    records.each do |record|
      if record.created_date == @date
         @datas[courses.find(record.course_id).title] = record.revenue
      end
    end
    @datas = Hash[@datas.sort_by{|k, v| v}.reverse]
  end
end
