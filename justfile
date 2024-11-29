set dotenv-load
filename := "kadykov"
cv := "cv"
letter := "letter"
job-description := "job-description"
language := "fr"
output-dir := "."
typst := "typst compile"
pandoc := "pandoc --data-dir=$PANDOC_DATA_DIR --wrap=preserve --pdf-engine=typst --lua-filter=linkify.lua --lua-filter=typst-cv.lua"
pandoc-to-typst := "--to=typst | typst compile -"
pandoc-clean := "pandoc --strip-comments --wrap=none --lua-filter clean.lua"
private-args := '--input EMAIL="$EMAIL" --input PHONE="$PHONE"'

alias build-private := build

build-public:
  just build public

build mode="private":
  mkdir -p {{output-dir}}
  pandoc --to markdown \
  {{filename}}-{{cv}}-{{language}}.md \
  --include-after-body {{filename}}-after-{{cv}}-{{language}}.md \
  | {{pandoc}} \
  --metadata-file {{filename}}-{{cv}}-{{language}}.yml \
  --template=typst-{{cv}}.typ \
  {{pandoc-to-typst}} \
  {{output-dir}}/{{filename}}-{{cv}}-{{language}}.pdf \
  {{ if mode == "private" {private-args} else {""} }}
  {{pandoc}} \
  {{filename}}-{{letter}}-{{language}}.md \
  --metadata-file {{filename}}-{{letter}}-{{language}}.yml \
  --template=typst-{{letter}}.typ \
  {{pandoc-to-typst}} \
  {{output-dir}}/{{filename}}-{{letter}}-{{language}}.pdf \
  {{ if mode == "private" {private-args} else {""} }}

prompt target=cv:
  mkdir -p {{output-dir}}
  {{pandoc-clean}} \
  {{filename}}-{{letter}}-{{language}}.md \
  -o prompt-{{letter}}-{{language}}.md
  {{pandoc-clean}} \
  {{job-description}}.md \
  -o prompt-{{job-description}}-{{language}}.md
  {{pandoc-clean}} \
  {{filename}}-{{cv}}-{{language}}.md \
  --include-before-body prompt-before-{{cv}}-{{language}}.md \
  --include-after-body prompt-before-{{letter}}-{{language}}.md \
  --include-after-body prompt-{{letter}}-{{language}}.md \
  --include-after-body prompt-before-{{job-description}}-{{language}}.md \
  --include-after-body prompt-{{job-description}}-{{language}}.md \
  --include-after-body prompt-instructions-{{target}}-{{language}}.md \
  -o {{output-dir}}/prompt-output.md
  rm \
  prompt-{{letter}}-{{language}}.md \
  prompt-{{job-description}}-{{language}}.md
