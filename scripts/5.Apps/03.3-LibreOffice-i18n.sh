#!/bin/bash

#============================ Term Size============================
## Detect terminal size
### incase tput is not found, sets to fixed value
TERM_HEIGHT=$(tput lines 2>/dev/null || echo 24)
TERM_WIDTH=$(tput cols 2>/dev/null || echo 80)
## Set TUI size based on terminal size
HEIGHT=$(( TERM_HEIGHT  ))
WIDTH=$(( TERM_WIDTH  ))
MENU_HEIGHT=$(( HEIGHT - 10 ))
### use $HEIGHT $WIDTH for --inputbox --msgbox --yesno
### or $HEIGHT $WIDTH $MENU_HEIGHT for --menu

#============================ Intro ============================
whiptail --title "LibreOffice Language Packs" \
--msgbox "Select one or more language packs to install.

Use SPACE to select, ENTER to confirm." \
"$HEIGHT" "$WIDTH"

#============================ Checklist ============================

CHOICES=$(whiptail --title "LibreOffice i18n" \
--checklist "Select language packs:" \
"$HEIGHT" "$WIDTH" "$MENU_HEIGHT" \
"libreoffice-i18n-ab" "Abkhazian" OFF \
"libreoffice-i18n-af" "Afrikaans" OFF \
"libreoffice-i18n-am" "Amharic" OFF \
"libreoffice-i18n-ar" "Arabic" OFF \
"libreoffice-i18n-as" "Assamese" OFF \
"libreoffice-i18n-ast" "Asturian" OFF \
"libreoffice-i18n-be" "Belarusian" OFF \
"libreoffice-i18n-bg" "Bulgarian" OFF \
"libreoffice-i18n-bn" "Bengali" OFF \
"libreoffice-i18n-bn-IN" "Bengali (India)" OFF \
"libreoffice-i18n-bo" "Tibetan" OFF \
"libreoffice-i18n-br" "Breton" OFF \
"libreoffice-i18n-brx" "Bodo" OFF \
"libreoffice-i18n-bs" "Bosnian" OFF \
"libreoffice-i18n-ca" "Catalan" OFF \
"libreoffice-i18n-ca-valencia" "Catalan (Valencian)" OFF \
"libreoffice-i18n-ckb" "Central Kurdish" OFF \
"libreoffice-i18n-cs" "Czech" OFF \
"libreoffice-i18n-cy" "Welsh" OFF \
"libreoffice-i18n-da" "Danish" OFF \
"libreoffice-i18n-de" "German" OFF \
"libreoffice-i18n-dgo" "Dogri" OFF \
"libreoffice-i18n-dsb" "Lower Sorbian" OFF \
"libreoffice-i18n-dz" "Dzongkha" OFF \
"libreoffice-i18n-el" "Greek" OFF \
"libreoffice-i18n-en-GB" "English (UK)" OFF \
"libreoffice-i18n-en-US" "English (US)" OFF \
"libreoffice-i18n-en-ZA" "English (South Africa)" OFF \
"libreoffice-i18n-eo" "Esperanto" OFF \
"libreoffice-i18n-es" "Spanish" OFF \
"libreoffice-i18n-et" "Estonian" OFF \
"libreoffice-i18n-eu" "Basque" OFF \
"libreoffice-i18n-fa" "Persian" OFF \
"libreoffice-i18n-fi" "Finnish" OFF \
"libreoffice-i18n-fr" "French" OFF \
"libreoffice-i18n-fur" "Friulian" OFF \
"libreoffice-i18n-fy" "Frisian" OFF \
"libreoffice-i18n-ga" "Irish" OFF \
"libreoffice-i18n-gd" "Scottish Gaelic" OFF \
"libreoffice-i18n-gl" "Galician" OFF \
"libreoffice-i18n-gu" "Gujarati" OFF \
"libreoffice-i18n-gug" "Guaraní" OFF \
"libreoffice-i18n-he" "Hebrew" OFF \
"libreoffice-i18n-hi" "Hindi" OFF \
"libreoffice-i18n-hr" "Croatian" OFF \
"libreoffice-i18n-hsb" "Upper Sorbian" OFF \
"libreoffice-i18n-hu" "Hungarian" OFF \
"libreoffice-i18n-hy" "Armenian" OFF \
"libreoffice-i18n-id" "Indonesian" OFF \
"libreoffice-i18n-is" "Icelandic" OFF \
"libreoffice-i18n-it" "Italian" OFF \
"libreoffice-i18n-ja" "Japanese" OFF \
"libreoffice-i18n-ka" "Georgian" OFF \
"libreoffice-i18n-kab" "Kabyle" OFF \
"libreoffice-i18n-kk" "Kazakh" OFF \
"libreoffice-i18n-km" "Khmer" OFF \
"libreoffice-i18n-kmr-Latn" "Kurdish (Latin)" OFF \
"libreoffice-i18n-kn" "Kannada" OFF \
"libreoffice-i18n-ko" "Korean" OFF \
"libreoffice-i18n-kok" "Konkani" OFF \
"libreoffice-i18n-ks" "Kashmiri" OFF \
"libreoffice-i18n-lb" "Luxembourgish" OFF \
"libreoffice-i18n-lo" "Lao" OFF \
"libreoffice-i18n-lt" "Lithuanian" OFF \
"libreoffice-i18n-lv" "Latvian" OFF \
"libreoffice-i18n-mai" "Maithili" OFF \
"libreoffice-i18n-mk" "Macedonian" OFF \
"libreoffice-i18n-ml" "Malayalam" OFF \
"libreoffice-i18n-mn" "Mongolian" OFF \
"libreoffice-i18n-mni" "Manipuri" OFF \
"libreoffice-i18n-mr" "Marathi" OFF \
"libreoffice-i18n-my" "Burmese" OFF \
"libreoffice-i18n-nb" "Norwegian (Bokmål)" OFF \
"libreoffice-i18n-ne" "Nepali" OFF \
"libreoffice-i18n-nl" "Dutch" OFF \
"libreoffice-i18n-nn" "Nynorsk" OFF \
"libreoffice-i18n-nr" "Ndebele" OFF \
"libreoffice-i18n-nso" "Northern Sotho" OFF \
"libreoffice-i18n-oc" "Occitan" OFF \
"libreoffice-i18n-om" "Oromo" OFF \
"libreoffice-i18n-or" "Oriya" OFF \
"libreoffice-i18n-pa-IN" "Punjabi (India)" OFF \
"libreoffice-i18n-pl" "Polish" OFF \
"libreoffice-i18n-pt" "Portuguese" OFF \
"libreoffice-i18n-pt-BR" "Portuguese (Brazil)" OFF \
"libreoffice-i18n-ro" "Romanian" OFF \
"libreoffice-i18n-ru" "Russian" OFF \
"libreoffice-i18n-rw" "Kinyarwanda" OFF \
"libreoffice-i18n-sa-IN" "Sanskrit" OFF \
"libreoffice-i18n-sat" "Santali" OFF \
"libreoffice-i18n-sat-Olck" "Santali (Ol Chiki)" OFF \
"libreoffice-i18n-sd" "Sindhi" OFF \
"libreoffice-i18n-si" "Sinhala" OFF \
"libreoffice-i18n-sid" "Sidamo" OFF \
"libreoffice-i18n-sk" "Slovak" OFF \
"libreoffice-i18n-sl" "Slovenian" OFF \
"libreoffice-i18n-sq" "Albanian" OFF \
"libreoffice-i18n-sr" "Serbian" OFF \
"libreoffice-i18n-sr-Latn" "Serbian (Latin)" OFF \
"libreoffice-i18n-ss" "Swati" OFF \
"libreoffice-i18n-st" "Southern Sotho" OFF \
"libreoffice-i18n-sv" "Swedish" OFF \
"libreoffice-i18n-sw-TZ" "Swahili (Tanzania)" OFF \
"libreoffice-i18n-szl" "Silesian" OFF \
"libreoffice-i18n-ta" "Tamil" OFF \
"libreoffice-i18n-te" "Telugu" OFF \
"libreoffice-i18n-tg" "Tajik" OFF \
"libreoffice-i18n-th" "Thai" OFF \
"libreoffice-i18n-tl" "Tagalog" OFF \
"libreoffice-i18n-tn" "Tswana" OFF \
"libreoffice-i18n-tr" "Turkish" OFF \
"libreoffice-i18n-ts" "Tsonga" OFF \
"libreoffice-i18n-tt" "Tatar" OFF \
"libreoffice-i18n-ug" "Uyghur" OFF \
"libreoffice-i18n-uk" "Ukrainian" OFF \
"libreoffice-i18n-uz" "Uzbek" OFF \
"libreoffice-i18n-ve" "Venda" OFF \
"libreoffice-i18n-vec" "Venetian" OFF \
"libreoffice-i18n-vi" "Vietnamese" OFF \
"libreoffice-i18n-xh" "Xhosa" OFF \
"libreoffice-i18n-zh-CN" "Chinese (Simplified)" OFF \
"libreoffice-i18n-zh-TW" "Chinese (Traditional)" OFF \
"libreoffice-i18n-zu" "Zulu" OFF \
3>&1 1>&2 2>&3)

# Handle cancel
if [ $? -ne 0 ]; then
    exit 0
fi

#============================ Process Selection ============================
# Remove quotes from output
PACKAGES=$(echo "$CHOICES" | tr -d '"')

# If nothing selected
if [ -z "$PACKAGES" ]; then
    whiptail --msgbox "No language packs selected." "$HEIGHT" "$WIDTH"
    exit 0
fi

#============================ Install ============================
if whiptail --yesno "Install selected language packs?" "$HEIGHT" "$WIDTH"; then
    if sudo xbps-install -y $PACKAGES; then
        whiptail --msgbox "Language packs installed successfully!" "$HEIGHT" "$WIDTH"
    else
        whiptail --msgbox "Error installing language packs." "$HEIGHT" "$WIDTH"
    fi
else
    whiptail --msgbox "Installation cancelled." "$HEIGHT" "$WIDTH"
fi

exit 0

