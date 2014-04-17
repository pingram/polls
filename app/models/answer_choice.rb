class AnswerChoice < ActiveRecord::Base
  validates :question_id, :text, presence: true
  before_destroy :destroy_responses

  belongs_to(
    :question,
    class_name: "Question",
    foreign_key: :question_id,
    primary_key: :id
  )

  has_many(
    :responses,
    class_name: "Response",
    foreign_key: :answer_choice_id,
    primary_key: :id
  )

  def destroy_responses
    self.responses.map(&:destroy!)
  end

end