require 'set'

class WordChainer
  
  def initialize(dictionary_file_name)
    @dictionary = Set.new
    File.foreach(dictionary_file_name) { |line| @dictionary.add(line.chomp) }
  end

  def adjacent_words(word)
    adjacent = []
    length = word.length
    @dictionary.each do |elem|
      if elem.length == length
        count = 0
        elem.each_char.with_index do |char, idx|
          count += 1 if char == word[idx]
        end
        adjacent << elem if count == length - 1
      end
    end
    adjacent
  end

  def explore_current_words
    new_current_words = []
    @current_words.each do |current_word|
      adjacent_words(current_word).each do |adj_word|
        if !@all_seen_words.include?(adj_word)
          new_current_words << adj_word
          @all_seen_words[adj_word] = current_word
        end
      end
    end
    # new_current_words.each do |word|
    #   puts "#{word} => #{@all_seen_words[word]}"
    # end
    new_current_words
  end

  def build_path(target)
    path = [target]
    last_word = @all_seen_words[target]
    if last_word == nil
      return path + [nil]
    else
      return path + build_path(last_word)
    end
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = { source => nil }
    until @all_seen_words.has_key?(target) || @current_words.empty?
      new_current_words = explore_current_words
      @current_words = new_current_words
    end
    build_path(target)[0...-1].reverse!
  end

end


# Testing
my_chain = WordChainer.new("dictionary.txt")
puts my_chain.run("duck", "ruby")
