# help2man
## Configure
help2man is built before gettext-tiny, so `--disable-nls` isn't actually needed
(examine config.log and notice `ac_cv_enable_nls='no'` even without adding
`--disable-nl`).
