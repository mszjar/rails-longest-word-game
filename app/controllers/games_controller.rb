require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = Array.new(0)
    @letters << alphabet.sample(1) while @letters.size < 10
    @letters
  end

  def score
    start_time = Time.now
    @attempt = params[:attempt]
    @letters = params[:letters]
    # load_dictionary
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    dictionary_serialized = URI.open(url).read
    dictionary = JSON.parse(dictionary_serialized)
    # run_game
    @result = { score: 0, message: '', time: 0 }
    # check_word
    check = true
    @attempt.upcase.chars.each do |letter|
      if @letters.chars.include?(letter)
        @letters.chars.delete_at(@letters.index(letter))
      else
        check = false
      end
    end
    # run_game
    if dictionary['found'] && check
      @result = { score: 1 - @result[:time] + dictionary['length'], message: 'Well done!', time: Time.now - start_time }
    elsif check
      @result[:message] = 'Your word is not an english word'
    else
      @result[:message] = 'Your word is not in the grid'
    end
    @result
  end
end
