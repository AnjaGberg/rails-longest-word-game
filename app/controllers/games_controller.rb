require 'open-uri'
# this is a class
class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10).join(' ')
  end

  def score
    @grid = params[:token]
    @answer = params[:answer]
    if real_word(@answer) && correct_letters(@answer)
      @result = "Congratulations #{@answer} is a valid English word"
      @score = params[:answer].count('a-zA-Z')
    elsif correct_letters(@answer)
      @result = "Sorry but #{@answer} does not seam to be a valid English word"
      @score = 0
    else
      @result = "Sorry but #{@answer} can't be built out of #{@grid}"
      @score = 0
    end
    session_score(@score)
    @overall_score = session[:score]
  end

  def session_score(score)
    if session[:score].nil?
      session[:score] = score
    else
      session[:score] += score
    end
  end

  def correct_letters(query)
    letters_used = query.upcase.chars.tally
    letters_used.each do |key, value|
      next if @grid.count(key) >= value

      return false
    end
    true
  end

  def real_word(query)
    url = "https://wagon-dictionary.herokuapp.com/#{query}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    @realword = word['found']
  end
end
