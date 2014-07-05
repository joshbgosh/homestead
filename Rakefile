require File.expand_path('../config/application', __FILE__)
require 'rake'
# If you named your application something other than SampleApp, change that below
module ::BothAreTotallyEnraged
    class Application
        include Rake::DSL
    end
end

module ::RakeFileUtils
    extend Rake::FileUtilsExt
end

BothAreTotallyEnraged::Application.load_tasks