# frozen_string_literal: true
require 'levenshtein'

class Solver

  def parse(file_path)
    candidate_hash = Hash.new(0)

    File.foreach(file_path) do |line|
      candidate_name = line[/candidate: ([^\r,]+)/, 1]
      candidate_hash[candidate_name] += 1
    end
    candidate_hash
  end

  def solve(file_path)
    uniq_candidates = parse(file_path)
    answer_hash = Hash.new(0)
    temp_key, temp_value = uniq_candidates.shift
    answer_hash[temp_key] = temp_value
    uniq_candidates.each do |candidate, votes|
      flag = true
      answer_hash.each do |name, all_votes|
        if flag && (Levenshtein.distance(candidate, name) <= 3)
          flag = false
          answer_hash[name] += votes
        end
      end
      if flag
        answer_hash[candidate] += votes
      end
    end
    answer_hash
  end

  def bad_guy_finder(file_path)

  end
end

# sorts this by value order
candidate_names = Solver.new.solve("votes_21.txt").sort_by { |k, v| -v }.to_h
candidate_names.each do |candidate, votes|
  puts candidate + " " + votes.to_s
end
puts candidate_names.length
sum = 0
candidate_names.each do |candidate, votes|
  sum += votes
end
puts sum.to_s + " all votes"