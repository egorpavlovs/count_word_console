require "arachnid2"
require "nokogiri"
require 'uri'
require 'fileutils'
require "lemmatizer"
class SiteService
  class << self

    L_DOCS_HOME_PATH = 'docs'

    def set_site(url)
      content = start_crawling(url)
    end

    def start_crawling(url)
      spider = Arachnid2.new(url)
        responses = []
        doc_dir = "docs"

        spider.crawl(max_urls: 2000, timeout: 10, time_box: 1000) { |response|
          responses << Nokogiri::HTML(response.body)
          print '*'
        }

        responses.each_with_index do |response, index|
          response_directory_name = "response_#{index}"
          # path = [doc_dir, folder_name, response_directory_name].join('/')
          # FileUtils.mkdir_p(path)
          element = response.elements.last
          element.search("//style|//script").remove
          content = element.content
          host = URI(url).host
          lemming(content, "response_#{index}", host)
          # l_path = FileUtils.mkdir_p([L_DOCS_HOME_PATH, host, "response_#{index}"].join("/"))
          # File.open([l_path, "content.txt"].join("/"), "w") {|file| file.puts(element.content)}
        end
    end

    def lemming(content, folder_name, host)
        # all_paths = Dir["#{DOCS_HOME_PATH}/#{folder_name}/*/*/"]
        # words = all_paths.map do |path|
          # print '*'
          # content = File.open([path, "content.txt"].join("/"), "r", encoding: 'ISO-8859-1:UTF-8'){ |f| f.read }
          stop_words = File.open("stop_words", "r"){ |f| f.read }.split("\n")
          lem = Lemmatizer.new
          tokenize_words_lemm = tokenize(content, stop_words).map { |word| lem.lemma(word) unless word.nil? }.compact

          l_path = FileUtils.mkdir_p([L_DOCS_HOME_PATH, host, folder_name].join("/"))
          # puts l_path
          tokenize_words_lemm.each{ |word|
            File.open([l_path, "content.txt"].flatten.join("/"), "a") {|file| file.puts(word)}
          }
        # end
      # end
    end

    def tokenize(content, stop_words)
      numbers = content.scan(/\d+/)
      result = content.split(/\W+/) - numbers
      result.map{ |word| word.downcase if word.size > 1 && word.gsub(/\d+/,"") == word && !stop_words.include?(word) }
    end
  end
end