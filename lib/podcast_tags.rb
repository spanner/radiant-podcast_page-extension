module PodcastTags
  include Radiant::Taggable
  require 'rss/maker'
  require 'rss/itunes'
  
  class TagError < StandardError; end

  desc %{
    For a podcast built from page assets, all you need is this:
  
    <pre><code><r:podcast /></code></pre>
    
    Or perhaps some of:
    
    <pre><code><r:podcast [title=""] [author=""] [keywords="comma,separated"] [link=""] [category="slash/filed"] /></code></pre>
    
    To add to the podcast, just attach an audio asset to the page. To change the sequence, reorder the assets. To add a fuller description, create a 'description' page part or expand the tag:
    
    <pre><code><r:podcast>Songs about hopping</r:podcast></code></pre>

    To combine lots of pages - a whole blog, for example - into one feed, do this:
    
    <pre><code><r:find url="/blog"><r:podcast title="blogmusic" from="children" /></r:find></code></pre>
    
  }
  tag 'podcast' do |tag|
    raise TagError, "can't have a podcast without a page" unless page = tag.locals.page
    base_url = "http://" + (Page.respond_to?(:current_site) ? Page.current_site.base_domain : Radiant::Config['site.url']) + ':3000'
    # base_url = "#{base_url}/" unless base_url.match(/\/$/)
    
    defaults = {
      'title' => page.title,
      'subtitle' => "",
      'author' => page.created_by.name,
      'email' => page.created_by.email,
      'keywords' => page.keywords,
      'language' => 'en-US',
      'category' => 'Society &amp; Culture',
      'copyright' => "",
      'image' => "",
      'explicit' => false,
      'link' => base_url
    }
    defaults.each {|k,v| tag.attr[k] ||= v}
    
    if tag.double?
      tag.attr['description'] ||= tag.expand
    elsif page.part(:description)
      tag.attr['description'] ||= page.render_part(:description)
    end
    tag.attr['description'] ||= "No description found."
    
    if i = page.assets.images.first
      tag.attr['image'] = base_url + i.thumbnail(:itunes)
    end
    
    tag.locals.episodes = []
    
    if tag.attr['from'] == 'children'
      tag.attr['link'] ||= page.url     # normally we are referring to another html page with children here by way of an r:find tag
      tag.locals.page.children.each do |child|
        description = child.part(:description) ? child.render_part( :description ) : child.render_part( :body )
        child.assets.each do |a|
          if a.audio? or a.movie?
            tag.locals.episodes.push({
              :title => child.title,
              :subtitle => a.caption,
              :description => description || a.caption, 
              :link => base_url + a.asset.url, 
              :file_size => a.asset_file_size, 
              :file_type => a.asset_content_type, 
              :date => child.published_at
            })
          end
        end
      end
    else
      tag.locals.page.assets.each do |a| 
        if a.audio? || a.movie?
          tag.locals.episodes.push({
            :title => a.title, 
            :subtitle => a.caption,
            :date => a.created_at, 
            :file_size => a.asset_file_size, 
            :file_type => a.asset_content_type, 
            :link => base_url + a.asset.url, 
            :description => a.caption
          })
        end
      end
    end
    render_feed(tag)
  end

  protected

    def render_feed(tag)
      feed = RSS::Maker.make('2.0') do |m|
        m.channel.title = tag.attr['title']
        m.channel.subtitle = tag.attr['subtitle']
        m.channel.link = tag.attr['link']
        m.channel.description = tag.attr['description']
        m.channel.copyright = tag.attr['copyright']
        m.channel.language = tag.attr['language']

        m.channel.itunes_summary = tag.attr['description']
        m.channel.itunes_image = tag.attr['image']

        m.channel.author = tag.attr['author']
        m.channel.itunes_author = tag.attr['author']
        m.channel.itunes_owner.itunes_name = tag.attr['author']
        m.channel.itunes_owner.itunes_email = tag.attr['email']
        
        cat = nil
        tag.attr['category'].split('/').each do |subcat|
          from = cat || m.channel.itunes_categories
          cat = from.new_category
          cat.text = subcat
        end
        m.channel.itunes_categories << cat if cat
        
        latest_episode_date = nil
        tag.locals.episodes.each do |ep|
          latest_episode_date = ep[:date] unless latest_episode_date && latest_episode_date >= ep[:date]
          item = m.items.new_item
          item.title = ep[:title]
          item.description = ep[:description]
          item.itunes_subtitle = ep[:subtitle]
          item.itunes_summary = ep[:description]

          item.link = ep[:link]
          item.guid.content = ep[:link]
          item.guid.isPermaLink = true
          item.enclosure.url = ep[:link]
          item.enclosure.type = ep[:file_type]
          item.enclosure.length = ep[:file_size]

          item.date = ep[:date]
          item.itunes_explicit = tag.attr[:explicit] || 'No'
          item.itunes_author = tag.attr['author']
        end
        
        m.items.do_sort = true
        m.channel.lastBuildDate = latest_episode_date
      end
      feed.to_s
    end
    
end
