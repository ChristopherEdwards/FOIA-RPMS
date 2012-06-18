BEHODCP ;MSC/IND/MGH - TIU Progress Note Look-up Method ;20-Mar-2007 13:48;DKM
 ;;1.1;BEH COMPONENTS;**001001**;Mar 20, 2007
 ;=================================================================
 ;Functionally the same as TIUPUTPN except modified to use note IEN
 ;and not to use SSN for patient identifier.
 ;===============================================================
LOOKUP ; Look-up code used by router/filer
 ; Required: TIUHRN, TIUVDT
 N DA,DFN,TIU,TIUDAD,TIUEDIT,TIUEDT,TIULDT,TIUXCRP,TIUTYPE,TIUNEW
 N TIUDPRM,TIUIEN,BEHDFN,CREATE,BEHTIU,TIUNAME2,TIUVSTRB
IEN ;Get data needed to identify note
 S BEHTIU=+$G(TIUHDR("TIUHRN")) S DFN=$$CKHRN(BEHTIU)
 ;I $S('$D(TIUNAME):1,'$D(TIUVDT):1,1:0) S Y=-1 G LOOKUPX
 I DFN="" S Y=-1 G LOOKUPX
 S TIUNAME2=$P($G(^DPT(DFN,0)),U,1)
 S TIUSSN=$P($G(^DPT(DFN,0)),U,9)
 ; Check clinic name
 I '$G(TIUHDR("TIUIEN")) D  G:Y=-1 LOOKUPX
 .I '$L($G(TIULOC)) S Y=-1 Q
 .S TIULOC=+$$ILOC(TIULOC)
 .I '$D(^SC(+$G(TIULOC),0)) S Y=-1
 ; Check appointment date
 I '$G(TIUHDR("TIUIEN")) D  G:Y=-1 LOOKUPX
 .S TIUEDT=$$IDATE(+$G(TIUVDT)),TIULDT=$$FMADD^XLFDT(TIUEDT,1)
 .I +TIUEDT'>0 S Y=-1
 S TIUTYPE=$$WHATITLE(TIUTITLE)
 I +TIUTYPE'>0 S Y=-1 G LOOKUPX
 D DOCPRM^TIULC1(+TIUTYPE,.TIUDPRM)
 I $G(TIUHDR("TIUIEN"))="" D NAMECK,REGULAR:Y'=-1
 I $G(TIUHDR("TIUIEN"))'="" D SPECIAL,REGULAR:Y'=-1
 Q
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
NAMECK ; If no note ien, check last name entered with last name from HRN
 N LNAME1,LNAME2
 S LNAME1=$P($G(TIUNAME),","),LNAME2=$P(TIUNAME2,",")
 I LNAME1'=LNAME2 S Y=-1
 Q
SPECIAL ;If the note ien exists, make sure its the correct one
 S TIUIEN=$G(TIUHDR("TIUIEN"))
 I $G(^TIU(8925,TIUIEN,0))="" S Y=-1 Q
 I $P($G(^TIU(8925,TIUIEN,0)),U,2)'=DFN S TIUIEN="",Y=-1 Q
 I $P($G(^TIU(8925,TIUIEN,0)),U,1)'=$P(TIUTYPE,U,1) S TIUIEN="",Y=-1 Q
 S TIULOC=$P($G(^TIU(8925,TIUIEN,12)),U,5)
 S TIUEDT=$P($G(^TIU(8925,TIUIEN,0)),U,7)
 S TIULDT=$P($G(^TIU(8925,TIUIEN,0)),U,8)
 S TIUVISIT=$P($G(^TIU(8925,TIUIEN,0)),U,3)
 Q
REGULAR ;Get the visit
 I $P($G(^SC(+$G(TIULOC),0)),U,3)="W" S TIUSC="H"
 E  S TIUSC="A"
 S TIUVSTR=TIULOC_";"_TIUEDT_";"_TIUSC
 ;The variable TIUVSTR needs the fourth element (the IEN) if the
 ;visit is known. However, the TIU lookup routine does not use this
 ;element so both of them have to be saved
 I $D(TIUIEN) S TIUVSTRB=TIUVSTR_";"_$G(TIUVISIT)
 E  S TIUVSTRB=TIUVSTR
 S CREATE=1
 ;Find the visit or make a new one
 S TIUVISIT=$$VSTR2VIS^BEHOENCX(DFN,TIUVSTRB,CREATE)
 S TIUVSTR=$P(TIUVSTRB,";",1,3)
 ;Get the variables for the TIU array
 D PATVADPT^TIULV(.TIU,DFN,"",TIUVSTR)
 S TIUTYP(1)=1_U_TIUTYPE_U_$$PNAME^TIULC1(TIUTYPE)
 ;Store record
 I +$G(TIUIEN) D
 .S Y=TIUIEN
 E  S Y=$$GETRECNW^TIUEDI3(DFN,.TIU,TIUTYP(1),.TIUNEW,.TIUDPRM)
 I +Y'>0 G LOOKUPX
 ; If record is not new, has text and can be edited, then replace
 ; existing text
 I +$G(TIUNEW)'>0 D
 . S TIUEDIT=$$CANEDIT(+Y)
 . I +TIUEDIT>0,$D(^TIU(8925,+Y,"TEXT")) D DELTEXT(+Y)
 . I +TIUEDIT'>0 S TIUDAD=+Y,Y=$$MAKEADD
 I +Y'>0 Q
 D STUFREC(Y,+$G(TIUDAD))
 I +$G(TIUDAD) D SENDADD^TIUALRT(+Y)
 K TIUHDR(.01),TIUHDR(.07),TIUHDR(1301)
LOOKUPX Q
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
MAKEADD() ; Create an addendum record
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
 . S @FDARR@(.08)=$P($G(TIU("LDT")),U)
 . S @FDARR@(1201)=$$NOW^TIULC
 . S @FDARR@(1205)=$S(+$P($G(TIU("LOC")),U):$P($G(TIU("LOC")),U),1:$P($G(TIU("VLOC")),U))
 . ;S @FDARR@(1211)=$P($G(TIU("VLOC")),U)
 . S @FDARR@(1404)=$P($G(TIU("SVC")),U)
 I +$G(PARENT)>0 D
 . S @FDARR@(.02)=+$P($G(^TIU(8925,+PARENT,0)),U,2)
 . S @FDARR@(.03)=+$P($G(^TIU(8925,+PARENT,0)),U,3),@FDARR@(.05)=3
 . S @FDARR@(.06)=PARENT
 . S @FDARR@(.07)=$P($G(^TIU(8925,+PARENT,0)),U,7)
 . S @FDARR@(.08)=$P($G(^TIU(8925,+PARENT,0)),U,8)
 . S @FDARR@(1205)=$P($G(^TIU(8925,+PARENT,12)),U,5)
 . S @FDARR@(1404)=$P($G(^TIU(8925,+PARENT,14)),U,4)
 . S @FDARR@(1201)=$$NOW^TIULC
 S @FDARR@(1205)=$P($G(TIU("LOC")),U)
 S @FDARR@(1301)=$S($G(TIUDDT)]"":$$IDATE^TIULC($G(TIUDDT)),1:"")
 I $S(@FDARR@(1301)'>0:1,$P(@FDARR@(1301),".",2)']"":1,1:0) D
 . S @FDARR@(1301)=$S($P($G(TIU("VSTR")),";",3)="H":$$NOW^XLFDT,1:$G(@FDARR@(.07)))
 S @FDARR@(1303)="U"
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
 S @FDARR@(1204)=$$WHOSIGNS^TIULC1(TIUDA)
 I +$P($G(^TIU(8925,TIUDA,12)),U,9),'+$P($G(^(12)),U,8) D
 . S @FDARR@(1208)=$$WHOCOSIG^TIULC1(TIUDA)
 D FILE^DIE(FLAGS,"FDA","TIUMSG")
 I +$P($G(^TIU(8925,+TIUDA,12)),U,8),(+$P($G(^TIU(8925,+TIUDA,12)),U,4)'=+$P($G(^(12)),U,8)) D
 . S @FDARR@(1506)=1 D FILE^DIE(FLAGS,"FDA","TIUMSG")
 D RELEASE^TIUT(TIUDA,1)
 D AUDIT^TIUEDI1(TIUDA,0,$$CHKSUM^TIULC("^TIU(8925,"_+TIUDA_",""TEXT"")"))
 I '$D(TIU("VSTR")) D
 . N TIUD0,TIUD12,TIUVLOC,TIUHLOC,TIUEDT,TIULDT
 . S TIUD0=$G(^TIU(8925,+TIUDA,0)),TIUD12=$G(^(12))
 . S DFN=+$P(TIUD0,U,2),TIUEDT=+$P(TIUD0,U,7)
 . S TIULDT=$$FMADD^XLFDT(TIUEDT,1),TIUHLOC=+$P(TIUD12,U,5)
 . S TIUVLOC=$S(+$P(TIUD12,U,11):+$P(TIUD12,U,11),1:+TIUHLOC)
 . I $S(+DFN'>0:1,+TIUEDT'>0:1,+TIULDT'>0:1,+TIUVLOC'>0:1,1:0) Q
 . D MAIN^TIUVSIT(.TIU,DFN,"",TIUEDT,TIULDT,"LAST",0,+TIUVLOC)
 Q:'$D(TIU("VSTR"))
 D ENQ^TIUPXAP1 ; Get/file VISIT
 Q
