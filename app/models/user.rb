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

    answered_q_ids = self.questions_answered.map(&:id) # !
    # have we answered every q in a poll?

    query = <<-SQL
    SELECT
    polls.*, COUNT(*) AS q_count
    FROM
    polls
    JOIN
    questions
    ON
    polls.id = questions.poll_id
    WHERE
    questions.id IN (#{answered_q_ids.map(&:to_s).join(', ')})
    GROUP BY
    polls.id
    SQL

    answered_polls = Poll.find_by_sql(query)

    answered_polls.map(&:q_count)

    poll_questions = Poll.all.includes(:questions)

    result = []

    poll_questions.each do |pq|
      ans_pol = answered_polls.select {|poll| poll.id == pq.id}.first
      if !ans_pol.nil? && pq.questions.length == ans_pol.q_count
        result << pq
      end
    end

    result

    # for each poll, we want to get the questions

  end

  def uncompleted_polls
    Poll.all - self.completed_polls
  end

end