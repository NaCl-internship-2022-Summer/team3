# 画面設定に関係するメソッドは以下を参照
# http://mirichi.github.io/dxruby-doc/api/Window.html

# 画面サイズ設定
Window.width = 800
Window.height = 600

# ウィンドウのタイトル
Window.caption = "バズねこ"

# 全てのシーン共通で使いたい設定などをしまう
# 使うときは Setting::定数名 で使う
module Setting
    # font
  FONT_JA = "あずきフォント"
  DEFAULT_FONT_SIZE       = 24
  TITLE_FONT_SIZE         = 48
  TITLE_BUTTON_FONT_SIZE  = 32
  ENDING_FONT_SIZE        = 48
  DESCRIBE_FONT_SIZE      = 32

  # text
  DESCRIBE_TEXTS = [
    "TODO: ゲームの説明",
    "改行もできる"
  ]

  # main game
  PLAYER_SPEED = 2
  TIME_LIMIT = 60
  PROGRESS_BAR_START = 100
  PROGRESS_BAR_END = 700

  # others
  SAVE_FILE_NAME = "data/raw.json"
end

Font.install("./fonts/azuki.ttf")
