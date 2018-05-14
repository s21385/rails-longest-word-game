class GamesController < ApplicationController
  require 'json'
  require 'open-uri'

  ALPHABET = ("a".."z").to_a

  def letters_builder
    alphabet_sample = []
    number_of_ltrs = (8..15).to_a.sample
    number_of_ltrs.times do |l|
      letter_pick_index = (0..25).to_a.sample.to_i
      random_letter = ALPHABET[letter_pick_index]
      alphabet_sample << random_letter
    end
    return alphabet_sample
  end

  def new
    @letters = letters_builder
  end

  def score
    @word_guess = params[:word_guess]
    @letters = params[:letters_score].split
    @message = ""

    if grid_check == true && english_check == true
      @message = "Your score is #{score_result}."
    elsif grid_check == false
      @message = "Sorry but your word can't be built with #{ @letters.join }"
    elsif grid_check == true && english_check != true
      @message = "Sorry but #{@word_guess} is not an English word."
    end
  end

  def score_result
    if @word_guess.length <= 3
      @score = 3
    elsif @word_guess.length > 3 && @word_guess.length < 6
      @score = 5
    elsif @word_guess.length > 6
      @score = 10
    end
  end

  def grid_check
    answers = []
    @word_guess.split(//).each do |l|
      answers << @letters[0].split(//).include?(l).to_s
      answers.sort!
    end
    if answers[0] == "false"
      return false
    else
      return true
    end
  end

  def english_check
    url = "https://wagon-dictionary.herokuapp.com/#{@word_guess}"
    words = open(url).read
    word = JSON.parse(words)
    if word['found'] == true
      return true
    elsif word['found'] == false
      return false
    end
  end

end
