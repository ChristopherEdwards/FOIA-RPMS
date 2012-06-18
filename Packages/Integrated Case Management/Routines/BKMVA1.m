BKMVA1 ;PRXM/HC/CJS - HMS PATIENT REGISTER; [ 1/19/2005 7:16 PM ] ; 21 Jul 2005  12:25 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ; Entry point will calculate reminders.
EN ;  EP - Entry point for BKMV R/E Patient Record
 N HIVIEN,BKMPRIV,BKMIEN,BKMREG,BKMTMP
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) W !,"You are not a valid HMS user." H 2 Q
 S BKMPRIV=$$BKMPRIV^BKMIXX3(DUZ)
 ;
 K ^TMP("BKMVA1",$J)
 F  Q:'$$GETPAT^BKMVA1A()  D
 . S HIVIEN=$$HIVIEN^BKMIXX3()
 . I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 . S BKMPRIV=$$BKMPRIV^BKMIXX3(DUZ)
 . ; Builds ^TMP("BKMLKP",$J) for patient info and sets DFN
 . D BASETMP^BKMIXX3(DFN)
 . S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 . I BKMIEN="" W !,"There is no register entry for this patient." Q
 . S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 . I BKMREG="" W !,"There is no HMS registry entry for this patient." Q
 . ; Pre-edit audit capture
 . D EN^BKMVAUD
 . I BKMPRIV,$$MSNGDATA^BKMVA1A(DFN,HIVIEN),$$YNP^BKMVA1B("Do you want to add missing registry data at this time","NO") D  D PROMPTS^BKMVA1B(DFN,1)
 .. I $$EXISTHDC^BKMVA1A(DFN,HIVIEN),$$EXISTIHD^BKMVA1A(DFN,HIVIEN),$$EXISTIAD^BKMVA1A(DFN,HIVIEN) Q
 .. D LDREC
 . I $D(DIRUT) D POST^BKMVAUD Q
 . I '$$GETALL(DFN,1) W !,"No Patient entered or Patient Not In Register" S BKMTMP=$$PAUSE^BKMIXX3 Q
 . D ^XBFMK,EN^VALM("BKMV R/E PATIENT RECORD")
 . K ^TMP("BKMVA1",$J)
 . S:$G(DFN)="" DFN=$G(^TMP("BKMLKP",$J))
 . S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 . I BKMIEN="" W !,"There is no register entry for this patient." Q
 . S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 . I BKMREG="" W !,"There is no HMS registry entry for this patient." Q
 . ; Post-edit audit capture
 . D ^XBFMK,POST^BKMVAUD
 . K BKMVA1,BKMVA1E,DFN,X,Y,AGE,DOB,PNT,HRN,RID,ADD1,PHONE,RES,CRBY,CRDT,CRTM,EDBY,EDDT,EDTM,STAT,STATDT,STATCOM,ET
 K BKMVA1,BKMVA1E,DFN,X,Y,AGE,DOB,PNT,HRN,RID,ADD1,PHONE,RES,CRBY,CRDT,CRTM,EDBY,EDDT,EDTM,STAT,STATDT,STATCOM,ET
 K ^TMP("BKMVA2R",$J)
 Q
 ;
EN2(DFN,AGE,SEX,DOB,PNT) ; EP - Main entry point for BKMV R/E Patient Record
 N HIVIEN,BKMPRIV,BKMIEN,BKMREG,BKMTMP
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) W !,"You are not a valid HMS user." Q
 S BKMPRIV=$$BKMPRIV^BKMIXX3(DUZ)
 ;
 K ^TMP("BKMVA1",$J)
 ; Builds ^TMP("BKMLKP",$J) for patient info and sets DFN
 D BASETMP^BKMIXX3(DFN)
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 I BKMIEN="" W !,"There is no register entry for this patient." Q
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 I BKMREG="" W !,"There is no HMS registry entry for this patient." Q
 ; Pre-edit audit capture
 D EN^BKMVAUD
 I BKMPRIV,$$MSNGDATA^BKMVA1A(DFN,HIVIEN),$$YNP^BKMVA1B("Do you want to add missing registry data at this time","NO") D  D PROMPTS^BKMVA1B(DFN,1)
 . I $$EXISTHDC^BKMVA1A(DFN,HIVIEN),$$EXISTIHD^BKMVA1A(DFN,HIVIEN),$$EXISTIAD^BKMVA1A(DFN,HIVIEN) Q
 . D LDREC
 I $D(DIRUT) D POST^BKMVAUD Q
 ;
 I '$$GETALL(DFN,1) W !,"No Patient entered or Patient Not In Register" S BKMTMP=$$PAUSE^BKMIXX3 Q
 D EN^VALM("BKMV R/E PATIENT RECORD")
 K ^TMP("BKMVA1",$J)
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 I BKMIEN="" W !,"There is no register entry for this patient." Q
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 I BKMREG="" W !,"There is no HMS registry entry for this patient." Q
 ; Post-edit audit capture
 D POST^BKMVAUD
 K BKMVA1,BKMVA1E,DFN,X,Y,AGE,DOB,PNT,HRN,RID,ADD1,PHONE,RES,CRBY,CRDT,CRTM,EDBY,EDDT,EDTM,STAT,STATDT,STATCOM
 K ^TMP("BKMVA2R",$J)
 Q
 ;
EN3 ; -- main entry point for BKMV R/E Patient Record. The Following entry point will not calculate reminders.
 K BKMVA1,BKMVA1E,DFN,X,Y,AGE,DOB,PNT,HRN,RID,ADD1,PHONE,RES,CRBY,CRDT,CRTM,EDBY,EDDT,EDTM,STAT,STATDT,STATCOM
 N HIVIEN,BKMPRIV,BKMIEN,BKMREG,BKMTMP
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) W !,"You are not a valid HMS user." Q
 S BKMPRIV=$$BKMPRIV^BKMIXX3(DUZ)
 ;
 K ^TMP("BKMVA1",$J)
 F  Q:'$$GETPAT^BKMVA1A()  D
 . S HIVIEN=$$HIVIEN^BKMIXX3()
 . I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 . S BKMPRIV=$$BKMPRIV^BKMIXX3(DUZ)
 . ; Builds ^TMP("BKMLKP",$J) for patient info and sets DFN
 . D BASETMP^BKMIXX3(DFN)
 . S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 . I BKMIEN="" W !,"There is no register entry for this patient." Q
 . S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 . I BKMREG="" W !,"There is no HMS registry entry for this patient." Q
 . ; Pre-edit audit capture
 . D EN^BKMVAUD
 . I BKMPRIV,$$MSNGDATA^BKMVA1A(DFN,HIVIEN),$$YNP^BKMVA1B("Do you want to add missing registry data at this time","NO") D  D PROMPTS^BKMVA1B(DFN,1)
 .. I $$EXISTHDC^BKMVA1A(DFN,HIVIEN),$$EXISTIHD^BKMVA1A(DFN,HIVIEN),$$EXISTIAD^BKMVA1A(DFN,HIVIEN) Q
 .. D LDREC
 . I $D(DIRUT) D POST^BKMVAUD Q
 . I '$$GETALL(DFN,0) W !,"No Patient entered or Patient Not In Register" S BKMTMP=$$PAUSE^BKMIXX3 Q
 . D EN^VALM("BKMV R/E PATIENT RECORD")
 . K ^TMP("BKMVA1",$J)
 . S:$G(DFN)="" DFN=$G(^TMP("BKMLKP",$J))
 . S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 . I BKMIEN="" W !,"There is no register entry for this patient." Q
 . S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 . I BKMREG="" W !,"There is no HMS registry entry for this patient." Q
 . ; Post-edit audit capture
 . D POST^BKMVAUD
 . K BKMVA1,BKMVA1E,DFN,X,Y,AGE,DOB,PNT,HRN,RID,ADD1,PHONE,RES,CRBY,CRDT,CRTM,EDBY,EDDT,EDTM,STAT,STATDT,STATCOM
 K BKMVA1,BKMVA1E,DFN,X,Y,AGE,DOB,PNT,HRN,RID,ADD1,PHONE,RES,CRBY,CRDT,CRTM,EDBY,EDDT,EDTM,STAT,STATDT,STATCOM
 Q
 ;
HDR ; -- header code
 N SITE,DA,IENS
 S DA=$G(DUZ(2)),IENS=$$IENS^DILF(.DA),SITE=$$GET1^DIQ(4,IENS,.01,"E")
 S VALMHDR(1)=$$PAD^BKMIXX4("",">"," ",(80-$L(SITE)+2)\2)_"["_$G(SITE)_"]"
 Q
ADDRESS(DFN) ;EP
 N ADDR,IND,FIELD,FIELDE,ITEM
 S ADDR=""
 F IND=.111,.112,.113,.114,.115,.116 D
 . S ITEM=$$GET1^DIQ(2,DFN,IND,"E")
 . I IND=".115" S ITEM=$$IENTOST(ITEM)
 . I ADDR="" S ADDR=ITEM Q
 . S ADDR=ADDR_"^"_ITEM Q
 Q ADDR
IENTOEMP(IEN) ;
 N EMPE,EMP
 Q:IEN?." " ""
 S EMP=$$GET1^DIQ(200,IEN,.01,"I","","EMPE")
 Q:$D(EMPE) IEN
 Q EMP
IENTOST(IEN) ;
 N ST,STE
 Q:IEN?." " ""
 S ST=$$GET1^DIQ(5,IEN,1,"I","","STE")
 Q:$D(STE) IEN
 Q ST
PHONE(DFN,TYPE) ;EP
 N PHONE,PHONEE
 Q:DFN?." " ""
 I '$D(TYPE) S TYPE=1
 D GETS^DIQ(2,DFN,".131;.132","I","PHONE","PHONEE")
 Q:$D(PHONEE) DFN
 Q $S(TYPE=1:$G(PHONE(2,DFN_",",.131,"I")),TYPE=2:$G(PHONE(2,DFN_",",.132,"I")),1:"")
RES(DFN) ;EP
 Q $$GET1^DIQ(9000001,DFN,"1117","E")
HRN(DFN) ;EP
 N DA,IENS
 S DA(1)=DFN,DA=DUZ(2)
 S IENS=$$IENS^DILF(.DA)
 Q $$GET1^DIQ(9000001.41,IENS,.02,"E")
PRIMPROV(DFN) ;EP
 Q $$GET1^DIQ(9000001,DFN,.14,"E")
SUMMARY ; Health Summary
 ;D HS^BKMIHSM(DFN)
 D SUPP^BKMSUPP(DFN)
 S VALMBCK="R"
 Q
 ; View/Edit problem list
UPD1HDR(SCRN,NAME) ;
 S SCRN=$G(SCRN),NAME=$G(NAME)
 W:SCRN'?." " !,SCRN
 W:NAME'?." " !,NAME
 W:SCRN'?." "!(NAME'?." ") !
 Q
 ;
 ; Patient Reports in the patient record screen.
REPORTS ;
 N EXITREP,SELECT,OPT
 S EXITREP=0
 F  D  Q:EXITREP
 . D ^XBFMK
 . D CLEAR^VALM1
 . D FULL^VALM1
 . ; PRXM/HC/BHS - 05/10/2006 - Replace DIR selector with code to allow
 . ;                            partial matches on code and desc
 . ;K DIR
 . ;S DIR(0)="SO^DO:Due/OverDue;QC:Quality of Care Audit Report;SUPP:HMS Supplement;HS:Health Summary;BOTH:Both Health Summary and Supplement;SSR:State Surveillance Report;Q:Quit"
 . ;S DIR("A")="Select Patient Report"
 . ;D ^DIR
 . ;S SELECT=Y
 . ;I SELECT?." "!(SELECT?1."^")!(SELECT="Q") S EXITREP=1 Q
 . S SELECT=$$OPT^BKMVA1C()
 . I SELECT="" S EXITREP=1 Q
 . I SELECT="DO" D ONE^BKMVDOD(DFN) Q
 . ;I SELECT="2" D CSEL^BKMIMRP1 Q
 . I SELECT="QC" D EN^BKMVQCR(1) Q
 . I SELECT="SUPP" S OPT=1 D CLEAR^VALM1,FR2^BKMSUPP Q
 . I SELECT="HS" S OPT=2 D CLEAR^VALM1,FR2^BKMSUPP Q
 . I SELECT="BOTH" S OPT=3 D CLEAR^VALM1,FR2^BKMSUPP Q
 . ;I $F("^3^4^5^",U_SELECT_U) S OPT=SELECT-2 D CLEAR^VALM1,FR1^BKMSUPP
 . I SELECT="SSR" D EN1^BKMVSSR Q
 . W !,"Invalid Entry"
 D ^XBFMK
 Q
 ;
ADDDATA(DFN) ;EP - Add Patient Data
 K CALCREM
 D ADDDATA^BKMVA2(DFN)
 Q
INIT ;EP - Review/Edit Patient Record
 D INIT^BKMVA2
 Q
GETALL(DFN,RECALC) ;EP
 S RECALC=$G(RECALC)
 Q $$GETALL^BKMVA2(DFN,RECALC)
 ;
FREVEDIT(ADD,REV,PCCSF) ; EP - Review Edit
 N OPTION
 F  Q:'$$REVEDIT(.OPTION)  D
 . I OPTION="ADD" D  Q
 . . ; PRXM/BHS - 04/05/2006 - Kill removed since it is inside the loop and would reset potentially after data was added for a previous iteration
 . . ;K CALCREM
 . . I '$G(BKMPRIV) D NOGO^BKMIXX3 Q
 . . NEW DIR
 . . S DIR(0)="YA"
 . . S DIR("A")="Do you wish to continue? "
 . . S DIR("A",1)="The data you enter for the above patient will be added permanently"
 . . S DIR("A",2)="to the PCC database."
 . . S DIR("A",3)=" "
 . . S DIR("B")="YES"
 . . D ^DIR
 . . I $D(DTOUT)!$D(DUOUT)!(Y=0) Q
 . . D @ADD
 . . ; Save HMS PCC Buffer subfile
 . . D SAVEVF^BKMVA1A(DFN,PCCSF)
 . . ; PRXM/BHS - 04/05/2006 - Set CALCREM in SAVEVF^BKMVA1A only if data was actually saved
 . . ;S CALCREM=1
 . I OPTION="REV" D @REV Q
 ; Save HMS PCC Buffer subfile
 ;D SAVEVF^BKMVA1A(DFN,PCCSF)
 Q
 ;
REVEDIT(OPTION) ;
 N RCRDHDR,BKMDOD
 D ^XBFMK
 D CLEAR^VALM1
 D FULL^VALM1
 S RCRDHDR=$$PAD^BKMIXX4(" Patient: ",">"," ",10)_$$PAD^BKMIXX4($$GET1^DIQ(2,DFN,".01","E"),">"," ",30)_$$PAD^BKMIXX4(" HRN: ",">"," ",6)_$$PAD^BKMIXX4($$HRN^BKMVA1(DFN),">"," ",9)
 S BKMDOD=$$GET1^DIQ(2,DFN,".351","I")
 I BKMDOD'="" S RCRDHDR=RCRDHDR_$$PAD^BKMIXX4(" DOD: ",">"," ",6)_$$PAD^BKMIXX4($$FMTE^XLFDT(BKMDOD,1),">"," ",15)
 W !,RCRDHDR
 K DIR
 S DIR(0)="SO^REV:Review History;ADD:Add New Data;Q:Quit"
 ;PRXM/HC/DLS 11/30/2005 ; changed V-File prompt to 'Select Action'...
 S DIR("A")="Select Action"
 ;S DIR("A")="Select V-File Option"
 D ^DIR I $D(DIRUT) D ^XBFMK Q 0
 S OPTION=Y
 I Y?1."^"!(Y?." ")!($TR($E(Y,1),"q","Q")="Q") D ^XBFMK Q 0
 D ^XBFMK
 Q 1
 ;
INFO ;
 ;N EXIT,INFO
 ;S EXIT=0
 ;F  D  Q:EXIT
 ;. D ^XBFMK
 ;. D CLEAR^VALM1
 ;. D FULL^VALM1
 ;. K DIR
 ;. S DIR(0)="SO^1:Enter/Edit Info;2:Print Info;Q:Quit;"
 ;. S DIR("A")="Select Info Option"
 ;. D ^DIR
 ;. S INFO=$G(Y)
 ;. I INFO?1."^"!(INFO?." ") S EXIT=1 Q
 ;.;PRXM/HC/CJS 07/21/2005 -- Check for edit access
 ;.; I INFO=1 D ^BKMDOCE Q
 ;. I INFO=1 D:$G(BKMPRIV) ^BKMDOCE D:'$G(BKMPRIV) NOGO^BKMIXX3 Q
 ;. I INFO=2 D ^BKMPHPR Q
 ;. I INFO="Q" S EXIT=1 Q
 ;. W !,"Invalid Selection"
 ;D ^XBFMK
 Q
 ;
LDREC ;Load default values if Diagnosis Category is not at risk
 N DIAG
 S DIAG=$$DIAG^BKMVA1B(DFN)
 I DIAG]"",'$F("^A^H^",U_DIAG_U) Q
 D LDREC^BKMVA1B(DFN)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !
 Q
