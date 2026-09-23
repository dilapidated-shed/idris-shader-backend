#!/usr/bin/env bash
set -euo pipefail

root='books about GPU programming'
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

rm -rf "$root"
mkdir -p "$root"

clone() {
  local repo="$1"
  local dst="$2"
  git clone --quiet --depth=1 "https://github.com/\${repo}.git" "$dst"
}

write_upstream() {
  local dst="$1"
  local title="$2"
  local source="$3"
  local revision="$4"
  local licenses="$5"
  local scope="$6"
  cat > "$dst/UPSTREAM.md" <<EOF
# Upstream snapshot

- **Work:** $title
- **Canonical source:** $source
- **Pinned revision:** $revision
- **Upstream license(s):** $licenses
- **Mirror scope:** $scope
- **Local changes:** directory relocation plus the attribution/thanks files added by this repository; upstream book text is otherwise kept as supplied.

This directory is an attributed mirror. Its upstream license applies to the mirrored material; the shader backend's repository-wide license does not relicense this work.
EOF
}

src="$work/vulkan-guide"
dst="$root/Vulkan Guide"
clone "KhronosGroup/Vulkan-Guide" "$src"
mkdir -p "$dst"
rsync -a --exclude='.git' --exclude='.github' "$src/" "$dst/"
sha="$(git -C "$src" rev-parse HEAD)"
write_upstream "$dst" "Vulkan Guide" "https://github.com/KhronosGroup/Vulkan-Guide" "$sha" "CC-BY-4.0 (with any per-file SPDX exceptions preserved upstream)" "Complete current source tree except Git metadata and upstream CI configuration."

src="$work/vulkan-tutorial"
dst="$root/Vulkan Tutorial"
clone "KhronosGroup/Vulkan-Tutorial" "$src"
mkdir -p "$dst"
for item in LICENSE LICENSES REUSE.toml README.adoc CONTRIBUTORS.adoc CODE_OF_CONDUCT.adoc antora en images; do
  if [ -e "$src/$item" ]; then
    rsync -a "$src/$item" "$dst/"
  fi
done
sha="$(git -C "$src" rev-parse HEAD)"
write_upstream "$dst" "Khronos Vulkan Tutorial" "https://github.com/KhronosGroup/Vulkan-Tutorial" "$sha" "CC-BY-SA-4.0 for the tutorial unless stated otherwise; per-directory Apache-2.0, MIT and other notices retained; original tutorial code listings include CC0 material" "Tutorial text, courses under en/, tutorial images, Antora metadata, contributor list, and root license metadata. The large attachments/ tree is excluded because it bundles independent samples, third-party libraries, and assets under additional licenses."

src="$work/webgpu-fundamentals"
dst="$root/WebGPU Fundamentals"
clone "webgpu/webgpufundamentals" "$src"
mkdir -p "$dst"
for item in LICENSE contributors.md README.md README.es.md README.ko.md README.pt-BR.md README.zh-CN.md toc.hanson; do
  [ -e "$src/$item" ] && cp -a "$src/$item" "$dst/"
done
mkdir -p "$dst/webgpu/lessons"
while IFS= read -r -d '' f; do
  rel="\${f#"$src/"}"
  mkdir -p "$dst/$(dirname "$rel")"
  cp -a "$f" "$dst/$rel"
done < <(find "$src/webgpu/lessons" -type f \( \
  -name '*.md' -o -name '*.html' -o -name '*.js' -o -name '*.mjs' -o \
  -name '*.css' -o -name '*.json' -o -name '*.hanson' -o -name '*.txt' \
\) -print0)
sha="$(git -C "$src" rev-parse HEAD)"
write_upstream "$dst" "WebGPU Fundamentals" "https://github.com/webgpu/webgpufundamentals" "$sha" "BSD-3-Clause" "Textual lesson source and executable text examples, plus upstream license/readmes/contributor file. Large photos, videos, models, third-party bundles, and other media are excluded so independently licensed media is not silently relicensed."

src="$work/enccs-gpu-programming"
dst="$root/ENCCS GPU Programming - When Why and How"
clone "ENCCS/gpu-programming" "$src"
mkdir -p "$dst"
for item in LICENSE LICENSE.code; do
  [ -e "$src/$item" ] && cp -a "$src/$item" "$dst/"
done
rsync -a --exclude='slides/' "$src/content/" "$dst/content/"
sha="$(git -C "$src" rev-parse HEAD)"
write_upstream "$dst" "GPU Programming: When, Why and How?" "https://github.com/ENCCS/gpu-programming" "$sha" "CC-BY-4.0 for lesson material; MIT for code" "Lesson source, examples, exercises, figures, and license files. The slides/ directory is excluded because it contains large PDF slide decks and derivative presentation artifacts; the complete editable lesson source is retained."

src="$work/enccs-cuda"
dst="$root/ENCCS CUDA Training"
clone "ENCCS/cuda" "$src"
mkdir -p "$dst"
for item in LICENSE LICENSE.code README.md; do
  [ -e "$src/$item" ] && cp -a "$src/$item" "$dst/"
done
[ -d "$src/content" ] && rsync -a "$src/content/" "$dst/content/"
[ -d "$src/examples" ] && rsync -a "$src/examples/" "$dst/examples/"
sha="$(git -C "$src" rev-parse HEAD)"
write_upstream "$dst" "ENCCS CUDA Training Materials" "https://github.com/ENCCS/cuda" "$sha" "CC-BY-4.0 for lesson material; MIT for code" "Lesson source, examples, root readme, and both upstream licenses."

dst="$root/EVITA Introduction to GPU Programming"
mkdir -p "$dst"
host='introduction-to-gpu-programming-9cf4de.pages.code.europa.eu'
site="https://$host/"
mkdir -p "$work/evita"
(
  cd "$work/evita"
  wget --quiet --mirror --page-requisites --convert-links --adjust-extension --no-parent \
    --domains="$host" "$site" || true
)
if [ ! -f "$work/evita/$host/index.html" ]; then
  echo "EVITA site mirror failed: index.html missing" >&2
  exit 1
fi
rsync -a "$work/evita/$host/" "$dst/site/"
cat > "$dst/LICENSE.md" <<'EOF'
# License and attribution

The mirrored EVITA Introduction to GPU Programming site states:

- pedagogical material and media: Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0);
- source code and code snippets: MIT License.

Copyright © 2026, EVITA project; Cristian-Vasile Achim; Hicham Agueny; Andrey Alekseenko; Richard Darst; Karim Elgammal; Francesco Fiusco; Juan de Gracia; Johan Hellsvik; Jaro Hokkanen; Erik Holmström; Qiang Li; Wei Li; Daniel Medeiros; Ashwin Vishnu Mohanan; Tapish Narwal; Pedro Ojeda May; Yann Pfau-Kempf; Stephan Smuts; Stepas Toliautas; Apostolos Vasileiadis; Yonglei Wang; and Kjartan Thor Wikfeldt.

Canonical license pages:

- https://creativecommons.org/licenses/by-sa/4.0/
- https://opensource.org/license/mit

The upstream site's full credits/license notice is preserved in the mirrored site itself.
EOF
write_upstream "$dst" "Introduction to GPU Programming" "$site" "site snapshot retrieved 2026-09-23" "CC-BY-SA-4.0 for pedagogical/media material; MIT for source code and code snippets" "Static rendered site mirrored from the canonical EVITA Pages host."

cat > "$root/README.md" <<'EOF'
# Books about GPU programming

This directory mirrors GPU-programming material whose published licenses permit copying and reuse. Each work lives in its own directory with the upstream license, pinned source information, and an explicit thanks/attribution file.

The mirror is deliberately conservative about licensing: material that is merely free-to-read is not included, and material carrying NoDerivatives or NonCommercial restrictions is not treated here as freely reusable source material.

| Work | License used for inclusion |
| --- | --- |
| Vulkan Guide | CC-BY-4.0 |
| Khronos Vulkan Tutorial | CC-BY-SA-4.0, with preserved per-file exceptions |
| WebGPU Fundamentals | BSD-3-Clause |
| GPU Programming: When, Why and How? (ENCCS) | CC-BY-4.0 / MIT code |
| ENCCS CUDA Training Materials | CC-BY-4.0 / MIT code |
| Introduction to GPU Programming (EVITA) | CC-BY-SA-4.0 / MIT code |

## Not mirrored

The following material discussed during the same research pass is intentionally absent:

- GPU Gems 2: freely readable online, but not published under a general open redistribution/adaptation license.
- The Book of Shaders: freely readable/source-visible, but its repository states all rights reserved.
- Norm Matloff's Programming on Parallel Machines: CC BY-ND; redistribution is allowed, but NoDerivatives is intentionally outside this mirror's open-reuse criterion.
- SLING/other CC BY-NC-SA CUDA workshop material: NonCommercial restriction is intentionally outside this mirror's open-reuse criterion.
- Commercial textbooks such as Programming Massively Parallel Processors, The CUDA Handbook, and Numerical Computations with GPUs.

## Attribution policy

For every included work, preserve the upstream license and source. THANKS.md files thank upstream authors/contributors and, where the material contains a bibliography/reference section, list every identifiable individual author/editor recovered from the cited work's public metadata. BIBLIOGRAPHY-METADATA.json records the underlying citation-resolution result so unresolved or organizational references remain visible instead of being guessed.
EOF

cat > "$work/generate_thanks.py" <<'PY'
import concurrent.futures
import difflib
import html
import json
import os
import pathlib
import re
import urllib.parse
import urllib.request

ROOT = pathlib.Path("books about GPU programming")
TOKEN = os.environ.get("GITHUB_TOKEN", "")
UA = "idris-shader-backend-open-book-mirror/1.0"

BOOK_REPOS = {
    "Vulkan Guide": "KhronosGroup/Vulkan-Guide",
    "Vulkan Tutorial": "KhronosGroup/Vulkan-Tutorial",
    "WebGPU Fundamentals": "webgpu/webgpufundamentals",
    "ENCCS GPU Programming - When Why and How": "ENCCS/gpu-programming",
    "ENCCS CUDA Training": "ENCCS/cuda",
}

EVITA_AUTHORS = [
    "Cristian-Vasile Achim", "Hicham Agueny", "Andrey Alekseenko",
    "Richard Darst", "Karim Elgammal", "Francesco Fiusco",
    "Juan de Gracia", "Johan Hellsvik", "Jaro Hokkanen",
    "Erik Holmström", "Qiang Li", "Wei Li", "Daniel Medeiros",
    "Ashwin Vishnu Mohanan", "Tapish Narwal", "Pedro Ojeda May",
    "Yann Pfau-Kempf", "Stephan Smuts", "Stepas Toliautas",
    "Apostolos Vasileiadis", "Yonglei Wang", "Kjartan Thor Wikfeldt",
]

TEXT_EXT = {".md", ".adoc", ".rst", ".html", ".htm"}
REFERENCE_WORDS = ("bibliograph", "references", "further reading", "additional resources", "sources")
URL_RE = re.compile(r"https?://[^\s<>)\]}\"']+")
MD_LINK_RE = re.compile(r"\[([^\]]+)\]\((https?://[^)]+)\)")
ADOC_LINK_RE = re.compile(r"link:(https?://[^\[]+)\[([^\]]*)\]")
RST_LINK_RE = re.compile(r"\x60([^\x60<]+)\s*<(https?://[^>]+)>\x60_")
HTML_LINK_RE = re.compile(r"<a\b[^>]*href=[\"'](https?://[^\"']+)[\"'][^>]*>(.*?)</a>", re.I | re.S)
TAG_RE = re.compile(r"<[^>]+>")

def request(url, timeout=12):
    headers = {"User-Agent": UA, "Accept": "text/html,application/json;q=0.9,*/*;q=0.1"}
    if "api.github.com" in url and TOKEN:
        headers["Authorization"] = f"Bearer {TOKEN}"
        headers["X-GitHub-Api-Version"] = "2022-11-28"
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.read(2_000_000), r.headers.get_content_type(), r.geturl()

def normalize_title(s):
    s = html.unescape(TAG_RE.sub(" ", s or ""))
    s = re.sub(r"\s+", " ", s).strip(" \t\r\n-–—:;.")
    return s

def links_from_line(line):
    out = []
    for title, url in MD_LINK_RE.findall(line):
        out.append((normalize_title(title), url.rstrip(".,;")))
    for url, title in ADOC_LINK_RE.findall(line):
        out.append((normalize_title(title) or url, url.rstrip(".,;")))
    for title, url in RST_LINK_RE.findall(line):
        out.append((normalize_title(title), url.rstrip(".,;")))
    if not out:
        for url in URL_RE.findall(line):
            out.append((url, url.rstrip(".,;")))
    return out

def extract_reference_links(path):
    try:
        text = path.read_text("utf-8", errors="ignore")
    except Exception:
        return []
    rel = str(path.relative_to(ROOT))
    found = []
    if any(w in path.name.lower() for w in ("reference", "bibliograph")):
        if path.suffix.lower() in {".html", ".htm"}:
            for url, title in HTML_LINK_RE.findall(text):
                title = normalize_title(title)
                if title:
                    found.append((rel, title, html.unescape(url)))
        else:
            for line in text.splitlines():
                found.extend((rel, title, url) for title, url in links_from_line(line))
        return found

    lines = text.splitlines()
    active = False
    active_level = None
    for i, line in enumerate(lines):
        md = re.match(r"^(#{1,6})\s+(.+?)\s*$", line)
        adoc = re.match(r"^(={1,6})\s+(.+?)\s*$", line)
        heading = None
        level = None
        if md:
            level, heading = len(md.group(1)), normalize_title(md.group(2))
        elif adoc:
            level, heading = len(adoc.group(1)), normalize_title(adoc.group(2))
        elif i + 1 < len(lines) and re.match(r"^[=\-~^+]{3,}\s*$", lines[i + 1]):
            heading, level = normalize_title(line), 2
        if heading is not None:
            low = heading.lower()
            if any(w in low for w in REFERENCE_WORDS):
                active, active_level = True, level
                continue
            if active and level is not None and active_level is not None and level <= active_level:
                active = False
        if active:
            found.extend((rel, title, url) for title, url in links_from_line(line))
    return found

def strip_person_noise(name):
    name = html.unescape(TAG_RE.sub("", name or "")).strip()
    name = re.sub(r"\s+", " ", name)
    if not name or len(name) > 120:
        return ""
    return name

def authors_from_html(blob):
    s = blob.decode("utf-8", errors="ignore")
    names = []
    pats = [
        r"<meta[^>]+name=[\"']citation_author[\"'][^>]+content=[\"']([^\"']+)",
        r"<meta[^>]+content=[\"']([^\"']+)[\"'][^>]+name=[\"']citation_author[\"']",
        r"<meta[^>]+name=[\"'](?:dc\.creator|author)[\"'][^>]+content=[\"']([^\"']+)",
        r"<meta[^>]+content=[\"']([^\"']+)[\"'][^>]+name=[\"'](?:dc\.creator|author)[\"']",
    ]
    for p in pats:
        names.extend(re.findall(p, s, re.I))
    for block in re.findall(r"<script[^>]+type=[\"']application/ld\+json[\"'][^>]*>(.*?)</script>", s, re.I | re.S):
        try:
            data = json.loads(html.unescape(block))
        except Exception:
            continue
        stack = data if isinstance(data, list) else [data]
        for obj in stack:
            if not isinstance(obj, dict):
                continue
            a = obj.get("author")
            if isinstance(a, dict):
                names.append(a.get("name", ""))
            elif isinstance(a, list):
                for x in a:
                    if isinstance(x, dict):
                        names.append(x.get("name", ""))
                    elif isinstance(x, str):
                        names.append(x)
            elif isinstance(a, str):
                names.append(a)
    return sorted({strip_person_noise(n) for n in names if strip_person_noise(n)}, key=str.casefold)

def crossref_authors(title):
    if not title or title.startswith("http") or len(title.split()) < 3:
        return []
    q = urllib.parse.urlencode({"query.title": title, "rows": 1, "select": "title,author,editor,DOI"})
    try:
        blob, _, _ = request("https://api.crossref.org/works?" + q, timeout=10)
        item = json.loads(blob)["message"]["items"][0]
    except Exception:
        return []
    got = normalize_title((item.get("title") or [""])[0])
    score = difflib.SequenceMatcher(None, title.lower(), got.lower()).ratio()
    if score < 0.80:
        return []
    names = []
    for role in ("author", "editor"):
        for p in item.get(role, []) or []:
            n = " ".join(x for x in (p.get("given", ""), p.get("family", "")) if x).strip()
            if n:
                names.append(n)
    return sorted(set(names), key=str.casefold)

def resolve_one(item):
    rel, title, url = item
    authors = []
    final = url
    try:
        blob, ctype, final = request(url)
        if ctype and "html" in ctype:
            authors = authors_from_html(blob)
    except Exception:
        pass
    if not authors:
        authors = crossref_authors(title)
    return {"source_file": rel, "title": title, "url": url, "resolved_url": final, "authors": authors}

def gh_contributors(repo):
    names = []
    for page in range(1, 6):
        url = f"https://api.github.com/repos/{repo}/contributors?per_page=100&anon=1&page={page}"
        try:
            blob, _, _ = request(url)
            rows = json.loads(blob)
        except Exception:
            break
        if not rows:
            break
        for x in rows:
            login = x.get("login")
            if login and login.endswith("[bot]"):
                continue
            if login:
                display = ""
                try:
                    ub, _, _ = request(f"https://api.github.com/users/{login}")
                    display = (json.loads(ub).get("name") or "").strip()
                except Exception:
                    pass
                names.append(display or login)
            elif x.get("name"):
                names.append(x["name"])
        if len(rows) < 100:
            break
    return sorted(set(names), key=str.casefold)

all_items = []
for path in ROOT.rglob("*"):
    if path.is_file() and path.suffix.lower() in TEXT_EXT and path.name not in {"THANKS.md", "UPSTREAM.md"}:
        all_items.extend(extract_reference_links(path))

dedup = {}
for rel, title, url in all_items:
    book = rel.split(os.sep, 1)[0]
    if "creativecommons.org/licenses/" in url:
        continue
    key = (book, normalize_title(title), url)
    dedup[key] = (rel, normalize_title(title), url)
items = list(dedup.values())

resolved = []
with concurrent.futures.ThreadPoolExecutor(max_workers=10) as ex:
    futures = [ex.submit(resolve_one, x) for x in items]
    for f in concurrent.futures.as_completed(futures):
        try:
            resolved.append(f.result())
        except Exception:
            pass

by_book = {}
for r in resolved:
    book = r["source_file"].split(os.sep, 1)[0]
    by_book.setdefault(book, []).append(r)

for bookdir in sorted([p for p in ROOT.iterdir() if p.is_dir()]):
    book = bookdir.name
    repo = BOOK_REPOS.get(book)
    if repo:
        upstream_people = gh_contributors(repo)
    elif book == "EVITA Introduction to GPU Programming":
        upstream_people = EVITA_AUTHORS[:]
    else:
        upstream_people = []

    citations = sorted(by_book.get(book, []), key=lambda x: (x["title"].casefold(), x["url"]))
    cited_people = sorted({a for c in citations for a in c.get("authors", [])}, key=str.casefold)

    lines = [
        "# Thanks and attribution",
        "",
        "This mirror thanks the people who created and maintained the upstream work, and also the identifiable people named as authors or editors of works in its bibliography/reference sections.",
        "",
        "The upstream license and exact source snapshot are recorded in UPSTREAM.md; upstream license files are retained beside the material.",
        "",
        "## Upstream authors and contributors",
        "",
    ]
    if upstream_people:
        lines.extend(f"- {n}" for n in upstream_people)
    else:
        lines.append("- See the preserved upstream credits and license files; no GitHub contributor list applies to this static-site source.")

    lines += ["", "## People cited in bibliography/reference sections", ""]
    if cited_people:
        lines.extend(f"- {n}" for n in cited_people)
    else:
        lines.append("- No individually named bibliography authors/editors were resolved from the upstream reference sections in this snapshot.")

    lines += ["", "## Cited works checked", ""]
    if citations:
        for c in citations:
            who = ", ".join(c["authors"]) if c["authors"] else "individual author/editor not stated in accessible metadata"
            title = c["title"] or c["url"]
            lines.append(f"- **{title}** — {who} — {c['url']}")
    else:
        lines.append("- No formal bibliography/reference links were detected in the mirrored source.")

    lines += [
        "",
        "## Method",
        "",
        "Names above are not invented. Reference links were extracted from headings such as Bibliography, References, Further Reading, and Additional Resources, plus dedicated reference pages. Individual authors/editors were taken from citation metadata or JSON-LD on the cited page or, when that was absent, from a high-title-similarity Crossref record. Unresolved works stay visibly unresolved rather than being guessed.",
        "",
    ]
    (bookdir / "THANKS.md").write_text("\n".join(lines), encoding="utf-8")
    (bookdir / "BIBLIOGRAPHY-METADATA.json").write_text(json.dumps(citations, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
PY

python3 "$work/generate_thanks.py"

python3 - <<'PY'
from pathlib import Path
import hashlib, json
root = Path("books about GPU programming")
rows = []
for p in sorted(root.rglob("*")):
    if p.is_file():
        h = hashlib.sha256(p.read_bytes()).hexdigest()
        rows.append({"path": str(p.relative_to(root)), "bytes": p.stat().st_size, "sha256": h})
(root / "MIRROR-MANIFEST.json").write_text(json.dumps(rows, indent=2) + "\n")
print(f"mirrored {len(rows)} files, {sum(r['bytes'] for r in rows)} bytes")
PY
