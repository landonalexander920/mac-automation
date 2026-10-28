# mac-automation

Automations I run on my own Mac. I use AI to help draft the scripts, but nothing runs on my machine until I've reviewed it for security and tested it somewhere safe first. This repo is where I keep the scripts and document what I checked.

## clean_downloads.sh

My Downloads folder was a mess, so I wanted it sorted into folders by file type automatically.

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

### Usage

It works like `terraform plan` and `terraform apply`.

```
~/scripts/clean_downloads.sh plan
~/scripts/clean_downloads.sh apply
```

`plan` shows what would move. `apply` actually moves the files. Running it with nothing after it, or with a typo, just prints how to use it.

```
[preview] Lab_Report.pdf  ->  Documents/
[preview] Screenshot_0412.png  ->  Images/
[preview] project_files.zip  ->  Archives/
[preview] SomeApp.dmg  ->  Installers/
[preview] notes  ->  Other/

Preview done. 5 file(s) would be moved. Run with apply to do it for real.
```

### Security review

Before running this on my real files, I went through it with these questions.

**Can it destroy data?**
No. It only moves files and never deletes. I also made sure it can't overwrite anything. Duplicate names get `(1)` added, and `mv -n` blocks overwriting as a backup.

**Does it do anything I didn't ask for?**
I searched the script for risky commands like `rm`, `sudo`, `curl`, `eval`, and `open`. None of them are in it. It doesn't need admin rights, doesn't touch the internet, and never opens the files it moves.

**Where can it reach?**
Only the top level of `~/Downloads`. It skips folders, hidden files, and symlinks, since a symlink can point somewhere outside Downloads.

**What happens if I mess up?**
Originally the script moved files by default and needed a flag to preview. I flipped that so it's safe by default. Nothing moves unless I type `apply`, and a typo stops it.

**Can a file name trick it?**
I tested it with names built to cause problems:

- `-rf.txt`, which a careless script could read as a command option
- `$(whoami).txt`, which tries to sneak a command in through the name
- `semi;colon.txt` and names with spaces

All of them were moved as normal files and nothing ran.

**Did I test it somewhere safe first?**
Yes. I pointed the script at a fake home folder full of test files before running it on my real Downloads:

```
HOME=~/testhome ~/scripts/clean_downloads.sh plan
```

## Next up

- [ ] Run the cleaner weekly with `launchd`
- [ ] Local account audit (users, admins, last login)
- [ ] Entra ID users and groups managed with Terraform
