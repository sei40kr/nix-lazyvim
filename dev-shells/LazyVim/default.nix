{ LazyVim, mkShell }:

mkShell {
  buildInputs = [ LazyVim ];

  shellHook = ''
    export XDG_CACHE_HOME=$(mktemp -d)
    export XDG_CONFIG_HOME=$(mktemp -d)
    export XDG_DATA_HOME=$(mktemp -d)
    export XDG_STATE_HOME=$(mktemp -d)

    mkdir -p $XDG_CONFIG_HOME/lazyvim/lua/plugins
    cat <<EOF >$XDG_CONFIG_HOME/lazyvim/lua/plugins/init.lua
    return {}
    EOF

    _clean() {
      rm -rf $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME $XDG_STATE_HOME
    }

    trap _clean EXIT
  '';
}
