json.info do |info|
  info.username     @user.username
end

if @user_authenticated
  json.seshes @user.seshes do |sesh|
    @sesh = sesh
    json.partial! 'api/v1/seshes/sesh'
  end
else
  json.seshes @user.public_seshes do |sesh|
    @sesh = sesh
    json.partial! 'api/v1/seshes/sesh'
  end
end
