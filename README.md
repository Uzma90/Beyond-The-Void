# Beyond-The-Void

A 2D platformer game built with Godot and deployed as a web-based experience.

## About

Beyond-The-Void is an immersive 2D platformer adventure game created with the Godot Engine. The project features character-driven gameplay, environmental puzzles, and an engaging storyline delivered through interactive cutscenes. The game is fully playable in the browser via WebAssembly export.

## Features

- **2D Platformer Gameplay** - Smooth character movement and platforming mechanics
- **Cutscene System** - Dynamic story sequences that drive the narrative
- **Collectibles** - Gem collection mechanics for progression and rewards
- **Interactive Environments** - Platform-based level design with environmental challenges
- **Web-Based** - Play directly in your browser via WebAssembly export
- **Cross-Platform** - Configured for multiple platform exports (Web, Windows, etc.)

## Technology Stack

| Language | Percentage | Purpose |
|----------|-----------|---------|
| JavaScript | 42.2% | Web frontend and browser interactivity |
| GDScript | 35.5% | Godot game logic and mechanics |
| HTML | 22.3% | Web page structure and deployment |

## Project Structure

```
Beyond-The-Void/
├── scripts/              # GDScript files for game logic
├── sceans/               # Scene files (game levels and components)
├── assets/               # Game assets (sprites, animations, etc.)
├── font/                 # Custom fonts for UI
├── index.html            # Web export entry point
├── index.js              # Web export JavaScript runtime
├── index.wasm            # WebAssembly compiled Godot engine
├── index.pck             # Godot game data package
├── cutscene.gd           # Cutscene script system
├── cutscene.tscn         # Cutscene scene template
├── character_body_2d.tscn # Player character scene
├── game.tscn             # Main game scene
├── gems.tscn             # Collectible gems scene
├── platform.tscn         # Platform objects scene
├── tileset.png           # Tileset artwork
├── project.godot         # Godot project configuration
└── export_presets.cfg    # Export platform configurations
```

## Getting Started

### Prerequisites

- Godot Engine 4.x (for development)
- Web browser (to play the web export)

### Playing in Browser

Simply open the game at the GitHub Pages deployment or navigate to the `index.html` file to play in your browser.

### Development Setup

1. Install Godot Engine from https://godotengine.org/download
2. Open the project by selecting the `project.godot` file
3. Run the project using Play or build for different platforms using the Export menu

## Game Controls

- Arrow Keys or WASD - Move character
- Space - Jump
- Interact - Collect gems and trigger events
- Skip - Skip cutscenes (configuration may vary)

## Assets

- **Tileset** - `tileset.png` provides the visual foundation for level design
- **Icons** - Custom icon and Apple touch icon included
- **Fonts** - Stored in the `font/` directory for consistent UI styling

## Building and Exporting

The project includes export presets configured for:
- Web (WebAssembly) - Current deployment format
- Windows - Desktop executable
- Additional platforms can be configured in Godot's export settings

To export:

1. Open Godot project
2. Navigate to Project > Export
3. Select your desired platform
4. Click Export

## License

This project is open source. See the repository for license details.

## Contributing

Contributions are welcome. Feel free to:
- Report bugs and issues
- Suggest new features
- Submit pull requests with improvements

## Author

Uzma90 - Game Developer

## Support

For issues, questions, or suggestions, please open an issue in the GitHub repository.
