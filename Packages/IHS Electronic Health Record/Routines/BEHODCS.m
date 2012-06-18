BEHODCS ;MSC/IND/MGH - TIU Discharge Summary Look-up Method ;20-Mar-2007 13:48;DKM
 ;;1.1;BEH COMPONENTS;**001001**;Mar 20, 2007
 ;=================================================================
 ;Functionally the same as TIUPUTPN except modified to use note IEN
 ;and not to use SSN for patient identifier.
 ;===============================================================
LOOKUP ; Look-up code used by router/filer
 ; Required: TIUHRN, TIUVDT
 N DA,DFN,TIU,TIUDAD,TIUEDIT,TIUEDT,TIULDT,TIUXCRP,TIUTYPE,TIUNEW
 N TIUDPRM,TIUIEN,CREATE,BEHTIU,BEHDFN
IEN ;Get data needed to identify note
 I $S('$D(TIUNAME):1,'$D(TIUHRN):1,'$D(TIUADT):1,1:0) S Y=-1 G LOOKUPX
 S BEHTIU=+$G(TIUHDR("TIUHRN")) S DFN=$$CKHRN(BEHTIU)
 I DFN="" S Y=-1 G LOOKUPX
 S TIUNAME2=$P($G(^DPT(DFN,0)),U,1)
 S TIUSSN=$P($G(^DPT(DFN,0)),U,9)
 S TIUEDT=$$IDATE^TIULC(TIUADT),TIULDT=$$FMADD^XLFDT(TIUEDT,1)
 I +TIUEDT'>0 S Y=-1 Q
 D NAMECK I $G(Y)=-1 Q
 D MAIN^TIUMOVE(.TIU,.DFN,TIUSSN,TIUEDT,TIULDT,1,"LAST",0)
 I $S($D(TIU)'>9:1,+$G(DFN)'>0:1,1:0) S Y=-1 G LOOKUPX
 I $P(+$G(TIU("EDT")),".")'=$P($$IDATE^TIULC(TIUADT),".") S Y=-1 G LOOKUPX
 I '+$G(TIU("LDT")),($G(TIUDICDT)]""),(+$$IDATE^TIULC(TIUDICDT)=-1) S Y=-1 Q
 D DOCPRM^TIULC1(RECORD("TYPE"),.TIUDPRM)
 S TIUTYP(1)=1_U_RECORD("TYPE")_U_$$PNAME^TIULC1(RECORD("TYPE"))
 S Y=$$GETRECNW^TIUEDI3(DFN,.TIU,TIUTYP(1),.TIUNEW,.TIUDPRM)
 I +Y'>0 G LOOKUPX
 S TIUEDIT=$$CANEDIT(+Y)
 ;If record has text and can be edited, then replace existing text
 I +TIUEDIT>0,$D(^TIU(8925,+Y,"TEXT")) D DELTEXT(+Y)
 I +TIUEDIT'>0 S TIUDAD=+Y,Y=$$MAKENADD
 I +Y'>0 G LOOKUPX
 D STUFREC(Y,+$G(TIUDAD))
 I +$G(TIUDAD) D SENDADD^TIUALRT(+Y)
 K TIUHDR(.01),TIUHDR(.07),TIUHDR(1301)
LOOKUPX Q
 ; Returns patient for given HRN and DUZ(2) value
 ; Input - BEHTIU - Health Record Number
 ; Assumes - DUZ(2) is set to currently facility
 ; Returns - DFN or ""
CKHRN(BEHTIU) ;If entered name doesn't match a patient, use the Health
 ;Record Number if available.
 N INST,DFN,RES
 S BEHTIU=$G(BEHTIU,""),RES=""
 I BEHTIU'="" D
 .S DFN=0 F  S DFN=$O(^AUPNPAT("D",BEHTIU,DFN)) Q:'DFN!RES  D
 ..S INST=0 F  S INST=$O(^AUPNPAT("D",BEHTIU,DFN,INST)) Q:'INST!RES  D
 ...S:INST=DUZ(2) RES=DFN
 Q RES
NAMECK ;If no note ien, check last name entered with last name from HRN
 N LNAME1,LNAME2
 S LNAME1=$P(TIUNAME,",",1),LNAME2=$P(TIUNAME2,",",1)
 I LNAME1'=LNAME2 S Y=-1
 Q
 I +Y'>0 G LOOKUPX
 ; If record is not new, has text and can be edited, then replace
 ; existing text
 I +$G(TIUNEW)'>0 D
 . S TIUEDIT=$$CANEDIT(+Y)
 . I +TIUEDIT>0,$D(^TIU(8925,+Y,"TEXT")) D DELTEXT(+Y)
 . I +TIUEDIT'>0 S TIUDAD=+Y,Y=$$MAKENADD
 I +Y'>0 Q
 D STUFREC(Y,+$G(TIUDAD))
 I +$G(TIUDAD) D SENDADD^TIUALRT(+Y)
 K TIUHDR(.01),TIUHDR(.07),TIUHDR(1301)
 Q
IDATE(X) ; Receives date in external format, returns internal format
 N %DT,Y
 I ($L(X," ")=2),(X?1.2N1P1.2N1P1.2N.2N1" "1.2N.E) S X=$TR(X," ","@")
 S %DT="TSP" D ^%DT
 Q Y
ILOC(LOCATION) ; Get pointer to file 44
 N DIC,X,Y
 S DIC=44,DIC(0)="M",X=LOCATION D ^DIC
 Q Y
CANEDIT(DA) ; Check whether or not document is in a status up to unsigned
 Q $S(+$P($G(^TIU(8925,+DA,0)),U,5)<6:1,1:0)
MAKENADD() ; Create an addendum record
 N DIE,DR,DA,DIC,X,Y,DLAYGO,TIUATYP,TIUFPRIV S TIUFPRIV=1
 S TIUATYP=+$$WHATITLE("ADDENDUM")
 S (DIC,DLAYGO)=8925,DIC(0)="L",X=""""_"`"_TIUATYP_""""
 D ^DIC
 S DA=+Y
 I +DA>0 S DIE=DIC,DR=".04////"_$$DOCCLASS^TIULC1(TIUATYP) D ^DIE
 K TIUHDR(.01)
 Q +DA
STUFREC(DA,PARENT) ; Stuff fixed field data
 N FDA,FDARR,IENS,FLAGS,TIUMSG
 S IENS=""""_DA_",""",FDARR="FDA(8925,"_IENS_")",FLAGS="K"
 I +$G(PARENT)'>0 D
 . S @FDARR@(.02)=$G(DFN),@FDARR@(.03)=$P($G(TIU("VISIT")),U)
 . S @FDARR@(.05)=3
 . S @FDARR@(.07)=$P($G(TIU("EDT")),U)
 . S @FDARR@(.08)=$P($G(TIU("LDT")),U),@FDARR@(1401)=TIU("AD#")
 . S @FDARR@(1201)=$$NOW^TIULC
 . S @FDARR@(1402)=$P($G(TIU("TS")),U)
 I +$G(PARENT)>0 D
 . S @FDARR@(.02)=+$P($G(^TIU(8925,+PARENT,0)),U,2)
 . S @FDARR@(.03)=+$P($G(^TIU(8925,+PARENT,0)),U,3),@FDARR@(.05)=3
 . S @FDARR@(.06)=PARENT,@FDARR@(.08)=$P($G(^TIU("LDT")),U)
 . S @FDARR@(1401)=$P($G(^TIU(8925,+PARENT,14)),U)
 . S @FDARR@(1402)=$P($G(^TIU(8925,+PARENT,14)),U,2)
 . S @FDARR@(1201)=$$NOW^TIULC
 S @FDARR@(1205)=$P($G(TIU("LOC")),U)
 I +$G(TIU("LDT")) S TIURDT=+$G(TIU("LDT"))
 I +$G(TIU("LDT"))'>0 D
 .S TIUDICDT=+$$IDATE^TIULC($G(TIUDICDT))
 .S TIURDT=$S(+$G(TIUICDT)>0:+$G(TIUDICDT),1:+$$NOW^TIULC)
 .S TIU("LDT")=TIURDT_U_$$DATE^TIULS(TIURDT,"AMTH DD, CCYY@HR:MIN:SEC")
 .S @FDARR@(.12)=1
 S @FDARR@(1301)=TIURDT,@FDARR@(1303)="U"
 D FILE^DIE(FLAGS,"FDA","TIUMSG") ; File record
 Q
DELTEXT(DA) ; Delete existing text in preparation for replacement
 N DIE,DR,X,Y
 S DIE=8925,DR="2///@" D ^DIE
 Q
WHATYPE(X) ; Identify document type
 ; Receives: X=Document Definition Name
 ;  Returns: Y=Document Definition IFN
 N DIC,Y,TIUFPRIV S TIUFPRIV=1
 S DIC=8925.1,DIC(0)="M"
 S DIC("S")="I $D(^TIU(8925.1,+Y,""HEAD""))!$D(^TIU(8295.1,+Y,""ITEM""))"
 D ^DIC K DIC("S")
WHATYPX Q Y
WHATITLE(X) ; Identify document title
 ; Receives: X=Document Definition Name
 ;  Returns: Y=Document Definition IFN
 N DIC,Y,TIUFPRIV S TIUFPRIV=1
 S DIC=8925.1,DIC(0)="M"
 S DIC("S")="I $P(^TIU(8925.1,+Y,0),U,4)=""DOC"""
 D ^DIC K DIC("S")
WHATITX Q Y
FOLLOWUP(TIUDA) ; Post-filing code for PROGRESS NOTES
 N FDA,FDARR,IENS,FLAGS,TIUMSG,TIU,DFN
 S IENS=""""_TIUDA_",""",FDARR="FDA(8925,"_IENS_")",FLAGS="K"
 D GETTIU^TIULD(.TIU,TIUDA)
 I $L($G(TIU("EDT"))) S @FDARR@(.07)=$P($G(TIU("EDT")),U)
 S @FDARR@(1204)=$$WHOSIGNS^TIULC1(TIUDA)
 S @FDARR@(1208)=$$WHOCOSIG^TIULC1(TIUDA)
 D FILE^DIE(FLAGS,"FDA","TIUMSG")
 I $D(^TIU(8925,+TIUDA,12)),+$P(^(12),U,4)'=+$P(^(12),U,9) D
 . S @FDARR@(1506)=1 D FILE^DIE(FLAGS,"FDA","TIUMSG")
 D ENQ^TIUPXAP1 ; get/file visit
 D RELEASE^TIUT(TIUDA,1)
 D AUDIT^TIUEDI1(TIUDA,0,$$CHKSUM^TIULC("^TIU(8925,"_+TIUDA_",""TEXT"")"))
 Q
