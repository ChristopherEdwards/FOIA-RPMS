LRHYPOST ;VA/DALOI/HOAK - UNIVERSAL EDITOR 12/01/1999 ; 13-Aug-2013 09:16 ; MKK
 ;;5.2;LAB SERVICE;**405,1033**;NOV 01, 1997
 ;
PROX ;
 ; This block sets the Howdy Bot user in the New Person file.
 ; D CREATE^XUSAP("HOWDY,BOT","l","LRHY HOWDY BOT","LRHY HOWDY BOT") ; IHS/OIT/MKK - IHS will NOT use HOWDY
 ;
POST ; KIDS Post install for LR*5.2*405
 ;
 N XQA,XQAMSG,MSG
 S XQAMSG="Installation of patch LR*5.2*405"
 S XQAMSG=XQAMSG_" completed on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 ; D SETUP^XQALERT
 D BMES^XPDUTL($$CJ^XLFSTR(XQAMSG,80))
 ;
 S MSG="Sending install completion alert to mail group G.LMI"
 ; D BMES^XPDUTL($$CJ^XLFSTR(MSG,80))
 K MSG
 ;
 ;
 QUIT
