#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
temp=$(mktemp -d)
trap 'rm -rf "$temp"' EXIT
git init -q "$temp/upstream"
git -C "$temp/upstream" fetch -q --depth=1 https://github.com/Endcord/endcord-mobile.git d95c4e8cda229deb5a401dc8a5c079a8c79ce09a
mkdir "$temp/source"
git -C "$temp/upstream" archive FETCH_HEAD android bundle LICENSE UPSTREAM.md | tar -xf - -C "$temp/source"
cat "$root"/native-source/part-* | base64 --decode > "$temp/native.patch.gz"
printf '%s  %s\n' 9d47779a356ea654573e92cf170badcf8477fa80161a88c29454712a599ebc4a "$temp/native.patch.gz" | sha256sum --check
(cd "$temp/source" && gzip -dc "$temp/native.patch.gz" | git apply --binary --whitespace=nowarn)
for path in android bundle ANDROID-UPSTREAM.md ANDROID-UPSTREAM-LICENSE; do
    test ! -e "$root/$path" || { echo "Already exists: $path" >&2; exit 1; }
done
mv "$temp/source"/{android,bundle,ANDROID-UPSTREAM.md,ANDROID-UPSTREAM-LICENSE} "$root/"
