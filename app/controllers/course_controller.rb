class CourseController < ApplicationController
  def show
    @title = params[:id]
    @datas = Hash.new
    puts(@title)
    course_idx = Course.find_by(title: @title).id
    records = SalesRecord.all

    records.each do |record|
      if record.course_id == course_idx 
         @datas[record.created_date] = record.revenue
      end
    end
    @datas = Hash[@datas.sort]
    @datas = @datas.drop(1)
  end
end