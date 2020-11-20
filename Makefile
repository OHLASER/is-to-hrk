
MKDIR=mkdir
MSGFMT=msgfmt
PYTHON=python
CP=cp
RM=rm
ZIP=zip
PUSHD=pushd
POPD=popd

GEN_HRK_INX=$(PYTHON) tools/olhrk-i18n.py


all: build

build: olhrk-64-ja olhrk-64-en olhrk-32-ja olhrk-32-en


archive-all: build olhrk-64-ja-zip olhrk-64-en-zip olhrk-32-ja-zip olhrk-32-en-zip


# 64
olhrk-64-ja-zip: dist/olhrk-64-ja.zip

olhrk-64-en-zip: dist/olhrk-64-en.zip

# 32
olhrk-32-ja-zip: dist/olhrk-32-ja.zip

olhrk-32-en-zip: dist/olhrk-32-en.zip



# 64
dist/olhrk-64-ja.zip: olhrk-64-ja
	$(PUSHD) $(@D)/64/ja/is-to-hrk; \
	$(ZIP) -r ../../../$(@F) .; \
	$(POPD)	

dist/olhrk-64-en.zip: olhrk-64-en
	$(PUSHD) $(@D)/64/en/is-to-hrk; \
	$(ZIP) -r ../../../$(@F) .; \
	$(POPD)	


# 32
dist/olhrk-32-ja.zip: olhrk-32-ja
	$(PUSHD) $(@D)/32/ja/is-to-hrk; \
	$(ZIP) -r ../../../$(@F) .; \
	$(POPD)	

dist/olhrk-32-en.zip: olhrk-32-en
	$(PUSHD) $(@D)/32/en/is-to-hrk; \
	$(ZIP) -r ../../../$(@F) .; \
	$(POPD)	


# 64

olhrk-64-ja: olhrk-64-ja-inx\
	olhrk-64-ja-py\
	json-builder-64-ja-dll\
	json-parser-64-ja-dll\
	oldl-64-ja-dll

olhrk-64-en: olhrk-64-en-inx\
	olhrk-64-en-py\
	json-builder-64-en-dll\
	json-parser-64-en-dll\
	oldl-64-en-dll

# 32

olhrk-32-ja: olhrk-32-ja-inx\
	olhrk-32-ja-py\
	json-builder-32-ja-dll\
	json-parser-32-ja-dll\
	oldl-32-ja-dll

olhrk-32-en: olhrk-32-en-inx\
	olhrk-32-en-py\
	json-builder-32-en-dll\
	json-parser-32-en-dll\
	oldl-32-en-dll

clean-64-ja:
	$(RM) -r dist/64/ja

clean-64-en:
	$(RM) -r dist/64/en

clean-32-ja:
	$(RM) -r dist/32/ja

clean-32-en:
	$(RM) -r dist/32/en


clean: clean-64-ja clean-64-en clean-32-ja clean-32-en
	$(RM) -r dist

# 64

olhrk-64-ja-inx: dist/64/ja/is-to-hrk/olhrk.inx

olhrk-64-en-inx: dist/64/en/is-to-hrk/olhrk.inx

olhrk-64-ja-py: dist/64/ja/is-to-hrk/olhrk.py

olhrk-64-en-py: dist/64/en/is-to-hrk/olhrk.py

json-builder-64-ja-dll: dist/64/ja/is-to-hrk/json_builder.dll

json-parser-64-ja-dll: dist/64/ja/is-to-hrk/json_parser.dll

oldl-64-ja-dll: dist/64/ja/is-to-hrk/oldl.dll

json-builder-64-en-dll: dist/64/en/is-to-hrk/json_builder.dll

json-parser-64-en-dll: dist/64/en/is-to-hrk/json_parser.dll

oldl-64-en-dll: dist/64/en/is-to-hrk/oldl.dll

##  32
olhrk-32-ja-inx: dist/32/ja/is-to-hrk/olhrk.inx

olhrk-32-en-inx: dist/32/en/is-to-hrk/olhrk.inx

olhrk-32-ja-py: dist/32/ja/is-to-hrk/olhrk.py

olhrk-32-en-py: dist/32/en/is-to-hrk/olhrk.py

json-builder-32-ja-dll: dist/32/ja/is-to-hrk/json_builder.dll

json-parser-32-ja-dll: dist/32/ja/is-to-hrk/json_parser.dll

oldl-32-ja-dll: dist/32/ja/is-to-hrk/oldl.dll

json-builder-32-en-dll: dist/32/en/is-to-hrk/json_builder.dll

json-parser-32-en-dll: dist/32/en/is-to-hrk/json_parser.dll

oldl-32-en-dll: dist/32/en/is-to-hrk/oldl.dll


# licalization

i18n/ja/LC_MESSAGES/messages.mo: tools/i18n/ja/LC_MESSAGES/messages.po
	@$(MKDIR) -p $(@D) && $(MSGFMT) -o $@ $<

i18n/en/LC_MESSAGES/messages.mo: tools/i18n/en/LC_MESSAGES/messages.po
	@$(MKDIR) -p $(@D) && $(MSGFMT) -o $@ $<

# 64
dist/64/ja/is-to-hrk/olhrk.inx: src/olhrk.inx\
	i18n/ja/LC_MESSAGES/messages.mo
	@$(MKDIR) -p $(@D) && $(GEN_HRK_INX) -l ja -o $@ -i $<

dist/64/en/is-to-hrk/olhrk.inx: src/olhrk.inx\
	i18n/en/LC_MESSAGES/messages.mo
	@$(MKDIR) -p $(@D) && $(GEN_HRK_INX) -l en -o $@ -i $<

# 32
dist/32/ja/is-to-hrk/olhrk.inx: src/olhrk.inx\
	i18n/ja/LC_MESSAGES/messages.mo
	@$(MKDIR) -p $(@D) && $(GEN_HRK_INX) -l ja -o $@ -i $<

dist/32/en/is-to-hrk/olhrk.inx: src/olhrk.inx\
	i18n/en/LC_MESSAGES/messages.mo
	@$(MKDIR) -p $(@D) && $(GEN_HRK_INX) -l en -o $@ -i $<


# 64
dist/64/ja/is-to-hrk/olhrk.py: src/olhrk.py
	@$(MKDIR) -p $(@D) && $(CP) $< $@	

dist/64/en/is-to-hrk/olhrk.py: src/olhrk.py
	@$(MKDIR) -p $(@D) && $(CP) $< $@	

# 32 
dist/32/ja/is-to-hrk/olhrk.py: src/olhrk.py
	@$(MKDIR) -p $(@D) && $(CP) $< $@	

dist/32/en/is-to-hrk/olhrk.py: src/olhrk.py
	@$(MKDIR) -p $(@D) && $(CP) $< $@	


# 64 bit
dist/64/ja/is-to-hrk/json_builder.dll: ../x64/Release/json_builder.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D) 

dist/64/ja/is-to-hrk/json_parser.dll: ../x64/Release/json_parser.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D)

dist/64/ja/is-to-hrk/oldl.dll: ../x64/Release/oldl.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D) 


dist/64/en/is-to-hrk/json_builder.dll: ../x64/Release/json_builder.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D) 

dist/64/en/is-to-hrk/json_parser.dll: ../x64/Release/json_parser.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D) 

dist/64/en/is-to-hrk/oldl.dll: ../x64/Release/oldl.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D) 


# 32 bit 
dist/32/ja/is-to-hrk/json_builder.dll: ../Release/json_builder.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D) 

dist/32/ja/is-to-hrk/json_parser.dll: ../Release/json_parser.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D)

dist/32/ja/is-to-hrk/oldl.dll: ../Release/oldl.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D) 


dist/32/en/is-to-hrk/json_builder.dll: ../Release/json_builder.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D) 

dist/32/en/is-to-hrk/json_parser.dll: ../Release/json_parser.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D) 

dist/32/en/is-to-hrk/oldl.dll: ../Release/oldl.dll
	@$(MKDIR) -p $(@D) && $(CP) $< $(@D) 


.PHONY: clean

# vi: se ts=4 noet:
