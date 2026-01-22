---
description: Automatically build and deploy a Flutter Web PWA to GitHub Pages
---

# Deploy Flutter PWA to GitHub Pages

This workflow sets up a GitHub Action to automatically build your Flutter Web app and deploy it to the `gh-pages` branch whenever you push to `main`.

## 1. Create Workflow File

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy PWA to GitHub Pages

on:
  push:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          # flutter-version: '3.19.0' # Optional: pin version

      - name: Install Dependencies
        run: flutter pub get

      - name: Build Web
        # Set base-href to your repo name!
        # Example: if repo is 'username/my-app', base-href is '/my-app/'
        run: flutter build web --release --base-href "/${{ github.event.repository.name }}/"

      # Create .nojekyll to allow files starting with underscore
      - name: Create .nojekyll
        run: touch build/web/.nojekyll

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

## 2. Configure GitHub Repo
1. Go to **Settings > Pages**.
2. Under **Build and deployment > Source**, select **Deploy from a branch**.
3. Select the `gh-pages` branch (it will be created after the first Action run).

## 3. PWA Optimization (Drift/Database)
For robust database support on Web, ensure you are using a library like `sqlite3_flutter_libs` with WASM or falling back to `idb_shim` / `drift_sqflite` depending on your setup.

**Key constraints:**
- `dart:io` cannot be used.
- File system access is restricted (use `FilePicker` + `Uint8List`).
