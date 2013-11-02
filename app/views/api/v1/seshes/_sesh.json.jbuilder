json.id                 @sesh.id

json.info do |info|
  info.title            @sesh.title
  info.favorites_count  @sesh.favoriters_count
  info.listens_count    @sesh.listens_count
end

json.comments           @sesh.comments

json.assets do |assets|
  assets.audio_url      @sesh.audio.url
end

unless @sesh.is_anonymous
  json.author do |author|
    author.id           @sesh.author.id
    author.username     @sesh.author.username
  end
end
