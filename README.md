# mac-automation

Scripts I write to automate stuff on my Mac. I'm using these to get better at scripting, and I try to build each one the safe way from the start.

## clean_downloads.sh

My Downloads folder was a mess, so I wrote a zsh script that sorts it into folders by file type.

| Folder | File types |
|---|---|
| Documents | pdf, doc, docx, txt, rtf, pptx, xlsx, csv, pages |
| Images | png, jpg, jpeg, heic, gif, webp, svg |
| Videos | mp4, mov, mkv |
| Audio | mp3, wav, m4a |
| Archives | zip, rar, 7z, tar, gz |
| Installers | dmg, pkg, iso |
| Code | py, sh, ps1, json, html, js |
| Other | anything else |

PDFs go in Documents with Word files on purpose. A lot of my schoolwork is a .docx plus the PDF I submitted, and I wanted those together.

### Setup

```
mkdir -p ~/scripts
mv clean_downloads.sh ~/scripts/
chmod +x ~/scripts/clean_downloads.sh
```

### Usage

Preview what would move:

```
~/scripts/clean_downloads.sh --dry-run
```

Run it:

```
~/scripts/clean_downloads.sh
```

Example preview:

```
[preview] Lab_Report.pdf  ->  Documents/
[preview] Screenshot_0412.png  ->  Images/
[preview] project_files.zip  ->  Archives/
[preview] SomeApp.dmg  ->  Installers/
[preview] notes  ->  Other/

Preview done. 5 file(s) would be moved. Run without --dry-run to do it for real.
```

### Why it's built this way

Sorting files was the easy part. The bigger question was what happens if something goes wrong.

- **It never deletes.** It only moves files, so the worst case is something lands in the wrong folder.
- **Dry run first.** I can see every change before it happens.
- **Typos don't run it.** A bad flag like `--dryrun` stops the script instead of running it for real.
- **No overwriting.** Duplicate names get `(1)` added, and `mv -n` backs that up.
- **Only top-level files.** It skips folders, hidden files, and symlinks, since a symlink can point outside Downloads.
- **Skips unfinished downloads** from Chrome, Firefox, and Safari.
- **No sudo, no network, never opens files.** Installers and scripts get filed, not run.

I also tested it with file names that have spaces and one named `-rf.txt`, which a careless script could mistake for a command option.

## Next up

- [ ] Run the cleaner weekly with `launchd`
- [ ] Local account audit (users, admins, last login)
- [ ] Entra ID user lifecycle script (create, assign groups, disable)
