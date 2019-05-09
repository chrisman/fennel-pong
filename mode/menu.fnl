(local (w h) (love.window.getMode))

{
 :name "menu"

 :update (fn update [dt set-mode])

 :keypressed (fn keypressed [key set-mode]
   (when (= "return" key) (set-mode "mode.pong")))

 :draw (fn draw [message]
   (love.graphics.printf "PoNG\n\nPlayer 1: a/z\nPlayer 2: up/down\n\nsMash Enter" 0 (/ h 3) w "center"))
 }
