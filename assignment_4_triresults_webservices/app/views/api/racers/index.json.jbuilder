json.array!(@api_racers) do |api_racer|
  json.extract! api_racer, :id
  json.url api_racer_url(api_racer, format: :json)
end
