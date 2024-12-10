for x in *.pdf; do
  # Check file extension and process accordingly
  if [[ $x == *.pdf ]]; then
    words=$(ps2ascii "$x" | wc -w)
  elif [[ $x == *.docx ]]; then
    words=$(docx2txt "$x" - | wc -w)
  fi
 
  breach="${x%%/*}" # Extract the directory name
  # Extract numeric part from filename
  number_part=$(echo "$x" | sed -n 's/.*Participant_\([0-9]*\)_assignsubmission_file.*/\1/p')
  echo "$x, $breach, $number_part, $words"
done