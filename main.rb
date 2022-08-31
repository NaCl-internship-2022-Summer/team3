require 'dxruby'

# Dir.[]: [] 内に列挙されたパターンに合うファイルを検索します。
# https://docs.ruby-lang.org/ja/2.7.0/method/Dir/s/=5b=5d.html

# require_relative: 相対パスでrubyファイルを読み込めます。
Dir['setting.rb', 'lib/*.rb', 'fixtures/*.rb', 'fixtures/main_game/*.rb', 'scene/*.rb'].each do |file|
  require_relative file
end

scene = Scene::Opening.new

Debugger.new

# Window.loopは60fps (1sec に 60回)で処理を実行する
# Window.fps = でfpsを変えることも可能
Window.loop do
  scene.update
  scene = scene.next_scene if scene.finish?
  Window.close unless scene
end
