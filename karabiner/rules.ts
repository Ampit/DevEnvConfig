import fs from "fs";
import { routeCommands } from "./command-routing";
import { KarabinerRules } from "./types";
import { createHyperSubLayers, app, open, windowManagement } from "./utils";

const rules: KarabinerRules[] = [
  {
    description: "Option + Shift + HJKL: Focus windows across displays with wrap",
    manipulators: [
      {
        type: "basic",
        from: {
          key_code: "h",
          modifiers: { mandatory: ["option", "shift"] },
        },
        conditions: [{ type: "variable_unless", name: "hyper", value: 1 }],
        to: [{ shell_command: "/usr/bin/open -g 'hammerspoon://focus-left'" }],
      },
      {
        type: "basic",
        from: {
          key_code: "j",
          modifiers: { mandatory: ["option", "shift"] },
        },
        conditions: [{ type: "variable_unless", name: "hyper", value: 1 }],
        to: [{ shell_command: "/usr/bin/open -g 'hammerspoon://focus-down'" }],
      },
      {
        type: "basic",
        from: {
          key_code: "k",
          modifiers: { mandatory: ["option", "shift"] },
        },
        conditions: [{ type: "variable_unless", name: "hyper", value: 1 }],
        to: [{ shell_command: "/usr/bin/open -g 'hammerspoon://focus-up'" }],
      },
      {
        type: "basic",
        from: {
          key_code: "l",
          modifiers: { mandatory: ["option", "shift"] },
        },
        conditions: [{ type: "variable_unless", name: "hyper", value: 1 }],
        to: [{ shell_command: "/usr/bin/open -g 'hammerspoon://focus-right'" }],
      },
    ],
  },
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
  {
    description: "Block Mouse Button 5",
    manipulators: [
      {
        type: "basic",
        from: {
          pointing_button: "button5",
        },
        to: [],
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
      3: app("T3 Code (Nightly)"),
      a: app("Arc"),
      b: app("Obsidian"),
      c: app("Notion Calendar"),
      d: app("Discord"),
      e: app("Superhuman"),
      f: app("Finder"),
      g: app("Ghostty"),
      h: app("Google Chrome"),
      k: app("WhatsApp"),
      l: app("Linear"),
      m: app("Spotify"),
      n: app("Notion"),
      s: app("Slack"),
      t: app("Telegram"),
      u: app("PgAdmin 4"),
      v: app("Agent Orchestrator"),
      w: app("Warp"),
      x: app("ChatGPT"),
      y: app("Xcode"),
      z: app("zoom.us"),
    },
    i: {
      d: app("TradingView"),
      f: app("Firefox"),
      s: app("Todoist"),
      v: app("Cursor"),
      w: app("Webull Desktop"),
    },

    // w = "Window" via Raycast
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
      y: windowManagement("previous-display"),
      o: windowManagement("next-display"),
      k: windowManagement("top-half"),
      j: windowManagement("bottom-half"),
      l: windowManagement("right-half"),
      h: windowManagement("left-half"),
      f: windowManagement("maximize"),
      c: windowManagement("center"),
      g: windowManagement("almost-maximize"),
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
      // Hide/Show all windows (e = empty/hide, r = restore/show)
      e: {
        description: "Window: Hide All",
        to: [
          {
            shell_command:
              "osascript -e 'tell application \"System Events\" to set visible of every process to false'",
          },
        ],
      },
      r: {
        description: "Window: Show All",
        to: [
          {
            shell_command:
              "osascript -e 'tell application \"System Events\" to set visible of every process to true'",
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
      t: open("raycast://extensions/raycast/system-actions/toggle-system-appearance?launchType=background"),
      c: open("raycast://extensions/raycast/raycast/open-camera"),
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
      n: open("raycast://extensions/raycast/system-actions/dismiss-notifications?launchType=background"),
      e: open(
        "raycast://extensions/raycast/emoji-symbols/search-emoji-symbols"
      ),
      p: open("raycast://extensions/raycast/raycast/confetti"),
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
          virtual_hid_keyboard: { keyboard_type_v2: "ansi" },
          complex_modifications: {
            rules: routeCommands(rules),
          },
        },
      ],
    },
    null,
    2
  )
);
