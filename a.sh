#!/bin/sh

sed -e 's@prepare() {@ceras_prepare() {@g' -i $(ugrep -rnw . -lie "prepare\(\) \{$.*")
sed -e 's@configure() {@ceras_configure() {@g' -i $(ugrep -rnw . -lie "configure\(\) \{$.*")
sed -e 's@build() {@ceras_build() {@g' -i $(ugrep -rnw . -lie "build\(\) \{$.*")
sed -e 's@check() {@ceras_check() {@g' -i $(ugrep -rnw . -lie "check\(\) \{$.*")
sed -e 's@install() {@ceras_install() {@g' -i $(ugrep -rnw . -lie "install\(\) \{$.*")
