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
      "media.autoplay.default" = 5;

      # UI
      "browser.uidensity" = 1;
      "browser.tabs.inTitlebar" = 0;

      # Enable DRM :(
      "media.eme.enabled" = true;

      # Ask where to save files
      "browser.download.useDownloadDir" = false;

      # Enable HTTPS only mode
      "dom.security.https_only_mode" = true;

      # Show punycode in URLs to prevent homograph attacks
      "network.IDN_show_punycode" = true;

      # Extensions
      "extensions.enabledScopes" = 5;
      "extensions.webextensions.restrictedDomains" = "";

      # Disable annoying firefox functionality
      "browser.aboutConfig.showWarning" = false; # about:config warning
      "browser.aboutwelcome.enabled" = false;
      "browser.formfill.enable" = false;
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "browser.translations.automaticallyPopup" = false;
      "extensions.formautofill.creditCards.enabled" = false;
      "extensions.pocket.enabled" = false;
      "identity.fxaccounts.enabled" = false; # Firefox sync
      "privacy.webrtc.legacyGlobalIndicator" = false; # Sharing indicator
      "signon.autofillForms" = false;
      "signon.rememberSignons" = false;

      # Disable telemetry
      "app.shield.optoutstudies.enabled" = false;
      "browser.discovery.enabled" = false;
      "datareporting.healthreport.uploadEnabled" = false;
      "extensions.getAddons.showPane" = false;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
    };

    commonExtensions = with pkgs.nur.repos.rycee.firefox-addons;
      [ ublock-origin ];
  in {
    enable = true;
    nativeMessagingHosts = [
      pkgs.tridactyl-native
      (let
        file = pkgs.writeText "org.keepassxc.keepassxc_browser.json" ''
          {
            "allowed_extensions": [
                "keepassxc-browser@keepassxc.org"
            ],
            "description": "KeePassXC integration with native messaging support",
            "name": "org.keepassxc.keepassxc_browser",
            "path": "${pkgs.keepassxc}/bin/keepassxc-proxy",
            "type": "stdio"
          }
        '';
      in pkgs.stdenv.mkDerivation {
        pname = "keepassxc-native";
        version = "1.0.0";

        dontUnpack = true;
        installPhase =
          "install -Dm755 ${file} $out/lib/mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json";
      })
    ];
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = commonSettings // {
          # History customisation
          "privacy.history.custom" = true;
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "privacy.clearOnShutdown.cache" = true;
          "privacy.clearOnShutdown.cookies" = true;
          "privacy.clearOnShutdown.downloads" = true;
          "privacy.clearOnShutdown.formdata" = true;
          "privacy.clearOnShutdown.history" = true;
          "privacy.clearOnShutdown.offlineApps" = true;
          "privacy.clearOnShutdown.sessions" = true;
          "privacy.clearOnShutdown.sitesettings" = false;
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
