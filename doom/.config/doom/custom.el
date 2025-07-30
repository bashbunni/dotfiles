(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("5c7720c63b729140ed88cf35413f36c728ab7c70f8cd8422d9ee1cedeb618de5"
     "adaf421037f4ae6725aa9f5654a2ed49e2cd2765f71e19a7d26a454491b486eb"
     "a44e2d1636a0114c5e407a748841f6723ed442dc3a0ed086542dc71b92a87aee"
     "7a424478cb77a96af2c0f50cfb4e2a88647b3ccca225f8c650ed45b7f50d9525"
     "a060c0315a44bee19ac87414571131c8c8fad7a940bda0102da67410e66833aa"
     "5a00018936fa1df1cd9d54bee02c8a64eafac941453ab48394e2ec2c498b834a"
     "2ce76d65a813fae8cfee5c207f46f2a256bac69dacbb096051a7a8651aa252b0"
     "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8"
     "56044c5a9cc45b6ec45c0eb28df100d3f0a576f18eef33ff8ff5d32bac2d9700"
     "4fda8201465755b403a33e385cf0f75eeec31ca8893199266a6aeccb4adedfa4"
     "c865644bfc16c7a43e847828139b74d1117a6077a845d16e71da38c8413a5aaa" default))
 '(elfeed-feeds '("https://charm.sh/blog/rss.xml") t)
 '(package-selected-packages
   '(better-jumper go-dlv kaolin-themes pbcopy posframe realgud-lldb)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(after! projectile
  (add-to-list 'projectile-globally-ignored-directories "*vendor"))
(setq elfeed-feeds
      '("https://this-week-in-rust.org/rss.xml"
        "http://feeds.bbci.co.uk/news/rss.xml"
        "https://charm.sh/blog/rss.xml"))
