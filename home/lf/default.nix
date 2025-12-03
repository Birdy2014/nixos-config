{ pkgs, ... }:

{
  programs.lf = {
    enable = true;

    settings = {
      dircounts = true;
      info = "size";
      incsearch = true;
      icons = true;
      cursorpreviewfmt = "\\033[7m";
      rulerfmt = "%a  | %p |\\033[7;31m %m \\033[0m  |\\033[7;33m %c \\033[0m  |\\033[7;35m %s \\033[0m  |\\033[7;34m %f \\033[0m  | %d | %i/%t";
      shell = "sh";
      shellopts = "-eu";
      ifs = "\n";
      scrolloff = 10;
      sixel = true;
      mouse = true;
      period = 1;
    };

    keybindings = {
      "<enter>" = "shell";

      P = "paste-overwrite";
      "<c-c>" = "cancel-paste";

      a = "push %mkdir<space>";

      gi = ''$lf -remote "send $id cd /run/media/$USER"'';
      gs = ''$lf -remote "send $id cd /run/user/$UID/gvfs"'';
      gc = ''$lf -remote "send $id cd $XDG_CONFIG_HOME"'';

      D = "trash";
      E = "extract";
      R = "reload";

      st = ":set sortby time; set reverse";
      sa = ":set sortby atime; set reverse";
      sc = ":set sortby ctime; set reverse";
      se = ":set sortby ext; set noreverse";
      sn = ":set sortby natural; set noreverse";
      ss = ":set sortby size; set reverse";

      "<m-up>" = "up";
      "<m-down>" = "down";
    };

    previewer.source = "${
      pkgs.writeShellApplication {
        name = "lf-preview";
        runtimeInputs = with pkgs; [
          kitty
          chafa
          highlight
          poppler-utils
          imagemagick
          ffmpeg
          ffmpegthumbnailer
          odt2txt
          unzip
          gnutar
          _7zz
          unrar
          gnome-epub-thumbnailer
          f3d
        ];
        text = builtins.readFile ./preview.sh;
      }
    }/bin/lf-preview";

    commands = {
      on-cd = ''
        &{{
          printf "\033]0; $PWD\007" > /dev/tty
        }}'';

      open = ''
        ''${{
          test -L $f && f=$(readlink -f $f)
          $OPENER $f
        }}'';

      open-with = ''
        ''${{
          command -v "$1" && {
            setsid "$@" "$f" > /dev/null 2> /dev/null &
          }
        }}'';

      edit = ''
        ''${{
          test -L $f && f=$(readlink -f $f)
          $EDITOR $fx;
        }}'';

      drag = "&${pkgs.ripdrag}/bin/ripdrag --no-click --all $fx";

      # extract the current file with the right command
      # (xkcd link: https://xkcd.com/1168/)
      extract = ''
        ''${{
          set -f
          case $f in
            *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) ${pkgs.gnutar}/bin/tar --one-top-level -xjvf $f;;
            *.tar.gz|*.tgz) ${pkgs.gnutar}/bin/tar --one-top-level -xzvf $f;;
            *.tar.xz|*.txz) ${pkgs.gnutar}/bin/tar --one-top-level -xJvf $f;;
            *.zip) ${pkgs.unzip}/bin/unzip -d ''${f%.*} $f;;
            *.rar) ${pkgs.unrar}/bin/unrar x -y -op''${f%.*} -- $f;;
            *.7z) ${pkgs._7zz}/bin/7zz -o''${f%.*} x $f;;
            *.xz) ${pkgs.xz}/bin/unxz $f;;
          esac
        }}'';

      # compress current file or selected files with 7z
      compress-7z = ''
        ''${{
          set -f
          if [[ -n "$fs" ]]; then
            mkdir $1
            cp -r $fx $1
            ${pkgs._7zz}/bin/7zz a $1.7z $1
            rm -rf $1
          else
            ${pkgs._7zz}/bin/7zz a $f.7z $f
          fi
        }}'';

      # Necessary / Better alternative?
      duplicate = ''
        ''${{
          file="$f"
          IFS=' ' new_name="$*"
          cp -r "$file" "$new_name"
        }}'';

      trash = ''
        %{{
          printf 'Put "%s" in trash? [y/N]' "$f"
          read -r ans
          if [ "$ans" = "y" ]; then
            trash-put $fx
            echo "Trashed"
          else
            echo
          fi
        }}'';

      bulk-rename = ''
        ''${{
          old="$(mktemp)"
          new="$(mktemp)"
          if [ -n "$fs" ]; then
            fs="$(basename -a $fs)"
          else
            fs="$(ls)"
          fi
          printf '%s\n' "$fs" >"$old"
          printf '%s\n' "$fs" >"$new"
          $EDITOR "$new"
          [ "$(wc -l < "$new")" -ne "$(wc -l < "$old")" ] && exit
          paste "$old" "$new" | while IFS= read -r names; do
            src="$(printf '%s' "$names" | cut -f1)"
            dst="$(printf '%s' "$names" | cut -f2)"
            if [ "$src" = "$dst" ] || [ -e "$dst" ]; then
              continue
            fi
            mv -- "$src" "$dst"
          done
          rm -- "$old" "$new"
          lf -remote "send $id unselect"
        }}'';

      mkdir = ''
        ''${{
          [[ "$#" -eq 0 ]] && echo 'Not enough arguments'>&2
          IFS=' ' name="$*"
          mkdir "$name"
        }}'';

      touch = ''
        ''${{
          [[ "$#" -eq 0 ]] && echo 'Not enough arguments'>&2
          IFS=' ' name="$*"
          touch "$name"
        }}'';
    };

    extraConfig = ''
      set cleaner ${
        pkgs.writeShellApplication {
          name = "lf-clean";
          runtimeInputs = with pkgs; [ kitty ];
          text = builtins.readFile ./clean.sh;
        }
      }/bin/lf-clean

      on-cd
    '';
  };

  xdg.configFile."lf/icons".source = ./icons;
}
