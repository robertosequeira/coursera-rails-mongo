json.array!(@api_races) do |api_race|
  json.extract! api_race, :id
  json.url api_race_url(api_race, format: :json)
end
