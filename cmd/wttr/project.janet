(declare-project
  :name "wttr"
  :description "Fetch and cache the current weather from wttr.in"
  :dependencies
     [{:repo "https://github.com/cosmictoast/jurl.git"
       :tag "v1.4.3"}])

(declare-executable
  :name "wttr"
  :entry "main.janet"
  :install true)
