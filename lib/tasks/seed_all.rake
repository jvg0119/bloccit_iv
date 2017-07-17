namespace :seed do

  desc "Seeds posts"
  task all: :environment do

    # cleans db & resets id
    Topic.destroy_all
    ActiveRecord::Base.connection.reset_pk_sequence!('topics')
    ActiveRecord::Base.connection.reset_pk_sequence!('posts')
    ActiveRecord::Base.connection.reset_pk_sequence!('comments')
    ActiveRecord::Base.connection.reset_pk_sequence!('sponsored_posts')

    # create topics
    1.upto(15) do |x|
      Topic.create!(
      name: "My Topic Name number: #{x}",
      description: "this is the topic description for topic number: #{x}",
      )
    end
    topics = Topic.all

    # create posts
    50.times do |x|
      Post.create!(
      title: "My Post Title number: #{x}",
      body: "this is the post body for post number: #{x}",
      topic: topics.sample
      )
    end
    posts = Post.all

    # create comments
    100.times do |x|
      Comment.create!(
      body: "this is a comment body number #{x}",
      post: posts.sample
      )
    end

    # sponsored_post
    1.upto(100) do |x|
      SponsoredPost.create(
      title: "Sponsored Post Title number #{x}",
      body: "sponsored post body number #{x}",
      price: rand(25..50)

      topic: topics.sample
      )
    end

    puts "".center(40,"*")
    puts
    puts "Finish seeding".center(40)
    puts "#{Topic.count} = topics created".center(40)
    puts "#{Topic.first.id} = SponsoredPost.id".center(40)
    puts "#{Post.count} = posts created".center(40)
    puts "#{Post.first.id} = SponsoredPost.id".center(40)
    puts "#{Comment.count} = comments created".center(40)
    puts "#{Comment.first.id} = SponsoredPost.id".center(40)
    puts "#{SponsoredPost.count} = sponsored_posts created".center(40)
    puts "#{SponsoredPost.first.id} = SponsoredPost.id".center(40)
    puts "".center(40,"*")



  end
end



# to create the file w/ generator
# bin/rails g task seed_all
# edit namespace  from seed_all to seed
# add desc (description)
# add tast (name of task) and :environment (this will add the rails resource environments)
# do & end
# add your seed codes inside the do/end block

# bin/rake -T          list all rake tasks
# bin/rake seed:all    run this task
