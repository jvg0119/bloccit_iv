require 'random_data'

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
  topic: topics.sample
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

# sponsored_post
1.upto(100) do |x|
  SponsoredPost.create(
  title: RandomData.random_sentence,
  body: RandomData.random_paragraph,
  price: rand(25..50),
  topic: topics.sample
  )
end



puts "".center(40,"*")
puts
puts "Finish seeding".center(40)
puts "#{Topic.count} = topics created".center(40)
puts "#{Post.count} = posts created".center(40)
puts "#{Comment.count} = comments created".center(40)
puts "#{SponsoredPost.count} = sponsored posts created".center(40)
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
