class PodcastBits < ActiveRecord::Migration

  def self.up
    Layout.create :name => 'podcast', :content_type => 'application/xml+rss', :content => "<r:content />" unless Layout.find_by_name('podcast')
    Radiant::Config['assets.additional_thumbnails'] = Radiant::Config['assets.additional_thumbnails'] + ", itunes=1024x1024#" unless Radiant::Config['assets.additional_thumbnails'] =~ /itunes/
  end

  def self.down
    
  end
  
end
