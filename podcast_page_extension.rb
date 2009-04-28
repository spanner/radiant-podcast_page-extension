# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class PodcastPageExtension < Radiant::Extension
  version "0.1"
  description "Makes it easy to render an iTunes-compatible podcast rss feed"
  url "http://spanner.org/radiant/podcast_page"
  
  # define_routes do |map|
  #   map.namespace :admin, :member => { :remove => :get } do |admin|
  #     admin.resources :podcast
  #   end
  # end
  
  def activate
    PodcastPage
    Page.send :include, PodcastTags
  end
  
  def deactivate
    # admin.tabs.remove "Podcast"
  end
  
end
