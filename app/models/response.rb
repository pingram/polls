class Response < ActiveRecord::Base
  validates :answer_choice_id, :user_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :respondent_cannot_respond_to_own_poll

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
    unless respondent.questions_answered.empty?
      if respondent.questions_answered.pluck(:id).include?(question.id)
        errors[:base] << "You have already responded to that question!"
      end
    end
  end

  def respondent_cannot_respond_to_own_poll

    # query = <<-SQL
#       SELECT
#         answer_choices.id
#       FROM
#         polls
#       JOIN
#         questions
#       ON
#         questions.poll_id=polls.id
#       JOIN
#         answer_choices
#       ON
#         answer_choices.question_id = questions.id
#       WHERE
#         polls.author_id = #{respondent.id}
#     SQL

    answer_choice_ids = AnswerChoice.select("answer_choices.id")
                        .joins( :question, {:question => :poll} )
                        .where("polls.author_id = #{respondent.id}")

    if answer_choice_ids.map(&:id).include?(answer_choice_id)
      errors[:base] << "Stop rigging your poll!"
    end

  end
end