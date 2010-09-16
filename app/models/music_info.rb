class MusicInfo < ActiveRecord::Base
  belongs_to :download
  has_one :content, :as => :attachable_info

end
