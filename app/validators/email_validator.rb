class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present?
      existing_user = User.find_by(email: value)
      if existing_user && existing_user.id != record.id
        record.errors.add(attribute, 'has already been taken')
      end
    else
      record.errors.add(attribute, 'can\'t be blank')
    end
  end
end

ActiveRecord::Base.send(:include, ActiveModel::Validations::HelperMethods)
ActiveRecord::Base.send(:include, EmailValidator)
