class Tag < ApplicationRecord
  has_many :post_tag_relations
  has_many :posts, through: :post_tag_relations

  # validates :tag_name, uniqueness: { case_sensitive: true }, length: { maximum: 5 }
  validates :tag_name, uniqueness: true
end
