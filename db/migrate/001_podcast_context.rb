class PodcastContext < ActiveRecord::Migration

  def self.up
    if Radiant::Config['assets.additional_thumbnails']
      Radiant::Config['assets.additional_thumbnails'] = Radiant::Config['assets.additional_thumbnails'] + ", itunes=1024x1024#" unless Radiant::Config['assets.additional_thumbnails'] =~ /itunes/
    end
  end

  def self.down
    
  end
  
end
