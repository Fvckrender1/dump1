# Crystal Growth Simulator

An interactive particle system where clicks spawn crystalline formations that grow and refract light. Built with vanilla JavaScript and HTML5 Canvas.

![Crystal Growth Simulator](https://img.shields.io/badge/status-active-success)

## Features

### Interactive Crystal Growth
- **Click to Spawn**: Click anywhere on the canvas to spawn a crystalline formation
- **Recursive Branching**: Crystals grow using a recursive branching algorithm with multiple generations
- **Real-time Growth**: Watch crystals grow dynamically from their spawn point

### Visual Effects
- **Light Refraction**: Radial gradients and glow effects simulate light refraction through crystals
- **Particle System**: Thousands of particles emit from crystal structures with physics-based movement
- **Shadow & Bloom**: Atmospheric rendering with shadow blur and bloom effects
- **Fade Trails**: Motion trails create ethereal visual effects

### User Controls

#### Growth Parameters
- **Growth Speed** (0.5 - 5.0): Control how fast crystals grow
- **Complexity** (3 - 12): Adjust the number of branches per node
- **Branch Length** (10 - 100): Set the length of crystal branches
- **Particle Density** (0.1 - 2.0): Control particle emission rate

#### Color Palettes
- **Ice Blues**: Cool cyan and blue tones for icy crystalline structures
- **Acid Greens**: Vibrant green hues for toxic-looking crystals
- **Blood Reds**: Deep red and crimson for dramatic formations
- **Aurora**: Soft pastel gradient inspired by northern lights
- **Toxic**: Purple and magenta for otherworldly crystals

#### Actions
- **Clear Canvas**: Remove all crystals and particles
- **Pause/Resume**: Freeze and resume the simulation

## Technical Details

### Architecture

#### Classes
- **Particle**: Individual light particles with physics simulation
  - Position, velocity, life cycle
  - Decay and alpha blending
  - Radial gradient rendering

- **CrystalBranch**: Single branch of a crystal structure
  - Recursive growth with parent-child relationships
  - Generation tracking (up to 4 levels deep)
  - Segment-based particle emission points

- **Crystal**: Complete crystal formation
  - Multiple initial branches arranged radially
  - Central core with glow effect
  - Color palette management

- **CrystalSimulator**: Main simulation engine
  - Canvas rendering and animation loop
  - User input handling
  - Particle and crystal management

### Rendering Techniques
- **Fade Trail Effect**: Canvas cleared with low-alpha black for motion blur
- **Layered Rendering**: Particles → Crystal branches → Central cores
- **GPU-Accelerated**: Uses Canvas2D with hardware acceleration
- **Shadow Blur**: Multiple blur layers for depth perception

### Performance
- Particle limit: 1000 concurrent particles
- Automatic particle cleanup when life expires
- Efficient canvas operations with alpha blending
- ~60 FPS on modern hardware

## Getting Started

### Installation
1. Clone the repository
2. Open `index.html` in a modern web browser
3. No build process or dependencies required!

### Usage
1. Click anywhere on the canvas to spawn a crystal
2. Adjust growth parameters in real-time using the control panel
3. Switch between color palettes to change the aesthetic
4. Clear the canvas to start fresh

## Browser Support
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

Requires HTML5 Canvas and ES6 support.

## Credits
Created for interactive visual art and creative coding exploration.

## License
MIT License - Feel free to use and modify for your own projects!
