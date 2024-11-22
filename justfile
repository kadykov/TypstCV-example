set dotenv-load
filename := "kadykov"
cv := "cv"
letter := "letter"
job-description := "job-description"
language := "en"
output-dir := "."
typst := "typst compile"
pandoc := "pandoc --data-dir=$PANDOC_DATA_DIR --wrap=preserve --pdf-engine=typst --lua-filter=linkify.lua --lua-filter=typst-cv.lua"
pandoc-to-typst := "--to=typst | typst compile -"
private-args := '--input EMAIL="$EMAIL" --input PHONE="$PHONE"'

build-public:
  mkdir -p {{output-dir}}
  pandoc --to markdown \
  {{filename}}-{{cv}}-{{language}}.md \
  --include-after-body {{filename}}-after-{{cv}}-{{language}}.md \
  | {{pandoc}} \
  --include-in-header {{filename}}-{{cv}}-{{language}}.yml \
  -o {{output-dir}}/{{filename}}-{{cv}}-{{language}}.pdf \
  --template=typst-{{cv}}.typ
  {{pandoc}} \
  {{filename}}-{{letter}}-{{language}}.md \
  --include-in-header {{filename}}-{{letter}}-{{language}}.yml \
  -o {{output-dir}}/{{filename}}-{{letter}}-{{language}}.pdf \
  --template=typst-{{letter}}.typ

build:
  mkdir -p {{output-dir}}
  pandoc --to markdown \
  {{filename}}-{{cv}}-{{language}}.md \
  --include-after-body {{filename}}-after-{{cv}}-{{language}}.md \
  | {{pandoc}} \
  --include-in-header {{filename}}-{{cv}}-{{language}}.yml \
  --template=typst-{{cv}}.typ \
  {{pandoc-to-typst}} \
  {{output-dir}}/{{filename}}-{{cv}}-{{language}}.pdf \
  {{private-args}}
  {{pandoc}} \
  {{filename}}-{{letter}}-{{language}}.md \
  --include-in-header {{filename}}-{{letter}}-{{language}}.yml \
  --template=typst-{{letter}}.typ \
  {{pandoc-to-typst}} \
  {{output-dir}}/{{filename}}-{{letter}}-{{language}}.pdf \
  {{private-args}}

build-private:
  just build

prompt:
  mkdir -p {{output-dir}}
  pandoc --strip-comments --wrap=none \
  {{filename}}-{{letter}}-{{language}}.md \
  -o prompt-{{letter}}-{{language}}.md
  pandoc --strip-comments --wrap=none \
  {{job-description}}.md \
  -o prompt-{{job-description}}-{{language}}.md
  pandoc --strip-comments --wrap=none \
  {{filename}}-{{cv}}-{{language}}.md \
  --include-before-body prompt-before-{{cv}}-{{language}}.md \
  --include-after-body prompt-before-{{letter}}-{{language}}.md \
  --include-after-body prompt-{{letter}}-{{language}}.md \
  --include-after-body prompt-before-{{job-description}}-{{language}}.md \
  --include-after-body prompt-{{job-description}}-{{language}}.md \
  --include-after-body prompt-instructions-{{cv}}-{{language}}.md \
  -o {{output-dir}}/prompt-output.md
  rm \
  prompt-{{letter}}-{{language}}.md \
  prompt-{{job-description}}-{{language}}.md
