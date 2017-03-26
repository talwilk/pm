class CategoryListValidator < ActiveModel::Validator
  def validate(record)
    if record.category_list.present?
      record.category_list.each do |tag|
        record.errors.add(tag,I18n.t("category_not_valid")) unless SupportedCategory.all.include?(tag)
      end
    end
  end
end
