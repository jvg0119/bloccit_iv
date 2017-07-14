require 'random_data'

# Post.destroy_all

# create posts
50.times do
  Post.create!(
  title: RandomData.random_sentence,
  body: RandomData.random_paragraph
  )
end

posts = Post.all

# create comments
100.times do
  Comment.create!(
  body: RandomData.random_paragraph,
  post: posts.sample
  )
end

# create questions
1.upto(20) do |x|
  Question.create!(title: "My Question Title number #{x}.",
                    body: "my question body number #{x}.",
                    resolved: [true,false,false].sample
                    )
end

puts "".center(40,"*")
puts
puts "Finish seeding".center(40)
puts "#{Post.count} = posts created".center(40)
puts "#{Comment.count} = comments created".center(40)
puts "#{Question.count} = questions created".center(40)
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
