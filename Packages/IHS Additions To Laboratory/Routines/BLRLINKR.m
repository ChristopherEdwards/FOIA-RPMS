BLRLINKR ; IHS/DIR/FJE - VALIDATION OF VARIOUS V FILE FIELDS ; [ 07/30/2002  9:42 AM ]
 ;;5.2;BLR;**1001**;FEB 1, 1998
 ;
 ; The following is post-validation logic for the fields in the various
 ; V files 9000010.09 (^AUPNVLAB,^AUPNVMIC,^AUPNVBB, etc.).  It is
 ; called by the linkage process and will be executed ONLY if the PCC
 ; process rejects the write to the V file (PCC error  1 or 2).
 ; The functionality of this procedure is to interpret the reason of
 ; the V file edit rejection and store the error reason in field 106
 ; of file 9009022.
 ;
 ;
 S ALRCHKIP="",BLRLINK=1,BLRCHQ=0
 F T=1:1 S BLRTXT=$T(PARSE+T) S BLRSTR=$P(BLRTXT,";",3) Q:BLRSTR=""!(BLRCHQ)  D BLDFLD I $D(APCDALVR(BLRNAME)) D:BLRSS1[BLRSS!(BLRSS1="")
 .S X=APCDALVR(BLRNAME)
 .I 'BLRQUIET D FLDSCHK Q:BLRCHQ
 .S BLRVSUB=$S(BLRVSUB'="":BLRVSUB,1:"TRANS")
 .D @BLRVSUB
 .I '$D(X) W:'BLRQUIET !,BLRLIT_" failed edit in V file" D
 ..S:BLRPCC="" BLRBUL=2,BLRPCC="Field "_BLRTLOG_" of file 9009022 is invalid"
 ; generic reject message created when specific PCC rejection not determined
 S:BLRPCC="" BLRBUL=2,BLRPCC="Write to "_$P(^DIC(BLRVFILE,0),U)_" file rejected"
 K BLRTXT,BLRSTR,BLRNAME,BLRVFLD,BLRLIT,BLRTLOG,BLRROOT,BLRPMSG,BLRVPRV,BLRVSUB,BLRCHQ
 Q
BLDFLD ; create BLR variables from BLRSTR
 S BLRNAME=$P(BLRSTR,"|"),BLRVFLD=$P(BLRSTR,"|",2),BLRLIT=$P(BLRSTR,"|",3),BLRTLOG=$P(BLRSTR,"|",4),BLRROOT=$P(BLRSTR,"|",5),BLRVSUB=$P(BLRSTR,"|",6),BLRSS1=$P(BLRSTR,"|",7) S:BLRTLOG="" BLRTLOG=BLRLIT
 Q
 ;
TRANS ; perform input transform found in file in DD for appropriate V file
 Q:APCDALVR(BLRNAME)=""
 S (DIE,DIC)=BLRROOT,DIC(0)=""
 X $P(^DD(BLRVFILE,BLRVFLD,0),U,5,99)
 Q
 ;
VTEST ; validation on required TEST field
 I APCDALVR(BLRNAME)="" D REQMSG K X Q
 S APCDALVR(BLRNAME)=$P(APCDALVR(BLRNAME),"`",2)
 I '$D(^LAB(60,APCDALVR(BLRNAME))) S BLRBUL=2,BLRPCC="Field "_BLRTLOG_" of file 9009022 not a valid test in file 60" K X
 Q
VVSIT ; validation on required VISIT field
 I APCDALVR(BLRNAME)="" D REQMSG K X Q
 I APCDALVR(BLRNAME)'?1N.N S BLRBUL=2,BLRPCC=BLRNAME_" needs to be all numeric" K X Q
 I '$D(^AUPNVSIT(APCDALVR(BLRNAME),0)) S BLRBUL=2,BLRPCC=BLRNAME_" not a valid visit" K X
 Q:'BLRVIEN
 S (DIE,DIC)=BLRROOT,DIC(0)=""
 X $P(^DD(BLRVFILE,BLRVFLD,0),U,5,99)
 Q
 ;
VANTIB ; validation on antibiotic field for Micro or
 ; antibody field for blood bank
 Q:APCDALVR(BLRNAME)=""
 I $E(APCDALVR(BLRNAME))="`" S APCDALVR(BLRNAME)=$P(APCDALVR(BLRNAME),"`",2)
 I BLRSS="MI",'$D(^LAB(62.06,APCDALVR(BLRNAME))) S BLRBUL=2,BLRPCC="Field "_BLRTLOG_" of file 9009022 not a valid antibiotic IEN" K X Q
 I BLRSS="BB",'$D(^LAB(61.3,APCDALVR(BLRNAME))) S BLRBUL=2,BLRPCC="Field "_BLRTLOG_" of file 9009022 not a valid antibody IEN" K X
 Q
 ;
VPROV ;
 Q:$G(APCDALVR(BLRNAME))=""
 S BLRPMSG="Field "_BLRTLOG_" of file 9009022 not in Provider file"
 ;I $P(^VA(200,$P(X,"`",2),0),"^",16)="" S BLRBUL=2,BLRPCC=BLRPMSG K X Q
 S BLRVPRV=BLROPRV
 I BLRVPRV="" S BLRBUL=2,BLRPCC=BLRPMSG K X Q
 I '$D(^DIC(6,BLRVPRV)) S BLRBUL=2,BLRPCC=BLRPMSG K X
 Q
FLDSCHK ;
 D CHK^DIE(BLRVFILE,BLRVFLD,"E",APCDALVR(BLRNAME),.BLRCHK)
 I BLRCHK="^" W !,APCDALVR(BLRNAME)_" value is invalid for field "_BLRLIT_" "_BLRVFLD_" in file "_BLRVFILE,! S BLRCHQ=1
 K BLRCHK
 Q
 ;
PARSE ;;subscript name|field # for appropriate V file |literal desc|field # for file #9009022|global root|validation subroutine
 ;;APCDTLAB|.01|lab test|.06||VTEST|
 ;;APCDVSIT|.03|Visit IEN||^AUPNVSIT(|VVSIT|
 ;;APCDTRES|.04|result text|2001|||BB,CH
 ;;APCDTABN|.05|Normal flag|2002|||CH
 ;;APCDTANT|.05|antibiotic|1303||VANTIB|MI
 ;;APCDTANT|.05|antibody|1403||VANTIB|BB
 ;;APCDTACC|.06|Acc #|1202|||
 ;;APCDTRES|.07|blood bank test name|1402|||BB
 ;;APCDTCOL|.08|collection sample|1307|||MI  ;IHS/DIR TUC/AAB 04/08/98
 ;;APCDTCMD|.09|complete date|1309|||MI  ;IHS/DIR TUC/AAB 04/08/98
 ;;APCDTUNI|1101|units|2003|||
 ;;APCDTORD|1102|order number|1103||
 ;;APCDTSTE|1103|site/specimen|2004|^LAB(61,|
 ;;APCDTRFL|1104|reference low|2008||
 ;;APCDTRFH|1105|reference high|2009||
 ;;APCDTCOS|1110|lab test cost|108||
 ;;APCDTCDT|1201|date/time collected|1201||
 ;;APCDTPRV|1202|ordering provider ien|1104||VPROV
 ;;APCDTEPR|1204|encounter provider ien|113||VPROV
 ;;APCDTOPR|1210|outside provider name|1105 or 114||
 ;;APCDTLC1|1301|free text comment 1|3001||
 ;;APCDTLC2|1302|free text comment 2|3001||
 ;;APCDTLC3|1303|free text comment 3|3001||
 ;;APCDTCPS|1402|cpt string|201||
 ;
 Q
REQMSG ;creation of required field message
 S BLRBUL=2,BLRPCC="Field "_BLRTLOG_" is required for PCC and cannot be null"
 Q
