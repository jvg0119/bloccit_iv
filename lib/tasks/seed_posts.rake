namespace :seed do

  require 'random_data'

  desc "Seeds posts"
  task posts: :environment do

    Post.destroy_all
    #
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

    puts "".center(40,"*")
    puts
    puts "Finish seeding".center(40)
    puts "#{Post.count} = posts created".center(40)
    puts "#{Comment.count} = comments created".center(40)
    puts
    puts "".center(40,"*")


  end

end
