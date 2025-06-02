import { Octokit } from "@octokit/rest";
import axios from "axios";
import path from "path";
import lzma from "lzma-native";
import crypto from "crypto";
import fs from 'fs';
import semver from 'semver';

const GITHUB_TOKEN = process.env.GITHUB_TOKEN;
const SOURCE_REPO = "Web3-Pi/Ethereum-On-Raspberry-Pi";
const ASSET_PATTERN = /Web3Pi_Single_Device\.img\.xz$/;
const MIN_VERSION = "0.7.0";
const OUTPUT_FILE = "web3_pi_imager_os_list_v1.json";
const OUTPUT_FILE_OFFICIAL_RPI_IMAGER = "os-sublist-web3pi.json";

const octokit = new Octokit({ auth: GITHUB_TOKEN });

async function main() {
  const cacheDir = path.join(process.cwd(), 'cache');
  await fs.promises.mkdir(cacheDir, { recursive: true });

  try {
    const [owner, repo] = SOURCE_REPO.split("/");

    const releases = await octokit.paginate(octokit.repos.listReleases, {
      owner,
      repo,
    });

    const latestRelease = await getLatestRelease(owner, repo);
    const latestReleaseId = latestRelease?.id;

    const entries = [];

    for (const release of releases) {
      if (!release.draft && !release.prerelease) {
        console.log(`Processing release: ${release.name}`);

        const versionMatch = release.name.match(/v?(\d+\.\d+\.\d+)/);
        if (!versionMatch) {
          console.warn(`No version found in release name: ${release.name}`);
          continue;
        }

        const version = versionMatch[1];

        if (!semver.gte(version, MIN_VERSION)) {
          console.log(`Skipping version ${version} (below ${MIN_VERSION})`);
          continue;
        }

        const isLatest = release.id === latestReleaseId;

        const asset = release.assets.find((asset) =>
          ASSET_PATTERN.test(asset.name)
        );

        if (!asset) {
          console.warn(`Asset not found: ${release.name}`);
          continue;
        }

        console.log(`Downloading asset: ${asset.name}`);
        const details = await calculateFileDetails(asset.browser_download_url, cacheDir, release.id);

        const entry = {
          name: release.name + (isLatest ? " (latest)" : ""),
          "description": "Get Running Your Full Ethereum Node on Raspberry Pi. 2TB storage is required (USB SSD or NVMe)",
          url: asset.browser_download_url,
          ...details,
          release_date: release.published_at.split("T")[0],
          "init_format": "cloudinit",
          "devices": [
            "pi5-64bit",
            "pi4-64bit"
          ]
        };

        console.log(`Added new entry:`, entry);
        entries.push(entry);
      }
    }

    const outputPath = path.join(process.cwd(), OUTPUT_FILE);
    const outputData = { os_list: entries };
    await fs.promises.writeFile(outputPath, JSON.stringify(outputData, null, 2), "utf8");

    console.log(`Saved to ${outputPath}`);

    const outputPathRpi = path.join(process.cwd(), OUTPUT_FILE_OFFICIAL_RPI_IMAGER);
    await fs.promises.writeFile(outputPathRpi, JSON.stringify({
      os_list: entries.slice(0, 1).map(entry => ({
        "website": "https://www.web3pi.io/",
        "icon": "https://web3-pi.github.io/release-json/40x40.png",
        ...entry,
        name: entry.name.replace(' (latest)', '').replace('image - ', '') + ' - 64bit'
      }))
    }, null, 2), "utf8");

    console.log(`Saved latest version to ${outputPathRpi}`);

  } catch (error) {
    console.error("Error:", error.message);
  }
}

main()

async function downloadToCache(fileUrl, cachePath) {
  const response = await axios.get(fileUrl, { responseType: 'stream' });
  const writer = fs.createWriteStream(cachePath);

  return new Promise((resolve, reject) => {
    response.data.pipe(writer);
    writer.on('finish', () => resolve());
    writer.on('error', reject);
  });
}

async function calculateFileDetails(fileUrl, cacheDir, releaseId) {
  const releaseCacheDir = path.join(cacheDir, releaseId.toString());
  await fs.promises.mkdir(releaseCacheDir, { recursive: true });

  const fileName = path.basename(fileUrl);
  const cachedFilePath = path.join(releaseCacheDir, fileName);

  if (await fileExists(cachedFilePath)) {
    console.log(`Using cached file: ${cachedFilePath}`);
    return await calculateDetailsFromCache(cachedFilePath);
  }

  console.log(`Downloading file to cache: ${cachedFilePath}`);
  await downloadToCache(fileUrl, cachedFilePath);
  return await calculateDetailsFromCache(cachedFilePath);
}

async function calculateDetailsFromCache(filePath) {
  const stream = await fs.createReadStream(filePath);
  const hash = crypto.createHash('sha256');
  let imageDownloadSize = 0;

  stream.on('data', (chunk) => {
    imageDownloadSize += chunk.length;
    hash.update(chunk);
  });

  const decompressor = lzma.createDecompressor();
  let extractSize = 0;
  const extractHash = crypto.createHash('sha256');

  return new Promise((resolve, reject) => {
    stream.pipe(decompressor)
      .on('data', (chunk) => {
        extractSize += chunk.length;
        extractHash.update(chunk);
      })
      .on('end', () => {
        const extractSha256 = extractHash.digest('hex');
        const imageDownloadSha256 = hash.digest('hex');
        resolve({
          image_download_size: imageDownloadSize,
          image_download_sha256: imageDownloadSha256,
          extract_size: extractSize,
          extract_sha256: extractSha256,
        });
      })
      .on('error', (err) => {
        console.error("Error while extracting: ", err);
        reject(err);
      });
  });
}

async function getLatestRelease(owner, repo) {
  try {
    const { data: latestRelease } = await octokit.repos.getLatestRelease({
      owner,
      repo,
    });
    return latestRelease;
  } catch (error) {
    console.warn("Unable to find latest release:", error.message);
    return null;
  }
}

async function fileExists(filePath) {
  try {
    await fs.promises.access(filePath);
    return true;
  } catch (error) {
    return false;
  }
}
