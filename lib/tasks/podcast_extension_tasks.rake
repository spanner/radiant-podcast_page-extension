namespace :radiant do
  namespace :extensions do
    namespace :podcast do
      
      desc "Runs the migration of the Podcast extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          PodcastExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          PodcastExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Podcast to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from PodcastExtension"
        Dir[PodcastExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(PodcastExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
