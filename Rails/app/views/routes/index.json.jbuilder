json.array!(@routes) do |route|
  json.extract! route, :name, :stop_id
  json.url route_url(route, format: :json)
end