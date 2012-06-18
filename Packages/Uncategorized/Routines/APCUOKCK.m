APCUOKCK ; TEST KEYWORD ADD ; [ 04/15/86  12:51 PM ]
ERR W !! S $ZT="ERR^CQC"
 F Q=0:0 R "KEYWORD TO LOOK FOR: ",KW,! Q:KW=""  D KCHECK
 W "Bye.",!
 K  Q
KCHECK ;
 I '$D(^ICD9("C",KW)) W *7,"-- NOT FOUND.",! Q
 S ME="" F Q=0:0 S ME=$O(^ICD9("C",KW,ME)) Q:ME=""  D ME
 Q
ME W "MAIN ENTRY (",ME,"): ",$P(^ICD9(ME,0),"^",1)," ",$P(^(0),"^",3),!
 W ?20,^(1),!
 S SE="" F Q=0:0 S SE=$O(^ICD9("C",KW,ME,SE)) Q:SE=""  D SE
 Q
SE W " SUBENTRY (",SE,"): ",^ICD9(ME,9999999.21,SE,0),!
 Q
