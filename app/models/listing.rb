class Listing < ActiveRecord::Base
	if Rails.env.development?
		has_attached_file :image, :styles => { :medium => "200x>", :thumb => "100x100>" }, :default_url => "imageNotFound.jpg"
		validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	else
		has_attached_file :image, :styles => { :medium => "200x>", :thumb => "100x100>" }, :default_url => "imageNotFound.jpg", 
						  :storage => :dropbox,
				    	  :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
				    	  :path => ":style/:id_:filename"
		validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	end

	validates :name, :subject, :number, :condition, :price, presence: true
	validates :number, numericality: {greater_than: 99, less_than: 1000}
	validates :price, numericality: {greater_than: 15, less_than: 200}	
	validates_attachment_presence :image


	belongs_to :user	
	has_many :orders   	
end