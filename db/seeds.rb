require 'json'
def genre_relationships(n_game, genres)
  return if genres == nil
  begin
    genres.each{ |genre| n_game.genres << Genre.find_by(name: genre) }
  rescue
    p "Genre relationship not created for #{n_game}"
  end
end
def platform_relationships(n_game, platforms)
  return if platforms == nil
  begin
    platforms.each{ |platform| n_game.platforms << Platform.find_by(name: platform["name"]) }
  rescue
    p "Platform relationship not created for #{n_game}"
  end
end
def involved_companies_relationships(n_game, involved_companies)
  return if involved_companies == nil
  begin
    involved_companies.each do |involved_company|
      company = Company.find_by(name: involved_company["name"])
      InvolvedCompany.create( company: company, game: n_game, developer: involved_company["developer"], publisher: involved_company["publisher"] )
    end
  rescue
    p "Involved company relationship not created for #{n_game}"
  end
end
def game_relationships(n_game, game)
  genre_relationships(n_game, game["genres"])
  platform_relationships(n_game, game["platforms"])
  involved_companies_relationships(n_game, game["involved_companies"])
end
p "Seeding data ..."
companies = JSON.parse(File.read('db/companies.json'))
platforms = JSON.parse(File.read('db/platforms.json'))
genres = JSON.parse(File.read('db/genres.json'))
games = JSON.parse(File.read('db/games.json'))
p "Companies..."
companies.each do |company|
  n_company = Company.new(company)
  p "#{n_company} not created" unless n_company.save
end
p "Platforms..."
platforms.each do |platform|
  n_platform = Platform.new(platform)
  p "#{n_platform} not created" unless n_platform.save
end
p "Genres..."
genres["genres"].each do |genre|
  n_genre = Genre.new(name: genre)
  p "#{n_genre} not created" unless n_genre.save
end
p "Main games and relations..."
main_games = games.select { |game| game["parent"] == nil }
main_games.each do |game|
  n_game = Game.new(game.slice("name", "summary", "release_date", "category", "rating"))
  if n_game.save
    game_relationships(n_game, game)
  else
    p "#{n_game} not created"
  end
end
p "Expansion games and relations..."
expansion_games = games.select{ |game| game["parent"] != nil }
expansion_games.each do |game|
  game_data = game.slice("name", "summary", "release_date", "category", "rating")
  game_data["parent"] = Game.find_by(name: game["parent"])
  n_game = Game.new(game_data)
  if n_game.save
    game_relationships(n_game, game)
  else
    p "#{n_game} not created"
  end
end
p "Completed!"