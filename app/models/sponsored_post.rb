class SponsoredPost < ActiveRecord::Base
	belongs_to :topic, dependent: :destroy
end
