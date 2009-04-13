class PodcastPage < Page

  description %{
    Podcast pages render as an rss feed in the standard podcast format and are suitable
    for listing in the itunes store and other aggregators.
  }
  
  def set_defaults
    layout = Layout.find_by_name('Podcast') || Layout.create!({:name => 'Podcast', :content_type => 'application/rss+xml', :content => '<r:content />'})
    logger.warn "!!! setting podcast page layout to #{podcast_layout.id}"
    update_attribute(:layout_id, podcast_layout.id) if podcast_layout && layout_id != podcast_layout.id
  end

end