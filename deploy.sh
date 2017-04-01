# Validation
# http://stackoverflow.com/a/699613
if [ "$#" -ne 1 ];
then
  echo "1 argument required, $# provided" && exit 1
else
  # Branch: Hugo
  git add .            &&
  git commit -m "$1"   &&
  git push origin hugo &&

  # Branch: Master
  cd public              &&
  git add .              &&
  git commit -m "$1"     &&
  git push origin master &&
  cd ..
fi
