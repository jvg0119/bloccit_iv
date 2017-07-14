namespace :seed do

  desc "seeds questions"
  task questions: :environment do  # sets environment for Question Resource
    Question.destroy_all # cleans databast
    ActiveRecord::Base.connection.reset_pk_sequence!('questions') # resets db id

    # start creating questions:
    1.upto(20) do |x|
      Question.create!(title: "My Question Title number #{x}.",
                        body: "my question body number #{x}.",
                        resolved: [true,false,false].sample
                        )
    end

    puts "".center(40,"*")
    puts
    puts "Finish seeding".center(40)
    puts "#{Question.count} = questions created".center(40)
    puts
    puts "".center(40,"*")

  end # seeds questions

end

# rake -T               list of rake tasks
# rake seed:questions   runs this task
# runs independent of the regular seed task 
