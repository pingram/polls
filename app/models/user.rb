class User < ActiveRecord::Base
  validates :user_name, presence: true, uniqueness: true

  has_many(
    :authored_polls,
    class_name: "Poll",
    foreign_key: :author_id,
    primary_key: :id
  )

  has_many(
    :responses,
    class_name: "Response",
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many :questions_answered, through: :responses, source: :question

  def completed_polls

    # all the polls that we've answered a question in, plus the questions we've answered!

    query = <<-SQL
    SELECT
    polls.*, COUNT(*) AS q_count
    FROM
    polls
    JOIN
    questions
    ON
    polls.id = questions.poll_id
    JOIN
    answer_choices AS ac
    ON
    ac.question_id = questions.id
    JOIN
    responses
    ON
    responses.answer_choice_id = ac.id
    WHERE
    responses.user_id = #{self.id}
    GROUP BY
    polls.id
    SQL

    answered_polls = Poll.find_by_sql(query)

    # all the polls with their question count!

    poll_questions = Poll.all.includes(:questions)

    poll_questions.each.with_object([]) do |pq, completed|
      ans_pol = answered_polls.select {|poll| poll.id == pq.id}.first
      if !ans_pol.nil? && pq.questions.length == ans_pol.q_count
        completed << pq
      end
    end

    # for each poll, we want to get the questions

  end

  def uncompleted_polls
    Poll.all - self.completed_polls
  end

end