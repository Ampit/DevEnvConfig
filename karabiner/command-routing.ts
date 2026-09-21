import fs from "fs";
import { KarabinerRules, KeyCode, To } from "./types";

type CommandBinding = {
  command: string;
  key: KeyCode;
  modifiers: NonNullable<To["modifiers"]>;
  receiverModifiers: string[];
};

const bindings: CommandBinding[] = [
  {
    "command": "open -a 'T3 Code (Nightly).app'",
    "key": "f13",
    "modifiers": [
      "left_control",
      "left_option",
      "left_shift"
    ],
    "receiverModifiers": [
      "ctrl",
      "alt",
      "shift"
    ]
  },
  {
    "command": "/usr/bin/open -g 'hammerspoon://focus-down'",
    "key": "f13",
    "modifiers": [
      "left_control",
      "left_shift"
    ],
    "receiverModifiers": [
      "ctrl",
      "shift"
    ]
  },
  {
    "command": "/usr/bin/open -g 'hammerspoon://focus-left'",
    "key": "f14",
    "modifiers": [
      "left_control",
      "left_shift"
    ],
    "receiverModifiers": [
      "ctrl",
      "shift"
    ]
  },
  {
    "command": "/usr/bin/open -g 'hammerspoon://focus-right'",
    "key": "f15",
    "modifiers": [
      "left_control",
      "left_shift"
    ],
    "receiverModifiers": [
      "ctrl",
      "shift"
    ]
  },
  {
    "command": "/usr/bin/open -g 'hammerspoon://focus-up'",
    "key": "f16",
    "modifiers": [
      "left_control",
      "left_shift"
    ],
    "receiverModifiers": [
      "ctrl",
      "shift"
    ]
  },
  {
    "command": "open -a '1Password.app'",
    "key": "f17",
    "modifiers": [
      "left_control",
      "left_shift"
    ],
    "receiverModifiers": [
      "ctrl",
      "shift"
    ]
  },
  {
    "command": "open -a 'Agent Orchestrator.app'",
    "key": "f18",
    "modifiers": [
      "left_control",
      "left_shift"
    ],
    "receiverModifiers": [
      "ctrl",
      "shift"
    ]
  },
  {
    "command": "open -a 'Arc.app'",
    "key": "f19",
    "modifiers": [
      "left_control",
      "left_shift"
    ],
    "receiverModifiers": [
      "ctrl",
      "shift"
    ]
  },
  {
    "command": "open -a 'ChatGPT.app'",
    "key": "f13",
    "modifiers": [
      "left_option",
      "left_shift"
    ],
    "receiverModifiers": [
      "alt",
      "shift"
    ]
  },
  {
    "command": "open -a 'Cursor.app'",
    "key": "f17",
    "modifiers": [
      "left_option",
      "left_shift"
    ],
    "receiverModifiers": [
      "alt",
      "shift"
    ]
  },
  {
    "command": "open -a 'Discord.app'",
    "key": "f18",
    "modifiers": [
      "left_option",
      "left_shift"
    ],
    "receiverModifiers": [
      "alt",
      "shift"
    ]
  },
  {
    "command": "open -a 'Finder.app'",
    "key": "f15",
    "modifiers": [
      "left_command"
    ],
    "receiverModifiers": [
      "cmd"
    ]
  },
  {
    "command": "open -a 'Firefox.app'",
    "key": "f13",
    "modifiers": [
      "left_command",
      "left_shift"
    ],
    "receiverModifiers": [
      "cmd",
      "shift"
    ]
  },
  {
    "command": "open -a 'Ghostty.app'",
    "key": "f14",
    "modifiers": [
      "left_command",
      "left_shift"
    ],
    "receiverModifiers": [
      "cmd",
      "shift"
    ]
  },
  {
    "command": "open -a 'Google Chrome.app'",
    "key": "f15",
    "modifiers": [
      "left_command",
      "left_shift"
    ],
    "receiverModifiers": [
      "cmd",
      "shift"
    ]
  },
  {
    "command": "open -a 'Linear.app'",
    "key": "f16",
    "modifiers": [
      "left_command",
      "left_shift"
    ],
    "receiverModifiers": [
      "cmd",
      "shift"
    ]
  },
  {
    "command": "open -a 'Notion Calendar.app'",
    "key": "f17",
    "modifiers": [
      "left_command",
      "left_shift"
    ],
    "receiverModifiers": [
      "cmd",
      "shift"
    ]
  },
  {
    "command": "open -a 'Notion.app'",
    "key": "f18",
    "modifiers": [
      "left_command",
      "left_shift"
    ],
    "receiverModifiers": [
      "cmd",
      "shift"
    ]
  },
  {
    "command": "open -a 'Obsidian.app'",
    "key": "f19",
    "modifiers": [
      "left_command",
      "left_shift"
    ],
    "receiverModifiers": [
      "cmd",
      "shift"
    ]
  },
  {
    "command": "open -a 'PgAdmin 4.app'",
    "key": "f20",
    "modifiers": [
      "left_command",
      "left_shift"
    ],
    "receiverModifiers": [
      "cmd",
      "shift"
    ]
  },
  {
    "command": "open -a 'Slack.app'",
    "key": "f13",
    "modifiers": [
      "left_command",
      "left_option",
      "left_shift"
    ],
    "receiverModifiers": [
      "cmd",
      "alt",
      "shift"
    ]
  },
  {
    "command": "open -a 'Spotify.app'",
    "key": "f14",
    "modifiers": [
      "left_command",
      "left_option",
      "left_shift"
    ],
    "receiverModifiers": [
      "cmd",
      "alt",
      "shift"
    ]
  },
  {
    "command": "open -a 'Superhuman.app'",
    "key": "f15",
    "modifiers": [
      "left_command",
      "left_option",
      "left_shift"
    ],
    "receiverModifiers": [
      "cmd",
      "alt",
      "shift"
    ]
  },
  {
    "command": "open -a 'Telegram.app'",
    "key": "f17",
    "modifiers": [
      "left_command",
      "left_option",
      "left_shift"
    ],
    "receiverModifiers": [
      "cmd",
      "alt",
      "shift"
    ]
  },
  {
    "command": "open -a 'Todoist.app'",
    "key": "f18",
    "modifiers": [
      "left_command",
      "left_option",
      "left_shift"
    ],
    "receiverModifiers": [
      "cmd",
      "alt",
      "shift"
    ]
  },
  {
    "command": "open -a 'TradingView.app'",
    "key": "f19",
    "modifiers": [
      "left_command",
      "left_option",
      "left_shift"
    ],
    "receiverModifiers": [
      "cmd",
      "alt",
      "shift"
    ]
  },
  {
    "command": "open -a 'Warp.app'",
    "key": "f20",
    "modifiers": [
      "left_command",
      "left_option",
      "left_shift"
    ],
    "receiverModifiers": [
      "cmd",
      "alt",
      "shift"
    ]
  },
  {
    "command": "open -a 'Webull Desktop.app'",
    "key": "f16",
    "modifiers": [
      "left_control",
      "left_option",
      "left_shift"
    ],
    "receiverModifiers": [
      "ctrl",
      "alt",
      "shift"
    ]
  },
  {
    "command": "open -a 'WhatsApp.app'",
    "key": "f17",
    "modifiers": [
      "left_control",
      "left_option",
      "left_shift"
    ],
    "receiverModifiers": [
      "ctrl",
      "alt",
      "shift"
    ]
  },
  {
    "command": "open -a 'Xcode.app'",
    "key": "f18",
    "modifiers": [
      "left_control",
      "left_option",
      "left_shift"
    ],
    "receiverModifiers": [
      "ctrl",
      "alt",
      "shift"
    ]
  },
  {
    "command": "open -a 'zoom.us.app'",
    "key": "f15",
    "modifiers": [
      "left_shift"
    ],
    "receiverModifiers": [
      "shift"
    ]
  },
  {
    "command": "open -g 'raycast://customWindowManagementCommand?position=center&relativeWidth=0.9&relativeHeight=0.9'",
    "key": "f16",
    "modifiers": [
      "left_shift"
    ],
    "receiverModifiers": [
      "shift"
    ]
  },
  {
    "command": "open -g 'raycast://extensions/raycast/window-management/bottom-half?launchType=background'",
    "key": "f17",
    "modifiers": [
      "left_shift"
    ],
    "receiverModifiers": [
      "shift"
    ]
  },
  {
    "command": "open -g 'raycast://extensions/raycast/window-management/center?launchType=background'",
    "key": "f18",
    "modifiers": [
      "left_shift"
    ],
    "receiverModifiers": [
      "shift"
    ]
  },
  {
    "command": "open -g 'raycast://extensions/raycast/window-management/left-half?launchType=background'",
    "key": "f19",
    "modifiers": [
      "left_shift"
    ],
    "receiverModifiers": [
      "shift"
    ]
  },
  {
    "command": "open -g 'raycast://extensions/raycast/window-management/maximize?launchType=background'",
    "key": "f16",
    "modifiers": [
      "left_command"
    ],
    "receiverModifiers": [
      "cmd"
    ]
  },
  {
    "command": "open -g 'raycast://extensions/raycast/window-management/move-to-next-display?launchType=background'",
    "key": "f13",
    "modifiers": [
      "left_control"
    ],
    "receiverModifiers": [
      "ctrl"
    ]
  },
  {
    "command": "open -g 'raycast://extensions/raycast/window-management/move-to-previous-display?launchType=background'",
    "key": "f16",
    "modifiers": [
      "left_control"
    ],
    "receiverModifiers": [
      "ctrl"
    ]
  },
  {
    "command": "open -g 'raycast://extensions/raycast/window-management/right-half?launchType=background'",
    "key": "f13",
    "modifiers": [
      "left_command",
      "left_option"
    ],
    "receiverModifiers": [
      "cmd",
      "alt"
    ]
  },
  {
    "command": "open -g 'raycast://extensions/raycast/window-management/top-half?launchType=background'",
    "key": "f14",
    "modifiers": [
      "left_command",
      "left_option"
    ],
    "receiverModifiers": [
      "cmd",
      "alt"
    ]
  },
  {
    "command": "open https://github.com/ampit",
    "key": "f15",
    "modifiers": [
      "left_command",
      "left_option"
    ],
    "receiverModifiers": [
      "cmd",
      "alt"
    ]
  },
  {
    "command": "open https://wakatime.com/dashboard",
    "key": "f16",
    "modifiers": [
      "left_command",
      "left_option"
    ],
    "receiverModifiers": [
      "cmd",
      "alt"
    ]
  },
  {
    "command": "open raycast://extensions/asubbotin/pomodoro/pomodoro-control-timer",
    "key": "f17",
    "modifiers": [
      "left_command",
      "left_option"
    ],
    "receiverModifiers": [
      "cmd",
      "alt"
    ]
  },
  {
    "command": "open raycast://extensions/raycast/clipboard-history/clipboard-history",
    "key": "f18",
    "modifiers": [
      "left_command",
      "left_option"
    ],
    "receiverModifiers": [
      "cmd",
      "alt"
    ]
  },
  {
    "command": "open raycast://extensions/raycast/emoji-symbols/search-emoji-symbols",
    "key": "f19",
    "modifiers": [
      "left_command",
      "left_option"
    ],
    "receiverModifiers": [
      "cmd",
      "alt"
    ]
  },
  {
    "command": "open raycast://extensions/raycast/raycast/confetti",
    "key": "f13",
    "modifiers": [
      "left_control",
      "left_option"
    ],
    "receiverModifiers": [
      "ctrl",
      "alt"
    ]
  },
  {
    "command": "open raycast://extensions/raycast/raycast/open-camera",
    "key": "f14",
    "modifiers": [
      "left_control",
      "left_option"
    ],
    "receiverModifiers": [
      "ctrl",
      "alt"
    ]
  },
  {
    "command": "open raycast://extensions/raycast/system-actions/toggle-system-appearance?launchType=background",
    "key": "f16",
    "modifiers": [
      "left_control",
      "left_option"
    ],
    "receiverModifiers": [
      "ctrl",
      "alt"
    ]
  },
  {
    "command": "open raycast://extensions/thomas/color-picker/pick-color",
    "key": "f17",
    "modifiers": [
      "left_control",
      "left_option"
    ],
    "receiverModifiers": [
      "ctrl",
      "alt"
    ]
  },
  {
    "command": "open raycast://extensions/raycast/system-actions/dismiss-notifications?launchType=background",
    "key": "f18",
    "modifiers": [
      "left_control",
      "left_option"
    ],
    "receiverModifiers": [
      "ctrl",
      "alt"
    ]
  },
  {
    "command": "osascript -e 'tell application \"System Events\" to set visible of every process to false'",
    "key": "f19",
    "modifiers": [
      "left_control",
      "left_option"
    ],
    "receiverModifiers": [
      "ctrl",
      "alt"
    ]
  },
  {
    "command": "osascript -e 'tell application \"System Events\" to set visible of every process to true'",
    "key": "f20",
    "modifiers": [
      "left_control",
      "left_option"
    ],
    "receiverModifiers": [
      "ctrl",
      "alt"
    ]
  }
];

export function routeCommands(rules: KarabinerRules[]): KarabinerRules[] {
  for (const binding of bindings) {
    if (!/^f(1[3-9]|20)$/.test(binding.key)) {
      throw new Error("Receiver keys must use F13-F20 to avoid media-key translation");
    }
    if (binding.receiverModifiers.includes("cmd") && binding.receiverModifiers.includes("ctrl")) {
      throw new Error("Receiver modifiers must not include both Command and Control: Wispr uses that chord for dictation");
    }
  }
  const byCommand = new Map(bindings.map(binding => [binding.command, binding]));
  const used = new Set<string>();
  const route = (event: To): To => {
    if (!event.shell_command) return event;
    const binding = byCommand.get(event.shell_command);
    if (!binding) throw new Error(`No receiver binding for: ${event.shell_command}`);
    used.add(binding.command);
    const { shell_command, ...rest } = event;
    return { ...rest, key_code: binding.key, modifiers: binding.modifiers };
  };
  const result = rules.map(rule => ({
    ...rule,
    manipulators: rule.manipulators?.map(manipulator => ({
      ...manipulator,
      ...(manipulator.to ? { to: manipulator.to.map(route) } : {}),
      ...(manipulator.to_if_alone ? { to_if_alone: manipulator.to_if_alone.map(route) } : {}),
      ...(manipulator.to_after_key_up ? { to_after_key_up: manipulator.to_after_key_up.map(route) } : {}),
    })),
  }));
  if (used.size !== bindings.length) throw new Error("Unused receiver bindings; update the registry");
  fs.writeFileSync("command-receiver.json", JSON.stringify(bindings, null, 2));
  return result;
}
