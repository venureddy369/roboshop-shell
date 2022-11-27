STAT(){

  if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
      echo Failure
      exit
  fi
}

PRINT(){

  echo -e "\e[31m$1\e[0m"
}