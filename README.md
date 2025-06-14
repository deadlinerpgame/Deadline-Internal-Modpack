# Deadline Internal Modpack 

#### Internal modpack for the Deadline RP server.

## Branch flow:
- Main = live server. **DO NOT PUSH TO MAIN.**
- Dev = development/test server.

- Make branches from dev for your features then merge back into dev once ready for the test server.

### Requirements:
- If you are making changes to .pack files (tilepacks) you must have [Git LFS installed](https://git-lfs.com/).

### IMPORTANT DEPLOYMENT NOTICE!!
- If you git pull this repo to deploy it, make sure you `git lfs pull` in order to convert the .tile LFS pointers to their actual original files!
