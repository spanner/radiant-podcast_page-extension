namespace :radiant do
  namespace :extensions do
    namespace :podcast_page do
      
      desc "Runs the migration of the Podcast extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          PodcastPageExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          PodcastPageExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Podcast to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from PodcastExtension"
        Dir[PodcastPageExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(PodcastPageExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
