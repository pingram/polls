# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

joe = User.create!(user_name: "joe_schmoe")
jill = User.create!(user_name: "jill_schmoe")
andre = User.create!(user_name: "andre_the_giant")
gov = User.create!(user_name: "the_government")

poll1 = Poll.create!(title: "Soda Pop Poll", author_id: gov.id)
poll2 = Poll.create!(title: "Super Heroes Poll", author_id: gov.id)
poll3 = Poll.create!(title: "WTF Heredocs???", author_id: andre.id)

#SODA POP QUESTIONS
q1 = Question.create!(poll_id: poll1.id, text: "Where are you from?")
q2 = Question.create!(poll_id: poll1.id,
text: "What is the correct term for a sweet, bubbly, non-alcoholic beverage?")

#SUPERHERO QUESITONS
q3 = Question.create!(poll_id: poll2.id, text: "Who is your favorite super hero?")
q4 = Question.create!(poll_id: poll2.id,
  text: <<-Q
    If the government could create your favorite super hero from stem cells,
    would you support stem cell research?
  Q
)

#HEREDOC (SUPERHERO) QUESTIONS
q5 = Question.create!(poll_id: poll3.id,
  text: <<-Q
    If you have a heredoc, do you need to indent the text?
  Q
)
q6 = Question.create!(poll_id: poll3.id,
  text: <<-Q
    If you have a heredoc, where should you close the parenthese?
  Q
)


#ANSWER CHOICES
ac1 = AnswerChoice.create!(question_id: q1.id, text: "Chicago")
ac2 = AnswerChoice.create!(question_id: q2.id, text: "Pop")
ac3 = AnswerChoice.create!(question_id: q1.id, text: "New Mexico")
ac4 = AnswerChoice.create!(question_id: q2.id, text: "Coke")

ac5 = AnswerChoice.create!(question_id: q3.id, text: "Ironman")
ac6 = AnswerChoice.create!(question_id: q4.id, text: "I know you already have!")

ac7 = AnswerChoice.create!(question_id: q5.id, text: "Yes")
ac8 = AnswerChoice.create!(question_id: q6.id, text: "No idea")


#RESPONSES
Response.create!(answer_choice_id: ac1.id, user_id: joe.id)
Response.create!(answer_choice_id: ac2.id, user_id: joe.id)
Response.create!(answer_choice_id: ac3.id, user_id: andre.id)
Response.create!(answer_choice_id: ac4.id, user_id: andre.id)

Response.create!(answer_choice_id: ac5.id, user_id: jill.id)
Response.create!(answer_choice_id: ac6.id, user_id: jill.id)

Response.create!(answer_choice_id: ac7.id, user_id: joe.id)
Response.create!(answer_choice_id: ac8.id, user_id: joe.id)

Response.create!(answer_choice_id: ac1.id, user_id: jill.id)
