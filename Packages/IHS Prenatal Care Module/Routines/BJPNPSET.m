BJPNPSET ;GDIT/HS/BEE-Prenatal Care Module Add/Edit Problem ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**3,6,7,8**;Feb 24, 2015;Build 25
 ;
 ;?P? [1] 29 Concept Id (R) [2] 29 Description Id (R) [3] 29 Provider Text (O) [4] 29 
 ;Mapped ICD (R) [5] 29 Location [6] 29 Date of Onset [7] 29
 ;IPL Status (R) [8] 29 Class [9] 29 Problem # [10] 29 
 ;Priority [11] 29 Inpatient_POV value (O) [12]
 ;?B? [1] 29 PIP Status (R) [2] 29 PIP Scope (R) [3] 29 PIP Priority (O) [4] 29 Definitive EDD (O) [5]
 ;?Q? [1] 29 TYPE (S/C) (R) [2] 29 IEN (for edits) (O) [3] 29 Concept Id of Entry (R) [4] 29
 ;User (null for new) [5] 29 Date/time (null for new) [6] 29 Delete flag (1 ? Delete, otherwise ? 0) (R) [7]
 ;
 Q
 ;
SET(DATA,DFN,PRBIEN,PIPIEN,VIEN,IARRAY) ;EP - BJPN SET PROBLEM
 ;
 ;This RPC adds/edits a PIP problem
 ;It also adds or updates the IPL problem entry, if necessary.
 ;
 ;Input parameters:
 ;     DFN - Patient IEN
 ;  PRBIEN - IEN of IPL, null if new
 ;  PIPIEN - IEN of PIP, null if new
 ;    VIEN - Visit IEN
 ;  IARRAY - Array of problem information - Records delimited by $c(28), fields by $c(29)
 ;                                        - (R) Required, (O) Optional
 ;Problem (IPL) entry (Required):
 ;?P? [1] 29 Concept Id (R) [2] 29 Description Id (R) [3] 29 Provider Text (O) [4] 29 
 ;Mapped ICD (R) [5] 29 Location (null for new) [6] 29 Date of Onset [7] 29
 ;IPL Status (R) [8] 29 Class [9] 29 Problem # [10] 29 
 ;Priority [11] 29 Inpatient_POV value (O) [12] 29 Laterality Attribute|Qualifier [13]
 ;
 ;Asthma
 ;"A"[1] 29 Classification [2] 29 Control (pass through value) [3] 29 V asthma IEN (pass through value) [4]
 ;
 ;Prenatal (PIP) entry (Required):
 ;?B? [1] 29 PIP Status (R) [2] 29 PIP Scope (R) [3] 29 PIP Priority (O) [4] 29 Definitive EDD (O) [5]
 ;
 ;Qualifier Entry or Entries (Optional):
 ;?Q? [1] 29 TYPE (S/C) (R) [2] 29 IEN (present for edits, null for new) (O) [3] 29 Concept Id of Entry (R) [4] 29
 ;User (null for new) [5] 29 Date/time (null for new) [6] 29 Delete flag (1 ? Delete, otherwise ? 0) (R) [7]
 ;
 ;Output value
 ;1^PRBIEN^PIPIEN - Success
 ;-1^^ERROR MESSAGE - Failure
 ;
 NEW UID,II,ENTRY,ECNT,PIECE,ARRAY,C8,C9,A,B,P,Q,%,LIST,RET,NEWIPL,EDD,ONSDT,LSTCNT
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPSET",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPSET D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define header
 S @DATA@(0)="I00001RESULT^I00010PRBIEN^I00010PIPIEN^T00200ERROR_MESSAGE"_$C(30)
 ;
 ;Get the current date/time
 D NOW^%DTC
 ;
 ;Check for input variables
 I $G(DFN)="" S BMXSEC="Invalid DFN" G XSET
 I $G(VIEN)="" S BMXSEC="Invalid VIEN" G XSET
 S PRBIEN=$G(PRBIEN)
 S PIPIEN=$G(PIPIEN)
 ;
 ;Parse the input array
 S (B,P)="",C8=$C(28),C9=$C(29)
 ;
 F ECNT=1:1:$L(IARRAY,C8) S ENTRY=$P(IARRAY,C8,ECNT) D
 . NEW ETYPE,IPRTY
 . S ETYPE=$P(ENTRY,C9)
 . ;
 . ;Set up problem entry
 . I ETYPE="P" D  Q
 .. NEW LOC,ONSET,CLASS,ISTS,PRBCNT
 .. S P="P"
 .. S $P(P,U,2)=$P(ENTRY,C9,2)  ;Concept Id
 .. S $P(P,U,3)=$P(ENTRY,C9,3)  ;Description Id
 .. S $P(P,U,4)=$P(ENTRY,C9,4)  ;Provider Text
 .. S $P(P,U,5)=$P(ENTRY,C9,5)  ;ICD Code
 .. ;
 .. ;Get the location
 .. S LOC="" I PRBIEN]"" S LOC=$$GET1^DIQ(9000011,PRBIEN_",",.06,"E")
 .. S:LOC="" LOC=$$GET1^DIQ(9000010,VIEN_",",".06","I")
 .. S $P(P,U,6)=LOC
 .. ;
 .. ;Convert the Date of Onset to internal
 .. S ONSDT=$P(ENTRY,C9,7) D:ONSDT]""
 ... NEW MONTH
 ... I ONSDT?4N S ONSDT="3"_$E(ONSDT,3,4)_"0000" Q  ;Year only
 ... I $L(ONSDT,"/")=2 D  Q  ;Month and Year
 .... S:$L($P(ONSDT,"/"))=1 ONSDT="0"_ONSDT
 .... S ONSDT="3"_$E($P(ONSDT,"/",2),3,4)_$P(ONSDT,"/")_"00" Q  ;Month/Year
 ... S:ONSDT]"" ONSDT=$$DATE^BJPNPRUT($P(ONSDT," "))
 .. S $P(P,U,7)=ONSDT
 .. ;
 .. ;IPL Status
 .. S ISTS=$P(ENTRY,C9,8)
 .. I ISTS="",PRBIEN]"" S ISTS=$$GET1^DIQ(9000011,PRBIEN_",",.12,"E")
 .. I ISTS="" S ISTS="Episodic"
 .. S $P(P,U,8)=ISTS
 .. ;
 .. ;If existing problem, get CLASS
 .. S CLASS=$P(ENTRY,C9,9)
 .. I CLASS="",PRBIEN]"",PIPIEN="" S CLASS=$$GET1^DIQ(9000011,PRBIEN_",",.04,"I")
 .. I CLASS="",PIPIEN]"" S CLASS="@"
 .. S $P(P,U,9)=CLASS
 .. ;
 .. ;Problem number - Get the next one if not an edit
 .. S PRBCNT=$P(P,U,1) S:PRBCNT["-" PRBCNT=+$P(PRBCNT,"-",2)
 .. I PRBCNT="",PRBIEN]"" S PRBCNT=$$GET1^DIQ(9000011,PRBIEN_",",.07,"I")
 .. I PRBCNT="" D
 ... NEW RET
 ... D NEXTID^BGOPROB(.RET,DFN)
 ... S PRBCNT=+$P(RET,"-",2)
 .. S $P(P,U,10)=PRBCNT
 .. ;
 .. ;IPL Priority
 .. S IPRTY=$P(ENTRY,C9,11)
 .. I IPRTY="",PRBIEN]"" D
 ... NEW PRIEN
 ... S PRIEN=$O(^BGOPROB("B",PRBIEN,"")) Q:PRIEN=""
 ... S IPRTY=$$GET1^DIQ(90362.22,PRIEN_",",.02,"I")
 .. S:IPRTY="" IPRTY=0
 .. S $P(P,U,11)=IPRTY
 .. ;
 .. ;BJPN*2.0*7;Added laterality
 .. S $P(P,U,13)=$P(ENTRY,C9,13)
 .. ;
 .. ;Inpatient Dx
 .. S $P(P,U,12)=$S($P(ENTRY,C9,12)="Y":1,1:0)
 . ;
 . ;Set up PIP entry
 . I ETYPE="B" D  Q
 .. S B=$TR(ENTRY,C9,"^")
 . ;
 . ;Set up Asthma entry
 . I ETYPE="A" D  Q
 .. S A=$TR(ENTRY,C9,"^")
 . ;
 . ;Define qualifiers
 . I ETYPE="Q" D  Q
 .. S Q=$G(Q)+1
 .. S Q(Q)=$TR(ENTRY,C9,"^")
 .. S:$P(Q(Q),U,5)="" $P(Q(Q),U,5)=DUZ
 .. S:$P(Q(Q),U,6)="" $P(Q(Q),U,6)=%
 ;
 ;Set up the array
 I P="" S BMXSEC="Missing IPL problem entry" G XSET
 I B="" S BMXSEC="Missing PIP problem entry" G XSET
 ;
 ;Convert the DEDD to internal
 ;S EDD=$P(B,U,5)  ;Always pull from reproductive factors
 S EDD=$$GET1^DIQ(9000017,DFN_",",1311,"I") I 1
 E  I EDD]"" S EDD=$$DATE^BJPNPRUT(EDD)
 S $P(B,U,5)=EDD
 ;
 S LSTCNT=0
 S LIST(0)=P
 I $G(A)]"" S LSTCNT=LSTCNT+1,LIST(LSTCNT)=A
 S Q="" F  S Q=$O(Q(Q)) Q:Q=""  S LSTCNT=LSTCNT+1,LIST(LSTCNT)=Q(Q)
 ;
 ;File the IPL entry
 ;
 ;New problem
 S NEWIPL=0
 I PRBIEN="" D  I $G(BMXSEC)]"" G XSET
 . ;
 . ;Log the IPL problem
 . S NEWIPL=1
 . D SET^BGOPROB(.RET,DFN,"",VIEN,.LIST)
 . I +RET S PRBIEN=+RET
 . ;
 . ;Now log the PIP problem
 . I +RET S RET=$$ADDPIP(DFN,+RET,B)
 . I +RET S PIPIEN=+RET
 ;
 ;Existing problem
 I 'NEWIPL D  I $G(BMXSEC)]"" G XSET
 . ;
 . ;Edit the problem
 . NEW RES1
 . D EDIT^BGOPROB1(.RET,DFN,PRBIEN,VIEN,.LIST)
 . I '$P(P,U,12) S RES1="" D HOSP^BGOHOS(.RES1,PRBIEN,VIEN,1) ;Remove inpatient checkbox if necessary
 . ;
 . ;If a new PIP entry, log it
 . I '+$G(PIPIEN) D  Q
 .. S RET=$$ADDPIP(DFN,PRBIEN,B)
 .. I +RET S PIPIEN=+RET
 . ;
 . ;If not a new PIP entry, perform edit
 . I +$G(PIPIEN) D  Q
 .. S RET=$$EDTPIP(PRBIEN,PIPIEN,B)
 ;
 ;Update the IPL PIP column
 I PRBIEN]"" D
 . NEW PRBUPD,ERROR,PIP
 . S PIP=$$GET1^DIQ(9000011,PRBIEN_",",.19,"I")
 . I PIP=$S($P(B,U,2)="A":1,1:"") Q   ;Skip if already the same value
 . S PRBUPD(9000011,PRBIEN_",",".19")=$S($P(B,U,2)="A":1,1:"@")
 . D FILE^DIE("","PRBUPD","ERROR")
 ;
 ;Assemble return piece
 I +$G(PRBIEN),+$G(PIPIEN) S RET="1^"_PRBIEN_U_PIPIEN
 E  S RET="-1^^Unable to create new IPL/PIP entry"
 S II=II+1,@DATA@(II)=RET_$C(30)
 ;
 ;Broadcast update
 ;D FIREEV^BJPNPDET("","REFRESH")
 ;BJPN*2.0*6;Do not fire since event fired from within EHR API
 ;D FIREEV^BJPNPDET("","PCC."_DFN_".PPL")
 ;D FIREEV^BJPNPDET("","PCC."_DFN_".PIP")
 ;
XSET S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ADDPIP(DFN,PRBIEN,B) ;EP - Add PIP entry
 ;
 NEW %,DA,IENS,DIC,DLAYGO,X,Y,LASTIEN,NEXTIEN,BJPNPIP,ERROR,PIPIEN,BJPNPIPF
 ;
 ;Get current date/time
 D NOW^%DTC
 ;
 ;Lock the header so duplicates aren't logged
 L +^BJPNPL(0):2 I '$T S BMXSEC="Could not lock header node" Q -1
 ;
 ;Get the next available IEN
 S LASTIEN=$O(^BJPNPL("A"),-1) I 'LASTIEN S ^BJPNPL(0)="BJPN PRENATAL PROBLEMS^90680.01I^"
 F NEXTIEN=LASTIEN+1:1 I '$D(^BJPNPL(NEXTIEN)) D LOCK^DILF("^BJPNPL(NEXTIEN)") I  Q:'$D(^BJPNPL(NEXTIEN))  L -^BJPNPL(NEXTIEN)
 ;
 ;Add new entry
 S DIC="^BJPNPL("
 S DLAYGO=90680.01,DIC(0)="LOX"
 S X=NEXTIEN
 K DO,DD D FILE^DICN
 ;
 ;Unlock header
 L -^BJPNPL(0)
 ;
 ;BJPN*2.0*7;Unlock entry
 L -^BJPNPL(NEXTIEN)
 ;
 ;Quit if filing issue
 I +Y=-1 S BMXSEC="Could not add new PIP entry" Q -1
 ;
 S PIPIEN=+Y
 ;
 ;File the PIP related entries
 S BJPNPIP(90680.01,PIPIEN_",",.02)=DFN        ;DFN
 S BJPNPIP(90680.01,PIPIEN_",",.06)=$P(B,U,4)  ;Priority
 S BJPNPIP(90680.01,PIPIEN_",",.07)=$P(B,U,3)  ;Scope
 S BJPNPIP(90680.01,PIPIEN_",",.08)=$P(B,U,2)  ;Status
 S BJPNPIP(90680.01,PIPIEN_",",.09)=$P(B,U,5)  ;DEDD
 S BJPNPIP(90680.01,PIPIEN_",",.1)=PRBIEN      ;IPL IEN
 D FILE^DIE("","BJPNPIP","ERROR")
 I $D(ERROR) S BMXSEC="Could not add values to new PIP entry" Q -1
 ;
 ;Add the IPL PIP flag
 S DIC="^BJPNPL("_PIPIEN_",5,"
 S DA(1)=PIPIEN
 S DLAYGO="90680.015",DIC("P")=$P(^DD(90680.01,5,0),U,2),DIC(0)="LOX"
 S X=%
 K DO,DD D FILE^DICN
 I +Y=-1 S BMXSEC="Could not add PIP column history" Q -1
 ;
 ;Add the User/PIP value
 S DA(1)=PIPIEN,DA=+Y,IENS=$$IENS^DILF(.DA)
 S BJPNPIPF(90680.015,IENS,".02")=$S($P(B,U,2)="A":1,1:0)
 S BJPNPIPF(90680.015,IENS,".03")=DUZ
 D FILE^DIE("","BJPNPIPF","ERROR")
 I $D(ERROR) S BMXSEC="Could not add PIP column history fields" Q -1
 Q PIPIEN
 ;
EDTPIP(PRBIEN,PIPIEN,B) ;EP - Edit PIP entry
 ;
 NEW %,BJPNPIP,ERROR,STATUS,SCOPE,DEDD,PRI,PIP
 ;
 ;Get current date/time
 D NOW^%DTC
 ;
 ;Get current values
 S PRI=$$GET1^DIQ(90680.01,PIPIEN_",",.06,"I")
 S SCOPE=$$GET1^DIQ(90680.01,PIPIEN_",",.07,"I")
 S STATUS=$$GET1^DIQ(90680.01,PIPIEN_",",".08","I")
 S DEDD=$$GET1^DIQ(90680.01,PIPIEN_",",.09,"I")
 S PIP=$$GET1^DIQ(9000011,PRBIEN_",",.19,"I"),PIP=$S(PIP="1":"A",1:"I")
 ;
 ;File the PIP related entries
 S:PRI'=$P(B,U,4) BJPNPIP(90680.01,PIPIEN_",",.06)=$P(B,U,4)  ;Priority
 S:SCOPE'=$P(B,U,3) BJPNPIP(90680.01,PIPIEN_",",.07)=$P(B,U,3)  ;Scope
 S:STATUS'=$P(B,U,2) BJPNPIP(90680.01,PIPIEN_",",.08)=$P(B,U,2)  ;Status
 S:DEDD'=$P(B,U,5) BJPNPIP(90680.01,PIPIEN_",",.09)=$P(B,U,5)  ;DEDD
 I $D(BJPNPIP)>9 D FILE^DIE("","BJPNPIP","ERROR")
 I $D(ERROR) S BMXSEC="Could not update values to new PIP entry" Q -1
 ;
 ;Update the IPL PIP flag if the status changed
 I $P(B,U,2)'=PIP D  I $G(BMXSEC)]"" Q -1
 . NEW DIC,DA,DLAYGO,X,Y,BJPNPIPF,ERROR,IENS
 . S DIC="^BJPNPL("_PIPIEN_",5,"
 . S DA(1)=PIPIEN
 . S DLAYGO="90680.015",DIC("P")=$P(^DD(90680.01,5,0),U,2),DIC(0)="LOX"
 . S X=%
 . K DO,DD D FILE^DICN
 . I +Y=-1 S BMXSEC="Could not add PIP column history" Q
 . ;
 . ;Add the User/PIP value
 . S DA(1)=PIPIEN,DA=+Y,IENS=$$IENS^DILF(.DA)
 . S BJPNPIPF(90680.015,IENS,".02")=$S($P(B,U,2)="A":1,1:0)
 . S BJPNPIPF(90680.015,IENS,".03")=DUZ
 . D FILE^DIE("","BJPNPIPF","ERROR")
 . I $D(ERROR) S BMXSEC="Could not add PIP column history fields"
 Q PIPIEN
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S II=II+1,@DATA@(II)=$C(31)
 Q
