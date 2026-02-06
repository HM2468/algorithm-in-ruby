# spec/spec_helper.rb
require "bundler/setup"
require "algorithms"
require "data_structure"

# 让 `lib` 自动加入 $LOAD_PATH
ROOT = File.expand_path("..", __dir__)
$LOAD_PATH.unshift(File.join(ROOT, "lib"))

RSpec.configure do |config|
  config.color = true
  config.default_formatter = "doc" if config.files_to_run.one?
end