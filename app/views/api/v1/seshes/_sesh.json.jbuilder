json.id             @sesh.id

json.info do |info|
  info.title        @sesh.title
end

json.assets do |assets|
  assets.audio_url  @sesh.audio.url
end

unless @sesh.is_anonymous
  json.author do |author|
    author.id         @sesh.author.id
    author.username   @sesh.author.username
  end
end
