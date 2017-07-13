require 'random_data'

# create posts
50.times do
  Post.create!(
  title: RandomData.random_sentence,
  body: RandomData.random_paragraph
  )
end
unique_post = Post.find_or_create_by!(title: "my unique title", body: "my unique body")

posts = Post.all

# create comments
100.times do
  Comment.create!(
  body: RandomData.random_paragraph,
  post: posts.sample
  )
end

Comment.find_or_create_by!(body: "my unique comment", post: unique_post)

unique_post_count = Post.where(title:"my unique title", body: "my unique body").count
unique_comment_count =  Comment.all.where(body: "my unique comment").count

puts "".center(40,"*")
puts
puts "Finish seeding".center(40)
puts "#{Post.count} = posts created".center(40)
puts "#{Comment.count} = comments created".center(40)
puts
puts "#{unique_post_count} = unique post".center(40)
puts "#{unique_comment_count} = unique comment".center(40)
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
