class Course < ApplicationRecord
    validates_uniqueness_of :key_link
end
