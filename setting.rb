# 画面設定に関係するメソッドは以下を参照
# http://mirichi.github.io/dxruby-doc/api/Window.html

# 画面サイズ設定
Window.width = 800
Window.height = 600

# ウィンドウのタイトル
Window.caption = "チュートリアル"

# 全てのシーン共通で使いたい設定などをしまう
# 使うときは Setting::定数名 で使う
module Setting
  DEFAULT_FONT_SIZE  = 24
  TITLE_FONT_SIZE    = 48
  ENDING_FONT_SIZE   = 48
  DESCRIBE_FONT_SIZE = 24
  DESCRIBE_TEXTS = [
    "TODO: ゲームの説明",
    "改行もできる"
  ]
  SAVE_FILE_NAME = "data/raw.json"
end
