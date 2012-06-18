BKMVCD ;PRXM/HC/BHS - HMS Candidate Detail ; 16-AUG-2005
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(BKMCIEN) ; EP - Main entry point for BKMV CANDIDATE DETAIL
 I '$$VALID^BKMIXX3(DUZ) Q
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 K ^TMP("BKMVCD",$J)
 D ^XBFMK
 D EN^VALM("BKMV CANDIDATE DETAIL")
 D ^XBFMK
 D EXIT
 Q
 ;
HDR ; -- header code
 ; Assumes existence of DUZ, BKMCIEN
 N DA,IENS,SITE,PTIEN,DOD
 S DA=$G(DUZ(2)),IENS=$$IENS^DILF(.DA),SITE=$$GET1^DIQ(4,IENS,.01,"E")
 S VALMHDR(1)=$$PAD^BKMIXX4("",">"," ",(80-$L(SITE)+2)\2)_"["_$G(SITE)_"]"
 ; Demo data
 S PTIEN=$$GET1^DIQ(90451.2,BKMCIEN,".01","I")
 ; Disp ind for deceased
 S DOD=$$GET1^DIQ(2,PTIEN_",",.351,"I")
 S VALMHDR(2)=$$PAD^BKMIXX4(" Patient: "_$$GET1^DIQ(2,PTIEN,".01","E"),">"," ",41)
 S VALMHDR(2)=VALMHDR(2)_$$PAD^BKMIXX4(" HRN: "_$$HRN^BKMVA1(PTIEN),">"," ",15)
 S VALMHDR(2)=VALMHDR(2)_$$PAD^BKMIXX4(" DOB: "_$$FMTE^XLFDT($$GET1^DIQ(2,PTIEN,".03","I"),"5Z"),">"," ",16)
 S VALMHDR(2)=VALMHDR(2)_$$PAD^BKMIXX4(" Sex: "_$$GET1^DIQ(2,PTIEN,".02","I"),">"," ",8)
 S VALMHDR(3)=$$PAD^BKMIXX4(" Status:  "_$$GET1^DIQ(90451.2,BKMCIEN,".03","E"),">"," ",41)
 S VALMHDR(3)=VALMHDR(3)_$$PAD^BKMIXX4(" Created: "_$$FMTE^XLFDT($$GET1^DIQ(90451.2,BKMCIEN,".04","I"),"5Z"),">"," ",39)
 S VALMHDR(4)=$$PAD^BKMIXX4($S(DOD:"*DOD:    "_$$FMTE^XLFDT(DOD\1,"5Z"),1:""),"<"," ",61)
 S VALMHDR(5)="   Visit Date"
 S VALMHDR(6)="     Description"
 S VALMHDR(7)="         Date Found  Taxonomy"
 Q
 ;
INIT ; -- init vars and list array
 ; Input vars:
 ;  BKMCIEN - File 90451.2 IEN
 ; Output vars:
 ;  VALMAR - ListMan array
 ;  VALMCNT - List array ct
 ;  VALM0
 N BKMI,BKMDATA,BKMVST,BKMVDT,BKMPTR,BKMDXN,BKMDSC,BKMJ,BKMTEXT,TEXT,QMAN,BKMFND,BKMVLAB
 N BKMK,BKMVMED,BKMTXDSC,BKMCTR,BKMNVST
 K ^TMP("BKMVCD",$J)
 D ^XBFMK
 S VALMCNT=0,VALMAR="^TMP(""BKMVCD"","""_$J_""")",VALM0=""
 S QMAN=$$GET1^DIQ(90451.2,BKMCIEN,".02","E")
 I QMAN'="" D  G INITX
 . S VALMCNT=$G(VALMCNT)+1
 . D SET^VALM10(VALMCNT," QMAN TEMPLATE:")
 . S VALMCNT=$G(VALMCNT)+1
 . D SET^VALM10(VALMCNT,"   N/A")
 . S VALMCNT=$G(VALMCNT)+1
 . D SET^VALM10(VALMCNT,"     "_QMAN)
 . S VALMCNT=$G(VALMCNT)+1
 . S TEXT=$$PAD^BKMIXX4("     "_$$FMTE^XLFDT($$GET1^DIQ(90451.2,BKMCIEN,".04","I"),"5Z"),">"," ",17)
 . D SET^VALM10(VALMCNT,TEXT)
 ; Loop thru qual crit and disp in priority order
 ;  Dxs 1st
 ;   Build disp for dx in rev dt order
 S BKMI=0
 F  S BKMI=$O(^BKM(90451.2,BKMCIEN,2,BKMI)) Q:'BKMI  D
 .  S BKMDATA=$G(^BKM(90451.2,BKMCIEN,2,BKMI,0))
 .  S BKMVST=$P(BKMDATA,U,2)
 .  Q:BKMVST=""
 .  S BKMVDT=$$GET1^DIQ(9000010,BKMVST_",",".01","I")
 .  Q:BKMVDT=""
 .  S BKMPTR=$P(BKMDATA,U,1),(BKMDXN,BKMDSC)=""
 .  I BKMPTR'="" D
 ..   I $T(ICDDX^ICDCODE)'="" S BKMDXN=$$ICD9^BKMUL3(BKMPTR,BKMVDT,2),BKMDSC=$$ICD9^BKMUL3(BKMPTR,BKMVDT,4) Q  ; csv
 ..   S BKMDXN=$$GET1^DIQ(80,BKMPTR_",",".01","E"),BKMDSC=$$GET1^DIQ(80,BKMPTR_",","3","E")
 .  I BKMPTR="" S BKMPTR="*"
 .  S ^TMP("BKMVCD",$J,"SORTED",-BKMVDT,BKMVST,BKMPTR)=$$FMTE^XLFDT(BKMVDT,"5Z")_U_BKMDXN_"  "_BKMDSC_U_$P(BKMDATA,U,3)_U_$$FMTE^XLFDT($P(BKMDATA,U,4),"5Z")
 ;   Disp dxs
 I $O(^TMP("BKMVCD",$J,"SORTED",""))'="" D
 . S VALMCNT=$G(VALMCNT)+1
 . D SET^VALM10(VALMCNT," DIAGNOSES:")
 S BKMI=""
 F  S BKMI=$O(^TMP("BKMVCD",$J,"SORTED",BKMI)) Q:'BKMI  D
 .  S BKMJ=""
 .  F  S BKMJ=$O(^TMP("BKMVCD",$J,"SORTED",BKMI,BKMJ)) Q:'BKMJ  D
 .  .  S BKMK="",BKMNVST=1
 .  .  F  S BKMK=$O(^TMP("BKMVCD",$J,"SORTED",BKMI,BKMJ,BKMK)) Q:'BKMK  D
 .  .  .  S BKMTEXT=$G(^TMP("BKMVCD",$J,"SORTED",BKMI,BKMJ,BKMK))
 .  .  .  I BKMNVST D
 .  .  .  . S VALMCNT=$G(VALMCNT)+1
 .  .  .  . S TEXT="   "_$P($P(BKMTEXT,U,1),"@",1)
 .  .  .  . D SET^VALM10(VALMCNT,TEXT)
 .  .  .  . S BKMNVST=0
 .  .  .  S VALMCNT=$G(VALMCNT)+1
 .  .  .  S TEXT=$$PAD^BKMIXX4("     "_$P(BKMTEXT,U,2),">"," ",78)
 .  .  .  D SET^VALM10(VALMCNT,TEXT)
 .  .  .  S VALMCNT=$G(VALMCNT)+1
 .  .  .  S TEXT=$$PAD^BKMIXX4("         "_$P($P(BKMTEXT,U,4),"@",1),">"," ",19)
 .  .  .  S TEXT=TEXT_$$PAD^BKMIXX4("  "_$P(BKMTEXT,U,3),">"," ",59)
 .  .  .  D SET^VALM10(VALMCNT,TEXT)
 ;  Meds 2nd
 K ^TMP("BKMVCD",$J,"SORTED")
 S BKMI=0
 F  S BKMI=$O(^BKM(90451.2,BKMCIEN,3,BKMI)) Q:'BKMI  D
 .  S BKMDATA=$G(^BKM(90451.2,BKMCIEN,3,BKMI,0))
 .  S BKMVST=$P(BKMDATA,U,2)
 .  Q:BKMVST=""
 .  S BKMVDT=$$GET1^DIQ(9000010,BKMVST_",",".01","I")
 .  Q:BKMVDT=""
 .  S BKMPTR=$P(BKMDATA,U,1),BKMDSC=""
 .  I BKMPTR'="" S BKMDSC=$$GET1^DIQ(50,BKMPTR_",",".01","E")
 .  I BKMPTR="" S BKMPTR="*"
 .  S ^TMP("BKMVCD",$J,"SORTED",-BKMVDT,BKMVST,BKMPTR)=$$FMTE^XLFDT(BKMVDT,"5Z")_U_BKMDSC_U_$P(BKMDATA,U,3)_U_$$FMTE^XLFDT($P(BKMDATA,U,4),"5Z")
 ;   Disp meds
 I $O(^TMP("BKMVCD",$J,"SORTED",""))'="" D
 . S VALMCNT=$G(VALMCNT)+1
 . D SET^VALM10(VALMCNT," MEDICATIONS:")
 S BKMI=""
 F  S BKMI=$O(^TMP("BKMVCD",$J,"SORTED",BKMI)) Q:'BKMI  D
 .  S BKMJ=""
 .  F  S BKMJ=$O(^TMP("BKMVCD",$J,"SORTED",BKMI,BKMJ)) Q:'BKMJ  D
 .  .  S BKMK="",BKMNVST=1
 .  .  F  S BKMK=$O(^TMP("BKMVCD",$J,"SORTED",BKMI,BKMJ,BKMK)) Q:'BKMK  D
 .  .  .  S BKMTEXT=$G(^TMP("BKMVCD",$J,"SORTED",BKMI,BKMJ,BKMK))
 .  .  .  I BKMNVST D
 .  .  .  . S VALMCNT=$G(VALMCNT)+1
 .  .  .  . S TEXT="   "_$P($P(BKMTEXT,U,1),"@",1)
 .  .  .  . D SET^VALM10(VALMCNT,TEXT)
 .  .  .  . S BKMNVST=0
 .  .  .  S VALMCNT=$G(VALMCNT)+1
 .  .  .  S TEXT=$$PAD^BKMIXX4("     "_$P(BKMTEXT,U,2),">"," ",78)
 .  .  .  D SET^VALM10(VALMCNT,TEXT)
 .  .  .  S VALMCNT=$G(VALMCNT)+1
 .  .  .  S TEXT=$$PAD^BKMIXX4("         "_$P($P(BKMTEXT,U,4),"@",1),">"," ",19)
 .  .  .  S TEXT=TEXT_$$PAD^BKMIXX4("  "_$P(BKMTEXT,U,3),">"," ",59)
 .  .  .  D SET^VALM10(VALMCNT,TEXT)
 ;  Labs 3rd
 K ^TMP("BKMVCD",$J,"SORTED")
 S BKMI=0
 F  S BKMI=$O(^BKM(90451.2,BKMCIEN,4,BKMI)) Q:'BKMI  D
 .  S BKMDATA=$G(^BKM(90451.2,BKMCIEN,4,BKMI,0))
 .  S BKMVST=$P(BKMDATA,U,2)
 .  Q:BKMVST=""
 .  S BKMVDT=$$GET1^DIQ(9000010,BKMVST_",",".01","I")
 .  Q:BKMVDT=""
 .  S BKMPTR=$P(BKMDATA,U,1),BKMDSC=""
 .  I BKMPTR'="" S BKMDSC=$$GET1^DIQ(60,BKMPTR_",",".01","E") D
 .  . ; Loop thru V LAB by visit IEN for V LAB IEN - result
 .  . S (BKMVLAB,BKMFND)=""
 .  . F  S BKMVLAB=$O(^AUPNVLAB("AD",BKMVST,BKMVLAB)) Q:BKMVLAB=""  D  Q:BKMFND
 .  . .  ; Compare to .01 in V LAB
 .  . .  I BKMPTR=$$GET1^DIQ(9000010.09,BKMVLAB_",",".01","I") S BKMFND=1 Q
 .  . I BKMVLAB'="" S BKMDSC=BKMDSC_" (RESULTS = '"_$$GET1^DIQ(9000010.09,BKMVLAB_",",".04","E")_"')"
 .  I BKMPTR="" S BKMPTR="*"
 .  S ^TMP("BKMVCD",$J,"SORTED",-BKMVDT,BKMVST,BKMPTR)=$$FMTE^XLFDT(BKMVDT,"5Z")_U_BKMDSC_U_$P(BKMDATA,U,3)_U_$$FMTE^XLFDT($P(BKMDATA,U,4),"5Z")
 ;   Disp labs
 I $O(^TMP("BKMVCD",$J,"SORTED",""))'="" D
 . S VALMCNT=$G(VALMCNT)+1
 . D SET^VALM10(VALMCNT," LABS:")
 S BKMI=""
 F  S BKMI=$O(^TMP("BKMVCD",$J,"SORTED",BKMI)) Q:'BKMI  D
 .  S BKMJ=""
 .  F  S BKMJ=$O(^TMP("BKMVCD",$J,"SORTED",BKMI,BKMJ)) Q:'BKMJ  D
 .  .  S BKMK="",BKMNVST=1
 .  .  F  S BKMK=$O(^TMP("BKMVCD",$J,"SORTED",BKMI,BKMJ,BKMK)) Q:'BKMK  D
 .  .  .  S BKMTEXT=$G(^TMP("BKMVCD",$J,"SORTED",BKMI,BKMJ,BKMK))
 .  .  .  I BKMNVST D
 .  .  .  . S VALMCNT=$G(VALMCNT)+1
 .  .  .  . S TEXT="   "_$P($P(BKMTEXT,U,1),"@",1)
 .  .  .  . D SET^VALM10(VALMCNT,TEXT)
 .  .  .  . S BKMNVST=0
 .  .  .  S VALMCNT=$G(VALMCNT)+1
 .  .  .  S TEXT=$$PAD^BKMIXX4("     "_$P(BKMTEXT,U,2),">"," ",78)
 .  .  .  D SET^VALM10(VALMCNT,TEXT)
 .  .  .  S VALMCNT=$G(VALMCNT)+1
 .  .  .  S TEXT=$$PAD^BKMIXX4("         "_$P($P(BKMTEXT,U,4),"@",1),">"," ",19)
 .  .  .  S TEXT=TEXT_$$PAD^BKMIXX4("  "_$P(BKMTEXT,U,3),">"," ",59)
 .  .  .  D SET^VALM10(VALMCNT,TEXT)
 ;  Probs 4th
 K ^TMP("BKMVCD",$J,"SORTED")
 S BKMI=0
 F  S BKMI=$O(^BKM(90451.2,BKMCIEN,5,BKMI)) Q:'BKMI  D
 .  S BKMDATA=$G(^BKM(90451.2,BKMCIEN,5,BKMI,0))
 .  S BKMVST=$P(BKMDATA,U,2)
 .  Q:BKMVST=""
 .  S BKMVDT=$$PROB^BKMVUTL(BKMVST)
 .  Q:BKMVDT=""
 .  S BKMPTR=$P(BKMDATA,U,1),BKMDSC=""
 .  I BKMPTR'="" D
 ..   I $T(ICDDX^ICDCODE)'="" S BKMDSC=$$ICD9^BKMUL3(BKMPTR,BKMVDT,2) Q  ; csv
 ..   S BKMDSC=$$GET1^DIQ(80,BKMPTR_",",".01","E")
 .  I BKMPTR="" S BKMPTR="*"
 .  S ^TMP("BKMVCD",$J,"SORTED",-BKMVDT,BKMVST,BKMPTR)=$$FMTE^XLFDT(BKMVDT,"5Z")_U_BKMDSC_U_$P(BKMDATA,U,3)_U_$$FMTE^XLFDT($P(BKMDATA,U,4),"5Z")
 ;   Disp probs
 I $O(^TMP("BKMVCD",$J,"SORTED",""))'="" D
 . S VALMCNT=$G(VALMCNT)+1
 . D SET^VALM10(VALMCNT," PROBLEMS:")
 S BKMI=""
 F  S BKMI=$O(^TMP("BKMVCD",$J,"SORTED",BKMI)) Q:'BKMI  D
 .  S BKMJ=""
 .  F  S BKMJ=$O(^TMP("BKMVCD",$J,"SORTED",BKMI,BKMJ)) Q:'BKMJ  D
 .  .  S BKMK="",BKMNVST=1
 .  .  F  S BKMK=$O(^TMP("BKMVCD",$J,"SORTED",BKMI,BKMJ,BKMK)) Q:'BKMK  D
 .  .  .  S BKMTEXT=$G(^TMP("BKMVCD",$J,"SORTED",BKMI,BKMJ,BKMK))
 .  .  .  I BKMNVST D
 .  .  .  . S VALMCNT=$G(VALMCNT)+1
 .  .  .  . S TEXT="   "_$P($P(BKMTEXT,U,1),"@",1)
 .  .  .  . D SET^VALM10(VALMCNT,TEXT)
 .  .  .  . S BKMNVST=0
 .  .  .  S VALMCNT=$G(VALMCNT)+1
 .  .  .  S TEXT=$$PAD^BKMIXX4("     "_$P(BKMTEXT,U,2),">"," ",78)
 .  .  .  D SET^VALM10(VALMCNT,TEXT)
 .  .  .  S VALMCNT=$G(VALMCNT)+1
 .  .  .  S TEXT=$$PAD^BKMIXX4("         "_$P($P(BKMTEXT,U,4),"@",1),">"," ",19)
 .  .  .  S TEXT=TEXT_$$PAD^BKMIXX4("  "_$P(BKMTEXT,U,3),">"," ",59)
 .  .  .  D SET^VALM10(VALMCNT,TEXT)
INITX ; INIT exit point
 K ^TMP("BKMVCD",$J,"SORTED")
 D ^XBFMK
 Q
 ;
HELP ; -- help code
 N X
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BKMVCD",$J)
 K VALM0,VALMAR,VALMCNT,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
ACCEPT(PROMPTS) ; -- accept code
 ; Input
 ;  PROMPTS - opt 0/1 flag for users to be prompted for missing data
 ; 
 D FULL^VALM1
 N BKMPTIEN,DIR,DTOUT,DUOUT,BKMSTS,Y,REGISTER,BKMIEN,BKMREG,DIR,DA,DIK
 S PROMPTS=+$G(PROMPTS)
 S VALMBCK="R"
 I +$G(BKMCIEN)=0 D EN^DDIOL("No candidate selected") H 2 S VALMBCK="Q" Q
 S BKMCIEN=+$G(BKMCIEN)
 S BKMPTIEN=$$GET1^DIQ(90451.2,BKMCIEN,".01","I")
 ; Prompt for Reg Status
 S DIR(0)="S^"_$P($G(^DD(90451.01,.5,0)),U,3),DIR(0)=$E(DIR(0),1,$L(DIR(0))-1)
 S DIR("A")="Select the Register Status that should be assigned"
 S DIR("B")="ACTIVE"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q
 S BKMSTS=Y
 ; Add HMS Register entry
 I '$$ACC(BKMPTIEN,BKMSTS) Q
 ; Prompt for missing data - like when manually adding pats
 I PROMPTS,$$YNP^BKMVA1B("Do you want to add missing registry data at this time","NO") D
 . ; Begin auditing
 . S BKMIEN=$$BKMIEN^BKMIXX3(BKMPTIEN)
 . I BKMIEN="" W !,"There is no register entry for this patient." H 1 Q
 . S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 . I BKMREG="" W !,"There is no HMS registry entry for this patient." H 1 Q
 . ; Pre-edit audit capture
 . D EN^BKMVAUD
 . D LDREC^BKMVA1B(BKMPTIEN)
 . D PROMPTS^BKMVA1B(BKMPTIEN,1)
 . ; Stop auditing
 . S BKMIEN=$$BKMIEN^BKMIXX3(BKMPTIEN)
 . I BKMIEN="" W !,"There is no register entry for this patient." H 1 Q
 . S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 . I BKMREG="" W !,"There is no HMS registry entry for this patient." H 1 Q
 . ; Post-edit audit capture
 . D POST^BKMVAUD
 ; If candidate is saved into register, delete candidate
 I $G(MADD)=0 S MADD=1
 S DIK="^BKM(90451.2,",DA=BKMCIEN D ^DIK
 S VALMBCK="Q"
 Q
 ;
NOT ; -- not accept code
 N DA,DIE,DR,%DT,X,Y
 S VALMBCK="R"
 I +$G(BKMCIEN)=0 D EN^DDIOL("No candidate selected") H 2 S VALMBCK="Q" Q
 I '$$OK() Q
 S BKMCIEN=+$G(BKMCIEN)
 S DA=BKMCIEN
 S DIE="^BKM(90451.2,"
 S DR=".03////NOT;.05////"_$$NOW^XLFDT()_";.06////"_DUZ
 L +^BKM(90451.2,DA):0 I $T D ^DIE L -^BKM(90451.2,DA) S VALMBCK="Q" Q
 W !?5,"Another user is editing this entry."
 Q
 ;
HS ; -- health summary code
 N BKMPTIEN
 S VALMBCK="R"
 I +$G(BKMCIEN)=0 D EN^DDIOL("No candidate selected") H 2 Q
 S BKMCIEN=+$G(BKMCIEN)
 S BKMPTIEN=$$GET1^DIQ(90451.2,BKMCIEN,".01","I")
 D FULL^VALM1
 D HS^BKMIHSM(BKMPTIEN)
 Q
 ;
ACC(BKMDFN,BKMSTS) ; EP - add pat to HMS reg w/ status
 N BKMHIV,BKMIEN,BKMREG,BKMVUP,BKMIENS,BKMOK
 S BKMOK=0
 D ^XBFMK ; Kills off many Fileman vars
 ; Add HMS Reg entry
 S BKMHIV=$$HIVIEN^BKMIXX3()
 I BKMHIV="" D EN^DDIOL("ERROR: There is no HMS register defined.") H 2 Q BKMOK
 S BKMIEN=$$BKMIEN^BKMIXX3(BKMDFN)   ; BKMIEN and BKMREG used by BKMVAUD
 I BKMIEN="" S BKMIEN=$$ADDPAT(BKMDFN) ; Create entry in iCare registry for pat
 I BKMIEN="" D EN^DDIOL("ERROR: An entry for the candidate could not be created in the iCare registry.") H 2 Q BKMOK
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 I BKMREG="" S BKMREG=$$ADDREG(BKMIEN,BKMHIV) ; Create HMS register entry for pat
 I BKMREG="" D EN^DDIOL("ERROR: An entry for the candidate could not be created in the HMS register.") H 2 Q BKMOK
 ; Success
 S BKMOK=1
 ; Add audit entry for the NEW rec
 D NEW^BKMVAUDN(BKMIEN,BKMREG,DUZ)
 ;
 D EN^BKMVAUD ; Start audit log
 K BKMVUP
 S BKMIENS=BKMREG_","_BKMIEN_","
 S BKMVUP(90451.01,BKMIENS,.02)=DT
 S BKMVUP(90451.01,BKMIENS,.025)=DUZ
 S BKMVUP(90451.01,BKMIENS,.5)=$G(BKMSTS)
 S BKMVUP(90451.01,BKMIENS,.75)=DT
 S BKMVUP(90451.01,BKMIENS,.8)=DUZ
 D FILE^DIE("I","BKMVUP")
 K BKMVUP
 D POST^BKMVAUD ; End audit log
 ;
 ;PRXM/HC/BHS - Removed 8/31/2005 per client request Bug #971
 ;S DA=BKMIEN
 ;D ID^BKMILK   ; Create patient ID and assign to patient.
 D ^XBFMK ; Kills off a lot of Fileman variables
 Q BKMOK
 ;
ADDPAT(BKMPAT) ; EP - Add pat to iCare register
 N DIC,X,Y
 S X=$G(BKMPAT)
 S DIC(0)="L"
 S DIC="^BKM(90451,"
 D FILE^DICN
 Q +$P(Y,U,1)
 ;
ADDREG(BKMIEN,BKMHIV) ; EP - Add new pat to the HMS register.
 N DA,DIC,X,Y
 S X=$G(BKMHIV)
 S DIC(0)="L"
 S DIC="^BKM(90451,"_BKMIEN_",1,"
 S DA(1)=BKMIEN
 D FILE^DICN
 Q +$P(Y,U,1)
 ;
OK() ; EP - OK to not accept candidate
 N DIR,X,Y,DTOUT,DUOUT
 S DIR("A")="Are you sure you want to remove the candidate from the list (Y/N)"
 S DIR("?")="Enter 'Y' to remove the candidate from the list, 'N' to return to the screen"
 S DIR(0)="Y",DIR("B")="N" D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q ""
 Q Y
 ;
 ;
