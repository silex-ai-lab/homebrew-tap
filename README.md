# Silex Homebrew tap

Install [Vibra](https://github.com/silex-ai-lab/silex_vibra), a menu bar monitor for local AI coding agents.

## Install

You need macOS 14 or later, [Homebrew](https://brew.sh), and Swift 6 or later. Apple's Command Line Tools are enough. A full Xcode installation is not required.

```sh
swift --version
brew install silex-ai-lab/tap/vibra
open "$(brew --prefix vibra)/Vibra.app"
```

If the Command Line Tools are missing, run `xcode-select --install`. If Swift is older than 6, update the Command Line Tools through Software Update or install a compatible Xcode version.

Homebrew downloads a checksum-verified source archive and builds on your Mac. The first installation takes longer than a prebuilt app download. This tap does not publish bottles.

Vibra lives in Homebrew's Cellar. Its menu bar item is the main interface. The formula also installs the `vibra` command.

```sh
vibra --query
brew test silex-ai-lab/tap/vibra
```

## Switch from a manual installation

Quit the existing Vibra app before opening the Homebrew copy. Launch the explicit path in the install command so macOS does not choose another copy with the same bundle identifier.

The formula does not overwrite or remove `/Applications/Vibra.app`. Once you have checked the Homebrew copy, you can move the old app to Trash in Finder. If you enabled a login item for the old copy, update it yourself to use the Homebrew app.

## Signing and permissions

This formula builds from source and ad-hoc signs the result. It is not a Developer ID signed or notarized download. Homebrew does not grant macOS permissions.

Automation permission may need approval again after upgrades. Notifications may be unavailable with ad-hoc signing. See [Vibra's signing notes](https://github.com/silex-ai-lab/silex_vibra/blob/main/docs/development.md#stable-signing-for-development).

## Upgrade or uninstall

Quit Vibra before upgrading or uninstalling.

```sh
brew update
brew upgrade silex-ai-lab/tap/vibra
open "$(brew --prefix vibra)/Vibra.app"
```

```sh
brew uninstall silex-ai-lab/tap/vibra
brew untap silex-ai-lab/tap
```

Uninstalling keeps Vibra preferences and never deletes coding-agent session data.

## Maintain the formula

1. Choose a tested upstream commit and release version.
2. Set the formula's source URL to that full commit, then calculate the archive's SHA-256 with `shasum -a 256`.
3. Update `version` to match the upstream Makefile's `VERSION`.
4. Run `brew style Formula/vibra.rb`, `brew reinstall --build-from-source silex-ai-lab/tap/vibra`, `brew test silex-ai-lab/tap/vibra`, and `brew audit --strict silex-ai-lab/tap/vibra`.
   Use `brew install` instead of `brew reinstall` for the first installation.
5. Review the macOS Apple Silicon and Intel CI results before publishing an update.

The formula's test uses an empty `VIBRA_HOME`; it does not inspect personal coding sessions.
