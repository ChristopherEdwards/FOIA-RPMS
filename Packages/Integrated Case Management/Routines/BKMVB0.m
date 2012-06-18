BKMVB0 ;PRXM/HC/CJS - Patient Record HAART Data ; 20 Jul 2005  4:40 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
EN ; EP - Main entry point for BKMV UPD1 HAART
 ; Assumes existence of BKMPRIV. BKMPRIV should not be killed here.
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$D(^BKM(90450,HIVIEN,11,"B",DUZ)) Q
 K ^TMP("BKMVB0",$J)
 D EN^VALM("BKMV UPD1 HAART")
 Q
 ;
HDR ; -- header code
 ;N DA,IENS,SITE
 ;S DA=$G(DUZ(2)),IENS=$$IENS^DILF(.DA),SITE=$$GET1^DIQ(4,IENS,.01,"E")
 ;S VALMHDR(1)=$$PAD^BKMIXX4("",">"," ",(80-$L(SITE)+2)\2)_"["_$G(SITE)_"]"
 ;S VALMHDR(2)=$G(RCRDHDR)
 D HDR^BKMVA51
 Q
 ;
INIT ; -- init variables and list array - called from list template BKMV UPD1 HAART
 S VALMCNT=0,VALMPGE=1,VALMAR="^TMP(""BKMVB0"","_$J_",""DISPLAY"")",VALM0=""
 D GETALL($G(DFN))
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BKMVB0",$J)
 K RCRDHDR,VALM0,VALMAR,VALMHDR,VALMCNT,VALMPGE
 Q
 ;
EXPND ; -- expand code
 Q
 ;
GETALL(DFN) ;get patient HAART information
 N DA2,DA1,HAARTDT,DA0,DA,HIENS,BKMIDT,BKMEDT,BKMSTS
 N BKMDATA,BKMTYPE,TEXT,BKMNOT,BKMCMT,BKMCTR
 S DA2=$$BKMIEN^BKMIXX3(DFN)
 Q:DA2=""
 S DA1=$$BKMREG^BKMIXX3(DA2)
 Q:DA1=""
 ; Identify HAART Appropriate Data
 S HAARTDT=""
 F  S HAARTDT=$O(^BKM(90451,DA2,1,DA1,40,"B",HAARTDT)) Q:HAARTDT=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90451,DA2,1,DA1,40,"B",HAARTDT,DA0)) Q:DA0=""  D
 . . D ^XBFMK
 . . S DA(2)=DA2,DA(1)=DA1,DA=DA0
 . . S HIENS=$$IENS^DILF(.DA)
 . . S BKMIDT=$$GET1^DIQ(90451.03,HIENS,".01","I") I BKMIDT="" Q
 . . ;PRXM/HC/BHS - 11/01/2005 - Modify external display format
 . . ;S BKMEDT=$$GET1^DIQ(90451.03,HIENS,".01","E")
 . . S BKMEDT=$$FMTE^XLFDT(BKMIDT\1,"1")
 . . S BKMSTS=$$GET1^DIQ(90451.03,HIENS,"1","E")
 . . S BKMNOT=$$GET1^DIQ(90451.03,HIENS,"2","E")
 . . S BKMCMT=$$GET1^DIQ(90451.03,HIENS,"3","E")
 . . S BKMCTR=+$G(^TMP("BKMVB0",$J,"SORT BY DATE",BKMIDT,0))+1
 . . S ^TMP("BKMVB0",$J,"SORT BY DATE",BKMIDT,0)=BKMCTR
 . . S ^TMP("BKMVB0",$J,"SORT BY DATE",BKMIDT,BKMCTR)="A"_U_BKMEDT_U_BKMSTS_U_BKMCMT_U_BKMNOT
 ; Identify HAART Compliance Data
 S HAARTDT=""
 F  S HAARTDT=$O(^BKM(90451,DA2,1,DA1,50,"B",HAARTDT)) Q:HAARTDT=""  D
 . S DA0=""
 . F  S DA0=$O(^BKM(90451,DA2,1,DA1,50,"B",HAARTDT,DA0)) Q:DA0=""  D
 . . D ^XBFMK
 . . S DA(2)=DA2,DA(1)=DA1,DA=DA0
 . . S HIENS=$$IENS^DILF(.DA)
 . . S BKMIDT=$$GET1^DIQ(90451.07,HIENS,".01","I") I BKMIDT="" Q
 . . ;PRXM/HC/BHS - 11/01/2005 - Modify external display format
 . . ;S BKMEDT=$$GET1^DIQ(90451.07,HIENS,".01","E")
 . . S BKMEDT=$$FMTE^XLFDT(BKMIDT\1,"1")
 . . S BKMSTS=$$GET1^DIQ(90451.07,HIENS,"1","E")
 . . S BKMCMT=$$GET1^DIQ(90451.07,HIENS,"2","E")
 . . S BKMCTR=+$G(^TMP("BKMVB0",$J,"SORT BY DATE",BKMIDT,0))+1
 . . S ^TMP("BKMVB0",$J,"SORT BY DATE",BKMIDT,0)=BKMCTR
 . . S ^TMP("BKMVB0",$J,"SORT BY DATE",BKMIDT,BKMCTR)="C"_U_BKMEDT_U_BKMSTS_U_BKMCMT
 ;
 ; Build HAART Appropriate/Compliance Display
 S HAARTDT=""
 F  S HAARTDT=$O(^TMP("BKMVB0",$J,"SORT BY DATE",HAARTDT),-1) Q:HAARTDT=""  D
 . S DA0=0
 . F  S DA0=$O(^TMP("BKMVB0",$J,"SORT BY DATE",HAARTDT,DA0)) Q:DA0=""  D
 . . S BKMDATA=$G(^TMP("BKMVB0",$J,"SORT BY DATE",HAARTDT,DA0))
 . . ; Appropriate/Compliance
 . . S BKMTYPE=$S($P(BKMDATA,U,1)="A":"Appropriate",1:"Compliance")
 . . S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,"")
 . . ;S TEXT="HAART "_BKMTYPE_":"_$S($P(BKMDATA,U,1)="A":" ",1:"  ")_BKMTYPE_$S($P(BKMDATA,U,1)="A":" ",1:"  ")_"  Date: "_$P(BKMDATA,U,2)
 . . S TEXT="HAART "_BKMTYPE_":"_$S($P(BKMDATA,U,1)="A":" ",1:"  ")_$$PAD^BKMIXX4($P(BKMDATA,U,3),">"," ",19)_"  Date: "_$P(BKMDATA,U,2)
 . . S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 . . I $P(BKMDATA,U,5)'="" D
 . . . S TEXT=$$PAD^BKMIXX4("Reason: ",">"," ",19)_$P(BKMDATA,U,5)
 . . . S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 . . I $P(BKMDATA,U,4)'="" D
 . . . S TEXT=$$PAD^BKMIXX4("Comment: ",">"," ",19)_$P(BKMDATA,U,4)
 . . . S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 Q
 ;
EDITMAIN ; Add a new HAART APPROPRIATE entry for patient
 N DA0,DA1,DA2,BKMDT,BKMSTS,IENS
 D ^XBFMK
 D FULL^VALM1
 S (DA2,DA(2))=$$BKMIEN^BKMIXX3(DFN)
 Q:DA(2)=""
 S (DA1,DA(1))=$$BKMREG^BKMIXX3(DA(2))
 Q:DA(1)=""
 ; Check editing rights
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 ; Default to today's date for prompt
 S X=DT
 S DIC="^BKM(90451,"_DA(2)_",1,"_DA(1)_",40,"
 S DIC(0)="L"
 ; Select existing or add new entry
 D FILE^DICN
 I Y=-1 G EDITMX
 ; Edit HAART appropriate fields in subfile
 S DIE=DIC
 K DIC
 ; Internal entry number of subentry chosen
 S (DA,DA0)=+Y
 S DR="1HAART Appropriate~;I X'=""N"" S Y=.01;2HAART Not Appropriate Reason~;.01HAART Appropriate Date~;3HAART Appropriate Comment~"
 ;L +^BKM(90451,DA2,1,DA1,40,DA):0 I '$T D EN^DDIOL("Another user is editing this entry.") H 2 G EDITMX
 D ^DIE
 ;L -^BKM(90451,DA2,1,DA1,40,DA)
 ;
 K DA
 S DA=DA0,DA(1)=DA1,DA(2)=DA2,IENS=$$IENS^DILF(.DA)
 S BKMDT=$$GET1^DIQ(90451.03,IENS,".01","I")
 S BKMSTS=$$GET1^DIQ(90451.03,IENS,"1","I")
 I BKMDT=""!(BKMSTS="") D  G EDITMX
 . K DA
 . S DA=DA0,DA(1)=DA1,DA(2)=DA2
 . S DIK="^BKM(90451,"_DA(2)_",1,"_DA(1)_",40,"
 . D ^DIK
 . W " *** Required field(s) missing, entry deleted! ***" H 1
EDITMX ; EDITMAIN exit logic
 K ^TMP("BKMVB0",$J)
 D INIT
 D ^XBFMK
 Q
 ;
EDITCOMP ; Add a new HAART COMPLIANCE entry for the patient
 N DA0,DA1,DA2,BKMDT,BKMSTS,IENS
 D ^XBFMK
 D FULL^VALM1
 S (DA2,DA(2))=$$BKMIEN^BKMIXX3(DFN)
 Q:DA(2)=""
 S (DA1,DA(1))=$$BKMREG^BKMIXX3(DA(2))
 Q:DA(1)=""
 ; Check editing rights
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 ; Default to today's date for prompt
 S X=DT
 S DIC="^BKM(90451,"_DA(2)_",1,"_DA(1)_",50,"
 S DIC(0)="L"
 ; Select existing or add new entry
 D FILE^DICN
 I Y=-1 G EDITCX
 ; Edit HAART compliance fields in subfile
 S DIE=DIC
 K DIC
 ; Internal entry number of subentry chosen
 S (DA,DA0)=+Y
 S DR="1HAART Compliant~;.01HAART Compliance Date~;2HAART Compliance Comment~"
 ;L +^BKM(90451,DA2,1,DA1,50,DA):0 I '$T D EN^DDIOL("Another user is editing this entry.") H 2 G EDITCX
 D ^DIE
 ;L -^BKM(90451,DA2,1,DA1,50,DA)
 ;
 K DA
 S DA=DA0,DA(1)=DA1,DA(2)=DA2,IENS=$$IENS^DILF(.DA)
 S BKMDT=$$GET1^DIQ(90451.07,IENS,".01","I")
 S BKMSTS=$$GET1^DIQ(90451.07,IENS,"1","I")
 I BKMDT=""!(BKMSTS="") D  G EDITCX
 . K DA
 . S DA=DA0,DA(1)=DA1,DA(2)=DA2
 . S DIK="^BKM(90451,"_DA(2)_",1,"_DA(1)_",50,"
 . D ^DIK
 . W " *** Required field(s) missing, entry deleted! ***" H 1
EDITCX ; EDITCOMP exit logic
 K ^TMP("BKMVB0",$J)
 D INIT
 D ^XBFMK
 Q
 ;
DELAPP ; Delete a HAART APPROPRIATE entry for patient
 N DA0,DA1,DA2,IENS,BKMDESC,BKMVB0,BKMVB0E
 D ^XBFMK
 D FULL^VALM1
 S (DA2,DA(2))=$$BKMIEN^BKMIXX3(DFN)
 Q:DA(2)=""
 S (DA1,DA(1))=$$BKMREG^BKMIXX3(DA(2))
 Q:DA(1)=""
 ; Check editing rights
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 ; Select an entry
 S DIC="^BKM(90451,"_DA(2)_",1,"_DA(1)_",40,"
 S DIC(0)="QAEV"
 S DIC("A")="Select HAART Appropriate Date: "
 S DIC("W")="D DICW^BKMVB0"
 D ^DIC
 I Y=-1 G DELAPPX
 ; Confirm delete HAART appropriate fields in subfile
 S (DA,DA0)=+$P(Y,U)
 S IENS=$$IENS^DILF(.DA)
 D GETS^DIQ(90451.03,IENS,".01;1;2;3","E","BKMVB0","BKMVB0E")
 ;
 S BKMDESC=""
 I $G(BKMVB0(90451.03,IENS,.01,"E"))'="" S BKMDESC=$G(BKMVB0(90451.03,IENS,.01,"E"))
 I $G(BKMVB0(90451.03,IENS,1,"E"))'="" S BKMDESC=BKMDESC_" ("_$G(BKMVB0(90451.03,IENS,1,"E"))
 I $G(BKMVB0(90451.03,IENS,2,"E"))'="" S BKMDESC=BKMDESC_", "_$G(BKMVB0(90451.03,IENS,2,"E"))
 I $G(BKMVB0(90451.03,IENS,3,"E"))'="" S BKMDESC=BKMDESC_", "_$G(BKMVB0(90451.03,IENS,3,"E"))
 I BKMDESC["(" S BKMDESC=BKMDESC_")"
 ; Confirm deletion
 I '$$YNP^BKMVA1B("Confirm deletion of "_BKMDESC,"NO") G DELAPPX
 K DA
 S DA=DA0,DA(1)=DA1,DA(2)=DA2
 S DIK="^BKM(90451,"_DA(2)_",1,"_DA(1)_",40,"
 D ^DIK
DELAPPX ; DELAPP exit logic
 K ^TMP("BKMVB0",$J)
 D INIT
 D ^XBFMK
 Q
 ;
DELCOM ; Delete a HAART COMPLIANCE entry for patient
 N DA0,DA1,DA2,IENS,BKMDESC,BKMVB0,BKMVB0E
 D ^XBFMK
 D FULL^VALM1
 S (DA2,DA(2))=$$BKMIEN^BKMIXX3(DFN)
 Q:DA(2)=""
 S (DA1,DA(1))=$$BKMREG^BKMIXX3(DA(2))
 Q:DA(1)=""
 ; Check editing rights
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 ; Select an entry
 S DIC="^BKM(90451,"_DA(2)_",1,"_DA(1)_",50,"
 S DIC(0)="QAEV"
 S DIC("A")="Select HAART Compliance Date: "
 S DIC("W")="D DICW^BKMVB0"
 D ^DIC
 I Y=-1 G DELAPPX
 ; Confirm delete HAART compliance fields in subfile
 S (DA,DA0)=+$P(Y,U)
 S IENS=$$IENS^DILF(.DA)
 D GETS^DIQ(90451.07,IENS,".01;1","E","BKMVB0","BKMVB0E")
 ;
 S BKMDESC=""
 I $G(BKMVB0(90451.07,IENS,.01,"E"))'="" S BKMDESC=$G(BKMVB0(90451.07,IENS,.01,"E"))
 I $G(BKMVB0(90451.07,IENS,1,"E"))'="" S BKMDESC=BKMDESC_" ("_$G(BKMVB0(90451.07,IENS,1,"E"))
 I BKMDESC["(" S BKMDESC=BKMDESC_")"
 ; Confirm deletion
 I '$$YNP^BKMVA1B("Confirm deletion of "_BKMDESC,"NO") G DELAPPX
 K DA
 S DA=DA0,DA(1)=DA1,DA(2)=DA2
 S DIK="^BKM(90451,"_DA(2)_",1,"_DA(1)_",50,"
 D ^DIK
DELCOMX ; DELCOM exit logic
 K ^TMP("BKMVB0",$J)
 D INIT
 D ^XBFMK
 Q
 ;
DICW ;EP - This is a specially written FileMan 'WRITE' statement
 N BKMNODE,BKMSTS,BKMSTSI,BKMCMT,BKMOTH,BKMOTHI
 S BKMNODE=$G(^(0))
 S BKMSTSI=$P(BKMNODE,U,2)
 S (BKMSTS,BKMOTH)=""
 I DIC[",40," D
 . I BKMSTSI'="" S BKMSTS=$$CODEDESC^BKMVFLD(90451.03,1,BKMSTSI)
 . I BKMSTSI="N" S BKMOTHI=$P(BKMNODE,U,3)  I BKMOTHI'="" S BKMOTH=$$CODEDESC^BKMVFLD(90451.03,2,BKMOTHI)
 . S BKMCMT=$P(BKMNODE,U,4)
 E  D
 . I BKMSTSI'="" S BKMSTS=$$CODEDESC^BKMVFLD(90451.07,1,BKMSTSI)
 . S BKMCMT=$P(BKMNODE,U,3)
 W ?20,BKMSTS," "
 I BKMOTH'="" W !,?20,BKMOTH
 I BKMCMT'="" W !,?20,BKMCMT
 Q
 ;
 ;
