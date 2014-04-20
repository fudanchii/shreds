json.array!(@users) do |user|
  json.extract! user, :id, :username, :email, :token, :provider_id
  json.url user_url(user, format: :json)
end
