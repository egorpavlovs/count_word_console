load 'site_service.rb'
load 'words_service.rb'

puts "Загрузить слова или сайт?"
variable = gets.chomp
if variable == "слова"
  if Dir['docs/*'].empty?
    puts "Сайты не добавлены"
  else
    puts "Вводи слова через пробел"
    WordsService.check_count(gets.chomp)
    puts "Слова посчитаны, проверь папку results"
  end
elsif variable == "сайт"
  puts "Введи сайт"
  SiteService.set_site(gets.chomp)
  puts "Сайт добавлен"
else
  puts "Не понял, запускай еще раз"
end
