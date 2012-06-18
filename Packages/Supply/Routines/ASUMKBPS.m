ASUMKBPS ; IHS/ITSC/LMH -UPDATE ISSUE BOOK MASTER ;  
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is a utility which is invoked to update the Issue Book
 ;Master file. The Issue Book master file is used to capture
 ;statistics concerning Issues.
 I $G(ASUT(ASUT,"B/O"))="B"&$G(ASUT(ASUT,"FPN"))="N" Q
 I $E(ASUT("TRCD"))=0 D
 .S ASUMK("E#","STA")=$G(ASUT(ASUT,"PT","STA"))
 E  D
 .S ASUMK("E#","STA")=$G(ASUMS("E#","STA"))
 S ASUMK("E#","REQ")=ASUT(ASUT,"PT","REQ")
 D STA^ASUMKBIO(ASUMK("E#","STA")) ;Lookup STA in Issue Book Master
 I Y<1 D  Q:$D(DDSERROR)
 .I Y=0 D
 ..D ADDSTA^ASUMKBIO(ASUMK("E#","STA")) ;Add STA to Issue Book master
 ..I Y<0 D
 ...N Z S Z="Error adding STA : "_ASUMK("E#","STA")_" to YTD DATA -RC : "_Y W *7 D HLP^ASUJHELP(.Z) S DDSERROR=1 ;DFM P1 9/1/98
 .E  D
 ..N Z S Z="Error finding STA : "_ASUMK("E#","STA")_" for YTD DATA -RC : "_Y W *7 D HLP^ASUJHELP(.Z) S DDSERROR=2 ;DFM P1 9/1/98
 D REQ^ASUMKBIO(ASUMK("E#","REQ")) ;Lookup REQ in Issue Book master
 I Y<1 D  Q:$D(DDSERROR)
 .I Y=0 D
 ..D ADDREQ^ASUMKBIO(ASUMK("E#","REQ")) ;Add REQ to Issue Book master
 ..I Y<0 D
 ...N Z S Z="Error adding REQ : "_ASUMK("E#","REQ")_" to YTD DATA -RC : "_Y W *7 D HLP^ASUJHELP(.Z) S DDSERROR=3 ;DFM P1 9/1/98
 .E  D
 ..N Z S Z="Error finding REQ : "_ASUMK("E#","REQ")_" for YTD DATA -RC : "_Y W *7 D HLP^ASUJHELP(.Z) S DDSERROR=4 ;DFM P1 9/1/98
 I ASUT("TYPE")=7 D
 .S ASUMX("E#","IDX")="99999999"
 E  D
 .D IDX^ASUMKBIO(ASUMX("E#","IDX")) ;Lookup IDX in Issue Book master
 I Y<1 D  Q:$D(DDSERROR)
 .I Y=0 D
 ..D ADDIDX^ASUMKBIO(ASUMK("E#","IDX")) ;Add IDX to Issue Book master
 ..I Y<0 D
 ...N Z S Z="Error adding IDX : "_ASUMK("E#","IDX")_" to YTD DATA -RC : "_Y W *7 D HLP^ASUJHELP(.Z) S DDSERROR=5 ;DFM P1 9/1/98
 .E  D
 ..N Z S Z="Error finding IDX : "_ASUMK("E#","IDX")_" for YTD DATA -RC : "_Y W *7 D HLP^ASUJHELP(.Z) S DDSERROR=6 ;DFM P1 9/1/98
 D READ^ASUMKBIO ;Read Issue Book master into variables
 I ASUT("TRCD")="5B" D
 .S ASUMK("ULQTY")=$S(ASUT(ASUT,"ULVQTY")=0:"",1:ASUT(ASUT,"ULVQTY"))
 .S ASUMK("PULQTY")=1
 E  D
 .S ASUV("MO")=+($P(ASUT(ASUT,"VOU"),"-",2))
 .Q:ASUV("MO")']""
 .I $E(ASUT("TRCD"),2)?1A D
 ..S ASUMK(ASUV("MO"),"DOC")=$G(ASUMK(ASUV("MO"),"DOC"))-1
 ..S ASUMK(ASUV("MO"),"QTY")=$G(ASUMK(ASUV("MO"),"QTY"))-ASUT(ASUT,"QTY","ISS")
 ..S ASUMK("CFY","VAL")=$G(ASUMK("CFY","VAL"))-(ASUT(ASUT,"VAL"))
 .E  D
 ..I ASUT("TRCD")'="31" D
 ...S ASUMK(ASUV("MO"),"DOC")=$G(ASUMK(ASUV("MO"),"DOC"))+1
 ..S ASUMK(ASUV("MO"),"QTY")=$G(ASUMK(ASUV("MO"),"QTY"))+ASUT(ASUT,"QTY","ISS")
 ..S ASUMK("CFY","VAL")=$G(ASUMK("CFY","VAL"))+(ASUT(ASUT,"VAL"))
 D EN1^ASUMKBIO
 Q
CLMO ;EP ;CLEAR MONTH
 S ASUMK("MO")=ASUP("MO")+1 S:ASUMK("MO")=13 ASUMK("MO")=1
CLSM ;EP ;CLEAR PREVIOUSLY SELECTED MONTH
 S (ASUMK("E#","STA"),ASUMK("E#","REQ"),ASUMK("E#","IDX"))=0
 F  S ASUMK("E#","STA")=$O(^ASUMK(ASUMK("E#","STA"))) Q:ASUMK("E#","STA")'?1N.N  D
 .F  S ASUMK("E#","REQ")=$O(^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"))) Q:ASUMK("E#","REQ")'?1N.N  D
 ..F  S ASUMK("E#","IDX")=$O(^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,ASUMK("E#","IDX"))) Q:ASUMK("E#","IDX")'?1N.N  D
 ...D READ^ASUMKBIO
 ...S ASUMK(ASUMK("MO"),"DOC")=""
 ...S ASUMK(ASUMK("MO"),"QTY")=""
 ...S ASUMK("NOKL")=1 D EN1^ASUMKBIO
 ..S ASUMK("E#","IDX")=0
 .S ASUMK("E#","REQ")=0,ASUMK("E#","IDX")=0
 K ASUMK
 Q
CLYR ;EP; CLEAR YEARLY
 S ASUP("CKY")=+$G(ASUP("CKY"))
 D DATE^ASUUDATE,TIME^ASUUDATE
 S ASURX="W !,""S.A.M.S. Beginning of Year Update Procedure begun "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 I ASUP("CKY")=0 S ASUP("CKY")=1 D SETSY^ASUCOSTS
 I ASUP("CKY")=1 D ASUYPSYR G:ASUP("HLT") DONE S ASUP("CKY")=2 D SETSY^ASUCOSTS
 I ASUP("CKY")=2 D ASUKPSYR G:ASUP("HLT") DONE S ASUP("CKY")=3 D SETSY^ASUCOSTS
 I ASUP("CKY")=3 D  G:ASUP("HLT") DONE S ASUP("CKY")=4 D SETSY^ASUCOSTS
 .S ASURX="W !,""Clearing Transaction History Files""" D ^ASUUPLOG
 .D EN2^ASU0PURG
 I ASUP("CKY")=4 D
 .S ASUU("E#")=""
 .F  S ASUU("E#")=$O(^ASUR1(ASUU("E#"))) Q:ASUU("E#")=""  Q:ASUU("E#")="B"  F ASUC("TR")=4,5,7,8,10,11,13,14,16,17,19,20 S $P(^ASUR1(ASUU("E#"),0),U,ASUC("TR"))=0
 .K ASU
 .S ASUP("CKY")=5 D SETSY^ASUCOSTS
 Q:$G(ASUP("HLT"))
 D TIME^ASUUDATE
 S ASURX="W !,""S.A.M.S. Beginning of Year Update Procedure ended "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 Q
DONE ;
 S ASUP("HLT")=1
 Q
ASUYPSYR ;
 S ASURX="W !,""Clearing Year to Date Issue Data""" D ^ASUUPLOG
 S (ASUMY("E#","REQ"),ASUMY("E#","SSA"),ASUMY("E#","ACC"))=0
 F  S ASUMY("E#","REQ")=$O(^ASUMY(ASUMY("E#","REQ"))) Q:ASUMY("E#","REQ")'?1N.N  K ^ASUMY(ASUMY("E#","REQ"))
 Q
 F  S ASUMY("E#","REQ")=$O(^ASUMY(ASUMY("E#","REQ"))) Q:ASUMY("E#","REQ")'?1N.N  D
 .F  S ASUMY("E#","SSA")=$O(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"))) Q:ASUMY("E#","SSA")'?1N.N  D
 ..F  S ASUMY("E#","ACC")=$O(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,ASUMY("E#","ACC"))) Q:ASUMY("E#","ACC")'?1N.N  S ASUQ(1)="" D
 ...D READ^ASUMYDIO
 ...F  S ASUQ(1)=$O(ASUMY("CMO",ASUQ(1))) Q:ASUQ(1)']""  S ASUQ(2)="" D
 ....F  S ASUQ(2)=$O(ASUMY("CMO",ASUQ(1),ASUQ(2))) Q:ASUQ(2)']""  D
 .....S ASUMY("CMO",ASUQ(1),ASUQ(2))=""
 ...F  S ASUQ(1)=$O(ASUMY("YTD",ASUQ(1))) Q:ASUQ(1)']""  S ASUQ(2)="" D
 ....F  S ASUQ(2)=$O(ASUMY("YTD",ASUQ(1),ASUQ(2))) Q:ASUQ(2)']""  D
 .....S ASUMY("YTD",ASUQ(1),ASUQ(2))=""
 ...S (ASUMY("ISO","LI"),ASUMY("ISP","LI"),ASUMY("B/O","LI"),ASUMY("QTYADJ","LI"))=""
 ...S ASUMY("NOKL")=1 D WRITY^ASUMYDIO
 ..S ASUMY("E#","ACC")=0
 .S ASUMY("E#","SSA")=0
 K DR,DIE,DA,ASUMY,ASU
 Q
ASUKPSYR ;
 S ASURX="W !,""Clearing Issue Book Master""" D ^ASUUPLOG
 S ASUMK("E#","STA")=0
 F  S ASUMK("E#","STA")=$O(^ASUMK(ASUMK("E#","STA"))) Q:ASUMK("E#","STA")'?1N.N  D
 .S ASUMK("E#","REQ")=0
 .F  S ASUMK("E#","REQ")=$O(^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"))) Q:ASUMK("E#","REQ")'?1N.N  D
 ..S ASUMK("E#","IDX")=0
 ..F  S ASUMK("E#","IDX")=$O(^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,ASUMK("E#","IDX"))) Q:ASUMK("E#","IDX")'?1N.N  D
 ...D READ^ASUMKBIO
 ...S ASUMK("PPY","VAL")=ASUMK("PFY","VAL")
 ...S ASUMK("PFY","VAL")=ASUMK("CFY","VAL")
 ...S ASUMK("CFY","VAL")=""
 ...S ASUMK("NOKL")=1 D EN1^ASUMKBIO
 K ASUMK
 Q
