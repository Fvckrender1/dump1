class Particle {
    constructor(x, y, color, size, velocity) {
        this.x = x;
        this.y = y;
        this.color = color;
        this.size = size;
        this.velocity = velocity;
        this.life = 1.0;
        this.decay = Math.random() * 0.005 + 0.002;
        this.alpha = 1.0;
    }

    update() {
        this.x += this.velocity.x;
        this.y += this.velocity.y;
        this.velocity.x *= 0.98;
        this.velocity.y *= 0.98;
        this.life -= this.decay;
        this.alpha = this.life;
        return this.life > 0;
    }

    draw(ctx) {
        ctx.save();
        ctx.globalAlpha = this.alpha;

        // Outer glow
        const gradient = ctx.createRadialGradient(this.x, this.y, 0, this.x, this.y, this.size * 3);
        gradient.addColorStop(0, this.color);
        gradient.addColorStop(0.5, this.color.replace('1)', '0.3)'));
        gradient.addColorStop(1, 'rgba(0,0,0,0)');

        ctx.fillStyle = gradient;
        ctx.fillRect(this.x - this.size * 3, this.y - this.size * 3, this.size * 6, this.size * 6);

        // Core
        ctx.fillStyle = this.color;
        ctx.shadowBlur = 15;
        ctx.shadowColor = this.color;
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
        ctx.fill();

        ctx.restore();
    }
}

class CrystalBranch {
    constructor(x, y, angle, length, generation, color, maxGen) {
        this.startX = x;
        this.startY = y;
        this.x = x;
        this.y = y;
        this.angle = angle;
        this.length = length;
        this.generation = generation;
        this.maxGeneration = maxGen;
        this.color = color;
        this.growth = 0;
        this.maxGrowth = 1;
        this.complete = false;
        this.children = [];
        this.segments = [];
    }

    update(speed) {
        if (this.growth < this.maxGrowth) {
            this.growth += speed * 0.02;
            if (this.growth >= this.maxGrowth) {
                this.growth = this.maxGrowth;
                this.complete = true;
            }

            const currentLength = this.length * this.growth;
            this.x = this.startX + Math.cos(this.angle) * currentLength;
            this.y = this.startY + Math.sin(this.angle) * currentLength;

            // Create segments for particle emission
            const segmentCount = Math.floor(currentLength / 5);
            this.segments = [];
            for (let i = 0; i <= segmentCount; i++) {
                const t = i / segmentCount;
                this.segments.push({
                    x: this.startX + Math.cos(this.angle) * currentLength * t,
                    y: this.startY + Math.sin(this.angle) * currentLength * t
                });
            }
        }

        this.children.forEach(child => child.update(speed));
    }

    draw(ctx) {
        if (this.growth <= 0) return;

        const currentLength = this.length * this.growth;
        const endX = this.startX + Math.cos(this.angle) * currentLength;
        const endY = this.startY + Math.sin(this.angle) * currentLength;

        ctx.save();

        // Draw glow
        ctx.strokeStyle = this.color;
        ctx.lineWidth = 3 + (this.maxGeneration - this.generation);
        ctx.shadowBlur = 20;
        ctx.shadowColor = this.color;
        ctx.globalAlpha = 0.6;

        ctx.beginPath();
        ctx.moveTo(this.startX, this.startY);
        ctx.lineTo(endX, endY);
        ctx.stroke();

        // Draw core line
        ctx.shadowBlur = 30;
        ctx.lineWidth = 1 + (this.maxGeneration - this.generation) * 0.5;
        ctx.globalAlpha = 1;
        ctx.stroke();

        // Draw crystalline node
        ctx.fillStyle = this.color;
        ctx.shadowBlur = 25;
        ctx.beginPath();
        ctx.arc(endX, endY, 2 + (this.maxGeneration - this.generation) * 0.5, 0, Math.PI * 2);
        ctx.fill();

        ctx.restore();

        this.children.forEach(child => child.draw(ctx));
    }

    spawn(complexity, branchLength, colorPalette) {
        if (this.generation >= this.maxGeneration || !this.complete) return;
        if (this.children.length > 0) return;

        const branchCount = Math.floor(complexity);
        const angleSpread = Math.PI / 2;

        for (let i = 0; i < branchCount; i++) {
            const branchAngle = this.angle + (Math.random() - 0.5) * angleSpread;
            const newLength = branchLength * (0.6 + Math.random() * 0.3);
            const color = colorPalette[Math.floor(Math.random() * colorPalette.length)];

            const child = new CrystalBranch(
                this.x,
                this.y,
                branchAngle,
                newLength,
                this.generation + 1,
                color,
                this.maxGeneration
            );

            this.children.push(child);
        }
    }

    getAllSegments() {
        let allSegments = [...this.segments];
        this.children.forEach(child => {
            allSegments = allSegments.concat(child.getAllSegments());
        });
        return allSegments;
    }
}

class Crystal {
    constructor(x, y, complexity, branchLength, colorPalette) {
        this.x = x;
        this.y = y;
        this.branches = [];
        this.colorPalette = colorPalette;
        this.complexity = complexity;
        this.branchLength = branchLength;

        const initialBranches = Math.floor(complexity * 1.5);
        const angleStep = (Math.PI * 2) / initialBranches;

        for (let i = 0; i < initialBranches; i++) {
            const angle = angleStep * i + Math.random() * 0.3;
            const color = colorPalette[Math.floor(Math.random() * colorPalette.length)];
            const branch = new CrystalBranch(x, y, angle, branchLength, 0, color, 4);
            this.branches.push(branch);
        }
    }

    update(speed) {
        this.branches.forEach(branch => {
            branch.update(speed);
            if (branch.complete) {
                branch.spawn(this.complexity, this.branchLength, this.colorPalette);
            }
        });
    }

    draw(ctx) {
        // Draw central core
        ctx.save();
        ctx.fillStyle = this.colorPalette[0];
        ctx.shadowBlur = 30;
        ctx.shadowColor = this.colorPalette[0];
        ctx.beginPath();
        ctx.arc(this.x, this.y, 5, 0, Math.PI * 2);
        ctx.fill();
        ctx.restore();

        this.branches.forEach(branch => branch.draw(ctx));
    }

    getAllSegments() {
        let allSegments = [];
        this.branches.forEach(branch => {
            allSegments = allSegments.concat(branch.getAllSegments());
        });
        return allSegments;
    }
}

class CrystalSimulator {
    constructor() {
        this.canvas = document.getElementById('crystalCanvas');
        this.ctx = this.canvas.getContext('2d');
        this.crystals = [];
        this.particles = [];
        this.isPaused = false;

        this.settings = {
            growthSpeed: 2,
            complexity: 6,
            branchLength: 40,
            particleDensity: 1,
            palette: 'ice'
        };

        this.colorPalettes = {
            ice: [
                'rgba(135, 206, 250, 1)',
                'rgba(176, 224, 230, 1)',
                'rgba(173, 216, 230, 1)',
                'rgba(135, 206, 235, 1)',
                'rgba(100, 149, 237, 1)'
            ],
            acid: [
                'rgba(50, 255, 126, 1)',
                'rgba(144, 238, 144, 1)',
                'rgba(152, 251, 152, 1)',
                'rgba(0, 255, 127, 1)',
                'rgba(127, 255, 212, 1)'
            ],
            blood: [
                'rgba(220, 20, 60, 1)',
                'rgba(255, 69, 0, 1)',
                'rgba(255, 99, 71, 1)',
                'rgba(255, 20, 147, 1)',
                'rgba(199, 21, 133, 1)'
            ],
            aurora: [
                'rgba(168, 237, 234, 1)',
                'rgba(254, 214, 227, 1)',
                'rgba(255, 209, 255, 1)',
                'rgba(207, 186, 240, 1)',
                'rgba(163, 228, 215, 1)'
            ],
            toxic: [
                'rgba(196, 113, 245, 1)',
                'rgba(250, 113, 205, 1)',
                'rgba(255, 0, 255, 1)',
                'rgba(186, 85, 211, 1)',
                'rgba(218, 112, 214, 1)'
            ]
        };

        this.init();
    }

    init() {
        this.resize();
        window.addEventListener('resize', () => this.resize());
        this.canvas.addEventListener('click', (e) => this.handleClick(e));
        this.setupControls();
        this.animate();
    }

    resize() {
        this.canvas.width = window.innerWidth;
        this.canvas.height = window.innerHeight;
    }

    handleClick(e) {
        const rect = this.canvas.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;

        const colorPalette = this.colorPalettes[this.settings.palette];
        const crystal = new Crystal(
            x,
            y,
            this.settings.complexity,
            this.settings.branchLength,
            colorPalette
        );

        this.crystals.push(crystal);
        this.spawnImpactParticles(x, y, colorPalette);
    }

    spawnImpactParticles(x, y, colorPalette) {
        const count = 30;
        for (let i = 0; i < count; i++) {
            const angle = (Math.PI * 2 * i) / count;
            const speed = Math.random() * 3 + 2;
            const color = colorPalette[Math.floor(Math.random() * colorPalette.length)];

            const particle = new Particle(
                x, y,
                color,
                Math.random() * 2 + 1,
                {
                    x: Math.cos(angle) * speed,
                    y: Math.sin(angle) * speed
                }
            );

            this.particles.push(particle);
        }
    }

    spawnCrystalParticles() {
        if (Math.random() > this.settings.particleDensity * 0.3) return;

        this.crystals.forEach(crystal => {
            const segments = crystal.getAllSegments();
            if (segments.length === 0) return;

            const segment = segments[Math.floor(Math.random() * segments.length)];
            const color = crystal.colorPalette[Math.floor(Math.random() * crystal.colorPalette.length)];

            const angle = Math.random() * Math.PI * 2;
            const speed = Math.random() * 0.5 + 0.2;

            const particle = new Particle(
                segment.x,
                segment.y,
                color,
                Math.random() * 1.5 + 0.5,
                {
                    x: Math.cos(angle) * speed,
                    y: Math.sin(angle) * speed
                }
            );

            this.particles.push(particle);
        });
    }

    update() {
        if (this.isPaused) return;

        this.crystals.forEach(crystal => {
            crystal.update(this.settings.growthSpeed);
        });

        this.particles = this.particles.filter(particle => particle.update());

        if (this.particles.length < 1000) {
            this.spawnCrystalParticles();
        }

        this.updateStats();
    }

    draw() {
        // Clear with fade effect
        this.ctx.fillStyle = 'rgba(10, 14, 23, 0.1)';
        this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);

        // Draw particles
        this.particles.forEach(particle => particle.draw(this.ctx));

        // Draw crystals
        this.crystals.forEach(crystal => crystal.draw(this.ctx));
    }

    animate() {
        this.update();
        this.draw();
        requestAnimationFrame(() => this.animate());
    }

    setupControls() {
        const speedSlider = document.getElementById('growthSpeed');
        const speedValue = document.getElementById('speedValue');
        speedSlider.addEventListener('input', (e) => {
            this.settings.growthSpeed = parseFloat(e.target.value);
            speedValue.textContent = this.settings.growthSpeed.toFixed(1);
        });

        const complexitySlider = document.getElementById('complexity');
        const complexityValue = document.getElementById('complexityValue');
        complexitySlider.addEventListener('input', (e) => {
            this.settings.complexity = parseInt(e.target.value);
            complexityValue.textContent = this.settings.complexity;
        });

        const branchSlider = document.getElementById('branchLength');
        const branchValue = document.getElementById('branchValue');
        branchSlider.addEventListener('input', (e) => {
            this.settings.branchLength = parseInt(e.target.value);
            branchValue.textContent = this.settings.branchLength;
        });

        const densitySlider = document.getElementById('particleDensity');
        const densityValue = document.getElementById('densityValue');
        densitySlider.addEventListener('input', (e) => {
            this.settings.particleDensity = parseFloat(e.target.value);
            densityValue.textContent = this.settings.particleDensity.toFixed(1);
        });

        const paletteButtons = document.querySelectorAll('.palette-btn');
        paletteButtons.forEach(btn => {
            btn.addEventListener('click', () => {
                paletteButtons.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                this.settings.palette = btn.dataset.palette;
            });
        });

        const clearBtn = document.getElementById('clearBtn');
        clearBtn.addEventListener('click', () => {
            this.crystals = [];
            this.particles = [];
            this.ctx.fillStyle = 'rgba(10, 14, 23, 1)';
            this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
        });

        const pauseBtn = document.getElementById('pauseBtn');
        pauseBtn.addEventListener('click', () => {
            this.isPaused = !this.isPaused;
            pauseBtn.textContent = this.isPaused ? 'Resume' : 'Pause';
        });
    }

    updateStats() {
        document.getElementById('crystalCount').textContent = this.crystals.length;
        document.getElementById('particleCount').textContent = this.particles.length;
    }
}

// Initialize the simulator when the page loads
window.addEventListener('DOMContentLoaded', () => {
    new CrystalSimulator();
});
