# Contributing to Pathanga

Thanks for helping map India's butterflies. You don't need to write code to contribute.

## Ways to help

**Naturalists and researchers**
- Report a species that is missing, misnamed or wrongly placed in a family. Include the accepted name, the authority, and a source (checklist, paper or field guide).
- Point out a wrong image, or offer an openly licensed photo (CC0, CC-BY or CC-BY-SA).
- Correct distribution or host-plant data, citing the source.

**Developers**
- Pick up an item from the roadmap in the [README](README.md#roadmap) or an open issue.
- Improve tests, documentation or setup.

## Data rules

1. **Never invent data.** If a value can't be verified, leave it empty and record why in `field_provenance`.
2. **Licensed images only.** Record the license, photographer and source URL for every image.
3. **Cite sources** for taxonomy, distribution and ecology changes.

## Development workflow

1. Fork the repo and create a branch: `git checkout -b fix/short-description`.
2. Follow the setup in the [README](README.md#getting-started).
3. Keep changes focused. One fix or feature per pull request.
4. Run the checks for the part you changed:
   - Backend: `cd backend && pytest`
   - Web apps: `npm run lint && npm run build`
   - Mobile: `flutter analyze && flutter test`
5. Write a clear commit message that says what changed and why, e.g. `Fix duplicate species after GBIF synonym merge`.
6. Open a pull request describing the change and how you tested it.

## Never commit secrets

`.env` files, keystores, `key.properties` and service-account JSON files are git-ignored. Keep them that way. Use `backend/.env.example` as the template.

## Reporting bugs

Open an issue with steps to reproduce, what you expected, what happened, and your platform (Android/iOS version or browser).
