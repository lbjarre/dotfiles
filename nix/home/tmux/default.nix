{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.skr.home.tmux;

  dotfiles = "${config.home.homeDirectory}/src/github.com/lbjarre/dotfiles";
  mkSymlink = p: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${p}";

  # Fuzzy-search switcher for tmux windows.
  #
  # TODO: Don't like reading this in bash, convert this to janet some day.
  tmux-select-window = pkgs.writeShellApplication {
    name = "tmux-select-window";
    runtimeInputs = [
      pkgs.tmux
      pkgs.fzf
      pkgs.coreutils
      pkgs.unixtools.column
    ];
    text = ''
      # Lists out all tmux-windows for fzf.
      # Creates 4 :-separated columns, containing:
      #   1. tmux session name
      #   2. tmux window id
      #   3. empty filler, needs to be here for alignment in the 4th column
      #   4. text info for fzf
      # The 4th column has additionally two whitespace separated columns:
      #   i.  tmux window name
      #   ii. working directory of a pane in the window (which one? honestly dont know)
      selection=$(
          tmux list-windows -a -F "#{session_name}:#{window_id}: :#{window_name} #{pane_current_path}" \
              | sed "s|$HOME|~|" \
              | column -s' ' -t \
              | fzf-tmux -p --delimiter=: --with-nth=4 --header="switch tmux window" --header-first
      ) || exit 0

      client="$(echo "$selection" | awk -F ':' '{ print $1 }')"
      window="$(echo "$selection" | awk -F ':' '{ print $2 }')"

      tmux select-window -t "$window" && tmux switch-client -t "$client"
    '';
  };

  # Writes out the current tmux session for the status bar.
  tmux-status-session = pkgs.writeShellScriptBin "tmux-status-session" ''
    ${pkgs.tmux}/bin/tmux display-message -p "#S"
  '';

  # Writes out the current Kubernetes context for the status bar.
  tmux-status-k8s = pkgs.writeShellApplication {
    name = "tmux-status-k8s";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.kubectl
    ];
    text = ''
      ctx="$(kubectl config current-context)"
      kubectl config get-contexts --no-headers "$ctx" | awk '{ printf("ctx:%s ns:%s", $2, $5) }'
    '';
  };

  # Create a wrapper for tmux with all the runtime scripts added to the path.
  tmux-wrapped = pkgs.symlinkJoin {
    name = "tmux";
    paths = [ pkgs.tmux ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild =
      let
        path = lib.makeBinPath [
          tmux-select-window
          tmux-status-session
          tmux-status-k8s
        ];
      in
      ''
        wrapProgram $out/bin/tmux \
          --prefix PATH : ${path}
      '';
  };
in
{
  options.skr.home.tmux = {
    enable = lib.mkEnableOption "Enable tmux";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ tmux-wrapped ];

    xdg = {
      enable = true;
      configFile.tmux.source = mkSymlink "config/tmux";
    };
  };
}
