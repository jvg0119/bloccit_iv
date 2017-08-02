require 'random_data'

# create users
User.create!(
  name: "Joe",
  email: "joe@example.com",
  password: "password",
  role: "admin"
)
User.create!(
  name: "Member",
  email: "member@example.com",
  password: "password"
)
5.times do
  User.create!(
    name: RandomData.random_name,
    email: RandomData.random_email,
    password: RandomData.random_sentence
  )
end
users = User.all

# create topics
15.times do
  Topic.create!(
  name: RandomData.random_sentence,
  description: RandomData.random_paragraph,
  )
end
topics = Topic.all

# Post.destroy_all
# create posts
50.times do
  Post.create!(
  title: RandomData.random_sentence,
  body: RandomData.random_paragraph,
  topic: topics.sample,
  user: users.sample
  )
end
posts = Post.all

# create comments
# 100.times do
#   Comment.create!(
#   body: RandomData.random_paragraph,
#   post: posts.sample,
#   user: users.sample
#   )
# end

50.times do
  topics.sample.comments.find_or_create_by!(
  body: RandomData.random_paragraph,
  #post: posts.sample,
  user: users.sample
  )
end

50.times do
  posts.sample.comments.find_or_create_by!(
  body: RandomData.random_paragraph,
  #post: posts.sample,
  user: users.sample
  )
end





puts "".center(40,"*")
puts
puts "Finish seeding".center(40)
puts "#{User.count} = users created".center(40)
puts "#{User.admin.count} = admin users created".center(40)
puts "#{User.member.count} = member users created".center(40)
puts "#{Topic.count} = topics created".center(40)
puts "#{Post.count} = posts created".center(40)
puts "#{Comment.count} = comments created".center(40)
puts
puts "".center(40,"*")

# puts
# puts "=============================="
# puts "Post List:"
# Post.all.each do |post|
#   puts post.title
#   puts post.body
# end
#
# puts
# puts "=============================="
# puts "Comments List:"
# Comment.all.each do |comment|
#   puts comment.body
# end
