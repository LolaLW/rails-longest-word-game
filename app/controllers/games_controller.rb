require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # The new action will be used to display a new random grid and a form
    @letters = []
    @letters = ('A'..'Z').to_a.split.sample(10)
  end

  def score
    # The form will be submitted (with POST) to the score action
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def score_and_message(attempt, grid, time)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        score = compute_score(attempt, time)
        [score, "well done"]
      else
        [0, "not an english word"]
      end
    else
      [0, "not in the grid"]
    end
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
