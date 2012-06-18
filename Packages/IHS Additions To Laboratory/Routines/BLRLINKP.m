BLRLINKP ; IHS/DIR/FJE - VALIDATION OF VARIOUS V FILE FIELDS ;DEC 09, 2008 8:30 AM
 ;;5.2;IHS LABORATORY;**1001,1015,1017,1018,1019,1021,1025**;NOV 01, 1997
 ;
 ; The following is post-validation logic for the fields in the various
 ; V files 9000010.09 (^AUPNVLAB,^AUPNVMIC,^AUPNVBB, etc.).  It is
 ; called by the linkage process and will be executed ONLY if the PCC
 ; process rejects the write to the V file (PCC error  1 or 2).
 ; The functionality of this procedure is to interpret the reason of
 ; the V file edit rejection and store the error reason in field 106
 ; of file 9009022.
 ; NOTE:  Field 106 = PCC ERROR FLAG;
 ;        File 9009022 = IHS LAB TRANSACTION FILE (the ^BLRTXLOG global)
 ;
 ;
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("ENTER ^BLRLINKP")
 S ALRCHKIP="",BLRLINK=1,BLRCHQ=0
 F T=1:1 S BLRTXT=$T(PARSE+T) S BLRSTR=$P(BLRTXT,";",3) Q:BLRSTR=""!(BLRCHQ)  D BLDFLD I $D(APCDALVR(BLRNAME)) D:BLRSS1[BLRSS!(BLRSS1="")
 .S X=APCDALVR(BLRNAME)
 .I 'BLRQUIET D FLDSCHK Q:BLRCHQ
 .S BLRVSUB=$S(BLRVSUB'="":BLRVSUB,1:"TRANS")
 .D @BLRVSUB
 .I '$D(X) W:'BLRQUIET !,BLRLIT_" failed edit in V file" D
 ..S:BLRPCC="" BLRBUL=2,BLRPCC="Field "_BLRTLOG_" of file 9009022 is invalid"
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1019 IHS
 ; Determine if update to deleted or merged visit caused Error IFF Error Message blank
 D:BLRPCC="" BLRPCCVE
 ;----- END IHS MODIFICATIONS LR*5.2*1019 IHS
 ; generic reject message created when specific PCC rejection not determined
 S:BLRPCC="" BLRBUL=2,BLRPCC="Write to "_$P($G(^DIC(BLRVFILE,0)),U)_" file rejected"
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("EXIT ^BLRLINKP")
 K BLRTXT,BLRSTR,BLRNAME,BLRVFLD,BLRLIT,BLRTLOG,BLRROOT,BLRPMSG,BLRVPRV,BLRVSUB,BLRCHQ
 Q
 ;
BLDFLD ; create BLR variables from BLRSTR
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("ENTER BLDFLD^BLRLINKP")
 S BLRNAME=$P(BLRSTR,"|"),BLRVFLD=$P(BLRSTR,"|",2),BLRLIT=$P(BLRSTR,"|",3),BLRTLOG=$P(BLRSTR,"|",4),BLRROOT=$P(BLRSTR,"|",5),BLRVSUB=$P(BLRSTR,"|",6),BLRSS1=$P(BLRSTR,"|",7) S:BLRTLOG="" BLRTLOG=BLRLIT
 Q
 ;
 ;
TRANS ; perform input transform found in file in DD for appropriate V file
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("ENTER TRANS^BLRLINKP")
 Q:APCDALVR(BLRNAME)=""
 S (DIE,DIC)=BLRROOT,DIC(0)=""
 X $P(^DD(BLRVFILE,BLRVFLD,0),U,5,99)   ;INPUT TRANSFORM
 Q
 ;
VTEST ; validation on required TEST field
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("ENTER VTEST^BLRLINKP")
 I APCDALVR(BLRNAME)="" D REQMSG K X Q
 S APCDALVR(BLRNAME)=$P(APCDALVR(BLRNAME),"`",2)
 I '$D(^LAB(60,APCDALVR(BLRNAME))) S BLRBUL=2,BLRPCC="Field "_BLRTLOG_" of file 9009022 not a valid test in file 60" K X
 Q
 ;
VVSIT ; validation on required VISIT field
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("ENTER VVSIT^BLRLINKP")
 I APCDALVR(BLRNAME)="" D REQMSG K X Q
 I APCDALVR(BLRNAME)'?1N.N S BLRBUL=2,BLRPCC=BLRNAME_" needs to be all numeric" K X Q
 ; I '$D(^AUPNVSIT(APCDALVR(BLRNAME),0)) S BLRBUL=2,BLRPCC=BLRNAME_" not a valid visit" K X
 ; ----- BEGIN IHS/OIT/MKK -- LR*5.2*1025 -- Need a QUIT if this error exists
 I '$D(^AUPNVSIT(APCDALVR(BLRNAME),0)) S BLRBUL=2,BLRPCC=BLRNAME_" not a valid visit" K X Q
 ; ----- END IHS/OIT/MKK -- LR*5.2*1025 -- Need a QUIT if this error exists
 Q:'BLRVIEN
 S (DIE,DIC)=BLRROOT,DIC(0)=""
 X $P(^DD(BLRVFILE,BLRVFLD,0),U,5,99)  ;INPUT TRANSFORM
 Q
 ;
VANTIB ; validation on antibiotic field for Micro or
 ; antibody field for blood bank
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("ENTER VANTIB^BLRLINKP")
 Q:APCDALVR(BLRNAME)=""
 I $E(APCDALVR(BLRNAME))="`" S APCDALVR(BLRNAME)=$P(APCDALVR(BLRNAME),"`",2)
 I BLRSS="MI",'$D(^LAB(62.06,APCDALVR(BLRNAME))) S BLRBUL=2,BLRPCC="Field "_BLRTLOG_" of file 9009022 not a valid antibiotic IEN" K X Q
 I BLRSS="BB",'$D(^LAB(61.3,APCDALVR(BLRNAME))) S BLRBUL=2,BLRPCC="Field "_BLRTLOG_" of file 9009022 not a valid antibody IEN" K X
 Q
 ;
VPROV ; validation of provider field
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("ENTER VPROV^BLRLINKP")
 Q:$G(APCDALVR(BLRNAME))=""
 ; S BLRPMSG="Field "_BLRTLOG_" of file 9009022 not in Provider file"
 ;----- BEGIN IHS/OIT/MKK MODIFICATIONS LR*5.2*1021
 S BLRPMSG="Field "_BLRTLOG_" of file 9009022 not in NEW PERSON file"
 ;----- END IHS/OIT/MKK MODIFICATIONS LR*5.2*1021
 S BLRVPRV=BLROPRV
 I BLRVPRV="" S BLRBUL=2,BLRPCC=BLRPMSG K X Q
 I $G(BLR200CV)]"",'$D(^VA(200,BLRVPRV)) D  Q  ;cmi/maw 1/8/2002**1015**
 . S BLRBUL=2,BLRPCC=BLRPMSG K X  ;cmi/maw 1/8/2002 **1015**
 ; I '$D(^DIC(6,BLRVPRV)) S BLRBUL=2,BLRPCC=BLRPMSG K X
 ;----- BEGIN IHS/OIT/MKK MODIFICATIONS LR*5.2*1021
 ;      If the provider is in dictionary 200, it DOES NOT matter if the
 ;      provider is not in dictionary 6.
 S BLRPMSG="Field "_BLRTLOG_" of file 9009022 not in PROVIDER file"
 I '$D(^DIC(6,BLRVPRV))&('$D(^VA(200,BLRVPRV))) S BLRBUL=2,BLRPCC=BLRPMSG K X
 ;----- END IHS/OIT/MKK MODIFICATIONS LR*5.2*1021
 Q
 ;
 ;no action taken at this time
VNOACT ;
 Q
FLDSCHK ;
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("ENTER FLDSCHK^BLRLINKP")
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
 ;;APCDTLNC|1113|loinc code|1310||VNOACT||  ;IHS/ITSC/TPF 07/01/03 ADD "||" **1017**
 ;;APCDTCLS|1114|collection sample|1307||VNOACT||  ;IHS/ITSC/TPF 07/01/03 ADD "||" **1017**
 ;;APCDTCDT|1201|date/time collected|1201||
 ;;APCDTPRV|1202|ordering provider ien|1104||VPROV
 ;;APCDTEPR|1204|encounter provider ien|113||VPROV
 ;;APCDTOPR|1210|outside provider name|1105 or 114||
 ;;APCDTRDT|1212|result date and time|1309||VNOACT||  ;IHS/ITSC/TPF 07/01/03 ADD "||" **1017**
 ;;APCDTLC1|1301|free text comment 1|3001||
 ;;APCDTLC2|1302|free text comment 2|3001||
 ;;APCDTLC3|1303|free text comment 3|3001||
 ;;APCDTCPS|1402|cpt string|201||
 ;
 Q
REQMSG ;creation of required field message
 S BLRBUL=2,BLRPCC="Field "_BLRTLOG_" is required for PCC and cannot be null"
 Q
 ;
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1019 IHS
 ;      This routine tries to determine if the error message should
 ;      reflect an unsuccessful update to either a deleted PCC visit or
 ;      a merged PCC visit or other non-reported incidents.
BLRPCCVE     ;
 ; Variables are being NEWed so as to make sure no interference
 ; occurs with other LAB routines.
 ;  
 NEW PTPTR,ORDERDT,COLLDT,ACC,DFN
 NEW BLRVDELF,BLRVMERF,COLLDTF,IHSVXF,PCCVDMF,PCCVIS
 NEW IHSVXF
 ;
 Q:BLRLOGDA=""                                   ; If no transaction #, quit
 ;
 S PTPTR=$P($G(^BLRTXLOG(BLRLOGDA,0)),"^",4)     ; Patient Pointer Value
 S ORDERDT=$P($G(^BLRTXLOG(BLRLOGDA,11)),"^",1)  ; Order Date/Time
 S COLLDT=$P($G(^BLRTXLOG(BLRLOGDA,12)),"^",1)   ; Collection Date/Time
 S ACC=$P($G(^BLRTXLOG(BLRLOGDA,12)),"^",2)      ; Accession Number
 S DFN=PTPTR_$P(ORDERDT,".",1)                   ; Pointer to PCC Visit
 ;
 ;----- BEGIN IHS/OIT/MKK MODIFICATIONS LR*5.2*1021 - Wrong. It should never be reported.
 ; An issue that is not reported correctly.
 ; I COLLDT<ORDERDT D  Q
 ; . S BLRPCC=""
 ; . S BLRPCC="Collection Date is LESS THAN Ordering Date."
 ; S BLRBUL=2
 ;----- END IHS/OIT/MKK MODIFICATIONS LR*5.2*1021
 ;
 I $G(DFN)="" Q                   ; If no PCC Visit pointer, quit
 ;
 ; Initialize variables
 S (BLRVDELF,BLRVMERF,COLLDTF,IHSVXF,PCCVDMF,PCCVIS)=""
 ;
 S IHSVXF=$O(^LRO(68.999999901,"B",DFN,IHSVXF))       ; PCC Visit X-Ref
 I IHSVXF="" D                                        ; If can't find PCC Visit
 . S DFN=PTPTR_$P(COLLDT,".",1)                       ; use Collect Date to try
 . S IHSVXF=$O(^LRO(68.999999901,"B",DFN,IHSVXF))     ; to get PCC Visit #
 . I IHSVXF'="" S COLLDTF="*"                         ; If Coll Date, Set Flag
 ;
 I IHSVXF="" Q                                        ; If still null, quit
 ;
 S PCCVIS=$P($G(^LRO(68.999999901,IHSVXF,0)),"^",2)   ; PCC Visit #
 S BLRVDELF=$P($G(^AUPNVSIT(PCCVIS,0)),"^",11)        ; Visit Del Flag
 I BLRVDELF'="" S PCCVDMF="D"                         ; Deleted
 S BLRVMERF=$P($G(^AUPNVSIT(PCCVIS,0)),"^",37)        ; Merged to Visit #
 I BLRVMERF'="" S PCCVDMF="M"                         ; Merged
 ;
 ;----- BEGIN IHS/OIT/MKK MODIFICATIONS LR*5.2*1021
 ;      The BLRPCC string could be over 60 characters in length,
 ;      which is too long for the PCC ERROR FLAG field in the
 ;      IHS LAB TRANSACTION LOG file.  It has been changed.
 I PCCVDMF="M" D  Q
 . S BLRPCC="PCC Visit "_PCCVIS
 . S BLRPCC=BLRPCC_" has been merged to "_BLRVMERF_"."
 . S BLRBUL=2
 ;
 I PCCVDMF="D" D
 . S BLRPCC="PCC Visit "_PCCVIS_" has been deleted."
 . S BLRBUL=2
 ;----- END IHS/OIT/MKK MODIFICATIONS LR*5.2*1021
 ;
 Q
 ;----- END IHS MODIFICATIONS LR*5.2*1019 IHS
