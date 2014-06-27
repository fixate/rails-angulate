class Person
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :email, :id_number, :secret_pattern, :custom_message,
    :age, :odd_number, :even_number, :only_integer

  validates :name, :email, presence: true
  validates :email, email: true
  validates_length_of :name, minimum: 5, maximum: 20
  validates_length_of :id_number, is: 10
  validates_format_of :secret_pattern, with: /\A[A-Z][a-z]*\z/
  validates_presence_of :custom_message, message: 'This is a custom validation message!'
  validates_numericality_of :age, greater_than: 18, less_than: 120
  validates_numericality_of :odd_number, odd: true
  validates_numericality_of :even_number, even: true
  validates_numericality_of :only_integer, only_integer: true


  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
