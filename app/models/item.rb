class Item < ActiveRecord::Base
	has_many :minutes
	has_many :meetings, through: :minutes
	belongs_to :minst
	# :number, :date, :standard, :clause, :subject, :draft
	validates :number, presence: true, format: { with: /\A\d{4}\z/, message: "must be 4 decimal digits" }
	validates :date, presence: true
	validates :standard, presence: true, length: { in: 3..50 }
	validates :subject, presence: true, length: { maximum: 200 }, unless: "Rails.application.config.importing"
	before_save {
		lastminute = self.minutes.where("minutes.DATE is not null").joins(:meeting).order("meetings.DATE").last;
		self.minst = lastminute.minst unless lastminute.nil?
	}

	CLOSED_CODES = ["P", "J", "W"]
	scope :closed, ->   { joins(:minst).where("minsts.code IN (?)", CLOSED_CODES) }
	scope :open,   ->   { joins(:minst).where.not("minsts.code IN (?)", CLOSED_CODES)  }
	scope :review, ->   { joins(:minst).where.not("minsts.code IN (?)", CLOSED_CODES + ["V"])  }

	def is_closed?
		self.minst && (CLOSED_CODES.include? self.minst.code)
	end
end
