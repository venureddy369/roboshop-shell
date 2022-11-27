STAT(){

  if [ $1 -eq 0 ]; then
    echo -e "\e[1;32mSUCCESS\e[0m"
  else
      echo -e "\e[33mFailure\e[0m"
      exit
  fi
}

PRINT(){

  echo -e "\e[31m$1\e[0m"
}