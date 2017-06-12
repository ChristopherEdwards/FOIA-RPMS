BSTSRPT ;GDIT/HS/BEE-Handle retired concepts/terms ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**8**;Sep 10, 2014;Build 35
 ;
EN ;EP - Main entry point
 ;
 NEW DIR,X,Y,FIX,CT,BST,TYPE,NMID,RCMP
 ;
 ;Determine whether concept or term review
 W !!
 K BST
 S BST(1)="This utility will loop through locally cached BSTS concepts and terms and for any that"
 S BST(2)="have been retired, it will attempt to find replacement concepts/terms"
 D EN^DDIOL(.BST)
 S DIR(0)="S^C:Check for retired concepts;T:Check for retired terms;Q:Quit"
 D ^DIR
 I Y'="C",Y'="T" G XEN
 S TYPE=Y
 ;
 ;Determine whether SNOMED or RxNorm
 K BST
 S BST(1)=" "
 S BST(2)="Choose the codeset to report on"
 D EN^DDIOL(.BST)
 S DIR(0)="S^S:SNOMED;R:RxNorm (Out of Order);Q:Quit"
 D ^DIR
 I Y'="S" G XEN
 ;I Y'="S",Y'="R" G XEN
 S NMID=$S(Y="S":36,1:1552)
 ;
 ;Process concepts
 I TYPE="C" D PRINT("CONC^BSTSRPT",NMID) G XEN
 ;
 I TYPE="T" D PRINT("TERM^BSTSRPT",NMID) G XEN
 ;
XEN Q
 ;
CONC ;Find list of retired concepts
 ;
 ;Validate input
 I $G(NMID)="" Q
 ;
 NEW OCONC
 ;
 ;Loop through Concept ID index
 W !,"Original",?18,"Replacement",?36,"Type",?42,"Desc ID",?54,"Preferred Term"
 S OCONC="" F  S OCONC=$O(^BSTS(9002318.4,"C",NMID,OCONC)) Q:OCONC=""  D
 . NEW CIEN
 . S CIEN=0 F  S CIEN=$O(^BSTS(9002318.4,"C",NMID,OCONC,CIEN)) Q:'CIEN  D
 .. NEW RETR,RCONC
 .. ;
 .. ;Quit if not retired or retired after current date
 .. S RETR=$$GET1^DIQ(9002318.4,CIEN_",",.06,"I")
 .. I (RETR="") Q  ;No retired date
 .. I (RETR>DT) Q  ;Retired date is in the future
 .. ;
 .. ;Look for replacements
 .. W !,OCONC
 .. D RCONC(OCONC,NMID,.RCONC)
 .. ;
 .. ;Handle Same As/Replaced By
 .. I $G(RCONC)]"" D  Q
 ... W ?17,"*"
 ... W ?18,$P(RCONC,U),?36,$P(RCONC,U,4),?42,$P(RCONC,U,3),?54,$E($P(RCONC,U,2),1,80)
 .. ;
 .. ;Handle Multiple Results
 .. I $G(RCONC)="",$O(RCONC(""))]"" D  Q
 ... NEW II
 ... S II="" F  S II=$O(RCONC(II)) Q:II=""  D
 .... NEW RES
 .... W:II'=1 ! W ?18,$P(RCONC(II),U),?36,$P(RCONC(II),U,4),?42,$P(RCONC(II),U,3),?54,$E($P(RCONC(II),U,2),1,80)
 .. ;
 .. ;No Match
 .. W ?18,"No Matches"
 ;
 ;Close the device
 I $D(IO("Q")) D ^%ZISC
 ;
 Q
 ;
TERM ;Find list of retired terms
 ;
 ;Validate input
 I $G(NMID)="" Q
 ;
 NEW ODSCID,NMIEN
 ;
 ;Get internal codeset IEN
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) Q:NMIEN=""
 ;
 ;Reset scratch global
 K ^TMP("BSTSRPT",$J)
 ;
 ;Loop through Description ID index
 W !,"Original Desc ID",?18,"Replacement Desc ID",?36,"Type",?42,"Conc ID",?54,"Term"
 S ODSCID="" F  S ODSCID=$O(^BSTS(9002318.3,"D",NMIEN,ODSCID)) Q:ODSCID=""  D
 . NEW TIEN
 . S TIEN=0 F  S TIEN=$O(^BSTS(9002318.3,"D",NMIEN,ODSCID,TIEN)) Q:'TIEN  D
 .. NEW RETR,RTERM
 .. ;
 .. ;Quit if not retired or retired after current date
 .. S RETR=$$GET1^DIQ(9002318.3,TIEN_",",.07,"I")
 .. I (RETR="") Q  ;No retired date
 .. I (RETR>DT) Q  ;Retired date is in the future
 .. ;
 .. ;Look for replacements
 .. W !,ODSCID
 .. D RTERM(ODSCID,NMID,.RTERM)
 .. ;
 .. ;Handle Exact Replacement
 .. I $G(RTERM)]"" D  Q
 ... W ?17,"*"
 ... W ?18,$P(RTERM,U),?42,$P(RTERM,U,3),?54,$E($P(RTERM,U,2),1,80)
 .. ;
 .. ;Handle Multiple Results
 .. I $G(RTERM)="",$O(RTERM(""))]"" D  Q
 ... NEW II
 ... S II="" F  S II=$O(RTERM(II)) Q:II=""  D
 .... NEW RES
 .... W:II'=1 ! W ?18,$P(RTERM(II),U),?36,$P(RTERM(II),U,4),?42,$P(RTERM(II),U,3),?54,$E($P(RTERM(II),U,2),1,80)
 .. ;
 .. ;No Match
 .. W ?18,"No Matches"
 ;
 ;Close the device
 I $D(IO("Q")) D ^%ZISC
 ;
 Q
 ;
RCONC(CONC,NMID,BSTSRET) ;PEP - Return replacement concept(s) for a concept
 ;
 ;This routine accepts a concept and namespace ID and returns a list
 ;of possible replacement concepts if it is retired. 
 ;
 ;Input:
 ;CONC - Concept ID
 ;NMID (Optional) - Namespace ID (36-SNOMED/1552-RxNorm) - Default is 36
 ;BSTSRET - Return variable array
 ;
 ;Output:
 ;
 ;If concept still active
 ;BSTSRET=Passed in Concept ID [1]^Preferred Term of Passed in Concept ID [2]
 ;        ^Preferred Desc ID of Passed in Concept ID [3]
 ;
 ;If exact match:
 ;BSTSRET=Exact Match (EM) Concept ID [1]^EM Preferred Term [2]^EM Preferred Desc ID [3]
 ;        ^EM Type, where: EM Type = R - Replaced By, S - Same As [4]
 ;
 ;If no single exact match but possible match(es) available:
 ;BSTSRET=""
 ;BSTSRET(#)=Possible Replacement (PR) Concept ID [1]^PR Preferred Term [2]^PR Preferred Desc ID [3]
 ;           ^PR Type, where: PR Type = R - Replaced By, S - Same As, M - May be a [4]
 ;
 ;If inactive and no matches available
 ;BSTSRET=""
 ;
 ;Sample call:
 ;
 ;>D RCONC^BSTSAPI(495003,36,.RET) ZW RET
 ;RET="715052003^Disease caused by Capripoxvirus^3301304017^R"
 ;
 NEW STS,DTSID,CIEN,RIEN,MEXCT,BSTSCNT,ICNT,RETR,VAR,TRY,MOD,OOD,LOC
 ;
 ;Reset output
 S BSTSRET="" S ICNT="" F  S ICNT=$O(BSTSRET(ICNT)) Q:ICNT=""  K BSTSRET(ICNT)
 ;
 ;Quit if no concept or namespace ID passed in
 I $G(CONC)="" Q
 S:$G(NMID)="" NMID=36
 ;
 ;Get the CIEN and DTSID
 S CIEN=$O(^BSTS(9002318.4,"C",NMID,CONC,"")) Q:CIEN=""
 S DTSID=$$GET1^DIQ(9002318.4,CIEN_",",".08","I") Q:DTSID=""
 ;
 ;Make sure the concept is up to date
 S OOD=$$GET1^DIQ(9002318.4,CIEN_",",".11","I")
 S MOD=$$GET1^DIQ(9002318.4,CIEN_",",".12","I")
 S LOC=1 I (MOD="")!(OOD="Y") S LOC=""
 F TRY=1:1:20 S STS=$$DTSLKP^BSTSAPI("VAR",DTSID_U_NMID_U_U_LOC) Q:(+STS=2)  I LOC=1,+STS=1 Q
 I '+STS Q
 ;
 ;Check for active concept
 S RETR=$G(VAR(1,"XRDT"))
 I (RETR="")!(RETR>DT) S BSTSRET=$G(VAR(1,"CON"))_U_$G(VAR(1,"PRE","TRM"))_U_$G(VAR(1,"PRE","DSC")) Q
 ;
 ;Look at replacement information
 S (BSTSCNT,MEXCT,RIEN)=0 F  S RIEN=$O(^BSTS(9002318.4,CIEN,17,RIEN)) Q:'RIEN  D
 . NEW NODE,DA,IENS,VAR,RTYPE,PRET,PREID,XRDT
 . S DA(1)=CIEN,DA=RIEN,IENS=$$IENS^DILF(.DA)
 . S CONC=$$GET1^DIQ(9002318.417,IENS,.01,"I") Q:CONC=""
 . S RTYPE=$$GET1^DIQ(9002318.417,IENS,.03,"I") Q:RTYPE=""
 . S STS=$$CNCLKP^BSTSAPI("VAR",CONC_"^"_NMID)
 . ;
 . ;Skip if not active
 . S XRDT=$G(VAR(1,"XRDT"))
 . I XRDT]"",XRDT'>DT Q
 . ; 
 . S PRET=$G(VAR(1,"PRE","TRM"))
 . S PREID=$G(VAR(1,"PRE","DSC"))
 . ;
 . ;Look for single exact match - clear if more than one
 . I MEXCT=1,(RTYPE="R")!(RTYPE="S") S BSTSRET=""
 . I MEXCT=0,(RTYPE="R")!(RTYPE="S") D
 .. S BSTSRET=CONC_U_PRET_U_PREID_U_RTYPE
 .. S MEXCT=1
 . ;
 . S BSTSCNT=BSTSCNT+1,BSTSRET(BSTSCNT)=CONC_U_PRET_U_PREID_U_RTYPE
 ;
 ;If exact match found, clear out array
 I BSTSRET]"" S ICNT="" F  S ICNT=$O(BSTSRET(ICNT)) Q:ICNT=""  K BSTSRET(ICNT)
 ;
 Q
 ;
RTERM(DESCID,NMID,BSTSRET) ;PEP - Return replacement term and concept for a term
 ;
 ;This routine accepts a Description ID and Namespace ID and returns a
 ;possible replacement if the term has been retired.
 ;
 ;Input:
 ;DESCID - Description ID
 ;NMID (Optional) - Namespace ID (36-SNOMED/1552-RxNorm) - Default to 36
 ;BSTSRET - Return variable array
 ;
 ;Output:
 ;
 ;If term and underlying concept are still active
 ;BSTSRET=Passed in Description ID [1]^Term of Passed in Description ID [2]
 ;        ^Concept ID of Passed in Term [3]
 ;
 ;If term is inactive but underlying concept is still active
 ;BSTSRET=Preferred Term Description ID of Underlying Concept [1]
 ;        ^Preferred Term of Underlying Concept [2]
 ;        ^Concept ID of Passed in Term [3]
 ;
 ;If both term and underlying concept are inactive it will try to identify an
 ;exact replacement concept. If one is found:
 ;1) It will first look for an exact match on the original term. If found:
 ;BSTSRET=New Description ID of Exact Term [1]^Exact Term [2]
 ;        ^Replacement Concept ID [3]
 ;2) If no exact match on original term is found:
 ;BSTSRET=Description ID of Preferred Term of Replacement Concept [1]^Preferred
 ;        Term of Replacement Concept [2]^Replacement Concept ID [3]
 ;
 ;If an exact replacement is not found but multiple replacements are:
 ;BSTSRET=""
 ;BSTSRET(#)=Possible Replacement (PR) Description ID [1]^PR Term [2]
 ;           ^PR Concept ID [3]^PR Type, where: PR Type = R - Replaced By, 
 ;           S - Same As, M - May be a [4]
 ;
 ;Sample call:
 ;>D RTERM^BSTSAPI(1908012,36,.RET) ZW RET
 ;RET="3301304017^Disease caused by Capripoxvirus^715052003"
 ;
 NEW STS,DTSID,CIEN,TIEN,RIEN,MEXCT,BSTSCNT,ICNT,RETR,VAR,TRY,MOD,OOD,NMIEN,LOC
 NEW OCONC,RCONC,CTERM
 ;
 ;Reset output
 S BSTSRET="" S ICNT="" F  S ICNT=$O(BSTSRET(ICNT)) Q:ICNT=""  K BSTSRET(ICNT)
 ;
 ;Quit if no concept or namespace ID passed in
 I $G(DESCID)="" Q
 S:$G(NMID)="" NMID=36
 ;
 ;Get internal codeset IEN
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) Q:NMIEN=""
 ;
 ;Get the TIEN, CIEN and DTSID
 S TIEN=$O(^BSTS(9002318.3,"D",NMIEN,DESCID,"")) Q:TIEN=""
 S CIEN=$$GET1^DIQ(9002318.3,TIEN_",",.03,"I") Q:CIEN=""
 S DTSID=$$GET1^DIQ(9002318.4,CIEN_",",".08","I") Q:DTSID=""
 S CTERM=$$GET1^DIQ(9002318.3,TIEN_",",1,"I")
 ;
 ;Make sure the term is up to date
 S OOD=$$GET1^DIQ(9002318.3,TIEN_",",".11","I")
 S LOC=1 I OOD="Y" S LOC=""
 F TRY=1:1:20 S STS=$$DTSLKP^BSTSAPI("VAR",DTSID_U_NMID_U_U_LOC) Q:(+STS=2)  I LOC=1,+STS=1 Q
 I '+STS Q
 ;
 ;Check if term and underlying concept are active
 S RETR=$$GET1^DIQ(9002318.3,TIEN_",",.07,"I")
 I (RETR="")!(RETR'<DT),($G(VAR(1,"XRDT"))="")!($G(VAR(1,"XRDT"))'<DT) D  Q
 . S BSTSRET=DESCID_U_CTERM_U_$G(VAR(1,"CON"))
 ;
 ;Check for inactive term, active concept
 I (RETR]""),RETR'>DT,($G(VAR(1,"XRDT"))="")!($G(VAR(1,"XRDT"))'<DT) D  Q
 . S BSTSRET=$G(VAR(1,"PRE","DSC"))_U_$G(VAR(1,"PRE","TRM"))_U_$G(VAR(1,"CON"))
 ;
 ;Checks for replacement concept
 ;
 S OCONC=$G(VAR(1,"CON")) Q:OCONC=""  ;Original Concept ID
 ;
 ;Look for replacement concept
 D RCONC(OCONC,NMID,.RCONC)
 ;
 ;Exact Replacement
 I $G(RCONC)]"" D  Q
 . NEW RCONCID,RVAR,STS,SYN
 . S RCONCID=$P(RCONC,U) Q:RCONCID=""
 . ;
 . ;Get information for replacement concept
 . S STS=$$CNCLKP^BSTSAPI("RVAR",RCONCID_U_NMID)
 . ;
 . ;Loop through synonyms looking for exact match
 . S SYN="" F  S SYN=$O(RVAR(1,"SYN",SYN)) Q:SYN=""  D  I BSTSRET]"" Q
 .. NEW RT
 .. S RT=$G(RVAR(1,"SYN",SYN,"TRM")) Q:RT=""
 .. I RT'=CTERM Q
 .. S BSTSRET=$G(RVAR(1,"SYN",SYN,"DSC"))_U_RT_U_RCONCID
 . ;
 . ;If not exact match use preferred
 . S BSTSRET=$G(RVAR(1,"PRE","DSC"))_U_$G(RVAR(1,"PRE","TRM"))_U_RCONCID
 ;
 ;Multiple Replacements
 I $O(RCONC(""))]"" D  Q
 . NEW RCNT,CNT
 . S RCNT="" F  S RCNT=$O(RCONC(RCNT)) Q:RCNT=""  D
 .. S CNT=$G(CNT)+1,BSTSRET(CNT)=$P(RCONC(RCNT),U,3)_U_$P(RCONC(RCNT),U,2)_U_$P(RCONC(RCNT),U)_U_$P(RCONC(RCNT),U,4)
 Q
 ;
PRINT(TAG,NMID) ;Print the report
 ;
 N %ZIS,ZTRTN,ZTIO,ZTDESC,ZTSAVE,ZTSK,POP
 S %ZIS="Q"
 I TAG["CONC" D
 . S %ZIS("A")="Print Inactive Concept Report on Device: ",ZTRTN="CONC^BSTSRPT"
 . S ZTDESC="Inactive Concept Report"
 I TAG["TERM" D
 . S %ZIS("A")="Print Inactive Terms Report on Device: ",ZTRTN="TERM^BSTSRPT"
 . S ZTDESC="Inactive Term Report"
 ;
 ;Prompt for device
 D ^%ZIS I $G(POP) Q
 ;
 ;Report queued
 I $D(IO("Q")) D  Q
 . S ZTIO=ION,ZTSAVE("NMID")="" D ^%ZTLOAD
 . W !!,$S($D(ZTSK):"Request queued!",1:"Unable to queue job.  Request cancelled!")
 . D ^%ZISC
 ;
 ;Print report
 U IO
 I TAG["CONC" D CONC
 I TAG["TERM" D TERM
 ;
 ;Close the device
 D ^%ZISC
 Q
 ;
REPL(CONCDA,GL) ;Update replacement concept information
 ;
 ;Called from UPDATE^BSTSDTS0
 ;
 I $G(CONCDA)="" Q 0
 I $G(GL)="" Q 0
 ;
 ;Clear out existing entries
 D
 . NEW REPCNT
 . S REPCNT=0 F  S REPCNT=$O(^BSTS(9002318.4,CONCDA,17,REPCNT)) Q:'REPCNT  D
 .. NEW DA,DIK
 .. S DA(1)=CONCDA,DA=REPCNT
 .. S DIK="^BSTS(9002318.4,"_DA(1)_",17," D ^DIK
 ;
 ;Now save Replacement Concepts
 I $D(@GL@("REP"))>1 D
 . ;
 . NEW REPCNT
 . S REPCNT="" F  S REPCNT=$O(@GL@("REP",REPCNT)) Q:REPCNT=""  D
 .. ;
 .. NEW DIC,DA,X,Y,IENS,DLAYGO,NODE,CONC,NMID,DTSID,IREV,OREV,NMIEN,RTYPE,BSTSC,ERROR
 .. S NODE=$G(@GL@("REP",REPCNT))
 .. ;
 .. ;Pull replacement information
 .. S CONC=$P(NODE,U) Q:CONC=""  ;Replacement concept
 .. S NMID=$P(NODE,U,2) Q:NMID=""  ;Namespace
 .. S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) Q:NMIEN=""
 .. S DTSID=$P(NODE,U,3) Q:DTSID=""  ;DTSID
 .. S IREV=$P(NODE,U,5) ;Revision In
 .. S OREV=$P(NODE,U,6) ;Revision Out
 .. S RTYPE=$P(NODE,U,7) ;Replacement Type
 .. S RTYPE=$S(RTYPE["SAME":"S",RTYPE["REPLACE":"R",RTYPE["MAY BE":"M",1:"") Q:RTYPE=""
 .. ;
 .. S DA(1)=CONCDA
 .. S DIC(0)="LX",DIC="^BSTS(9002318.4,"_DA(1)_",17,"
 .. S X=CONC
 .. S DLAYGO=9002318.417 D ^DIC
 .. ;
 .. ;Quit on fail
 .. I +Y<0 Q
 .. ;
 .. ;Save remaining fields
 .. S (DA)=+Y,IENS=$$IENS^DILF(.DA)
 .. S BSTSC(9002318.417,IENS,".02")=DTSID
 .. S BSTSC(9002318.417,IENS,".03")=RTYPE
 .. S BSTSC(9002318.417,IENS,".04")=NMIEN
 .. S BSTSC(9002318.417,IENS,".05")=$$DTS2FMDT^BSTSUTIL(IREV,1)
 .. S BSTSC(9002318.417,IENS,".06")=$$DTS2FMDT^BSTSUTIL(OREV,1)
 .. ;
 .. ;Save the information
 .. D FILE^DIE("","BSTSC","ERROR")
 ;
 Q
