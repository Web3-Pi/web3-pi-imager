import simpleGit from 'simple-git';
import path from 'path';
import { Octokit } from '@octokit/rest';
import fs from 'fs';

const git = simpleGit();
const octokit = new Octokit({ auth: process.env.GITHUB_TOKEN });

const TARGET_REPO = "Web3-Pi/file-bin";
const BRANCH_NAME = `update-os-list-json-file-${Date.now()}`;
const FILE_NAME = "web3_pi_imager_os_list_v1.json";
const JSON_FILE_PATH = path.join(process.cwd(), FILE_NAME);
const [targetOwner, targetRepo] = TARGET_REPO.split('/');

async function run() {
  const targetRepoDir = path.join(process.cwd(), "target-repo");
  console.log(`Cloning ${TARGET_REPO}...`);
  const repoUrl = `https://${process.env.GITHUB_TOKEN}:x-oauth-basic@github.com/${TARGET_REPO}.git`;
  await git.clone(repoUrl, targetRepoDir);

  if (fs.existsSync(JSON_FILE_PATH)) {
    console.log(`Found the generated JSON file: ${JSON_FILE_PATH}`);

    const targetJsonPath = path.join(targetRepoDir, FILE_NAME);
    fs.copyFileSync(JSON_FILE_PATH, targetJsonPath);
  } else {
    console.error("Generated JSON file not found.");
    return;
  }


  await git.cwd(targetRepoDir);
  await git.checkoutLocalBranch(BRANCH_NAME);
  await git.add(FILE_NAME);
  await git.commit("Update the generated JSON file containing the OS list for Web3 Pi Imager");
  await git.push("origin", BRANCH_NAME);

  const pr = await octokit.pulls.create({
    owner: targetOwner,
    repo: targetRepo,
    title: "Automated update of the JSON file containing the OS list for Web3 Pi Imager",
    head: BRANCH_NAME,
    base: "main",
    body: `This PR updates the generated JSON file containing the OS list for Web3 Pi Imager. It was generated automatically`,
  });

  console.log("Created Pull Request:", pr.data.html_url);
}

run()