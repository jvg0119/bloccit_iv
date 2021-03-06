module RandomData
  def self.random_paragraph
    sentences = []
    rand(4..6).times do
      sentences << random_sentence
    end
    sentences.join(" ")
  end

  def self.random_sentence
    strings = []
    rand(3..8).times do
      strings << random_word
    end
    sentence = strings.join(" ")
    sentence.capitalize << "."
  end

  def self.random_word
    letters = ('a'..'z').to_a
    letters.shuffle!
    letters[0,rand(3..8)].join
  end

  def self.random_name
    "#{random_word.capitalize} #{random_word.capitalize}"
  end

  def self.random_email
    "#{random_word}@#{random_word}.com"
  end

# OK but longer
  # def self.random_name
  #   string = []
  #   2.times do
  #     string << random_word.capitalize
  #   end
  #   name = string.join(" ")
  # end
  #
  # def self.random_email
  #   string = []
  #   2.times do
  #     string << random_word
  #   end
  #   email = "#{string.join("@")}.com"
  # end

end



#test random generator on console
# 5.times do
#   puts RandomData.random_paragraph
# end

# puts RandomData.random_sentence
# puts RandomData.random_paragraph

# puts RandomData.random_word

# puts RandomData.random_name
# puts RandomData.random_email
