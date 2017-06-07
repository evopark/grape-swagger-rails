require 'git'
require 'pry'
require 'pry-byebug'
namespace :swagger_ui do
  namespace :dist do
    desc 'Update Swagger-UI from swagger-api/swagger-ui.'
    task :update do
      Dir.mktmpdir 'swagger-ui' do |dir|
        puts "Cloning into #{dir} ..."
        # clone swagger-api/swagger-ui
        Git.clone 'git@github.com:swagger-api/swagger-ui.git', 'swagger-ui', path: dir, depth: 0
        # prune local files
        root = File.expand_path '../../..', __FILE__
        puts "Removing files from #{root} ..."
        repo = Git.open root
        # Javascripts
        puts 'Copying Javascripts ...'
        FileUtils.rm_r "#{root}/app/assets/javascripts/grape_swagger_rails" rescue Errno::ENOENT
        FileUtils.mkdir_p "#{root}/app/assets/javascripts/grape_swagger_rails"
        FileUtils.cp "#{dir}/swagger-ui/dist/swagger-ui-bundle.js", "#{root}/app/assets/javascripts/grape_swagger_rails/application.js"
        puts 'Copying Stylesheets ...'
        repo.remove 'app/assets/stylesheets/grape_swagger_rails', recursive: true
        FileUtils.mkdir_p "#{root}/app/assets/stylesheets/grape_swagger_rails"
        FileUtils.cp "#{dir}/swagger-ui/dist/swagger-ui.css", "#{root}/app/assets/stylesheets/grape_swagger_rails/application.css"
      end
    end
  end
end
