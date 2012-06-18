BQIPTMRG ;PRXM/HC/ALA-iCare Merge Patient Update ; 18 Oct 2007  3:29 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;;
 ;;BPMXBQI:
 ;;This routine merges patient data for the following iCare files -
 ;;  ICARE USER (#90505), ICARE PATIENT (#90507.5), 
 ;;  ICARE DX CAT REGISTRY (#90509 - v 1.2), 
 ;;  ICARE DX CAT FACTORS (#90509.5 - v 1.2)
 ;;
 ;;This routine is called by the special merge routine driver - ^BPMXDRV
 ;;
 ;;The IHS patient merge sofware enters at EN line label.  It is expected
 ;;that the following global would have been set up by the patient merge
 ;;software:
 ;;  ^TMP("XDRFROM",$J,FROMIEN,TOIEN,FROMIEN_GLOBROOT,TOIEN_GLOBROOT)=FILE
 ;;Example:
 ;;  ^TMP("XDRFROM",2804,6364,1991,"6364;DPT(","1991;DPT(")=2
 ;;where =2 is the parent file (VA PATIENT FILE)
 ;;
 ;;$$END
 ;
 NEW I,X
 F I=1:1 S X=$P($T(DESC+I),";;",2) Q:X["$$END"  D EN^DDIOL(X)
 Q
 ;
EN(BPMRY) ;EP -- Main entry point
 ; Input parameter
 ;   BPMRY  =  Temp global set up by the patient merge software,
 ;             i.e., "^TMP(""XDRFROM"",$J)"
 ;
 NEW BPMFR,BPMTO
 ;
 S BPMFR=$O(@BPMRY@(0))
 Q:'BPMFR
 S BPMTO=$O(@BPMRY@(BPMFR,0))
 Q:'BPMTO
 ;
 D PROC(BPMFR,BPMTO)
 Q
 ;
PROC(BPMFR,BPMTO) ; Process patient data
 ;
 NEW DIK,DA,UID,BI
 S UID=$J
 ;Update the ICARE PATIENT File (#90507.5)
 I $G(^BQIPAT(BPMTO,0))="" D
 . I $P($G(^DPT(BPMTO,.35)),U,1)'="" Q
 . ; Create new record
 . D NPT^BQITASK(BPMTO)
 . I $G(^BQIPAT(BPMFR,0))="" Q
 . S $P(^BQIPAT(BPMTO,0),U,2,99)=$P(^BQIPAT(BPMFR,0),U,2,99)
 . F BI=10,20,30,40,50 M ^BQIPAT(BPMTO,BI)=^BQIPAT(BPMFR,BI)
 S DIK="^BQIPAT(",DA=BPMFR D ^DIK
 ; Reindex new record
 S DIK="^BQIPAT(",DA=BPMTO D EN1^DIK
 ;
 ;Update the ICARE USER File (#90505)
 ;Check if patient exists in any panels and update them
 NEW OWNR,PLIEN
 S OWNR=""
 F  S OWNR=$O(^BQICARE("AB",BPMFR,OWNR)) Q:OWNR=""  D
 . S PLIEN=""
 . F  S PLIEN=$O(^BQICARE("AB",BPMFR,OWNR,PLIEN)) Q:PLIEN=""  D
 .. NEW DIC,DIE,DA,IENS,X,DATA,DINUM,DLAYGO
 .. S DATA=$G(^BQICARE(OWNR,1,PLIEN,40,BPMFR,0)) I DATA="" K ^BQICARE("AB",BPMFR,OWNR,PLIEN) Q
 .. ;
 .. S DA(2)=OWNR,DA(1)=PLIEN,DA=BPMFR
 .. ; Delete old record
 .. S DIK="^BQICARE("_DA(2)_",1,"_DA(1)_",40," D ^DIK
 .. ; Add new record
 .. S DA(2)=OWNR,DA(1)=PLIEN,(X,DINUM)=BPMTO
 .. S DIC="^BQICARE("_DA(2)_",1,"_DA(1)_",40,",DIE=DIC
 .. S DLAYGO=90505.04,DIC(0)="L",DIC("P")=DLAYGO
 .. I '$D(^BQICARE(DA(2),1,DA(1),40,0)) S ^BQICARE(DA(2),1,DA(1),40,0)="^90505.04P^^"
 .. K DO,DD D FILE^DICN
 .. S $P(^BQICARE(OWNR,1,PLIEN,40,BPMTO,0),U,2,99)=$P(DATA,U,2,99)
 .. D STA^BQIPLRF(OWNR,PLIEN)
 .. D ULK^BQIPLRF(OWNR,PLIEN)
 ;
 ; for version 2.0 of iCare
 ;Update ICARE DX CAT REGISTRY File (#90509)
 I $G(^BQIREG(0))="" Q
 NEW IEN,BQIUPD
 S IEN=""
 F  S IEN=$O(^BQIREG("AC",BPMFR,IEN)) Q:IEN=""  D
 . S BQIUPD(90509,IEN_",",.02)=BPMTO
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 ;Update ICARE ICARE DX CAT FACTORS File (#90509.5)
 S IEN=""
 F  S IEN=$O(^BQIFACT("AC",BPMFR,IEN)) Q:IEN=""  D
 . S BQIUPD(90509.5,IEN_",",.02)=BPMTO
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
CHK(BPMFR) ;EP - Check if FROM patient is in a panel that is opened
 NEW OWNR,PLIEN,UID,ARRAY,BQIX,LOCK,LGLOB,FLAG
 S OWNR="",FLAG=1,UID=$J
 I $O(^BQICARE("AB",BPMFR,OWNR))="" Q 1
 F  S OWNR=$O(^BQICARE("AB",BPMFR,OWNR)) Q:OWNR=""  D
 . S PLIEN=""
 . F  S PLIEN=$O(^BQICARE("AB",BPMFR,OWNR,PLIEN)) Q:PLIEN=""  D
 .. ; Try to lock all panels containing the patient being merged
 .. S LOCK=$$LCK^BQIPLRF(OWNR,PLIEN)
 .. S ARRAY(OWNR,PLIEN)=LOCK
 .. I 'LOCK D  Q
 ... D STA^BQIPLRF(OWNR,PLIEN)
 .. D STA^BQIPLRF(OWNR,PLIEN,1)
 ; If any panel was unable to be locked ('1'), set the flag to 'not'
 S BQIX="ARRAY" F  S BQIX=$Q(@BQIX) Q:BQIX=""  S:$P(@BQIX,U,1)=0 FLAG=0
 ;
 ;If a panel is found to be locked, unlock all the others that were locked
 ;in the check above
 I FLAG=0 D
 . F  S OWNR=$O(^BQICARE("AB",BPMFR,OWNR)) Q:OWNR=""  D
 .. S PLIEN=""
 .. F  S PLIEN=$O(^BQICARE("AB",BPMFR,OWNR,PLIEN)) Q:PLIEN=""  D
 ... D STA^BQIPLRF(OWNR,PLIEN)
 ... D ULK^BQIPLRF(OWNR,PLIEN)
 Q FLAG
