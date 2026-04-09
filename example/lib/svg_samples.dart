// SVG test cases organized by category.
// Each entry has a label, the SVG markup, and whether flutter_svg is expected
// to render it correctly.

class SvgSample {
  final String label;
  final String svg;
  final String category;
  final bool flutterSvgSupported;
  final String? notes;

  const SvgSample({
    required this.label,
    required this.svg,
    required this.category,
    this.flutterSvgSupported = true,
    this.notes,
  });
}

const svgSamples = [
  // ── W3Schools basics ──────────────────────────────────────────────────

  SvgSample(
    label: 'Circle',
    category: 'Basic (W3Schools)',
    svg: '''
<svg height="100" width="100" xmlns="http://www.w3.org/2000/svg">
  <circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" />
</svg>''',
  ),

  SvgSample(
    label: 'Rectangle',
    category: 'Basic (W3Schools)',
    svg: '''
<svg width="400" height="110" xmlns="http://www.w3.org/2000/svg">
  <rect width="300" height="100" rx="20" ry="20"
        style="fill:rgb(0,0,255);stroke-width:3;stroke:rgb(0,0,0)" />
</svg>''',
  ),

  SvgSample(
    label: 'Rounded rect (style attr)',
    category: 'Basic (W3Schools)',
    svg: '''
<svg width="400" height="180" xmlns="http://www.w3.org/2000/svg">
  <rect x="50" y="20" rx="20" ry="20" width="150" height="150"
        style="fill:red;stroke:black;stroke-width:5;opacity:0.5" />
</svg>''',
  ),

  SvgSample(
    label: 'Line',
    category: 'Basic (W3Schools)',
    svg: '''
<svg height="210" width="500" xmlns="http://www.w3.org/2000/svg">
  <line x1="0" y1="0" x2="200" y2="200"
        style="stroke:rgb(255,0,0);stroke-width:2" />
</svg>''',
  ),

  SvgSample(
    label: 'Polygon (star)',
    category: 'Basic (W3Schools)',
    svg: '''
<svg height="210" width="500" xmlns="http://www.w3.org/2000/svg">
  <polygon points="100,10 40,198 190,78 10,78 160,198"
           style="fill:lime;stroke:purple;stroke-width:5;fill-rule:evenodd;" />
</svg>''',
  ),

  SvgSample(
    label: 'Polyline',
    category: 'Basic (W3Schools)',
    svg: '''
<svg height="200" width="500" xmlns="http://www.w3.org/2000/svg">
  <polyline points="20,20 40,25 60,40 80,120 120,140 200,180"
            style="fill:none;stroke:black;stroke-width:3" />
</svg>''',
  ),

  SvgSample(
    label: 'Ellipse',
    category: 'Basic (W3Schools)',
    svg: '''
<svg height="140" width="500" xmlns="http://www.w3.org/2000/svg">
  <ellipse cx="200" cy="80" rx="100" ry="50"
           style="fill:yellow;stroke:purple;stroke-width:2" />
</svg>''',
  ),

  SvgSample(
    label: 'Path (quadratic bezier)',
    category: 'Basic (W3Schools)',
    svg: '''
<svg height="400" width="450" xmlns="http://www.w3.org/2000/svg">
  <path d="M 150 0 Q 175 300 300 150" fill="none" stroke="red" stroke-width="3"/>
</svg>''',
  ),

  SvgSample(
    label: 'Text',
    category: 'Basic (W3Schools)',
    svg: '''
<svg height="60" width="200" xmlns="http://www.w3.org/2000/svg">
  <text x="0" y="35" fill="red" font-size="35">Hello SVG</text>
</svg>''',
  ),

  // ── Gradients ─────────────────────────────────────────────────────────

  SvgSample(
    label: 'Linear gradient',
    category: 'Gradients',
    svg: '''
<svg height="150" width="400" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="lg1" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" style="stop-color:rgb(255,255,0);stop-opacity:1" />
      <stop offset="100%" style="stop-color:rgb(255,0,0);stop-opacity:1" />
    </linearGradient>
  </defs>
  <ellipse cx="200" cy="70" rx="85" ry="55" fill="url(#lg1)" />
</svg>''',
  ),

  SvgSample(
    label: 'Radial gradient',
    category: 'Gradients',
    svg: '''
<svg height="150" width="500" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <radialGradient id="rg1" cx="50%" cy="50%" r="50%" fx="50%" fy="50%">
      <stop offset="0%" style="stop-color:rgb(255,255,255);stop-opacity:0" />
      <stop offset="100%" style="stop-color:rgb(0,0,255);stop-opacity:1" />
    </radialGradient>
  </defs>
  <ellipse cx="230" cy="70" rx="85" ry="55" fill="url(#rg1)" />
</svg>''',
  ),

  // ── Transforms ────────────────────────────────────────────────────────

  SvgSample(
    label: 'Nested transforms',
    category: 'Transforms',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <g transform="translate(100,100)">
    <g transform="rotate(45)">
      <rect x="-40" y="-40" width="80" height="80" fill="teal" />
      <g transform="scale(0.5)">
        <rect x="-40" y="-40" width="80" height="80" fill="orange" />
      </g>
    </g>
  </g>
</svg>''',
  ),

  // ── Clip paths ────────────────────────────────────────────────────────

  SvgSample(
    label: 'Clip path (circle)',
    category: 'Clip paths',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <clipPath id="cp1">
      <circle cx="100" cy="100" r="80" />
    </clipPath>
  </defs>
  <rect width="200" height="200" fill="coral" clip-path="url(#cp1)" />
</svg>''',
  ),

  // ── use / defs / symbol ───────────────────────────────────────────────

  SvgSample(
    label: '<use> + <symbol>',
    category: 'References',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <symbol id="sym1" viewBox="0 0 100 100">
      <circle cx="50" cy="50" r="40" fill="steelblue" />
      <text x="50" y="55" text-anchor="middle" fill="white" font-size="16">S</text>
    </symbol>
  </defs>
  <use href="#sym1" x="10"  y="10"  width="80" height="80" />
  <use href="#sym1" x="110" y="10"  width="80" height="80" />
  <use href="#sym1" x="60"  y="110" width="80" height="80" />
</svg>''',
  ),

  // ── Filters (flutter_svg does NOT support) ────────────────────────────

  SvgSample(
    label: 'Gaussian blur',
    category: 'Filters',
    flutterSvgSupported: false,
    notes: 'flutter_svg ignores <filter> elements entirely.',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <filter id="blur1">
      <feGaussianBlur in="SourceGraphic" stdDeviation="5" />
    </filter>
  </defs>
  <rect x="30" y="30" width="140" height="140" fill="royalblue"
        filter="url(#blur1)" />
</svg>''',
  ),

  SvgSample(
    label: 'Drop shadow',
    category: 'Filters',
    flutterSvgSupported: false,
    notes: 'feDropShadow is part of SVG filters — unsupported.',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <filter id="shadow1">
      <feDropShadow dx="4" dy="4" stdDeviation="4" flood-color="black" flood-opacity="0.5" />
    </filter>
  </defs>
  <circle cx="90" cy="90" r="60" fill="tomato" filter="url(#shadow1)" />
</svg>''',
  ),

  SvgSample(
    label: 'Color matrix (sepia)',
    category: 'Filters',
    flutterSvgSupported: false,
    notes: 'feColorMatrix is unsupported.',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <filter id="sepia1">
      <feColorMatrix type="matrix"
        values="0.393 0.769 0.189 0 0
                0.349 0.686 0.168 0 0
                0.272 0.534 0.131 0 0
                0     0     0     1 0" />
    </filter>
  </defs>
  <rect x="20" y="20" width="160" height="160" fill="dodgerblue"
        filter="url(#sepia1)" />
  <text x="100" y="110" text-anchor="middle" fill="white" font-size="14"
        filter="url(#sepia1)">Sepia</text>
</svg>''',
  ),

  SvgSample(
    label: 'Composite filter chain',
    category: 'Filters',
    flutterSvgSupported: false,
    notes: 'Chained filter primitives are unsupported.',
    svg: '''
<svg width="240" height="200" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <filter id="glow1">
      <feGaussianBlur in="SourceAlpha" stdDeviation="4" result="blur" />
      <feFlood flood-color="gold" result="color" />
      <feComposite in="color" in2="blur" operator="in" result="shadow" />
      <feMerge>
        <feMergeNode in="shadow" />
        <feMergeNode in="SourceGraphic" />
      </feMerge>
    </filter>
  </defs>
  <text x="120" y="110" text-anchor="middle" font-size="48" font-weight="bold"
        fill="darkblue" filter="url(#glow1)">Glow</text>
</svg>''',
  ),

  // ── CSS animations (flutter_svg does NOT support) ─────────────────────

  SvgSample(
    label: 'CSS @keyframes rotation',
    category: 'CSS Animations',
    flutterSvgSupported: false,
    notes: 'Inline <style> with @keyframes is ignored.',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <style>
    @keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
    .spinner { animation: spin 2s linear infinite; transform-origin: 100px 100px; }
  </style>
  <rect class="spinner" x="70" y="70" width="60" height="60" rx="8" fill="mediumseagreen" />
</svg>''',
  ),

  SvgSample(
    label: 'CSS color pulse',
    category: 'CSS Animations',
    flutterSvgSupported: false,
    notes: 'CSS animation with fill changes.',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <style>
    @keyframes pulse { 0%,100% { fill: crimson; } 50% { fill: gold; } }
    .pulse { animation: pulse 1.5s ease-in-out infinite; }
  </style>
  <circle class="pulse" cx="100" cy="100" r="60" />
</svg>''',
  ),

  // ── SMIL <animate> (flutter_svg does NOT support) ─────────────────────

  SvgSample(
    label: 'SMIL animate (radius)',
    category: 'SMIL Animation',
    flutterSvgSupported: false,
    notes: '<animate> element is ignored.',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <circle cx="100" cy="100" r="30" fill="darkorange">
    <animate attributeName="r" values="30;60;30" dur="2s" repeatCount="indefinite" />
  </circle>
</svg>''',
  ),

  SvgSample(
    label: 'SMIL animateTransform',
    category: 'SMIL Animation',
    flutterSvgSupported: false,
    notes: '<animateTransform> is ignored.',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <rect x="75" y="75" width="50" height="50" fill="slateblue">
    <animateTransform attributeName="transform" type="rotate"
      from="0 100 100" to="360 100 100" dur="3s" repeatCount="indefinite" />
  </rect>
</svg>''',
  ),

  // ── Inline CSS / <style> block ────────────────────────────────────────

  SvgSample(
    label: 'CSS class selectors',
    category: 'CSS Styling',
    flutterSvgSupported: false,
    notes: 'flutter_svg only partially supports inline <style>; class selectors often fail.',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <style>
    .primary { fill: #2563eb; }
    .secondary { fill: #f59e0b; }
    .outline { stroke: #1e293b; stroke-width: 2; fill: none; }
  </style>
  <circle class="primary" cx="60" cy="100" r="40" />
  <circle class="secondary" cx="140" cy="100" r="40" />
  <rect class="outline" x="30" y="30" width="140" height="140" rx="10" />
</svg>''',
  ),

  SvgSample(
    label: 'CSS pseudo-classes (:hover)',
    category: 'CSS Styling',
    flutterSvgSupported: false,
    notes: 'Interactive CSS only works in a real DOM.',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <style>
    .hoverable { fill: steelblue; transition: fill 0.3s; cursor: pointer; }
    .hoverable:hover { fill: tomato; }
  </style>
  <circle class="hoverable" cx="100" cy="100" r="60" />
  <text x="100" y="108" text-anchor="middle" fill="white" font-size="14"
        pointer-events="none">Hover me</text>
</svg>''',
  ),

  // ── foreignObject (flutter_svg does NOT support) ──────────────────────

  SvgSample(
    label: 'foreignObject (HTML in SVG)',
    category: 'foreignObject',
    flutterSvgSupported: false,
    notes: 'Embeds HTML content inside SVG — completely unsupported.',
    svg: '''
<svg width="300" height="200" xmlns="http://www.w3.org/2000/svg">
  <rect width="300" height="200" rx="10" fill="#f0f0f0" stroke="#ccc" />
  <foreignObject x="20" y="20" width="260" height="160">
    <div xmlns="http://www.w3.org/1999/xhtml" style="font-family: sans-serif; font-size: 14px;">
      <h3 style="margin:0 0 8px 0; color: #333;">HTML in SVG</h3>
      <p style="margin:0; color: #666;">This is a paragraph rendered by the browser's HTML engine, embedded inside an SVG via foreignObject.</p>
      <button style="margin-top:8px; padding:4px 12px; border-radius:4px; border:1px solid #999; background:#fff; cursor:pointer;">A real button</button>
    </div>
  </foreignObject>
</svg>''',
  ),

  // ── Nested SVGs (flutter_svg does NOT support) ────────────────────────

  SvgSample(
    label: 'Nested <svg> elements',
    category: 'Nested SVG',
    flutterSvgSupported: false,
    notes: 'flutter_svg has a known issue (#132) with nested <svg> elements.',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <rect width="200" height="200" fill="#eee" />
  <svg x="20" y="20" width="80" height="80" viewBox="0 0 100 100">
    <circle cx="50" cy="50" r="45" fill="coral" />
  </svg>
  <svg x="100" y="100" width="80" height="80" viewBox="0 0 100 100">
    <rect width="100" height="100" rx="15" fill="cornflowerblue" />
  </svg>
</svg>''',
  ),

  // ── Masks ─────────────────────────────────────────────────────────────

  SvgSample(
    label: 'Mask (luminance)',
    category: 'Masks',
    flutterSvgSupported: false,
    notes: 'Complex masks with gradients may not render correctly.',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="mg1" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0%" stop-color="white" />
      <stop offset="100%" stop-color="black" />
    </linearGradient>
    <mask id="mask1" maskContentUnits="objectBoundingBox">
      <rect width="1" height="1" fill="url(#mg1)" />
    </mask>
  </defs>
  <rect width="200" height="200" fill="deeppink" mask="url(#mask1)" />
</svg>''',
  ),

  // ── Pattern fills ─────────────────────────────────────────────────────

  SvgSample(
    label: 'Pattern fill',
    category: 'Patterns',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <pattern id="pat1" x="0" y="0" width="20" height="20" patternUnits="userSpaceOnUse">
      <rect width="20" height="20" fill="#f0f0f0" />
      <circle cx="10" cy="10" r="5" fill="#4a90d9" />
    </pattern>
  </defs>
  <rect width="200" height="200" fill="url(#pat1)" stroke="#333" stroke-width="2" />
</svg>''',
  ),

  // ── Text features ─────────────────────────────────────────────────────

  SvgSample(
    label: 'textPath',
    category: 'Text',
    svg: '''
<svg width="300" height="200" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <path id="tp1" d="M 30 100 Q 150 20 270 100" fill="none" />
  </defs>
  <path d="M 30 100 Q 150 20 270 100" fill="none" stroke="#ddd" stroke-width="1" />
  <text font-size="16" fill="darkslategray">
    <textPath href="#tp1">Text along a curved path</textPath>
  </text>
</svg>''',
  ),

  SvgSample(
    label: 'letter-spacing / word-spacing',
    category: 'Text',
    flutterSvgSupported: false,
    notes: 'letter-spacing and word-spacing are not implemented.',
    svg: '''
<svg width="300" height="100" xmlns="http://www.w3.org/2000/svg">
  <text x="10" y="30" font-size="20" letter-spacing="5" fill="navy">Wide Letters</text>
  <text x="10" y="70" font-size="20" word-spacing="15" fill="maroon">Wide Words Here</text>
</svg>''',
  ),

  // ── Images ────────────────────────────────────────────────────────────

  SvgSample(
    label: 'Data URI (PNG)',
    category: 'Images',
    notes: 'Base64-encoded PNG — supported by both renderers.',
    svg: '''
<svg width="200" height="150" xmlns="http://www.w3.org/2000/svg">
  <rect width="200" height="150" fill="#f8f8f8" rx="8" />
  <image x="50" y="10" width="100" height="100"
    href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAA60lEQVR42u3WMQ6DMBAE0P3/o1OkSJEiRYqgNRI2WGPP7soUO9JIFPb8YjGYiIiIiIiIiGjLcV2+6/qGruN1nffr0PUcrmu/DH3H4br2zd/J99V3nL0Yuo7DdR2Lv5PV92q/NnQdr+tY/Z2svlf7tTl0Ha/rWP2drL5X+7U5dB2v61j9nay+V/u1OXQdr+tY/Z2svlf7tTl0Ha/rWP2drL5X+7U5dB2v61j9nay+V/u1OXQdr+tY/Z2svlf7tTl0Ha/rWP2drL5X+7U5dB2v61j9nay+V/u1OXQdr+tY/Z2IiIiIiIiIiP6/H8Y5Tk/lrHJ6AAAAAElFTkSuQmCC" />
  <text x="100" y="135" text-anchor="middle" font-size="12" fill="#333">data:image/png</text>
</svg>''',
  ),

  SvgSample(
    label: 'Data URI (JPEG)',
    category: 'Images',
    notes: 'Base64-encoded JPEG — supported by both renderers.',
    svg: '''
<svg width="200" height="150" xmlns="http://www.w3.org/2000/svg">
  <rect width="200" height="150" fill="#f8f8f8" rx="8" />
  <image x="50" y="10" width="100" height="100"
    href="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAAeAB4DASIAAhEBAxEB/8QAGAABAQEBAQAAAAAAAAAAAAAAAAUEBgf/xAAoEAABAwMDBAEFAAAAAAAAAAABAgMRAAQhBRIxBhNBUXEiMmGBkf/EABYBAQEBAAAAAAAAAAAAAAAAAAECA//EABkRAQEBAQEBAAAAAAAAAAAAAAEAAhEhMf/aAAwDAQACEQMRAD8A9coqDr2unSLTahN0EthzG1MFSjAkADiSTAz5oCt1ee2lqu6vXg0wgSpStEAVV6b6mi/KLO/CWroiArGxxXo+D7+asJCkhSSCkiQRkEe65/WOkEXC3LnTwhq5JlTCsCfaf4f9HugorVFKE6hqzTbqgq6umwogiJWYzFVeh9VItlN2GpOBLKjCHlfan0T/AH+0V1FZL+xtdQtlW15bt3DSuUrSCD/DQf/Z" />
  <text x="100" y="135" text-anchor="middle" font-size="12" fill="#333">data:image/jpeg</text>
</svg>''',
  ),

  SvgSample(
    label: 'Data URI (SVG in SVG)',
    category: 'Images',
    flutterSvgSupported: false,
    notes: 'SVG embedded as a data URI inside another SVG — inception.',
    svg: '''
<svg width="200" height="150" xmlns="http://www.w3.org/2000/svg">
  <rect width="200" height="150" fill="#2d2d2d" rx="8" />
  <image x="25" y="10" width="150" height="110"
    href="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNTAiIGhlaWdodD0iMTEwIj48cmVjdCB3aWR0aD0iMTUwIiBoZWlnaHQ9IjExMCIgZmlsbD0iI2ZmZiIgcng9IjgiLz48Y2lyY2xlIGN4PSI0MCIgY3k9IjU1IiByPSIyNSIgZmlsbD0iI2ZmNjM0NyIvPjxyZWN0IHg9Ijc1IiB5PSIzMCIgd2lkdGg9IjUwIiBoZWlnaHQ9IjUwIiByeD0iOCIgZmlsbD0iIzQyOTlFMSIvPjx0ZXh0IHg9Ijc1IiB5PSIxMDAiIGZvbnQtc2l6ZT0iMTIiIGZpbGw9IiM2NjYiIHRleHQtYW5jaG9yPSJtaWRkbGUiPk5lc3RlZCBTVkc8L3RleHQ+PC9zdmc+" />
  <text x="100" y="140" text-anchor="middle" font-size="11" fill="#aaa">data:image/svg+xml</text>
</svg>''',
  ),

  SvgSample(
    label: 'External URL (href)',
    category: 'Images',
    flutterSvgSupported: false,
    notes: 'flutter_svg only supports data URI images, not external URLs.',
    svg: '''
<svg width="220" height="200" xmlns="http://www.w3.org/2000/svg">
  <rect width="220" height="200" fill="#1a1a2e" rx="8" />
  <image x="10" y="10" width="200" height="140"
    href="https://www.w3schools.com/css/img_5terre.jpg" />
  <text x="110" y="180" text-anchor="middle" font-size="13" fill="#eee">External URL (href)</text>
</svg>''',
  ),

  SvgSample(
    label: 'External URL (xlink:href)',
    category: 'Images',
    flutterSvgSupported: false,
    notes: 'Legacy xlink:href attribute — deprecated but still widely used.',
    svg: '''
<svg width="220" height="200" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
  <rect width="220" height="200" fill="#1a2e1a" rx="8" />
  <image x="10" y="10" width="200" height="140"
    xlink:href="https://www.w3schools.com/html/pic_trulli.jpg" />
  <text x="110" y="180" text-anchor="middle" font-size="13" fill="#eee">xlink:href (legacy)</text>
</svg>''',
  ),

  SvgSample(
    label: 'Multiple external images',
    category: 'Images',
    flutterSvgSupported: false,
    notes: 'Multiple external image references in one SVG.',
    svg: '''
<svg width="300" height="200" xmlns="http://www.w3.org/2000/svg">
  <rect width="300" height="200" fill="#f0f0f0" rx="8" />
  <image x="10" y="10" width="130" height="85"
    href="https://www.w3schools.com/html/img_chania.jpg" />
  <image x="160" y="10" width="130" height="85"
    href="https://www.w3schools.com/html/pic_trulli.jpg" />
  <image x="85" y="105" width="130" height="85"
    href="https://www.w3schools.com/html/img_girl.jpg" />
</svg>''',
  ),

  SvgSample(
    label: 'Image with clip-path',
    category: 'Images',
    notes: 'Circular clip on an embedded image.',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
  <defs>
    <clipPath id="imgclip1">
      <circle cx="100" cy="100" r="80" />
    </clipPath>
  </defs>
  <rect width="200" height="200" fill="#e8e8e8" />
  <g clip-path="url(#imgclip1)">
    <rect x="20" y="20" width="160" height="160" fill="linear-gradient(coral, gold)" />
    <text x="100" y="90" text-anchor="middle" font-size="48" fill="white">IMG</text>
    <text x="100" y="125" text-anchor="middle" font-size="16" fill="white">clipped</text>
  </g>
</svg>''',
  ),

  SvgSample(
    label: 'Image with filter',
    category: 'Images',
    flutterSvgSupported: false,
    notes: 'Blur filter applied to an image element — filters unsupported.',
    svg: '''
<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <filter id="imgblur1">
      <feGaussianBlur stdDeviation="3" />
    </filter>
    <linearGradient id="imglg1" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="#ff6b6b" />
      <stop offset="50%" stop-color="#ffd93d" />
      <stop offset="100%" stop-color="#6bcb77" />
    </linearGradient>
  </defs>
  <rect width="200" height="200" fill="#222" rx="8" />
  <rect x="20" y="20" width="160" height="120" fill="url(#imglg1)" filter="url(#imgblur1)" rx="8" />
  <text x="100" y="170" text-anchor="middle" font-size="13" fill="#aaa">Blurred gradient</text>
  <rect x="20" y="20" width="160" height="120" fill="url(#imglg1)" rx="8" opacity="0.3" />
</svg>''',
  ),

  SvgSample(
    label: 'SVG image composition',
    category: 'Images',
    notes: 'Layered shapes simulating a photo card with shadow — tests compositing.',
    svg: '''
<svg width="240" height="200" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <filter id="cardshadow">
      <feDropShadow dx="3" dy="3" stdDeviation="4" flood-color="#000" flood-opacity="0.3" />
    </filter>
    <linearGradient id="sky" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#87CEEB" />
      <stop offset="100%" stop-color="#E0F7FA" />
    </linearGradient>
    <clipPath id="cardclip">
      <rect x="20" y="10" width="200" height="140" rx="12" />
    </clipPath>
  </defs>
  <!-- Card with shadow -->
  <rect x="20" y="10" width="200" height="140" rx="12" fill="white" filter="url(#cardshadow)" />
  <!-- Clipped scene -->
  <g clip-path="url(#cardclip)">
    <rect x="20" y="10" width="200" height="140" fill="url(#sky)" />
    <circle cx="180" cy="40" r="20" fill="#FFD700" />
    <ellipse cx="60" cy="120" rx="50" ry="30" fill="#228B22" />
    <ellipse cx="160" cy="125" rx="45" ry="25" fill="#2E8B57" />
    <rect x="110" y="80" width="20" height="50" fill="#8B4513" />
    <polygon points="120,40 95,85 145,85" fill="#006400" />
  </g>
  <!-- Caption -->
  <text x="120" y="175" text-anchor="middle" font-size="14" fill="#333" font-family="sans-serif">Landscape card</text>
</svg>''',
    flutterSvgSupported: false,
  ),
];
