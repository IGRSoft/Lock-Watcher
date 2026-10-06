# App Store listing

The App Store listing for Lock-Watcher, in the layout the
[App Store Connect CLI (`asc`)](https://github.com/rorkai/App-Store-Connect-CLI) reads and writes.
Credentials and the private publishing guide are outside this repo, in
`/Users/korich/Projects/igrsoft/AppStore/` (see its `README.md`).

| Path | Content | Managed with |
|---|---|---|
| `metadata/app-info/<locale>.json` | Name, subtitle, privacy policy URL | `asc metadata` |
| `metadata/version/<version>/<locale>.json` | Description, keywords, promotional text, What's New, support and marketing URLs | `asc metadata` |
| `screenshots/APP_DESKTOP/` | Mac screenshots, uploaded in file-name order | `asc screenshots` |
| `changelog.md` | Release history | by hand |

Locales: `en-US`, `uk`. App ID: `1583462846`. Platform: `MAC_OS`.

## Character limits

| Field | Limit |
|---|---|
| Name, subtitle | 30 |
| Promotional text | 170 |
| Keywords | 100, comma-separated |
| Description, What's New | 4000 |

Run `asc metadata validate --dir AppStore/metadata` after every edit; it checks limits, required fields and URLs.

## Publish a new version

From the repo root, with `<v>` the marketing version (for example `1.6.0`):

1. Create the version in App Store Connect if it does not exist:
   `asc versions create --app 1583462846 --version <v> --platform MAC_OS`
2. Start the local files from the live listing, then edit them:
   `asc metadata pull --app 1583462846 --version <v> --platform MAC_OS --dir AppStore/metadata`
3. Validate, then review what would change:
   ```
   asc metadata validate --dir AppStore/metadata
   asc metadata plan --app 1583462846 --version <v> --platform MAC_OS --dir AppStore/metadata
   ```
4. Apply after review:
   `asc metadata apply --app 1583462846 --version <v> --platform MAC_OS --dir AppStore/metadata --confirm`
5. Screenshots, when they change:
   ```
   asc screenshots validate --path AppStore/screenshots/APP_DESKTOP --device-type APP_DESKTOP
   asc screenshots upload --app 1583462846 --version <v> --path AppStore/screenshots/APP_DESKTOP --device-type APP_DESKTOP
   ```
6. Check readiness, attach the build and submit:
   ```
   asc status --app 1583462846
   asc validate --app 1583462846 --version-id <VERSION_ID>
   asc review submit --app 1583462846 --version <v> --build-number <build> --confirm
   ```

The build number on the attached build must match `CURRENT_PROJECT_VERSION` in `Configurations/base.xcconfig`.

## Privacy label

The published label is **Data Not Collected**: captures go only to the user's own iCloud, Dropbox or Mail, and
IGR Soft receives nothing. `Resources/PrivacyInfo.xcprivacy` declares no collected data types to match. Keep the two
in step; read the live label with `asc web privacy pull --app 1583462846`.
