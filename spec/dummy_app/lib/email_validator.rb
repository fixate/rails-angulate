class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.nil? || value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors.add(attribute, :email, (options[:message] || "is not an email"))
    end
  end
end

