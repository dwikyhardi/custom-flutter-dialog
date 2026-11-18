# Automated releases

1. Update `pubspec.yaml` and `CHANGELOG.md`, then open a PR to `master`.
2. CI uses FVM and `.fvmrc` to analyze the package and example, run tests and
   validate a publish dry run.
3. Successful push CI on `master` starts Auto Tag Release. It skips published
   versions and pushes `d_dialog-v<version>` at the tested commit.
4. The tag triggers Publish, which verifies the version and `master` ancestry,
   repeats validation and publishes to pub.dev using GitHub OIDC.

The repository secret `RELEASE_PAT` needs Contents read/write permission for
`dwikyhardi/custom-flutter-dialog`. Tag pushes using `GITHUB_TOKEN` cannot start
another workflow. The publishing job uses OIDC rather than a stored pub token.

The package's pub.dev automated-publishing settings must permit push events
from `dwikyhardi/custom-flutter-dialog` with tag pattern `d_dialog-v{{version}}`.
The publishing workflow is `.github/workflows/publish.yml`.

Versions are never bumped automatically. If publishing fails after tagging,
fix the cause and rerun the failed Publish run. Existing tags are never moved.
