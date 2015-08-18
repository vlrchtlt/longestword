require 'open-uri'
require 'json'

attempt = "apple"

def generate_grid(grid_size)
  alphabet ="abcdefghijklmnopqrstuvwxyz"

  generated_grid = []
  for i in 1..grid_size
    letter = alphabet[rand(25)]
    generated_grid.push letter.upcase
    i += 1
  end
  return generated_grid
  # TODO: generate random grid of letters
end


def attempt_exists?(attempt)
  hash_result = hash_from_api_attempt(attempt)
  hash_result
  if hash_result["Error"] != nil
    return false
  else
    return true
  end
end


def score(attempt, start_time, end_time)
  return score_result = (attempt.length.fdiv(end_time - start_time)) * 10
end


def hash_from_api_attempt(attempt)
  api_url = "http://api.wordreference.com/0.8/80143/json/enfr/#{attempt}"
  open(api_url) do |stream|
    return hash = JSON.parse(stream.read)
  end
end


def translate_attempt(attempt)
  if attempt_exists?(attempt)
    hash_attempt = hash_from_api_attempt(attempt)
    hash_attempt["term0"]["PrincipalTranslations"]["0"]["FirstTranslation"]["term"]
  else
    return false
  end
end


def hash_letter_occurences(attempt)
 letters = attempt.downcase.chars
 letters.reduce(Hash.new(0)) do |hash, letter|
 hash[letter] += 1
 hash
end
end

def check_attempt_in_grid?(attempt, grid)
 frequency_attempt = hash_letter_occurences(attempt)
 frequency_grid = hash_letter_occurences(grid.join)
 frequency_attempt.all? { |letter, freq| freq <= frequency_grid[letter] }
end



def run_game(attempt, grid, start_time, end_time)
  result = {}
  if check_attempt_in_grid?(attempt, grid)
    if attempt_exists?(attempt) == true
      result[:translation] = translate_attempt(attempt)
      result[:score] = score(attempt, start_time, end_time)
      result[:message] = "well done"
      result[:time] = start_time - end_time
    else
    result[:translation] = nil
      result[:score] = 0
      result[:message] = "not an english word"
      result[:time] = start_time - end_time
    end
  else
      result[:translation] = "nil translation"
      result[:score] = 0
      result[:message] = "not in the grid"
      result[:time] = start_time - end_time
  end

  return result
  # TODO: runs the game and return detailed hash of result
end
