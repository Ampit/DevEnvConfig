import fs from "fs";
import { KarabinerRules } from "./types";
import { createHyperSubLayers, app, open, rectangle } from "./utils";

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
    spacebar: open(
      "raycast://extensions/asubbotin/pomodoro/pomodoro-control-timer"
    ),
    // Mouse controls
    d: {
      // Slow mouse controls
      h: {
        to: [{ mouse_key: { x: -500 } }], // Move mouse left
      },
      j: {
        to: [{ mouse_key: { y: 500 } }], // Move mouse down
      },
      k: {
        to: [{ mouse_key: { y: -500 } }], // Move mouse up
      },
      l: {
        to: [{ mouse_key: { x: 500 } }], // Move mouse right
      },
    },
    f: {
      // Fast mouse controls
      h: {
        to: [{ mouse_key: { x: -5000 } }], // Move mouse left
      },
      j: {
        to: [{ mouse_key: { y: 5000 } }], // Move mouse down
      },
      k: {
        to: [{ mouse_key: { y: -5000 } }], // Move mouse up
      },
      l: {
        to: [{ mouse_key: { x: 5000 } }], // Move mouse right
      },
    },
    // Normal mouse controls for when f is not held
    h: {
      to: [{ mouse_key: { x: -1500 } }], // Move mouse left
    },
    j: {
      to: [{ mouse_key: { y: 1500 } }], // Move mouse down
    },
    k: {
      to: [{ mouse_key: { y: -1500 } }], // Move mouse up
    },
    l: {
      to: [{ mouse_key: { x: 1500 } }], // Move mouse right
    },
    e: {
      to: [{ pointing_button: "button1" }], // Left click
    },
    t: {
      to: [{ pointing_button: "button2" }], // Right click
    },
    // b = "B"rowse
    b: {
      w: open("https://wakatime.com/dashboard"),
      g: open("https://github.com/ampit"),
    },
    // o = "Open" applications
    o: {
      1: app("1Password"),
      2: app("Telegram"),
      3: app("Firefox"),
      4: app("Zed"),
      5: app("Webull Desktop"),
      a: app("Arc"),
      b: app("Obsidian"), // o is taken by "Open"
      c: app("Notion Calendar"),
      d: app("Discord"),
      e: app("Superhuman"),
      f: app("Finder"),
      g: app("Figma"), // f is taken by "Finder"
      h: app("Google Chrome"),
      i: app("iTerm"),
      j: app("Webstorm"), // j for JetBrains
      k: app("WhatsApp"),
      l: app("RunJS"),
      m: app("Spotify"),
      n: app("Notion"),
      p: app("Postman"),
      r: app("Linear"), // l is hard to press with o "Open"
      s: app("Slack"),
      t: app("TablePlus"),
      u: app("PgAdmin 4"),
      v: app("Cursor"),
      w: app("Warp"),
      x: app("ChatGPT"),
      y: app("Xcode"),
      z: app("zoom.us"),
    },

    // w = "Window" via rectangle.app
    w: {
      semicolon: {
        description: "Window: Hide",
        to: [
          {
            key_code: "h",
            modifiers: ["right_command"],
          },
        ],
      },
      y: rectangle("previous-display"),
      o: rectangle("next-display"),
      k: rectangle("top-half"),
      j: rectangle("bottom-half"),
      l: rectangle("right-half"),
      h: rectangle("left-half"),
      f: rectangle("maximize"),
      c: rectangle("center"),
      g: rectangle("almost-maximize"),
      u: {
        description: "Window: Previous Tab",
        to: [
          {
            key_code: "tab",
            modifiers: ["right_control", "right_shift"],
          },
        ],
      },
      i: {
        description: "Window: Next Tab",
        to: [
          {
            key_code: "tab",
            modifiers: ["right_control"],
          },
        ],
      },
      n: {
        description: "Window: Next Window",
        to: [
          {
            key_code: "grave_accent_and_tilde",
            modifiers: ["right_command"],
          },
        ],
      },
      b: {
        description: "Window: Back",
        to: [
          {
            key_code: "open_bracket",
            modifiers: ["right_command"],
          },
        ],
      },
      // Note: No literal connection. Both f and n are already taken.
      m: {
        description: "Window: Forward",
        to: [
          {
            key_code: "close_bracket",
            modifiers: ["right_command"],
          },
        ],
      },
      // x to quit application, can also do command + q
      x: {
        to: [
          {
            key_code: "q",
            modifiers: ["left_command"],
          },
        ],
      },
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
      n: {
        to: [{ mouse_key: { vertical_wheel: 50 } }],
      },
      m: {
        to: [{ mouse_key: { vertical_wheel: -50 } }],
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
      c: open("raycast://extensions/thomas/color-picker/pick-color"),
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
