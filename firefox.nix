{ pkgs, config, lib, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.unstable.firefox-unwrapped {
      extraPolicies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        FirefoxHome = {
          Search = true;
          Pocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
    };
    profiles = {
      sargo = {
        id = 0;

        name = "sargo";

        extensions = with config.nur.repos.rycee.firefox-addons;
          let
            gruvfox = buildFirefoxXpiAddon {
              pname = "gruvfox";
              version = "1.0";
              addonId = "{6f5ff416-2f62-443a-87b6-c0cefa5a857a}";
              url =
                "https://addons.mozilla.org/firefox/downloads/file/3793275/gruvfox-1.0.xpi";
              sha256 =
                "fb2b22ccb79afbf0a27a7131dc66797bda12c1b6462c46136d3e3ae367802882";
              meta = with lib; {
                description =
                  "Gruvfox is a minimal and flat Firefox theme based on Gruvbox. It aims to pair well with other flat-themed Gruvbox programs like: VSCode, iterm2, etc.";
                license = licenses.cc-by-nc-sa-30;
                platforms = platforms.all;
              };
            };

            trackmenot = buildFirefoxXpiAddon {
              pname = "trackmenot";
              version = "0.10.46";
              addonId = "trackmenot@mrl.nyu.edu";
              url =
                "https://addons.mozilla.org/firefox/downloads/file/3438065/trackmenot-0.10.46.xpi";
              sha256 =
                "f5ed9cd2432543e22213ee0e79bc66941fc6802a357a6ae9cca2dcbe8e4d124c";
              meta = with lib; {
                homepage = "http://cs.nyu.edu/trackmenot/";
                description =
                  "An artware browser add-on to protect privacy in web-search. By issuing randomized queries to common search-engines, TrackMeNot obfuscates your search profile and registers your discontent with surreptitious tracking.";
                license = licenses.gpl2;
                platforms = platforms.all;
              };
            };

          in [
            gruvfox
            trackmenot
            clearurls
            decentraleyes
            privacy-redirect
            adnauseam
            keepassxc-browser
            re-enable-right-click
            sponsorblock
            stylus
            tabliss
            tab-stash
            vimium-c
            youtube-shorts-block
            terms-of-service-didnt-read
          ];

        search = {
          force = true;
          default = "Brave";
          engines = {
            Brave = {
              urls = [{
                template = "https://search.brave.com/search";
                params = [{
                  name = "q";
                  value = "{searchTerms}";
                }];

              }];
              iconUpdateURL =
                "https://cdn.search.brave.com/serp/v1/static/brand/16c26cd189da3f0f7ba4e55a584ddde6a7853c9cc340ff9f381afc6cb18e9a1e-favicon-32x32.png";
              updateInterval = 24 * 60 * 60 * 1000;

            };
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];
              icon =
                "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "NixOS Wiki" = {
              urls = [{
                template = "https://nixos.wiki/index.php?search={searchTerms}";
              }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@nw" ];
            };
            "Wikipedia (en)".metaData.alias = "@wiki";
            "Google".metaData.hidden = true;
            "Amazon.com".metaData.hidden = true;
            "Bing".metaData.hidden = true;
            "eBay".metaData.hidden = true;
          };
        };

        settings = { "general.smoothScroll" = true; };
        extraConfig = ''
          lockPref("extensions.autoDisableScopes", 0); 
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("full-screen-api.ignore-widgets", true);
          user_pref("media.ffmpeg.vaapi.enabled", true);
          user_pref("media.rdd-vpx.enabled", true);
          //
          /* You may copy+paste this file and use it as it is.
           *
           * If you make changes to your about:config while the program is running, the
           * changes will be overwritten by the user.js when the application restarts.
           *
           * To make lasting changes to preferences, you will have to edit the user.js.
           */

          /****************************************************************************
           * Betterfox                                                                *
           * "Ad meliora"                                                             *
           * version: 113                                                             *
           * url: https://github.com/yokoffing/Betterfox                              *
          ****************************************************************************/

          /****************************************************************************
           * SECTION: FASTFOX                                                         *
          ****************************************************************************/
          user_pref("nglayout.initialpaint.delay", 0);
          user_pref("nglayout.initialpaint.delay_in_oopif", 0);
          user_pref("content.notify.interval", 100000);
          user_pref("browser.startup.preXulSkeletonUI", false);

          /** EXPERIMENTAL ***/
          user_pref("layout.css.grid-template-masonry-value.enabled", true);
          user_pref("layout.css.animation-composition.enabled", true);
          user_pref("dom.enable_web_task_scheduling", true);

          /** GFX ***/
          user_pref("gfx.webrender.all", true);
          user_pref("gfx.webrender.precache-shaders", true);
          user_pref("gfx.webrender.compositor", true);
          user_pref("layers.gpu-process.enabled", true);
          user_pref("media.hardware-video-decoding.enabled", true);
          user_pref("gfx.canvas.accelerated", true);
          user_pref("gfx.canvas.accelerated.cache-items", 32768);
          user_pref("gfx.canvas.accelerated.cache-size", 4096);
          user_pref("gfx.content.skia-font-cache-size", 80);
          user_pref("image.cache.size", 10485760);
          user_pref("image.mem.decode_bytes_at_a_time", 131072);
          user_pref("image.mem.shared.unmap.min_expiration_ms", 120000);
          user_pref("media.memory_cache_max_size", 1048576);
          user_pref("media.memory_caches_combined_limit_kb", 2560000);
          user_pref("media.cache_readahead_limit", 9000);
          user_pref("media.cache_resume_threshold", 6000);

          /** BROWSER CACHE ***/
          user_pref("browser.cache.memory.max_entry_size", 153600);

          /** NETWORK ***/
          user_pref("network.buffer.cache.size", 262144);
          user_pref("network.buffer.cache.count", 128);
          user_pref("network.http.max-connections", 1800);
          user_pref("network.http.max-persistent-connections-per-server", 10);
          user_pref("network.ssl_tokens_cache_capacity", 32768);

          /****************************************************************************
           * SECTION: SECUREFOX                                                       *
          ****************************************************************************/
          /** TRACKING PROTECTION ***/
          user_pref("browser.contentblocking.category", "strict");
          user_pref("urlclassifier.trackingSkipURLs", "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com");
          user_pref("urlclassifier.features.socialtracking.skipURLs", "*.instagram.com, *.twitter.com, *.twimg.com");
          user_pref("privacy.query_stripping.strip_list", "__hsfp __hssc __hstc __s _hsenc _openstat dclid fbclid gbraid gclid hsCtaTracking igshid mc_eid ml_subscriber ml_subscriber_hash msclkid oft_c oft_ck oft_d oft_id oft_ids oft_k oft_lk oft_sk oly_anon_id oly_enc_id rb_clickid s_cid twclid vero_conv vero_id wbraid wickedid yclid");
          user_pref("browser.uitour.enabled", false);
          user_pref("privacy.globalprivacycontrol.enabled", true);
          user_pref("privacy.globalprivacycontrol.functionality.enabled", true);

          /** OCSP & CERTS / HPKP ***/
          user_pref("security.OCSP.enabled", 0);
          user_pref("security.remote_settings.crlite_filters.enabled", true);
          user_pref("security.pki.crlite_mode", 2);
          user_pref("security.cert_pinning.enforcement_level", 2);

          /** SSL / TLS ***/
          user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
          user_pref("browser.xul.error_pages.expert_bad_cert", true);
          user_pref("security.tls.enable_0rtt_data", false);

          /** DISK AVOIDANCE ***/
          user_pref("browser.cache.disk.enable", false);
          user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);
          user_pref("browser.sessionstore.privacy_level", 2);

          /** SHUTDOWN & SANITIZING ***/
          user_pref("privacy.history.custom", true);

          /** SPECULATIVE CONNECTIONS ***/
          user_pref("network.http.speculative-parallel-limit", 0);
          user_pref("network.dns.disablePrefetch", true);
          user_pref("browser.urlbar.speculativeConnect.enabled", false);
          user_pref("browser.places.speculativeConnect.enabled", false);
          user_pref("network.prefetch-next", false);
          user_pref("network.predictor.enabled", false);
          user_pref("network.predictor.enable-prefetch", false);

          /** SEARCH / URL BAR ***/
          user_pref("browser.search.separatePrivateDefault.ui.enabled", true);
          user_pref("browser.urlbar.update2.engineAliasRefresh", true);
          user_pref("browser.search.suggest.enabled", false);
          user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
          user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
          user_pref("security.insecure_connection_text.enabled", true);
          user_pref("security.insecure_connection_text.pbmode.enabled", true);
          user_pref("network.IDN_show_punycode", true);

          /** HTTPS-FIRST MODE ***/
          user_pref("dom.security.https_first", true);

          /** PROXY / SOCKS / IPv6 ***/
          user_pref("network.proxy.socks_remote_dns", true);
          user_pref("network.file.disable_unc_paths", true);
          user_pref("network.gio.supported-protocols", "");

          /** PASSWORDS AND AUTOFILL ***/
          user_pref("signon.formlessCapture.enabled", false);
          user_pref("signon.privateBrowsingCapture.enabled", false);
          user_pref("signon.autofillForms", false);
          user_pref("signon.rememberSignons", false);
          user_pref("editor.truncate_user_pastes", false);

          /** ADDRESS + CREDIT CARD MANAGER ***/
          user_pref("extensions.formautofill.addresses.enabled", false);
          user_pref("extensions.formautofill.creditCards.enabled", false);
          user_pref("extensions.formautofill.heuristics.enabled", false);
          user_pref("browser.formfill.enable", false);

          /** MIXED CONTENT + CROSS-SITE ***/
          user_pref("network.auth.subresource-http-auth-allow", 1);
          user_pref("pdfjs.enableScripting", false);
          user_pref("extensions.postDownloadThirdPartyPrompt", false);
          user_pref("permissions.delegation.enabled", false);

          /** HEADERS / REFERERS ***/
          user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

          /** CONTAINERS ***/
          user_pref("privacy.userContext.ui.enabled", true);

          /** WEBRTC ***/
          user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);
          user_pref("media.peerconnection.ice.default_address_only", true);

          /** SAFE BROWSING ***/
          user_pref("browser.safebrowsing.downloads.remote.enabled", false);

          /** MOZILLA ***/
          user_pref("accessibility.force_disabled", 1);
          user_pref("identity.fxaccounts.enabled", false);
          user_pref("browser.tabs.firefox-view", false);
          user_pref("permissions.default.desktop-notification", 2);
          user_pref("permissions.default.geo", 2);
          user_pref("geo.provider.network.url", "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%");
          user_pref("geo.provider.ms-windows-location", false); // WINDOWS
          user_pref("geo.provider.use_corelocation", false); // MAC
          user_pref("geo.provider.use_gpsd", false); // LINUX
          user_pref("geo.provider.use_geoclue", false); // LINUX
          user_pref("permissions.manager.defaultsUrl", "");
          user_pref("webchannel.allowObject.urlWhitelist", "");

          /** TELEMETRY ***/
          user_pref("toolkit.telemetry.unified", false);
          user_pref("toolkit.telemetry.enabled", false);
          user_pref("toolkit.telemetry.server", "data:,");
          user_pref("toolkit.telemetry.archive.enabled", false);
          user_pref("toolkit.telemetry.newProfilePing.enabled", false);
          user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
          user_pref("toolkit.telemetry.updatePing.enabled", false);
          user_pref("toolkit.telemetry.bhrPing.enabled", false);
          user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
          user_pref("toolkit.telemetry.coverage.opt-out", true);
          user_pref("toolkit.coverage.opt-out", true);
          user_pref("datareporting.healthreport.uploadEnabled", false);
          user_pref("datareporting.policy.dataSubmissionEnabled", false);
          user_pref("app.shield.optoutstudies.enabled", false);
          user_pref("browser.discovery.enabled", false);
          user_pref("breakpad.reportURL", "");
          user_pref("browser.tabs.crashReporting.sendReport", false);
          user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
          user_pref("captivedetect.canonicalURL", "");
          user_pref("network.captive-portal-service.enabled", false);
          user_pref("network.connectivity-service.enabled", false);
          user_pref("default-browser-agent.enabled", false);
          user_pref("app.normandy.enabled", false);
          user_pref("app.normandy.api_url", "");
          user_pref("browser.ping-centre.telemetry", false);
          user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
          user_pref("browser.newtabpage.activity-stream.telemetry", false);

          /****************************************************************************
           * SECTION: PESKYFOX                                                        *
          ****************************************************************************/
          /** MOZILLA UI ***/
          user_pref("layout.css.prefers-color-scheme.content-override", 2);
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("app.update.suppressPrompts", true);
          user_pref("browser.compactmode.show", true);
          user_pref("browser.privatebrowsing.vpnpromourl", "");
          user_pref("extensions.getAddons.showPane", false);
          user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
          user_pref("browser.shell.checkDefaultBrowser", false);
          user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
          user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
          user_pref("browser.preferences.moreFromMozilla", false);
          user_pref("browser.tabs.tabmanager.enabled", false);
          user_pref("browser.aboutwelcome.enabled", false);
          user_pref("findbar.highlightAll", true);
          user_pref("middlemouse.contentLoadURL", false);
          user_pref("browser.privatebrowsing.enable-new-indicator", false);

          /** FULLSCREEN ***/
          user_pref("full-screen-api.transition-duration.enter", "0 0");
          user_pref("full-screen-api.transition-duration.leave", "0 0");
          user_pref("full-screen-api.warning.delay", -1);
          user_pref("full-screen-api.warning.timeout", 0);

          /** URL BAR ***/
          user_pref("browser.urlbar.suggest.engines", false);
          user_pref("browser.urlbar.suggest.topsites", false);
          user_pref("browser.urlbar.suggest.calculator", true);
          user_pref("browser.urlbar.unitConversion.enabled", true);

          /** NEW TAB PAGE ***/
          user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
          user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);

          /*** POCKET ***/
          user_pref("extensions.pocket.enabled", false);

          /** DOWNLOADS ***/
          user_pref("browser.download.useDownloadDir", false);
          user_pref("browser.download.alwaysOpenPanel", false);
          user_pref("browser.download.manager.addToRecentDocs", false);
          user_pref("browser.download.always_ask_before_handling_new_types", true);

          /** PDF ***/
          user_pref("browser.download.open_pdf_attachments_inline", true);

          /** TAB BEHAVIOR ***/
          user_pref("browser.tabs.loadBookmarksInTabs", true);
          user_pref("browser.bookmarks.openInTabClosesMenu", false);
          user_pref("layout.css.has-selector.enabled", true);

          /****************************************************************************
           * SECTION: SMOOTHFOX                                                       *
          ****************************************************************************/
          // visit https://github.com/yokoffing/Betterfox/blob/master/Smoothfox.js
          // Enter your scrolling prefs below this line:

          /****************************************************************************
           * START: MY OVERRIDES                                                      *
          ****************************************************************************/
          // Enter your personal prefs below this line:

          /****************************************************************************
           * END: BETTERFOX                                                           *
          ****************************************************************************/
        '';
        userChrome = ''
          # a css 
        '';
        userContent = ''
          # Here too
        '';
      };
    };
  };
}
