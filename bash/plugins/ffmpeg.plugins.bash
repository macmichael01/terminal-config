#!/usr/bin/env bash

# Valid video files to scan for.
export MUX_EXT=(flv avi mkv 3gp ogv m4v f4v mov mpeg mpg ts m2ts vob mp4)
# Video output container.
export MUX_TO="mp4"
# Video finder string
export MUX_FIND_STR="$(printf " -or -iname '*.%s'" ${MUX_EXT[@]})"
export MUX_FIND="find . -type f ! -iname '.*'"
# Find command string
export MUX_FIND="$MUX_FIND ${MUX_FIND_STR:4}"


function muxvideos_usage() {
  echo
  echo -e " ${echo_bold_blue}Video Muxer Help${echo_reset_color}${echo_normal}"
  echo -e "  Convenience method for processing an entire directory and"
  echo -e "  any sub-directories containing videos."
  echo
  echo -e "  By default the first audio and video tracks are demuxed from the"
  echo -e "  originating container and remuxed into the destination container."
  echo
  echo -e "  Note: The destination container must support audio and video codecs"
  echo -e "  that rea being provided or ffmpeg will fail and move onto the next file."
  echo
  echo -e " ${echo_bold_yellow}${echo_underline_yellow}Args${echo_reset_color}${echo_normal}:"
  echo -e "  -h  Help"
  echo -e "  -a  Audio track(s); Accepts a 0-based track index number or"
  echo -e "      specific range from 0-N in the form of 0:a:N"
  echo -e "  -v  Video track(s); accepts a 0-based track index number or"
  echo -e "      specific range from 0-N in the form of 0:v:N"
  echo -e "  -l  Log the output to a file."
  echo -e "  -c  Log the output to the console."
  echo
  echo -e " ${echo_bold_yellow}${echo_underline_yellow}Usage:${echo_reset_color}${echo_normal}"
  echo -e "  muxvideos -a 1:a:2 -v 0:v:0 -lc "
  echo -e "  muxvideos -a 1 -v 0"
  echo -e "  muxvideos"
  echo
}

function muxvideos() {
  command -v ffmpeg >/dev/null 2>&1 || { echo -e "${echo_bold_red}FFMPEG is required. Aborting.${echo_reset_color}" >&2; return; }
  OPTIND=1 # Reset
  mux_logall=""
  mux_console=""
  mux_audio="0:a:0"
  mux_video="0:v:0"

  while getopts "ha:v:lc" opt; do
  case "$opt" in
    h)
      muxvideos_usage
      return
      ;;
    a)
      # Audio track number(s)
      mux_audio=${OPTARG}
      if [[ "${mux_audio}" =~ ^[0-9]+$ ]]; then
        mux_audio="0:a:${mux_audio}"
      fi
      ;;
    v)
      # Video track number(s)
      mux_video=${OPTARG}
      if [[ "${mux_video}" =~ ^[0-9]+$ ]]; then
        mux_video="0:v:${mux_video}"
      fi
      ;;
    l)
      # Log console output to a file
      mux_logall="-l"
      ;;
    c)
      # Show console output
      mux_console="-c"
      ;;
  esac
  done
  shift $((OPTIND-1))
  echo -e "\n${echo_bold_blue}Starting Video Conversion: ${echo_reset_color}\n"
  eval "${MUX_FIND}" | while read mux_file ;
  do
    eval "$(printf "muxvideo -a ${mux_audio} -v  ${mux_video} ${mux_console} ${mux_logall} '${mux_file}'")"
  done
  echo -e "\n${echo_bold_green}Video Conversion Finished! ${echo_reset_color}\n"
}


function muxvideo_usage() {
  echo
  echo -e " ${echo_bold_blue}Muxvideos Help${echo_reset_color}${echo_normal}"
  echo -e "  Convenience method for the FFMPEG CLI"
  echo -e "  By default the first audio and video tracks are demuxed from the"
  echo -e "  originating container and remuxed into the destination container."
  echo
  echo -e "  Note: The destination container must support audio and video codecs"
  echo -e "  that rea being provided or ffmpeg will fail."
  echo
  echo -e " ${echo_bold_yellow}${echo_underline_yellow}Args${echo_reset_color}${echo_normal}:"
  echo -e "  -h  Help"
  echo -e "  -a  Audio track(s); Accepts a 0-based track index number or"
  echo -e "      specific range from 0-N in the form of 0:a:N"
  echo -e "  -v  Video track(s); accepts a 0-based track index number or"
  echo -e "      specific range from 0-N in the form of 0:v:N"
  echo -e "  -l  Log the output to a file."
  echo -e "  -c  Log the output to the console."
  echo
  echo -e " ${echo_underline_white}Note${echo_normal}: Copying subtitles is not supported at this time."
  echo
  echo -e " ${echo_bold_yellow}${echo_underline_yellow}Usage:${echo_reset_color}${echo_normal}"
  echo -e "  muxvideo -a 1:a:2 -v 0:v:0 -lc PATH_TO_FILE"
  echo -e "  muxvideo -a 1 -v 0 PATH_TO_FILE"
  echo -e "  muxvideo -a 1 PATH_TO_FILE"
  echo -e "  muxvideo PATH_TO_FILE"
  echo
}

function muxvideo() {
  command -v ffmpeg >/dev/null 2>&1 || { echo -e "${echo_bold_red}FFMPEG is required. Aborting.${echo_reset_color}" >&2; return; }
  FFREPORT=""
  OPTIND=1 # Reset
  mux_log=0
  mux_verbose="2>/dev/null"
  mux_report=""
  mux_audio="0:a:0"
  mux_video="0:v:0"

  while getopts "ha:v:lc" opt; do
  case "$opt" in
    h)
      muxvideo_usage
      return
      ;;
    a)
      # Audio track number(s)
      mux_audio=${OPTARG}
      if [[ "${mux_audio}" =~ ^[0-9]+$ ]]; then
        mux_audio="0:a:${mux_audio}"
      fi
      ;;
    v)
      # Video track number(s)
      mux_video=${OPTARG}
      if [[ "${mux_video}" =~ ^[0-9]+$ ]]; then
        mux_video="0:v:${mux_video}"
      fi
      ;;
    l)
      # Log ffmpeg results to a file.
      mux_log=1
      mux_report="-report"
      ;;
    c)
      # Show console output
      mux_verbose=""
      ;;
    esac
  done
  shift $((OPTIND-1))

  if [[ -z "$@" ]]; then
    echo -e "  ${echo_bold_red}File path not provided${echo_reset_color}"
    return
  fi

  # Get the file path, name, & extension
  mux_filepath=$@
  mux_filename="${mux_filepath%.*}"
  mux_extension="${mux_filepath##*.}"

  if [ "$mux_extension" == "$MUX_TO" ]; then
    return
  fi
  # Validate that the file exists.
  if [ -z "$mux_filepath" ]; then
    echo -e "  ${echo_bold_red}File does not exist${echo_reset_color}"
    return
  fi

  # Track validation. Make sure tracks are in the form of 0:a:1 and 0:v:1
  if ! [[ "${mux_video}" =~ ^[0-9:v]+$ ]] || ! [[ "${mux_audio}" =~ ^[0-9:a]+$ ]]; then
    echo -e "  ${echo_bold_red}Invalid audio or video track(s)${echo_reset_color}"
    return
  fi

  if [[ "${mux_log}" -eq 1 ]]; then
    FFREPORT=file=./${filename}-$(date +%h.%m.%s).log
  fi
  echo -e "  ${echo_bold_cyan}${mux_filepath} ${echo_reset_color}==>${echo_bold_cyan} ${mux_filename}.${MUX_TO}${echo_reset_color}"
  eval 'ffmpeg -i "${mux_filepath}" -acodec copy -vcodec copy -map ${mux_video} -map ${mux_audio} "${mux_filename}.${MUX_TO}" -nostdin ${mux_report} ${mux_verbose}'
}
