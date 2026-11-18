## [2.0.0] - 18 November 2026

- Adopt the MIT license for current development and retain the bundled Zoom widget's upstream copyright notice. Earlier public-domain releases retain their original terms.
- Migrate Material and Cupertino UI types to `material_ui ^1.11.1` and `cupertino_ui ^1.1.7`, including dialog extensions and the example. Apps must use the matching extracted UI types instead of legacy SDK types.
- Require Flutter >=3.47.0 and Dart >=3.13.0; validate with Flutter 3.50.0.
- Preserve the host theme for custom dialog actions and return typed dialog results without unsafe future casts.
- Localize modal dismissal and default progress cancellation under modern hosts without a legacy compatibility bridge. Preserve Cupertino-only and plain widgets hosts for custom routes.
- Add GitHub Actions validation, automatic release tags and trusted publishing from `master`.
- Add regression coverage for light/dark themes, localization, typed results, nested navigation, dismissal and progress completion.

## [1.0.2] - 25 February 2025

- Updating dependencies

## [1.0.1] - 04 Augustus 2023

- readme update

## [1.0.0] - 04 Augustus 2023 

- First release.

