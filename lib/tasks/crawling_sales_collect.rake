namespace :crawling_sales_collect do
  desc "TODO"
  task crawling_sales_collect: :environment do
    def change_price_to_int(p)
      if p.length == 2
          p = p[1]
      elsif p.length == 1
          p = p[0]
      end
  
      if p == '무료'
          return 0
      end
  
      p = p.split(//)
      s = ''
      p.each do |alpha|
          if alpha.ord >= 48 && alpha.ord <= 57
              s += alpha
          end
      end
  
      return s.to_i
    end

    require 'open-uri'
    require 'nokogiri'

    base_url = 'https://www.inflearn.com/courses/it-programming/'
    page_query = ['?page=', '&order=seq']

    now = Time.now()
    current_date = now.strftime('%Y-%m-%d')

    doc = Nokogiri::HTML(open(base_url)) # 노코기리 파서로 HTML 형태로 분류한 형태의 데이터를 doc 변수에 저장
    page_count = doc.css('a.pagination-link')[-1].text # it-programming 카테고리의 페이지 수

    (1 .. page_count.to_i).each do |page_number| # 페이지별 반복
      printf('페이지: ')
      puts(page_number)
      page_url = base_url + page_query[0] + (page_number.to_s) + page_query[1] # 페이지별 URL
  
      datas = Nokogiri::HTML(open(page_url)) # 한 페이지의 강의를 모두 불러옴
      card_list = datas.css('div.column.is-3-fullhd.is-3-widescreen.is-4-desktop.is-4-tablet.is-6-mobile')
  
      # 강의 별로 강의명, 링크, 수강생 수, 가격 불러옴
      card_list.each do |card|
          title = card.at_css('div.course_title').text.strip 
          title = title.delete'.'
          #printf('강좌명 :')
          #puts(title)
  
          link = card.css('a')[0]["href"]
          #printf('링크 :')
          #puts(link)
  
          student_count = card.css('div.student_num.column.is-half').text
          student_count = (student_count[0, student_count.length - 1]).to_i
          #printf('학생수 :')
          #puts(student_count)
  
          course_price = card.css('div.price.has-text-right.column.is-half').text.split()
          course_price = change_price_to_int(course_price).to_i
          #printf('가격 :')
          #puts(course_price)
          course_idx = Course.find_by(key_link: link)
          if(course_idx == nil) # 새로운 강좌인 경우
            Course.create( 
              :key_link => link,
              :title => title,
              :total_count => student_count,
              :created_date => current_date
            )
            SalesRecord.create(
              :course_id => Course.last.id,
              :price => course_price,
              :daily_sales => student_count,
              :revenue => student_count * course_price,
              :created_date => current_date
            )
          else # 이미 있는 강좌의 경우
            course_idx = course_idx.id
            before_student_count = Course.find(course_idx).total_count

            if before_student_count != student_count # 수강생 수가 증가한 경우
              daily_sales = student_count - before_student_count

              # 같은 날짜의 기록이 존재하는지 체크
                record_idx = SalesRecord.find_by(course_id: course_idx, created_date: current_date)

                if(record_idx == nil) # 같은 날짜 기록이 없다면 
                  SalesRecord.create(
                    :course_id => course_idx,
                    :price => course_price,
                    :daily_sales => daily_sales,
                    :revenue => course_price * daily_sales,
                    :created_date => current_date
                  )
                    
                else # 같은 날짜 기록이 있다면
                  record_idx = record_idx.id
                  # 같은 날짜의 SalesRecord 업데이트
                    s = SalesRecord.find(record_idx)
                    s.daily_sales = s.daily_sales + daily_sales
                    s.revenue =  s.revenue + s.price * daily_sales
                    s.save
                end

                c = Course.find(course_idx)
                c.total_count = student_count
                c.save
            end # 수강생 수가 증가 
          end # 새로운 강좌 or 이미 있는 강좌 
      end # 카드별 반복 
    end # 1.. page별 반복
  end

end
