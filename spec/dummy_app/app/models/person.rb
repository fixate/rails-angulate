class Person
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :email, :id_number, :secret_pattern, :custom_message,
    :age, :number, :odd_number, :even_number, :body, :no_validations, :multiple_custom_messages,
    :select_thing, :pet

  validates :name, :email, :body, presence: true
  validates :email, email: true
  validates_length_of :name, minimum: 5, maximum: 20
  validates_length_of :id_number, is: 10
  validates_format_of :secret_pattern, with: /\A[A-Z][a-z]*\z/
  validates_presence_of :custom_message, message: 'This is a custom validation message!'
  validates_numericality_of :age, greater_than: 18, less_than: 120
  validates_numericality_of :number, only_integer: true
  validates_numericality_of :odd_number, odd: true
  validates_numericality_of :even_number, even: true, only_integer: true
  validates :multiple_custom_messages,
    presence: { message: 'This is required son!' },
    numericality: { message: 'should be a number too' }

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end

    self.pet ||= Pet.new(attributes[:pet] || {})
  end

  # Allow Rails to pick up pet as a nested attribute
  def pet_attributes=(attrs)
    attrs.each do |name, value|
      pet.send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
