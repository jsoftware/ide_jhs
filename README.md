# JHS (J HTTP Server) IDE

JHS is a modern, web-based development environment for the J programming language. It provides a full-featured IDE experience directly in the browser, allowing for interactive execution, script editing, and advanced data visualization.

The ide/jhs addon is the JHS IDE for j701 and later releases.

## Key Features

- **Interactive Terminal (`jijx`)**: A specialized REPL interface with command history recall, multi-line paste handling, and real-time output updates via AJAX.
- **CodeMirror 6 Editor**: A high-performance code editor with custom J syntax highlighting, themes (Selenized Light/Dark), bracket matching, and multiple selection support.
- **Graphics & Visualization**: 
    - Integrated **D3.js** and **Chart.js** for high-quality plotting.
    - Custom HTML5 Canvas support via `jhjcanvas.js`.
    - **WebGL** support via `glMatrix`.
- **Data Management**: Integration with **Handsontable** for viewing and editing J arrays in a spreadsheet-like interface.
- **Single Page App (SPA) Support**: Capability to run multiple IDE components (terminal, files, locales) within a single tab using an internal iframe-based window manager.
- **Responsive Design**: Support for mobile browsers with specialized editors and touch-friendly interaction handles.

## Project Structure

- `/js/jsoftware/`: Core JHS logic.
    - `jscore.js`: The framework's engine. Handles AJAX (`jdoajax`), event routing (`jevdo`), and UI command processing (`jhrcmds`).
    - `jijx.js`: Implements the interactive terminal window.
    - `editor.js`: Integration of CodeMirror 6 for J script editing.
- `/widget/`: UI widgets.
    - `jhjcanvas.js`: Bridge between J sentences and HTML5 Canvas drawing commands.
- `/js/3rdparty/`: Bundled distributions of D3, Chart.js, Handsontable, and other utilities.

## Framework Architecture

The frontend uses a custom event system where UI interactions (clicks, keypresses) are routed through `jscore.js`. 

1. **Event Handling**: `jev(event)` captures UI events and translates them into J sentences.
2. **AJAX Protocol**: `jdoajax` sends POST requests to the J backend. Data is often delimited by `JASEP` (`\x01`).
3. **Server Commands**: The backend can return specialized commands via JSON (handled by `jhrcmds`) to dynamically modify the DOM, open pages, or update styles.

## Keyboard Shortcuts

The IDE uses an "Esc-lead" shortcut system:
- **Esc then Q**: Close all pages and exit the server.
- **Esc then 2**: Scroll terminal to the bottom.
- **Ctrl+Enter**: Execute the current input line.
- **Ctrl+S** (in editor): Save script.
- **Ctrl+R** (in editor): Run script.

## Technical Stack

- **Core**: Vanilla JavaScript
- **Editor**: CodeMirror 6 / Lezer (for parsing J)
- **Visuals**: D3.js v4, Chart.js v4
- **Grid**: Handsontable
- **Styles**: `style-mod` for dynamic CSS generation

---
*Part of the Jsoftware IDE suite.*
