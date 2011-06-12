#!/usr/bin/tcsh -f

#
# This is the file containing your username and password for TomTomUsers
# It consists of the following three lines:
#
# Line 1: #!/usr/bin/tcsh -f
# Line 2: set username=YOUR_USERNAME
# Line 3: set password=YOUR_PASSWORD
#
set fileUserPass="yourUserPass.csh"

# Get the username and password from the file
source "$fileUserPass"

set urlLogin="http://www.tomtomusers.com/dis/member.php?mod=logging&action=login&loginsubmit=yes&infloat=yes&lssubmit=yes&username=${username}&password=${password}"
set urlPOIList="http://www.tomtomusers.com/dis/forum.php?mod=viewthread&tid=1580&fromuid=1"

set fileCookieTXT="ttuCookie.txt"
set filePOIListHTML="ttuPOIList.html"
set filePOIUrlsTXT="ttuPOIUrls.txt"

set curlUserAgent='Mozilla/4.0'

echo Clean all temporary files
echo rm -f $fileCookieTXT
rm -f $fileCookieTXT
echo rm -f $filePOIListHTML
rm -f $filePOIListHTML
echo rm -f $filePOIUrlsTXT
rm -f $filePOIUrlsTXT
rm -f *.rar

echo curl --verbose --user-agent "$curlUserAgent" --cookie-jar "$fileCookieTXT" "$urlLogin"
curl --verbose --user-agent "$curlUserAgent" --cookie-jar "$fileCookieTXT" "$urlLogin"

echo curl --verbose --user-agent "$curlUserAgent" --cookie "$fileCookieTXT" --output "$filePOIListHTML" "$urlPOIList"
curl --verbose --user-agent "$curlUserAgent" --cookie "$fileCookieTXT" --output "$filePOIListHTML" "$urlPOIList"

echo Extract urls...
cat $filePOIListHTML | sed --expression="/comment_22659/,/<\/html>/d" | ./list_url.sed | grep 'http://www.tomtomusers.com/dis/forum.php?mod=attachment&aid=' | sort --unique > $filePOIUrlsTXT

echo Downloading RARs...
./getRARttu.pl

echo Clean all temporary files
echo rm -f $fileCookieTXT
rm -f $fileCookieTXT
echo rm -f $filePOIListHTML
rm -f $filePOIListHTML
echo rm -f $filePOIUrlsTXT
rm -f $filePOIUrlsTXT
rm -f *.rar
