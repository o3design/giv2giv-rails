# formerly 'endowment'
class CharityGroup < ActiveRecord::Base
  has_many :donations
  has_and_belongs_to_many :charities

  validates :name, :presence => true,
                   :uniqueness => { :case_sensitive => false }
  validates :charities, :length => { :minimum => 1, :message => 'must have 1 or more charities' }


  class << self
    def new_with_charities(options = {})
      charity_ids = options.delete(:charity_ids) || []
      group = CharityGroup.new(options)

      charity_ids.each do |cid|
        group.charities << Charity.find!(cid) # FIXME find(array_of_ids) doesnt currently work
      end

      group
    end
  end # end self

  def as_json(options = {})
    super(:include =>[:charities])
  end

  def add_charity(new_charity_id)
    charity = Charity.find(new_charity_id)
    self.charities << charity
    self.charities
  end



end
