#!/usr/bin/env bash

set -o noclobber -o noglob -o nounset -o pipefail

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
        chafa --fill=block --symbols=block -c 256 --size "${W}x${H}" "$image" 2>/dev/null
    fi
}

display_image_cache() {
    display_image "$IMAGE_CACHE_PATH"
}

cache_if_needed_and_display_image() {
    local image="$1"
    local image_width
    image_width="$(identify -format '%w' "$image")"
    if (( "$image_width" < "$MAX_IMAGE_WIDTH" )); then
        display_image "$image"
    else
        convert -geometry "$MAX_IMAGE_WIDTH"x -- "${image}" "${IMAGE_CACHE_PATH}" && display_image_cache
    fi
}

LF_CACHE="$HOME/.cache/lf_images"
[[ -d "$LF_CACHE" ]] || mkdir -p "$LF_CACHE"

# Use hash of absolute path and compare change time
IMAGE_CACHE_PATH="$LF_CACHE/$(echo "$FILE_PATH" | sha1sum | cut -f1 -d' ').jpg"

if [[ -f "$IMAGE_CACHE_PATH" ]]; then
    if [[ $(stat -c '%Y' "$FILE_PATH") -lt $(stat -c '%Y' "$IMAGE_CACHE_PATH") ]]; then
        display_image_cache && exit 1
    else
        rm "$IMAGE_CACHE_PATH"
    fi
fi

handle_mime() {
    local mimetype
    mimetype="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"
    case "${mimetype}" in
        ## HTML
        text/html)
            # Preview as text conversion
            tout w3m -dump "${FILE_PATH}" && exit 1
            exit 1;;

        ## Text
        text/* | */xml | application/json | application/javascript)
            # Syntax highlight
            highlight --out-format=ansi "${FILE_PATH}" && exit 1
            cat "${FILE_PATH}" && exit 1
            exit 1;;

        ## PDF
        application/pdf)
            pdftoppm -f 1 -l 1 \
                -singlefile \
                -jpeg -tiffcompression jpeg \
                -- "${FILE_PATH}" "${IMAGE_CACHE_PATH}" &&
            mv "${IMAGE_CACHE_PATH}.jpg" "${IMAGE_CACHE_PATH}" &&
            cache_if_needed_and_display_image "$IMAGE_CACHE_PATH"
            exit 1;;

        ## SVG
        image/svg+xml|image/svg)
            convert -- "${FILE_PATH}" "${IMAGE_CACHE_PATH}" && display_image_cache
            exit 1;;

        ## Image
        image/x-xcf)
            handle_fallback
            # shellcheck disable=SC2317
            exit 1;;

        image/*)
            cache_if_needed_and_display_image "$FILE_PATH"
            exit 1;;

        ## Video
        video/*)
            # Get embedded thumbnail
            ffmpeg -i "${FILE_PATH}" -map 0:v -map -0:V -c copy "${IMAGE_CACHE_PATH}" && cache_if_needed_and_display_image "$IMAGE_CACHE_PATH" && exit 1

            # Get frame 10% into video
            local video_width
            local target_width
            video_width=$(ffprobe -v error -show_entries stream=width -of default=nw=1:nk=1 "${FILE_PATH}" | head -n1)
            target_width=$((video_width>MAX_IMAGE_WIDTH ? MAX_IMAGE_WIDTH : video_width))
            ffmpegthumbnailer -i "${FILE_PATH}" -o "${IMAGE_CACHE_PATH}" -s ${target_width} && display_image_cache && exit 1
            exit 1;;

        ## Audio
        audio/*)
            preview_audio
            exit 1;;

        ## OpenDocument
        application/vnd.oasis.opendocument*)
            # Preview as text conversion
            tout odt2txt "${FILE_PATH}"
            exit 1;;

        ## Archives
        application/zip)
            tout zipinfo -1 -- "${FILE_PATH}" && exit 1
            exit 1;;

        application/x-tar|application/gzip|application/zstd)
            tout tar -tf "${FILE_PATH}" && exit 1
            exit 1;;

        application/x-7z-compressed)
            # Avoid password prompt by providing empty password
            tout 7zz l -ba -p -- "${FILE_PATH}" | awk '{$1=$2=$3=$4=$5=""; print $0}' | grep -o '\S.*'
            exit 1;;

        application/vnd.rar|application/x-rar)
            # Avoid password prompt by providing empty password
            tout unrar lb -p- -- "${FILE_PATH}"
            exit 1;;

        ## Epub
        application/epub+zip)
            tout gnome-epub-thumbnailer --size '512' "$FILE_PATH" "$IMAGE_CACHE_PATH" \
                && cache_if_needed_and_display_image "$IMAGE_CACHE_PATH" && exit 1
            exit 1;;
    esac
}

handle_extension() {
    case "$FILE_PATH" in
        *.mp3)
            # Sometimes mp3 files are not recognized for some reason
            preview_audio
            exit 1;;

        *.stl|*.obj)
            f3d --quiet --ambient-occlusion --up +Z --output "$IMAGE_CACHE_PATH" "$FILE_PATH" && display_image_cache
            exit 1;;
    esac
}

handle_fallback() {
    echo '----- File Type Classification -----' && file --dereference --brief -- "${FILE_PATH}"
    exit 1
}

preview_audio() {
    # Get embedded thumbnail
    ffmpeg -i "${FILE_PATH}" -map 0:v -map -0:V -c copy \
      "${IMAGE_CACHE_PATH}" && cache_if_needed_and_display_image "$IMAGE_CACHE_PATH" && exit 1

    # Get conver.png (or other formats) image
    local directory
    directory="$(dirname "$FILE_PATH")"
    for file in "cover.png" "cover.jpg"; do
        local cover_image_path="${directory}/${file}"
        [[ -f "$cover_image_path" ]] && cache_if_needed_and_display_image "$cover_image_path" && exit 1
    done
}

handle_extension
handle_mime
handle_fallback
