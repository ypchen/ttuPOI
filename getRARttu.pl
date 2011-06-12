#!/usr/bin/perl -w

$curlUserAgent="Mozilla/4.0";
$fileCookieTXT="ttuCookie.txt";
$filePOIUrlsTXT="ttuPOIUrls.txt";

$dirRar="POI";

$rarCount = 0;

system("rm -rf $dirRar");
system("mkdir $dirRar");

open(filePOIUrlsTXT) or die("Could not open $filePOIUrlsTXT");
foreach $line (<filePOIUrlsTXT>) {
    chomp($line);              # remove the newline from $line.
    # do line-by-line processing.
	$rarCount ++;
	printf "[%04d] %s\n", $rarCount, $line;

	$fileRar = sprintf("poi-%04d.rar", $rarCount);
	system("rm -f $fileRar");
	system("curl --silent --user-agent \"$curlUserAgent\" --cookie \"$fileCookieTXT\" --output \"$fileRar\" \"$line\"");
#	system("curl --verbose --dump-head - --user-agent \"$curlUserAgent\" --cookie \"$fileCookieTXT\" --output \"$fileRar\" \"$line\"");
	system("UnRar.exe e -y \"$fileRar\" \"$dirRar\"");
}
