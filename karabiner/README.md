# Karabiner Configuration System

This repository contains a TypeScript-based configuration system for Karabiner-Elements, allowing for a more maintainable and type-safe way to configure keyboard modifications.

## Overview

The system consists of three main components:

1. `rules.ts` - Contains the actual keyboard modification rules
2. `utils.ts` - Helper functions and types for creating rules
3. `karabiner.json` - The generated Karabiner configuration file

## How It Works

### Configuration Flow

1. We write our configuration in TypeScript using the provided utilities
2. The TypeScript code is compiled and executed
3. It generates a `karabiner.json` file that Karabiner-Elements can understand
4. Karabiner-Elements reads this JSON file and applies the modifications

### Key Components

#### Hyper Key
- Maps Caps Lock to act as a "Hyper Key" (⌃⌥⇧⌘)
- When pressed alone, acts as Escape
- When held, enables access to various sublayers

#### Sublayers
The configuration uses a sublayer system where:
- Hyper + Key activates a sublayer
- While in a sublayer, other keys trigger specific actions
- Sublayers can be nested (e.g. Hyper + O + 2 + F opens Firefox)

### Implementation Details

#### Utils.ts
- Provides type definitions and helper functions
- `createHyperSubLayer()` - Creates a sublayer triggered by Hyper + key
- `createHyperSubLayers()` - Processes all sublayer definitions
- Helper functions like `app()`, `open()`, `rectangle()` for common actions

#### Rules.ts
- Defines the actual keyboard modifications
- Uses the utilities to create structured configurations
- Outputs the final JSON configuration