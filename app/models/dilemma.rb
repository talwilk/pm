class Dilemma < ActiveRecord::Base
  belongs_to :user, -> { with_deleted }
  belongs_to :favorite_dilemma_advice, class_name: "DilemmaAdvice", foreign_key: "favorite_dilemma_advice_id"

  has_many :media, as: :mediable, dependent: :destroy, inverse_of: :mediable
  has_many :advices, class_name: 'DilemmaAdvice', dependent: :destroy
  has_many :user_points_logs, as: :gamificable

  accepts_nested_attributes_for :media, allow_destroy: true

  acts_as_paranoid
  acts_as_taggable_on :categories

  validates_with CategoryListValidator
  validates_presence_of :media
  validates :category_list, presence: true
  validates :title, presence: true, length:{ maximum: DILEMMA_TITLE }
  validate :count_without_html_tags

  def count_without_html_tags
    desc = ActionController::Base.helpers.strip_tags(description)

    unless desc.length <= DILEMMA_DESCRIPTION
      errors.add(:description, _('Description is too long (max. %{length} chars)') % { length: DILEMMA_DESCRIPTION })
      return false
    end
  end

  def to_param
    if permalink.present?
      "#{id}-#{permalink}"
    else
      id
    end
  end
end
