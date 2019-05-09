;; https://p.hagelb.org/pong.fnl.html
(local (speed ball-speed) (values 1 200))
(local (w h) (love.window.getMode))
(local _state {:x 100 :y 100 :dx 2 :dy 1 :left (- (/ h 2) 50) :right (- (/ h 2) 50)})
(global state {:x 100 :y 100 :dx 2 :dy 1 :left (- (/ h 2) 50) :right (- (/ h 2) 50)})
(var pause false)

(local keys {:a [:left -1] :z [:left 1] :up [:right -1] :down [:right 1]})

(fn on-paddle? []
  (or (and (< state.x 20)
           (< state.left state.y) (< state.y (+ state.left 100)))
      (and (< (- w 20) state.x)
           (< state.right state.y) (< state.y (+ state.right 100)))))

{
 :name "pong"

 :init (fn init []
             (set pause false)
             (each [k v (pairs _state)]
               (tset state k v)))

 :update (fn update [dt set-mode]
           (when (not pause)
             (set state.x (+ state.x (* state.dx dt ball-speed)))
             (set state.y (+ state.y (* state.dy dt ball-speed)))
             (each [key action (pairs keys)]
               (let [[player dir] action]
                 (when (love.keyboard.isDown key)
                   (tset state player (+ (. state player) (* dir speed))))))

             (when (or
                     (< state.y 0)
                     (> state.y h))
               (set state.dy (- 0 state.dy)))

             (when (on-paddle?)
               (set state.dx (- 0 state.dx)))

             (when (< state.x 0)
               (set-mode "mode.end" "2"))
             (when (> state.x w)
               (set-mode "mode.end" "1"))))

 :keypressed (fn keypressed [key set-mode]
               (when (= "p" key)
                 (set pause (not pause))))

 :draw (fn draw [m]
         (when (not pause)
           (love.graphics.rectangle "fill" 10 state.left 10 100)
           (love.graphics.rectangle "fill" (- w 20) state.right 10 100)
           (love.graphics.circle "fill" state.x state.y 10))
         (when pause
           (love.graphics.printf "Press 'p' to unpause" 0 (/ h 3) w "center")))
 }
