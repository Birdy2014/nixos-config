{ inputs, pkgs, ... }:

{
  programs.firefox = let
    commonSettings = {
      # Deactivate disk cache to reduce unnecessary disk writes
      "browser.cache.disk.enable" = false;
      "browser.cache.memory.enable" = true;
      "browser.cache.memory.capacity" = 1048576; # 1GiB

      # Disable fullscreen
      "full-screen-api.ignore-widgets" = true;

      # Autoplay
      "media.autoplay.block-event.enabled" = true;
      "media.autoplay.default" = 1;

      # UI
      "browser.uidensity" = 1;
      "browser.tabs.inTitlebar" = 0;

      # Enable DRM :(
      "media.eme.enabled" = true;

      # Disable annoying firefox functionality
      "signon.rememberSignons" = false;
      "browser.formfill.enable" = false;
      "extensions.formautofill.creditCards.enabled" = false;
      "browser.aboutwelcome.enabled" = false;
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "extensions.pocket.enabled" = false;
      "browser.translations.automaticallyPopup" = false;

      # Disable telemetry
      "app.shield.optoutstudies.enabled" = false;
      "browser.discovery.enabled" = false;
      "datareporting.healthreport.uploadEnabled" = false;
    };

    commonExtensions = with pkgs.nur.repos.rycee.firefox-addons;
      [ ublock-origin ];
  in {
    enable = true;
    package = (pkgs.firefox.override {
      nativeMessagingHosts = [ pkgs.tridactyl-native ];
    });
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = commonSettings // {
          # History customisation
          "privacy.history.custom" = true;
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "privacy.clearOnShutdown.offlineApps" = true;
          "privacy.clearOnShutdown.cache" = true;
          "privacy.clearOnShutdown.cookies" = true;
        };
        extensions = commonExtensions
          ++ (with pkgs.nur.repos.rycee.firefox-addons; [
            keepassxc-browser
            i-dont-care-about-cookies
            tridactyl
            darkreader
            return-youtube-dislikes
          ]);
        search.default = "DuckDuckGo";
        search.force = true;
        userChrome = ''
          @import "${
            inputs.self.packages.${pkgs.system}.lepton-firefox-theme
          }/userChrome.css";
        '';
        userContent = ''
          @import "${
            inputs.self.packages.${pkgs.system}.lepton-firefox-theme
          }/userContent.css";
        '';
        extraConfig = builtins.readFile
          "${inputs.self.packages.${pkgs.system}.lepton-firefox-theme}/user.js";
      };

      persistent = {
        id = 1;
        name = "persistent";
        isDefault = false;
        settings = commonSettings;
        extensions = commonExtensions
          ++ (with pkgs.nur.repos.rycee.firefox-addons; [
            return-youtube-dislikes
            youtube-shorts-block
            sponsorblock
          ]);
        search.default = "DuckDuckGo";
        search.force = true;
      };
    };
  };

  xdg.configFile."tridactyl/tridactylrc".text = ''
    set smoothscroll true

    bind / fillcmdline find
    bind ? fillcmdline find --reverse
    bind n findnext --search-from-view
    bind N findnext --search-from-view --reverse
    bind gn findselect
    bind gN composite findnext --search-from-view --reverse; findselect
    bind <esc> nohlsearch

    unbind <C-f>

    bind <A-q> tabclose
    bind <A-k> tabprev
    bind <A-j> tabnext
    bind <A-K> tabmove -1
    bind <A-J> tabmove +1
  '';
}
