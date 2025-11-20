# spec/spec_helper.rb
require "bundler/setup"
require "algorithms"

# 让 `lib` 自动加入 $LOAD_PATH
ROOT = File.expand_path("..", __dir__)
$LOAD_PATH.unshift(File.join(ROOT, "lib"))

RSpec.configure do |config|
  # 原来 RSpec 自动生成的一堆配置直接保留
end