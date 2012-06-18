ASUMYDPS ; IHS/ITSC/LMH -UPDATE YTD ISSUE DATA MASTER ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine updates the YTD Issue Data Master file with information
 ;from both Stock and Direct Issues as they are posted.
 N Q S Q=$S(ASUT(ASUT,"PT","REQ")?8N:ASUT(ASUT,"PT","REQ"),1:ASUT(ASUT,"USR"))
 D REQ^ASUMYDIO(.Q) ;Lookup REQ in YTD Issue Data master
 I Y<1 D  Q:DDSERROR
 .S DDSERROR=0 I Y=0 D
 ..D ADDREQ^ASUMYDIO(ASUMY("E#","REQ")) ;Add Requsitioner to YTD Issue Data master
 ..I Y<0 D
 ...N Z S Z="Error adding Requsitioner : "_ASUT(ASUT,"USR")_" to YTD DATA : "_Y W *7 D MSG^ASUJHELP(.Z) S DDSERROR=1 ;DFM P1 9/1/98
 .E  D
 ..N Z S Z="Error finding Requsitioner : "_ASUT(ASUT,"USR")_" for YTD DATA : "_Y W *7 D MSG^ASUJHELP(.Z) S DDSERROR=2 ;DFM P1 9/1/98
 I ASUT("TRCD")="5B" Q
 N S S S=$S(ASUT(ASUT,"PT","SSA")?5N:ASUT(ASUT,"PT","SSA"),1:ASUT(ASUT,"SSA"))
 D SSA^ASUMYDIO(.S) ;Lookup SSA in YTD Issue Data master
 S DDSERROR=0 I Y<1 D  Q:DDSERROR
 .I Y=0 D
 ..D ADDSSA^ASUMYDIO(ASUMY("E#","SSA")) ;Add SSA to YTD Issue Data master
 ..I Y<0 D
 ...N Z S Z="ASUYUPD err adding SSA : "_ASUT(ASUT,"SSA")_" to YTD DATA : "_Y W *7 D MSG^ASUJHELP(.Z) S DDSERROR=3 ;DFM P1 9/1/98
 .E  D
 ..N Z S Z="ASUYUPD err finding SSA : "_ASUT(ASUT,"SSA")_" for YTD DATA : "_Y W *7 D MSG^ASUJHELP(.Z) S DDSERROR=4 ;DFM P1 9/1/98
 I $G(ASUMX("ACC"))="" S ASUMX("ACC")=ASUT(ASUT,"ACC")
 D ACC^ASUMYDIO(ASUT(ASUT,"ACC")) ;Lookup ACCT in YTD Issue Data master
 S DDSERROR=0 I Y<1 D  Q:DDSERROR
 .I Y=0 D
 ..D ADDACC^ASUMYDIO(ASUMY("E#","ACC")) ;Add ACC to YTD Issue Data master
 ..I Y<0 D
 ...N Z S Z="ASUYUPD err adding Account : "_ASUT(ASUT,"ACC")_" to YTD DATA : "_Y W *7 D MSG^ASUJHELP(.Z) S DDSERROR=5 ;DFM P1 9/1/98
 .E  D
 ..N Z S Z="ASUYUPD err finding Account : "_ASUT(ASUT,"ACC")_" for YTD DATA : "_Y W *7 D MSG^ASUJHELP(.Z) S DDSERROR=6 ;DFM P1 9/1/98
 D READ^ASUMYDIO ;Read YTD Issue Data master into variables
 I $E(ASUT("TRCD"))=3 D
 .S:'$D(ASUV("VOU")) ASUV("VOU")=""
 .I ASUL(11,"TRN","REV") D
 ..I ASUT("TRCD")="3K" D
 ...S ASUMY("CMO","RCR","VAL")=$G(ASUMY("CMO","RCR","VAL"))-(ASUT(ASUT,"VAL"))
 ...S ASUMY("YTD","RCR","VAL")=$G(ASUMY("YTD","RCR","VAL"))-(ASUT(ASUT,"VAL"))
 ..I ASUT("TRCD")="3L" D
 ...S ASUMY("YTD","NRC","VAL")=$G(ASUMY("YTD","NRC","VAL"))-(ASUT(ASUT,"VAL"))
 ..I ASUT("TRCD")'="3K" Q
 ..I ASUT(ASUT,"REQ TYP")=1 S ASUMY("CMO","SCH","LI")=$G(ASUMY("CMO","SCH","LI"))-1,ASUMY("YTD","SCH","LI")=$G(ASUMY("YTD","SCH","LI"))-1
 ..I ASUT(ASUT,"REQ TYP")=2 S ASUMY("CMO","USC","LI")=$G(ASUMY("CMO","USC","LI"))-1,ASUMY("YTD","USC","LI")=$G(ASUMY("YTD","USC","LI"))-1
 .E  D
 ..I ASUT("TRCD")=32!(ASUT("TRCD")=31) D
 ...S ASUMY("CMO","RCR","VAL")=$G(ASUMY("CMO","RCR","VAL"))+(ASUT(ASUT,"VAL"))
 ...S ASUMY("YTD","RCR","VAL")=$G(ASUMY("YTD","RCR","VAL"))+(ASUT(ASUT,"VAL"))
 ..I ASUT("TRCD")=33 D
 ...S ASUMY("YTD","NRC","VAL")=$G(ASUMY("YTD","NRC","VAL"))+(ASUT(ASUT,"VAL"))
 ..I ASUT("TRCD")'=32 Q
 ..I ASUT(ASUT,"REQ TYP")=1 D
 ...S ASUMY("CMO","SCH","LI")=$G(ASUMY("CMO","SCH","LI"))+1
 ...S ASUMY("YTD","SCH","LI")=$G(ASUMY("YTD","SCH","LI"))+1
 ...N V S V=$P(ASUT(ASUT,"VOU"),"-")_$P(ASUT(ASUT,"VOU"),"-",2) I V=ASUK("DT","FYMO")&(ASUT(ASUT,"VOU")'=$G(ASUV("VOU"))) D
 ....S ASUMY("CMO","SCH","DOC")=$G(ASUMY("CMO","SCH","DOC"))+1
 ....S ASUMY("YTD","SCH","DOC")=$G(ASUMY("YTD","SCH","DOC"))+1
 ....S ASUV("VOU")=ASUT(ASUT,"VOU")
 ..I ASUT(ASUT,"REQ TYP")=2 D
 ...S ASUMY("CMO","USC","LI")=$G(ASUMY("CMO","USC","LI"))+1
 ...S ASUMY("YTD","USC","LI")=$G(ASUMY("YTD","USC","LI"))+1
 ...N V S V=$P(ASUT(ASUT,"VOU"),"-")_$P(ASUT(ASUT,"VOU"),"-",2) I V=ASUK("DT","FYMO")&(ASUT(ASUT,"VOU")'=$G(ASUV("VOU"))) D
 ....S ASUMY("CMO","USC","DOC")=$G(ASUMY("CMO","USC","DOC"))+1
 ....S ASUMY("YTD","USC","DOC")=$G(ASUMY("YTD","USC","DOC"))+1
 ....S ASUV("VOU")=ASUT(ASUT,"VOU")
 ..I ASUT(ASUT,"FPN")="N" S ASUMY("IS0","LI")=$G(ASUMY("IS0","LI"))+1
 ..I ASUT(ASUT,"FPN")="P" S ASUMY("ISP","LI")=$G(ASUMY("ISP","LI"))+1
 ..I ASUT(ASUT,"B/O")="B" S ASUMY("B/O","LI")=$G(ASUMY("B/O","LI"))+1
 ..I ASUT(ASUT,"QTY","ADJ")="A" S ASUMY("QTYADJ","LI")=$G(ASUMY("QTYADJ","LI"))+1
 E  D
 .I ASUL(11,"TRN","REV") D
 ..S ASUMY("CMO","DIR","VAL")=ASUMY("CMO","DIR","VAL")-(ASUT(ASUT,"VAL"))
 ..S ASUMY("YTD","DIR","VAL")=ASUMY("YTD","DIR","VAL")-(ASUT(ASUT,"VAL"))
 ..S ASUMY("CMO","DIR","LI")=ASUMY("CMO","DIR","LI")-ASUT(ASUT,"QTY","ISS")
 ..S ASUMY("YTD","DIR","LI")=ASUMY("YTD","DIR","LI")-ASUT(ASUT,"QTY","ISS")
 ..S ASUMY("CMO","DIR","DOC")=ASUMY("CMO","DIR","DOC")-1
 ..S ASUMY("YTD","DIR","DOC")=ASUMY("YTD","DIR","DOC")-1
 .E  D
 ..S ASUMY("CMO","DIR","VAL")=ASUMY("CMO","DIR","VAL")+(ASUT(ASUT,"VAL"))
 ..S ASUMY("YTD","DIR","VAL")=ASUMY("YTD","DIR","VAL")+(ASUT(ASUT,"VAL"))
 ..S ASUMY("CMO","DIR","LI")=ASUMY("CMO","DIR","LI")+ASUT(ASUT,"QTY","ISS")
 ..S ASUMY("YTD","DIR","LI")=ASUMY("YTD","DIR","LI")+ASUT(ASUT,"QTY","ISS")
 ..S ASUMY("CMO","DIR","DOC")=ASUMY("CMO","DIR","DOC")+1
 ..S ASUMY("YTD","DIR","DOC")=ASUMY("YTD","DIR","DOC")+1
 D WRITY^ASUMYDIO ;Write YTD Issue Data master from variables
 Q
MO ;EP; RESET YTD ISSUE DATA BEGIN OF MO PROC
 S (ASUMY("E#","REQ"),ASUMY("E#","SST"),ASUMY("E#","SSA"),ASUMY("E#","ACC"))=0,ASUMY("NOKL")=1
 F  S ASUMY("E#","REQ")=$O(^ASUMY(ASUMY("E#","REQ"))) Q:ASUMY("E#","REQ")'?1N.N  D
 .F  S ASUMY("E#","SST")=$O(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SST"))) Q:ASUMY("E#","SST")'?1N.N  D
 ..F  S ASUMY("E#","SSA")=$O(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"))) Q:ASUMY("E#","SSA")'?1N.N  D
 ...F  S ASUMY("E#","ACC")=$O(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,ASUMY("E#","ACC"))) Q:ASUMY("E#","ACC")'?1N.N  D
 ....D READ^ASUMYDIO S X=0
 ....F  S X=$O(ASUMY("CMO",X)) Q:X']""  S Y=0 D
 .....F  S Y=$O(ASUMY("CMO",X,Y)) Q:Y']""  S ASUMY("CMO",X,Y)=""
 ....D WRITY^ASUMYDIO
 ...S ASUMY("E#","ACC")=0
 ..S ASUMY("E#","SSA")=0
 .S ASUMY("E#","SST")=0
 K DR,DIE,DA,ASUMU,ASUMU,ASUMY,ASU
 Q
