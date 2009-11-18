class PodcastPage < Page

  description %{
    Podcast pages render as an rss feed in the standard podcast format and are suitable
    for listing in the itunes store and other aggregators.
  }
  
  def self.sphinx_indexes
    []
  end
  
  def layout
    Layout.find(layout_id)
  rescue ActiveRecord::RecordNotFound
    rss_layout = Layout.find_by_name('RSS') || Layout.create!({:name => 'RSS', :content_type => 'application/rss+xml', :content => '<r:content />'})
    update_attribute(:layout_id, rss_layout.id) if rss_layout
    rss_layout
  end

end