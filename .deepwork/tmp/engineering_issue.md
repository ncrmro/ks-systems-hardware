# Engineering Issue: Configure lfs-s3 with Cloudflare R2 for large file storage

## Parent Product Issue
- URL: (no product issue — direct user request)
- User Story: As a contributor, I want STL, PNG, and other large binary files stored in Cloudflare R2 via Git LFS so the repo stays lean and cloneable.

## Implementation Plan

### Task 1: Add lfs-s3 to devshell
- Requirement: lfs-s3 binary must be available in the Nix devshell
- Description: Add `lfs-s3-src` as a flake input pinned to `0.2.1` and build it with `buildGoModule` in the devshell packages list. Follow the same pattern used in keystone's `packages/lfs-s3/default.nix`.
- Files: `flake.nix`, `flake.lock`

### Task 2: Configure Git LFS custom transfer agent
- Requirement: Git LFS must use lfs-s3 as the transfer agent for this repo
- Description: Add `.lfsconfig` with `standalonetransferagent = lfs-s3` and the custom transfer path. Configure credential passing via CLI args sourced from environment variables in a wrapper script or `.envrc`. The `.lfsconfig` is committed (no secrets); credentials stay in `.env` (gitignored).
- Files: `.lfsconfig`, `.envrc`

### Task 3: Add .gitattributes for LFS-tracked file types
- Requirement: Binary files (STL, PNG, STEP, etc.) must be tracked by LFS
- Description: Create `.gitattributes` with LFS filter/diff/merge rules for `*.stl`, `*.png`, `*.step`, `*.3mf`, and other binary formats relevant to a hardware CAD project.
- Files: `.gitattributes`

### Task 4: Update .env.example with correct variable names
- Requirement: Environment variable names must match what lfs-s3 and the config expect
- Description: The existing `.env.example` uses `R2_*` prefixed names. lfs-s3 supports `S3_BUCKET`, `AWS_REGION`, `AWS_S3_ENDPOINT` as env vars, but credentials (`access_key_id`, `secret_access_key`) must be passed via CLI flags. Update `.env.example` to document the correct variable names and update `.envrc` to source `.env` and configure the git lfs custom transfer args.
- Files: `.env.example`, `.envrc`

### Task 5: Add setup documentation to README
- Requirement: Contributors must be able to set up LFS with R2 credentials
- Description: Add a "Large File Storage" section to README.md documenting how to set up credentials and push/pull LFS files.
- Files: `README.md`

## Test Definitions

| Test | Requirement | Red State (before) | Green State (after) |
|------|-------------|---------------------|---------------------|
| `which lfs-s3` in devshell | Task 1 | command not found | path to lfs-s3 binary |
| `git lfs env` shows lfs-s3 agent | Task 2 | default LFS endpoint (github) | standalonetransferagent = lfs-s3 |
| `git check-attr filter -- test.stl` | Task 3 | unspecified | filter: lfs |
| `.env.example` documents correct vars | Task 4 | R2_* prefix names | AWS_*/S3_* names matching lfs-s3 |

## Domain Context
- Engineering domain: Hardware/CAD (Python + AnchorSCAD)
- Build system: Nix devshell + `bin/render` (uv/Python)
- Test framework: pytest (`bin/test`)
