(declare-project
  :name "wttr"
  :description "Fetch and cache the current weather from wttr.in"
  :dependencies
     [{:repo "https://github.com/janet-lang/spork.git" :tag "v1.1.1"}
      {:repo "https://github.com/llmII/jsec.git"}])

(declare-executable
  :name "wttr"
  :entry "main.janet"
  :install true)
