# borrowed Colin's makefile, added html

# @status=$$(git status --porcelain); \
# if test "x$${status}" = x; then \
#             echo Working directory is okay >&2; \
#         else \
#             echo Working directory is dirty >&2; \
#         fi

DRAFTS =	draft-ietf-xrblock-independent-burst-gap-discard.txt \
          draft-ietf-xrblock-independent-burst-gap-discard.html \
					draft-ietf-xrblock-independent-burst-gap-discard.pdf
CMDSEP = ;
#VERSION = 00

all: $(DRAFTS)

%.txt: %.xml
	@echo "generate $< -> $@"
	@xml2rfc $< -o $@ 
	@egrep -ns --colour "\\bmust|required|shall|should|recommended|may|optional\\b" $< || true

%.html: %.xml
	@echo "generate $< -> $@"
	@xml2rfc $< -o $@ --html

%.pdf: %.txt
	@echo "enscript $< -> $@"
	@enscript -q -lc -f Courier11 -M A4 -p - $< | ps2pdf - $@

%.2up.pdf: %.txt
	@echo "enscript $< -> $@"
	@enscript -q -2lrc -M A4 -p - $< | ps2pdf - $@

clean:
	-rm -f $(DRAFTS)

copy:
	@version=$(shell if [ -z $(VERSION) ] ; then read -p "version: " REPLY ; echo $$REPLY ; fi ); \
	$(foreach var,$(DRAFTS), cp $(var) $(subst .,-$${version}., $(var))$(CMDSEP))

deploy: all copy clean
