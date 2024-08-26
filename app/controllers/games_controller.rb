require 'open-uri'
require 'json'

class GamesController < ApplicationController
  VOWELS = ['a', 'e', 'i', 'o', 'u']
  def new
    @letters = VOWELS
    @letters += Array.new(5) { (('a'..'z').to_a - VOWELS).sample }
    @letters.shuffle!
  end
  def score
    @letters = params[:letters].chars
    @word = params[:word]
    url = "https://dictionary.lewagon.com/#{@word}"

    response = URI.open(url).read
    data = JSON.parse(response)

    if spelt?(@word, @letters)
      if (data["found"])
        @message = "Congratulations! #{@word.upcase} is a valid English word!"
      else
        @message = "Sorry but #{@word.upcase} does not to be a valid English word..."
      end
    else
      @message = "Sorry but #{@word.upcase} can't be built out of #{@letters.join(', ').upcase}."
    end
  end

  private
  def spelt?(word, letters)
    word_letters = word.chars
    letters = letters.tally
    word_letters.all? do |letter|
      if letters[letter] && letters[letter] > 0
        letters[letter] -= 1
      else
        false
      end
    end
  end
end
