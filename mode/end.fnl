(local (w h) (love.window.getMode))

(var message "Unknown")

{
  :name "end"

  :init (fn init [m] (set message (.. "Player " m " wins")))

  :update (fn update [dt set-mode])

  :keypressed (fn keypressed [key set-mode]
    (when (= "y" key) (set-mode "mode.pong"))
    (when (= "n" key) (love.event.quit)))

  :draw (fn draw [m]
    (love.graphics.printf (.. message "\n\nPlay again? (y/n)") 0 (/ h 3) w "center"))
}
