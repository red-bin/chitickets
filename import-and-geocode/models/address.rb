class Address < ActiveRecord::Base

  def get_hash_key_unique
    return "#{self.number}__#{self.street}"
  end

  def get_hash_key_street
    
  end
end