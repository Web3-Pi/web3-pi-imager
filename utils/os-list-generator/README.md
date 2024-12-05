
# OS List Updater for Web3 Pi Imager

This script generates a JSON file containing a list of official releases for the [Web3 - Ethereum On Raspberry Pi](https://github.com/Web3-Pi/Ethereum-On-Raspberry-Pi).
It extracts details from GitHub releases, calculates file metadata.

---

## Features

- **Fetch GitHub Releases**: Retrieves all releases from the Ethereum On Raspberry Pi repository.
- **Version Filtering**: Processes only releases with version numbers `>= 0.7.0`.
- **Output Format**: Generates a JSON file in the following structure:
  ```json
  {
    "os_list": [
      {
        "name": "Web3 Pi v0.7.3 - 64bit (latest)",
        "description": "Get Running Your Full Ethereum Node on Raspberry Pi. 2TB storage is required (USB SSD or NVMe)",
        "url": "https://github.com/Web3-Pi/Ethereum-On-Raspberry-Pi/releases/download/v0.7.3/Web3Pi_Single_Device.img.xz",
        "image_download_size": 1113688272,
        "image_download_sha256": "ba929176edadafa3a07014f8d483f266639af280466c7729dc13a5c9500d5eca",
        "extract_size": 3675607040,
        "extract_sha256": "2a93ecacab07733f105b82e18deb4c019b82514f9db82c67ca773f13daf9d341",
        "release_date": "2024-10-30",
        "init_format": "cloudinit",
        "devices": [
          "pi5-64bit",
          "pi4-64bit"
        ]
      }
    ]
  }
  ```

---

## Prerequisites

- Node.js v18+ installed
- An environment variable `GITHUB_TOKEN` containing a valid [GitHub Personal Access Token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token).

---

## Installation

1. Install dependencies:
   ```bash
   npm install
   ```

2. Set the GitHub token:
   ```bash
   export GITHUB_TOKEN=your_personal_access_token
   ```

---

## Usage

Run the script to generate the JSON file:

```bash
node index.js
```

The output file `web3_pi_imager_os_list_v1.json` will be saved in the current directory.

---
``
## Configuration

The following constants can be configured in the script:
- **`SOURCE_REPO`**: The GitHub repository to fetch releases from. Default: `Web3-Pi/Ethereum-On-Raspberry-Pi`.
- **`ASSET_PATTERN`**: Regular expression to identify the relevant asset file. Default: `/Web3Pi_Single_Device\.img\.xz$/`.
- **`MIN_VERSION`**: Minimum release version to process. Default: `0.7.0`.``

---

## Cache Directory

The script uses a cache directory to store downloaded files. By default, it creates a `cache` folder in the working directory. Files are stored in subdirectories named after the release ID to avoid redundant downloads.


