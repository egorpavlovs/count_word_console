require "lemmatizer"
class WordsService
  class << self
    DOCS_HOME_PATH = 'docs'
    RESULTS_HOME_PATH = 'results'

    def check_count(words_line)
      lem = Lemmatizer.new

      words = words_line.split(" ")
      words = words.map{|word| lem.lemma(word)}
      p words
      all_folders = Dir["#{DOCS_HOME_PATH}/*"].map{|e| e.split("/").last}
      all_folders.each do |folder_name|
        file_name = Time.now.to_s
        File.open([RESULTS_HOME_PATH, file_name].join('/'), 'a') {|f| f.puts("\n\n#{folder_name}:") }
        words.each do |word|
          files = Dir["#{DOCS_HOME_PATH}/#{folder_name}/*/*"]
          count = 0
          files.each do |file|
            words_from_file = File.read(file).force_encoding('iso-8859-1').split(/[ ,\n\t]/)
            count += words_from_file.count{ |element| element.downcase == word }
          end
          File.open([RESULTS_HOME_PATH, file_name].join('/'), 'a') {|f| f.puts("#{word}: #{count}") }
        end
      end
    end
  end
end