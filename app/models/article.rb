# frozen_string_literal: true

#  oo   .----.
#   \\ /  ___ \
#   (-)  / __) )
#    \ `-\____/--/
#     '---------'~~-~~-~~ ~~-~ -~~- - -  -
class Article < ApplicationRecord
  validates :title, :content, presence: true

  validates :title, uniqueness: { case_sensitive: false, message: 'must be unique' }
  # validate :title, format: { with: /^[a-zA-Z0-9]*$/, message: 'can only contain alphanumeric characters' } # not yet...

  validates :permalink, uniqueness: { case_sensitive: false, allow_nil: true, message: 'must be unique, if set' }

  before_validation :normalise_fields, on: [:create, :update]
  after_validation :set_permalink, on: [:create, :update]

  private

  def normalise_fields
    # FIXME: do stuff
  end

  def set_permalink
    self.permalink = SecureRandom.base58(4) if permalink.nil?
  end
end
