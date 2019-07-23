Rails.application.routes.draw do
  root 'sales_record_controller#index'
  get '/sales_record/:id' => 'sales_record_controller#show',as:'daily_sales_by_course'
  get '/course/show/:id' => 'course#show', as:'course_sales_by_date'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end