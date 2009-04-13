class PodcastContext < ActiveRecord::Migration

  def self.up
    Layout.create :name => 'Podcast', :content_type => 'application/rss+xml', :content => "<r:content />" unless Layout.find_by_name('Podcast')
    Radiant::Config['assets.additional_thumbnails'] = Radiant::Config['assets.additional_thumbnails'] + ", itunes=1024x1024#" unless Radiant::Config['assets.additional_thumbnails'] =~ /itunes/
  end

  def self.down
    
  end
  
end
