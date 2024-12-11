#!/usr/bin/env bash

set +e -u -o noclobber -o noglob -o nounset -o pipefail

FILE_PATH="$(realpath "$1")"
W=$2
H=$3
X=$4
Y=$5

MAX_IMAGE_WIDTH=1280

tout() {
    timeout 2 "$@"
}

display_image() {
    local image="$1"
    if [[ "$TERM" =~ .*kitty.* ]]; then
        kitten icat --silent --stdin no --transfer-mode memory --place "${W}x${H}@${X}x${Y}" "$image" < /dev/null > /dev/tty
    else
        chafa -c full --size "${W}x${H}" "$image" 2>/dev/null
    fi
}

display_image_cache() {
    display_image "$FILE_CACHE_PATH"
}

cache_and_display_image() {
    local image="$1"

    magick "${image}" -geometry "$MAX_IMAGE_WIDTH"x\> "jpg:${FILE_CACHE_PATH}" && display_image_cache
}

display_text_cache() {
    cat "$FILE_CACHE_PATH"
}

cache_and_display_text() {
    head -n 80 | cut -c -1000 | iconv -c | tee "$FILE_CACHE_PATH"
}

LF_CACHE="$HOME/.cache/lf_previews"
[[ -d "$LF_CACHE" ]] || mkdir -p "$LF_CACHE"

# Use hash of absolute path and compare change time
FILE_PATH_HASH="$(echo "$FILE_PATH" | sha1sum | cut -f1 -d' ')"
FILE_CACHE_PATH="$LF_CACHE/$FILE_PATH_HASH"

if [[ -f "$FILE_CACHE_PATH" ]]; then
    if [[ $(stat -c '%Y' "$FILE_PATH") -lt $(stat -c '%Y' "$FILE_CACHE_PATH") ]] && [[ -s "$FILE_CACHE_PATH" ]]; then
        mimetype="$(file --dereference --brief --mime-type -- "${FILE_CACHE_PATH}")"
        case "$mimetype" in
            image/*)
                display_image_cache && exit 1
                ;;
            *)
                display_text_cache && exit 1
                ;;
        esac
    else
        rm "$FILE_CACHE_PATH"
    fi
fi

[[ -d "$LF_CACHE/tmp" ]] || mkdir "$LF_CACHE/tmp"
FILE_TMP_PATH="$LF_CACHE/tmp/$FILE_PATH_HASH"

handle_mime() {
    local mimetype
    mimetype="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"
    case "${mimetype}" in
        ## Text
        text/* | */xml | application/json | application/x-ndjson | application/javascript)
            # Syntax highlight
            highlight --out-format=ansi --line-length=400 "${FILE_PATH}" | cache_and_display_text && exit 1
            cache_and_display_text < "$FILE_PATH" && exit 1
            exit 1;;

        ## PDF
        application/pdf)
            pdftoppm -f 1 -l 1 \
                -singlefile \
                -jpeg -tiffcompression jpeg \
                -- "${FILE_PATH}" "${FILE_TMP_PATH}" &&
            cache_and_display_image "${FILE_TMP_PATH}.jpg" &&
            rm "${FILE_TMP_PATH}.jpg"
            exit 1;;

        ## SVG
        image/svg+xml|image/svg)
            cache_and_display_image "${FILE_PATH}"
            exit 1;;

        ## Image
        image/x-xcf)
            handle_fallback
            # shellcheck disable=SC2317
            exit 1;;

        image/*)
            cache_and_display_image "$FILE_PATH"
            exit 1;;

        ## Video
        video/*)
            preview_embedded_thumbnail_video_audio
            exit 1;;

        ## Audio
        audio/*)
            preview_audio
            ;;

        ## OpenDocument
        application/vnd.oasis.opendocument*)
            # Preview as text conversion
            tout odt2txt "${FILE_PATH}"
            exit 1;;

        ## Archives
        application/zip)
            tout zipinfo -1 -- "${FILE_PATH}" | cache_and_display_text && exit 1
            exit 1;;

        application/x-tar|application/gzip|application/zstd)
            tout tar -tf "${FILE_PATH}" | cache_and_display_text && exit 1
            exit 1;;

        application/x-7z-compressed)
            # Avoid password prompt by providing empty password
            tout 7zz l -ba -p -- "${FILE_PATH}" | awk '{$1=$2=$3=$4=$5=""; print $0}' | grep -o '\S.*' | cache_and_display_text
            exit 1;;

        application/vnd.rar|application/x-rar)
            # Avoid password prompt by providing empty password
            tout unrar lb -p- -- "${FILE_PATH}" | cache_and_display_text
            exit 1;;

        ## Epub
        application/epub+zip)
            tout gnome-epub-thumbnailer --size "$MAX_IMAGE_WIDTH" "$FILE_PATH" "$FILE_TMP_PATH.jpg" \
                && mv "$FILE_TMP_PATH.jpg" "$FILE_CACHE_PATH" \
                && display_image_cache && exit 1
            exit 1;;
    esac
}

handle_extension() {
    case "$FILE_PATH" in
        *.mp3)
            # Sometimes mp3 files are not recognized for some reason
            preview_audio
            ;;

        *.stl|*.obj)
            f3d --quiet --ambient-occlusion --up +Z --output "$FILE_CACHE_PATH" "$FILE_PATH" && display_image_cache
            exit 1;;
    esac
}

handle_fallback() {
    { echo '----- File Type Classification -----' && file --dereference --brief -- "${FILE_PATH}"; } | cache_and_display_text
    exit 1
}

preview_embedded_thumbnail_video_audio() {
    local video_width
    local target_width
    video_width=$(ffprobe -v error -show_entries stream=width -of default=nw=1:nk=1 -select_streams v "${FILE_PATH}" | head -n1)
    target_width=$((video_width>MAX_IMAGE_WIDTH ? MAX_IMAGE_WIDTH : video_width))
    ffmpegthumbnailer -i "${FILE_PATH}" -o "${FILE_CACHE_PATH}" -s "$target_width" -m -c jpeg && display_image_cache && exit 1
}

preview_audio() {
    preview_embedded_thumbnail_video_audio

    # Get conver.png (or other formats) image
    local directory
    directory="$(dirname "$FILE_PATH")"
    for file in "cover.png" "cover.jpg" "cover.avif" "cover.jxl" "cover.webp"; do
        local cover_image_path="${directory}/${file}"
        [[ -f "$cover_image_path" ]] && cache_and_display_image "$cover_image_path" && exit 1
    done
}

handle_extension
handle_mime
handle_fallback
