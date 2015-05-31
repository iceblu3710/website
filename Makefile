NAME = SumDumDum
DATE = $(shell date +'%m.%d.%Y')

MARKDOWN = "./markdown"

MD_FILES := $(shell find . -name "*.md")
IMG_2X_FILES := $(shell find . -name "*@2x.*")

HTML_FILES := $(MD_FILES:.md=.html)
IMG_FILES := $(subst @2x,,$(IMG_2X_FILES))

all: $(HTML_FILES) $(IMG_FILES)

%.html: TITLE = $(shell sed -n 's/^#[^#]//gp' $< | head -n 1 | sed 's/\&/\\\&/g')
%.html: %.md header.html footer.html Makefile
	@echo ".md -> .html  [$@]"
	@# Insert name and title into page header
	@sed 's/_TITLE_/$(TITLE)/g;s/_NAME_/$(NAME)/g' header.html > $@
	@# Render .md to .html, skipping the first line as it is assumed to be the title
	@tail -n +2 $< | $(MARKDOWN) >> $@
	@sed 's/_NAME_/$(NAME)/g;s/_DATE_/$(DATE)/g' footer.html >> $@

%.png: %@2x.png Makefile
	@echo "@2x.png -> .png  [$@]"
	@convert $< -resize 600x $@
%.jpg: %@2x.jpg Makefile
	@echo "@2x.jpg -> .jpg  [$@]"
	@convert $< -resize 600x $@
%.gif: %@2x.gif Makefile
	@echo "@2x.gif -> .gif  [$@]"
	@convert $< -coalesce -resize 600x -layers optimize $@
