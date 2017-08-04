class Label < ApplicationRecord

  has_many :labelings

  has_many :topics, through: :labelings, source: :labelable, source_type: :Topic

  has_many :posts, through: :labelings, source: :labelable, source_type: :Post



  # def self.update_labels(label_string)
  #   array_label = []
  #   label_string.split(',').map do |label|
  #     array_label << label.strip
  #   end
  #   array_label
  # end


  def self.update_labels(label_string)

     return Label.none if label_string.blank? # if string is empty it outputs an empty array

    # label_string.split(',') splits the string on ',' and creates an array
    # map iterates through the array
     label_string.split(",").map do |label|
    # Label.find_or_create_by!(name: label.strip)
    # Label.find_or_create_by!(name: label)
    # Label.create(name: "...") creates the label
    # .find_or_create_by   prevents any duplications
    # label.strip removes spaces
      Label.find_or_create_by!(name: label.strip)
     end
   end



end
