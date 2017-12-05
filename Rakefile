require 'colorize'
require 'rspec/core/rake_task'

require_relative 'build/file_utils'
require_relative 'build/static_utils'

namespace :static do
  task :style do
    style_tf
  end
  task :lint do
    lint_tf
  end
  task :format do
    format_tf
  end
end

task :validate => [ 'static:style', 'static:lint' ]

task :format => [ 'static:format' ]

task :build => [ 'static:style', 'static:lint' ]

task :default => [ 'validate' ]
