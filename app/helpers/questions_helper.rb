module QuestionsHelper

  def status(resolved)
    if resolved == true
      "Yes"
    else
      "No"
    end
  end

end
