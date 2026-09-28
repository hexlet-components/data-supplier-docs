SET = supplier-docs
STARTER = blender_kp.docx blender_passport.pdf boiler_scan.pdf golden_cards.json kettle_manual.pdf kettle_spec.xlsx
CATEGORIES = fan coffee heater iron microwave multicooker meatgrinder toaster vacuum fryer

test:
	@test "$$(ls *.pdf *.docx *.xlsx *.json | tr '\n' ' ')" = "$$(echo $(STARTER) | tr ' ' '\n' | sort | tr '\n' ' ')" || { echo "в корне не тот стартовый набор"; exit 1; }
	@test "$$(find $(SET) -type f | wc -l)" = 100 || { echo "в наборе не 100 файлов"; exit 1; }
	@for c in $(CATEGORIES); do \
		test "$$(ls $(SET)/$${c}_passport_* | wc -l)" = 5 || { echo "$$c: паспортов не 5"; exit 1; }; \
		test "$$(ls $(SET)/$${c}_spec_* | wc -l)" = 3 || { echo "$$c: спецификаций не 3"; exit 1; }; \
		test "$$(ls $(SET)/$${c}_kp_* | wc -l)" = 2 || { echo "$$c: КП не 2"; exit 1; }; \
	done
	@for f in $(SET)/*.pdf; do \
		pdftotext "$$f" - | grep -q . || { echo "нет текстового слоя: $$f"; exit 1; }; \
	done
	@echo "стартовый набор на месте; большой цел: 100 файлов, 10 категорий, текстовый слой на месте"
