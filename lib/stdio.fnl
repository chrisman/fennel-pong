(require "love.event")
(local fennel (require "lib.fennel"))
(local view (require "lib.fennelview"))

;; This module exists in order to expose stdio over a channel so that it
;; can be used in a non-blocking way from another thread.

(local (event channel) ...)

(defn display [s]
  (io.write s)
  (io.flush))

(defn prompt []
  (display "\n>> "))

(defn read-chunk []
  (let [input (io.read)]
    (when input
      (.. input "\n"))))

(var input "")
(when channel
  (let [(bytestream clearstream) (fennel.granulate read-chunk)
        read (fennel.parser
              (fn []
                (let [c (or (bytestream) 10)]
                  (set input (.. input (string.char c)))
                  c)))]
    (while true
      (prompt)
      (set input "")
      (let [(ok ast) (pcall read)]
        (if (not ok)
            (do
              (display (.. "Parse error:" ast "\n"))
              ;; fixme: not sure why the following fails
              ;; (clearstream)
              )
            (do
              (love.event.push event input)
              (display (: channel :demand))))))))

{:start (fn start-repl []
          (let [code (love.filesystem.read "stdio.fnl")
                lua (if code
                        (love.filesystem.newFileData
                         (fennel.compileString code) "io")
                        (love.filesystem.read "lib/stdio.lua"))
                thread (love.thread.newThread lua)
                io-channel (love.thread.newChannel)]
            ;; this thread will send "eval" events for us to consume:
            (: thread :start "eval" io-channel)
            (set love.handlers.eval
                 (fn [input]
                   (let [(ok val) (pcall fennel.eval input)]
                     (: io-channel :push (if ok (view val) val)))))))}
