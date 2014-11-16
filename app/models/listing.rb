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
end


#I MAY HAVE TO CHANGE IF ELSE STATEMENT SOMEHOW