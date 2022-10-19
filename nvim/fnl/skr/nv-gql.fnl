(local Job (require :plenary.job))
(local curl (require :plenary.curl))
(local {: split
        : cut} (require :skr.std))

(local {:api {:nvim_create_buf      create-buf
              :nvim_buf_set_option  buf-set-opt
              :nvim_buf_set_lines   buf-set-lines
              :nvim_buf_get_lines   buf-get-lines
              :nvim_win_set_buf     win-set-buf
              :nvim_get_current_buf get-current-buf
              :nvim_get_current_win get-current-win}
        : json
        :tbl_flatten flatten} vim)

(local delim-query "# ---query---")
(local delim-resp  "# ---response---")

(fn parse [lines]
  (-> lines
      ;; Cut at the delim-query line, which should be the first line
      (cut delim-query)
      ;; Check if it was successful
      (match
        [_ after] after
        {:error _} (error "missing query delimiter"))
      ;; Cut again at the delim-resp line, which should now separate the query
      ;; from the response
      (cut delim-resp)
      ;; Check again if it was successful
      (match
        [query resp] {:query (table.concat query "\n")
                      :resp  (table.concat resp "\n")}
        {:error _} (error "missing resp delimiter"))))

(fn write [buf {: query : resp}]
  (let [query-lines (split query "\n")
        lines (flatten [delim-query
                        query-lines
                        delim-resp
                        resp])]
    (buf-set-lines buf 0 -1 false lines)))

(fn read-token []
  (let [file (vim.fn.expand "~/.nclogin/prod-creds.json")
        [token] (-> {:command "jq"
                     :args ["--raw-output"
                            ".id_token"
                            file]
                     :enable_recording true}
                    (Job:new)
                    (: :sync))]
    token))

(fn send-query [query]
  (let [;; Read token from local cache.
        token (read-token)

        ;; Construct query via curl.
        url "https://api.northvolt.com/graphql"
        body (json.encode {: query})
        raw ["--header" (.. "Authorization: Bearer " token)
             "--header" "Content-Type: application/json; charset=utf-8"
             "--header" "Accept: application/json; charset=urf-8"]]

      ;; Post the query.
      (curl.post {: url
                  : body
                  : raw})))

(fn start []
  (let [;; Create new buffer for the querying
        buf (create-buf true true)
        ;; We want to set the buffer to the current window, so get that
        win (get-current-win)
        ;; The initial state we want to write to the buffer
        state {:query "query {\n}"
               :resp ""}]

    (do
      ;; Update the buffer of the window
      (win-set-buf win buf)
      ;; Set the filetype so we get syntax highlighting
      (buf-set-opt buf :filetype :graphql)
      ;; Write the initial state to the buffer
      (write buf state))))

(fn post []
  (let [buf (get-current-buf)
        ;; Parse the query from the buffer
        {: query} (-> buf
                      (buf-get-lines 0 -1 false)
                      (parse))
        ;; Send the request and get back the resp body
        {: body} (send-query query)
        ;; Construct new state
        new-state {: query :resp body}]

    ;; Write out the state
    (write buf new-state)))

{: start
 : post}
