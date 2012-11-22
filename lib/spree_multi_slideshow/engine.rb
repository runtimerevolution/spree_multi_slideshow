module SpreeMultiSlideshow
  class Engine < Rails::Engine
    engine_name 'spree_multi_slideshow'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end

      Dir.glob(File.join(File.dirname(__FILE__), "../../app/overrides/*.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end
    end

    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w( admin/slides/index.js admin/slides/new.js )
    end

    config.to_prepare &method(:activate).to_proc
  end
end
