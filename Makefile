
MKDIR=mkdir
MSGFMT=msgfmt
PYTHON=python
CP=cp
RM=rm
ZIP=zip
PUSHD=pushd
POPD=popd

GEN_HRK_INX=$(PYTHON) tools/olhrk-i18n.py


all: olhrk-ja olhrk-en


archive-all: olhrk-ja-zip olhrk-en-zip

olhrk-ja-zip: dist/olhrk-ja.zip

olhrk-en-zip: dist/olhrk-en.zip


dist/olhrk-ja.zip: olhrk-ja
	$(PUSHD) $(@D)/ja/is-to-hrk; \
	$(ZIP) -r ../../$(@F) .; \
	$(POPD)	

dist/olhrk-en.zip: olhrk-ja
	$(PUSHD) $(@D)/ja/is-to-hrk; \
	$(ZIP) -r ../../$(@F) .; \
	$(POPD)	


olhrk-ja: olhrk-ja-inx\
	olhrk-ja-py\
	json-builder-ja-dll\
	json-parser-ja-dll\
	oldl-ja-dll

olhrk-en: olhrk-en-inx\
	olhrk-en-py\
	json-builder-en-dll\
	json-parser-en-dll\
	oldl-en-dll

clean-ja:
	$(RM) -r dist/ja

clean-en:
	$(RM) -r dist/en

clean: clean-ja clean-en

olhrk-ja-inx: dist/ja/is-to-hrk/olhrk.inx

olhrk-en-inx: dist/en/is-to-hrk/olhrk.inx

olhrk-ja-py: dist/ja/is-to-hrk/olhrk.py

olhrk-en-py: dist/en/is-to-hrk/olhrk.py

json-builder-ja-dll: dist/ja/is-to-hrk/json_builder.dll

json-parser-ja-dll: dist/ja/is-to-hrk/json_parser.dll

oldl-ja-dll: dist/ja/is-to-hrk/oldl.dll

json-builder-en-dll: dist/en/is-to-hrk/json_builder.dll

json-parser-en-dll: dist/en/is-to-hrk/json_parser.dll

oldl-en-dll: dist/en/is-to-hrk/oldl.dll


i18n/ja/LC_MESSAGES/messages.mo: tools/i18n/ja/LC_MESSAGES/messages.po
	@$(MKDIR) -p $(@D) && $(MSGFMT) -o $@ $<

i18n/en/LC_MESSAGES/messages.mo: tools/i18n/en/LC_MESSAGES/messages.po
	@$(MKDIR) -p $(@D) && $(MSGFMT) -o $@ $<


dist/ja/is-to-hrk/olhrk.inx: src/olhrk.inx\
	i18n/ja/LC_MESSAGES/messages.mo
	@$(MKDIR) -p $(@D) && $(GEN_HRK_INX) -l ja -o $@ -i $<

dist/ja/is-to-hrk/olhrk.py: src/olhrk.py
	@$(MKDIR) -p $(@D) && $(CP) $< $@	

dist/en/is-to-hrk/olhrk.py: src/olhrk.py
	@$(MKDIR) -p $(@D) && $(CP) $< $@	


dist/en/is-to-hrk/olhrk.inx: src/olhrk.inx\
	i18n/en/LC_MESSAGES/messages.mo
	@$(MKDIR) -p $(@D) && $(GEN_HRK_INX) -l en -o $@ -i $<

dist/ja/is-to-hrk/json_builder.dll: ../x64/Release/json_builder.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D) 

dist/ja/is-to-hrk/json_parser.dll: ../x64/Release/json_parser.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D)

dist/ja/is-to-hrk/oldl.dll: ../x64/Release/oldl.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D) 


dist/en/is-to-hrk/json_builder.dll: ../x64/Release/json_builder.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D) 

dist/en/is-to-hrk/json_parser.dll: ../x64/Release/json_parser.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D) 

dist/en/is-to-hrk/oldl.dll: ../x64/Release/oldl.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D) 

.PHONY: clean

# vi: se ts=4 noet:
