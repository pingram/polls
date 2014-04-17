class Response < ActiveRecord::Base
  validates :answer_choice_id, :user_id, presence: true
  validate :respondent_has_not_already_answered_question

  belongs_to(
    :respondent,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )

  belongs_to(
    :answer_choice,
    class_name: "AnswerChoice",
    foreign_key: :answer_choice_id,
    primary_key: :id
  )

  has_one :question, through: :answer_choice, source: :question

  private
  def respondent_has_not_already_answered_question
    if respondent.questions_answered.pluck(:id).include?(question.id)
      errors[:base] << "You have already responded to that question!"
    end
  end
end