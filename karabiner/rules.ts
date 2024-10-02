import fs from "fs";
import { KarabinerRules } from "./types";
import { createHyperSubLayers, app, open, shell } from "./utils";

const rules: KarabinerRules[] = [
  // Define the Hyper key itself
  {
    description: "Hyper Key (⌃⌥⇧⌘)",
    manipulators: [
      {
        description: "Caps Lock -> Hyper Key",
        from: {
          key_code: "caps_lock",
          modifiers: {
            optional: ["any"],
          },
        },
        to: [
          {
            set_variable: {
              name: "hyper",
              value: 1,
            },
          },
        ],
        to_after_key_up: [
          {
            set_variable: {
              name: "hyper",
              value: 0,
            },
          },
        ],
        to_if_alone: [
          {
            key_code: "escape",
          },
        ],
        type: "basic",
      },
    ],
  },
  ...createHyperSubLayers({
    // spacebar: open(
    //   "raycast://extensions/stellate/mxstbr-commands/create-notion-todo"
    // ),
    // b = "B"rowse
    b: {
      // Quarterly "P"lan
      y: open("https://news.ycombinator.com"),
    },
    // o = "Open" applications
    o: {
      1: app("1Password"),
      a: app("Arc"),
      c: app("Notion Calendar"),
      v: app("Cursor"),
      d: app("Discord"),
      s: app("Slack"),
      e: app("Superhuman"),
      n: app("Notion"),
      w: app("Warp"),
      f: app("Finder"),
      p: app("Spotify"),
    },

    // w = "Window" via Raycast window management
    w: {
      semicolon: open(
        "raycast://extensions/raycast/window-management/hide-current-window"
      ),
      y: open(
        "raycast://extensions/raycast/window-management/move-window-to-previous-display"
      ),
      o: open(
        "raycast://extensions/raycast/window-management/move-window-to-next-display"
      ),
      k: open("raycast://extensions/raycast/window-management/top-half"),
      j: open("raycast://extensions/raycast/window-management/bottom-half"),
      h: open("raycast://extensions/raycast/window-management/left-half"),
      l: open("raycast://extensions/raycast/window-management/right-half"),
      f: open("raycast://extensions/raycast/window-management/maximize"),
      u: open("raycast://extensions/raycast/window-management/previous-tab"),
      i: open("raycast://extensions/raycast/window-management/next-tab"),
      n: open("raycast://extensions/raycast/window-management/next-window"),
      b: open("raycast://extensions/raycast/window-management/back"),
      m: open("raycast://extensions/raycast/window-management/forward"),
    },

    // s = "System"
    s: {
      u: {
        to: [
          {
            key_code: "volume_increment",
          },
        ],
      },
      j: {
        to: [
          {
            key_code: "volume_decrement",
          },
        ],
      },
      i: {
        to: [
          {
            key_code: "display_brightness_increment",
          },
        ],
      },
      k: {
        to: [
          {
            key_code: "display_brightness_decrement",
          },
        ],
      },
      l: {
        to: [
          {
            key_code: "q",
            modifiers: ["right_control", "right_command"],
          },
        ],
      },
      p: {
        to: [
          {
            key_code: "play_or_pause",
          },
        ],
      },
      semicolon: {
        to: [
          {
            key_code: "fastforward",
          },
        ],
      },
      d: open("raycast://extensions/raycast/system/toggle-do-not-disturb"),
      t: open("raycast://extensions/raycast/system/toggle-system-appearance"),
      c: open("raycast://extensions/raycast/system/open-camera"),
    },

    // v = "moVe" which isn't "m" because we want it to be on the left hand
    // so that hjkl work like they do in vim
    v: {
      h: {
        to: [{ key_code: "left_arrow" }],
      },
      j: {
        to: [{ key_code: "down_arrow" }],
      },
      k: {
        to: [{ key_code: "up_arrow" }],
      },
      l: {
        to: [{ key_code: "right_arrow" }],
      },
      u: {
        to: [{ key_code: "page_down" }],
      },
      i: {
        to: [{ key_code: "page_up" }],
      },
    },

    // c = Musi*c* which isn't "m" because we want it to be on the left hand
    c: {
      p: {
        to: [{ key_code: "play_or_pause" }],
      },
      n: {
        to: [{ key_code: "fastforward" }],
      },
      b: {
        to: [{ key_code: "rewind" }],
      },
    },

    // r = "Raycast"
    r: {
      c: open("raycast://extensions/raycast/color-picker/pick-color"),
      n: open("raycast://script-commands/dismiss-notifications"),
      e: open(
        "raycast://extensions/raycast/emoji-symbols/search-emoji-symbols"
      ),
      p: open("raycast://extensions/raycast/raycast/confetti"),
      a: open("raycast://extensions/raycast/raycast-ai/ai-chat"),
      h: open(
        "raycast://extensions/raycast/clipboard-history/clipboard-history"
      ),
    },
  }),
];

fs.writeFileSync(
  "karabiner.json",
  JSON.stringify(
    {
      global: {
        show_in_menu_bar: false,
      },
      profiles: [
        {
          name: "Default",
          complex_modifications: {
            rules,
          },
        },
      ],
    },
    null,
    2
  )
);
