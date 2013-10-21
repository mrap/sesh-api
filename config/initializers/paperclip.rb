# Interpolations for Paperclip paths
# Source: https://github.com/thoughtbot/paperclip/wiki/Interpolations

# Sesh.title
Paperclip.interpolates :title do |attachment, style|
  attachment.instance.title
end

Paperclip::Attachment.default_options.update({
  :hash_secret => ENV['PAPERCLIP_HASH_SECRET']
})

