class Question < ActiveRecord::Base
  validates :poll_id, :text, presence: true

  before_destroy :destroy_answer_choices


  has_many(
    :answer_choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id
  )

  belongs_to(
    :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id
  )

  def results
    answer_choices_with_count = self
      .answer_choices
      .select("answer_choices.*, COUNT(*) AS response_count")
      .joins(:responses)
      .group("answer_choices.id")

    answer_choices_with_count.each.with_object({}) do |ac, results|
      results[ac.text] = ac.response_count
    end
  end

  def destroy_answer_choices
    self.answer_choices.map(&:destroy!)
  end

end