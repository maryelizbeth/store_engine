class Product < ActiveRecord::Base
  attr_accessible :description, :photo_url, :price, :title, :product_category_ids, :active
  
  has_many :categorizations 
  has_many :product_categories, :through => :categorizations
  has_many :cart_products
  has_many :cart, :through => :cart_products

  validates_presence_of :title, :description
  validates_uniqueness_of :title 
  validates :price, :numericality => { :greater_than => 0 }, :presence => true
  validates :photo_url, :allow_blank => true, :format => { :with => /^(https?:\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?(?:png|jpe?g|gif|svg))$/ }

  DEFAULT_IMAGE_PATH = "/assets/no_image.jpg"

  def thumbnail
    unless photo_url.nil? || photo_url.blank?
      photo_url
    else
      DEFAULT_IMAGE_PATH
    end
  end

  def has_photo?
    !photo_url.blank?
  end

  def display_price
    # number_with_precision(self.price, :precision => 2)
    "%.2f" % self.price
  end
end
