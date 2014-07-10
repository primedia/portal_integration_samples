class User
  attr_accessor :email

  def initialize(email)
    @email = email
  end

  def self.find(email)
    new(email)
  end
end
