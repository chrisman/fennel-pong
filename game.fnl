(local fennel (require "lib.fennel"))
(local repl (require "lib.stdio"))

(var mode (require "mode.menu"))

(fn set-mode [mn ...]
  (set mode (require mn))
  (when mode.init
    (mode.init ...)))

(fn love.load []
  (repl.start))

(fn love.draw []
  (mode.draw))

(fn love.update [dt]
  (mode.update dt set-mode))

(fn love.keypressed [key]
  ;; LIVE RELOADING
  (when (= "f5" key)
    (let [name (.. "mode." (. mode :name))]
      (let [old (require name)
            _ (tset package.loaded name nil)
            new (require name)]
        (when (= (type new) :table)
          (each [k v (pairs new)]
            (tset old k v))
          (each [k v (pairs old)]
            (when (not (. new k))
              (tset old k nil)))
          (tset package.loaded name old))))
    )

  (when (= "escape" key)
    (love.event.quit))

  (mode.keypressed key set-mode))
