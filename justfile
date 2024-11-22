set dotenv-load
filename := "kadykov"
cv := "cv"
letter := "letter"
language := "en"
output-dir := "."
typst := "typst compile"
pandoc := "pandoc --data-dir=$PANDOC_DATA_DIR --wrap=preserve --pdf-engine=typst --lua-filter=linkify.lua --lua-filter=typst-cv.lua"
pandoc-to-typst := "--to=typst | typst compile -"
private-args := '--input EMAIL="$EMAIL" --input PHONE="$PHONE"'

build-public:
  mkdir -p {{output-dir}}
  {{pandoc}} \
  {{filename}}-{{cv}}-{{language}}.md \
  -o {{output-dir}}/{{filename}}-{{cv}}-{{language}}.pdf \
  --template=typst-{{cv}}.typ
  {{pandoc}} \
  {{filename}}-{{letter}}-{{language}}.md \
  -o {{output-dir}}/{{filename}}-{{letter}}-{{language}}.pdf \
  --template=typst-{{letter}}.typ

build:
  mkdir -p {{output-dir}}
  {{pandoc}} \
  {{filename}}-{{cv}}-{{language}}.md \
  --template=typst-{{cv}}.typ \
  {{pandoc-to-typst}} \
  {{output-dir}}/{{filename}}-{{cv}}-{{language}}.pdf \
  {{private-args}}
  {{pandoc}} \
  {{filename}}-{{letter}}-{{language}}.md \
  --template=typst-{{letter}}.typ \
  {{pandoc-to-typst}} \
  {{output-dir}}/{{filename}}-{{letter}}-{{language}}.pdf \
  {{private-args}}

build-private:
  just build
