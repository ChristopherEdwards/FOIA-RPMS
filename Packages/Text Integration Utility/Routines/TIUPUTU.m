TIUPUTU ; SLC/JER - Utilities for Filer/Router ;11-JUL-2001 15:58
 ;;1.0;TEXT INTEGRATION UTILITIES;**3,100,120**;Jun 20, 1997
 ;IHS/ITSC/LJF 02/27/2003 stripped dashes from HRCN; set into TIUSSN variable
 ;                        if addendum arrives in same batch as original, it will be added as separate entry
 ;                        added creation of v notes entry
 ;                        added check to set cosig needed only if signer requires cosig
 ;             07/29/2004 remove screen for 4 digit chart number
 ;
LOOKUP ; Look-up code used by router/filer
 ; Required: TIUSSN, TIUADT
 N DA,DFN,TIU,TIUDAD,TIUDPRM,TIUEDIT,TIUEDT,TIULDT,TIUXCRP S TIUXCRP=1
 ;I $S('$D(TIUSSN):1,'$D(TIUADT):1,$G(TIUSSN)?4N:1,$G(TIUSSN)']"":1,1:0) S Y=-1 G LOOKUPX
 I $S('$D(TIUSSN):1,'$D(TIUADT):1,$G(TIUSSN)']"":1,1:0) S Y=-1 G LOOKUPX   ;IHS/ITSC/LJF 7/29/2004 remove screen for 4 digits
 I TIUSSN?3N1P2N1P4N.E S TIUSSN=$TR(TIUSSN,"-/","")
 S TIUSSN=+$$STRIP^XLFSTR(TIUSSN,"-")  ;IHS/ITSC/LJF 02/27/2003 strip dashes from HRCN
 I TIUSSN["?" S Y=-1 G LOOKUPX
 S TIUEDT=$$IDATE^TIULC(TIUADT),TIULDT=$$FMADD^XLFDT(TIUEDT,1)
 I +TIUEDT'>0 S Y=-1 Q
 D MAIN^TIUMOVE(.TIU,.DFN,TIUSSN,TIUEDT,TIULDT,1,"LAST",0)
 I $S($D(TIU)'>9:1,+$G(DFN)'>0:1,1:0) S Y=-1 G LOOKUPX
 I $P(+$G(TIU("EDT")),".")'=$P($$IDATE^TIULC(TIUADT),".") S Y=-1 G LOOKUPX
 I '+$G(TIU("LDT")),($G(TIUDICDT)]""),(+$$IDATE^TIULC(TIUDICDT)=-1) S Y=-1 Q
 D DOCPRM^TIULC1(RECORD("TYPE"),.TIUDPRM)
 S TIUTYP(1)=1_U_RECORD("TYPE")_U_$$PNAME^TIULC1(RECORD("TYPE"))
 S Y=$$GETRECNW^TIUEDI3(DFN,.TIU,TIUTYP(1),.TIUNEW,.TIUDPRM)
 I +Y'>0 G LOOKUPX
 S TIUEDIT=$$CANEDIT(+Y)
 ; If record has text and can be edited, then replace existing text
 ;
 ;IHS/ITSC/LJF 02/27/2003 if text already exists in this batch, add addendum
 ;I +TIUEDIT>0,$D(^TIU(8925,+Y,"TEXT")) D DELTEXT(+Y)
 ;I +TIUEDIT'>0 S TIUDAD=+Y,Y=$$MAKEADD
 I $O(^TIU(8925,+Y,"TEXT",0)) S TIUDAD=+Y,Y=$$MAKEADD
 ;IHS/ITSC/LJF 02/27/2003 end of mods
 ;
 I +Y'>0 G LOOKUPX
 K TIUHDR(.07)
 D STUFREC(Y,+$G(TIUDAD))
 I +$G(TIUDAD) D SENDADD^TIUALRT(+Y)
LOOKUPX Q
CANEDIT(DA) ; Check whether or not document is released
 Q $S(+$P($G(^TIU(8925,+DA,13)),U,4):0,+$P($G(^(13)),U,5)>0:0,+$G(^(15)):0,1:1)
MAKEADD() ; Create an addendum record
 N DIE,DR,DA,DIC,X,Y,DLAYGO,TIUATYP,TIUFPRIV S TIUFPRIV=1
 S TIUATYP=+$$WHATITLE("ADDENDUM")
 S (DIC,DLAYGO)=8925,DIC(0)="L",X=""""_"`"_TIUATYP_""""
 D ^DIC
 S DA=+Y
 I +DA>0 S DIE=DIC,DR=".04////"_$$DOCCLASS^TIULC1(TIUATYP) D ^DIE
 Q +DA
STUFREC(DA,PARENT) ; Stuff fixed field data
 N FDA,FDARR,IENS,FLAGS,TIUMSG,TIURDT
 S IENS=""""_DA_",""",FDARR="FDA(8925,"_IENS_")",FLAGS="K"
 I +$G(PARENT)'>0 D
 . S @FDARR@(.02)=$G(DFN),@FDARR@(.03)=$P($G(TIU("VISIT")),U)
 . S @FDARR@(.05)=3
 . S @FDARR@(.07)=$P(TIU("EDT"),U)
 . S @FDARR@(.08)=$P(TIU("LDT"),U),@FDARR@(1401)=TIU("AD#")
 . S @FDARR@(1402)=$P($G(TIU("TS")),U),@FDARR@(1201)=$$NOW^TIULC
 I +$G(PARENT)>0 D
 . S @FDARR@(.02)=+$P(^TIU(8925,+PARENT,0),U,2)
 . S @FDARR@(.03)=+$P(^TIU(8925,+PARENT,0),U,3),@FDARR@(.05)=3
 . S @FDARR@(.06)=PARENT,@FDARR@(.08)=$P(TIU("LDT"),U)
 . S @FDARR@(1401)=$P(^TIU(8925,+PARENT,14),U)
 . S @FDARR@(1402)=$P(^TIU(8925,+PARENT,14),U,2)
 . S @FDARR@(1201)=$$NOW^TIULC
 S @FDARR@(1205)=$P($G(TIU("LOC")),U)
 I +$G(TIU("LDT")) S TIURDT=+$G(TIU("LDT"))
 I +$G(TIU("LDT"))'>0 D
 . S TIUDICDT=+$$IDATE^TIULC($G(TIUDICDT))
 . S TIURDT=$S(+$G(TIUDICDT)>0:+$G(TIUDICDT),1:+$$NOW^TIULC)
 . S TIU("LDT")=TIURDT_U_$$DATE^TIULS(TIURDT,"AMTH DD, CCYY@HR:MIN:SEC")
 . S @FDARR@(.12)=1
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
 S DIC("S")="I +$O(^TIU(8925.1,+Y,""HEAD"",0))!+$O(^TIU(8925.1,+Y,""ITEM"",0))"
 D ^DIC K DIC("S")
 Q Y
WHATYPE2(X) ; Identify document type
 ; Receives: X=Document Definition Name
 ;  Returns: Y=Document Definition IFN
 N DIC,Y,TIUFPRIV S TIUFPRIV=1
 S DIC=8925.1,DIC(0)="M"
 S DIC("S")="I +$O(^TIU(8925.1,+Y,""HEAD"",0))!+$O(^TIU(8925.1,+Y,""ITEM"",0))"
 D ^DIC K DIC("S")
 Q Y
WHATITLE(X) ; Identify document type
 ; Receives: X=Document Definition Name
 ;  Returns: Y=Document Definition IFN
 N DIC,Y,TIUFPRIV S TIUFPRIV=1
 S DIC=8925.1,DIC(0)="M"
 S DIC("S")="I $P(^TIU(8925.1,+Y,0),U,4)=""DOC"""
 D ^DIC K DIC("S")
 Q Y
FOLLOWUP(TIUDA) ; Post-filing code for Discharge Summaries
 N FDA,FDARR,IENS,FLAGS,TIUMSG,TIU
 S IENS=""""_TIUDA_",""",FDARR="FDA(8925,"_IENS_")",FLAGS="K"
 D GETTIU^TIULD(.TIU,TIUDA)
 I $L($G(TIU("EDT"))) S @FDARR@(.07)=$P($G(TIU("EDT")),U)
 S @FDARR@(1204)=$$WHOSIGNS^TIULC1(TIUDA)
 S @FDARR@(1208)=$$WHOCOSIG^TIULC1(TIUDA)
 D FILE^DIE(FLAGS,"FDA","TIUMSG")
 I +$P($G(^TIU(8925,+TIUDA,12)),U,4)'=+$P($G(^(12)),U,9) D
 . I '$$REQCOSIG^TIULP(+$P($G(^TIU(8925,+DA,0)),U),+DA,+$P($G(^(12)),U,4)) Q  ;IHS/ITSC/LJF 02/27/2003 don't cosig unless reqd
 . S @FDARR@(1506)=1 D FILE^DIE(FLAGS,"FDA","TIUMSG")
 ;D ENQ^TIUPXAP1 ; In-line call to get/file the visit             ;IHS;ITSC;LJF 09/09/2004 don't call PCE
 D VNOTE^BTIUPCC(TIUDA,$$IVST^BTIUU1(+TIUDA),$$IPAT^BTIUU1(+TIUDA),"ADD")  ;IHS/ITSC/LJF 02/27/2003 update V Note file;9/10/2004 changed DA to TIUDA
 D RELEASE^TIUT(TIUDA,1),UPDTIRT^TIUDIRT(.TIU,TIUDA)
 D AUDIT^TIUEDI1(TIUDA,0,$$CHKSUM^TIULC("^TIU(8925,"_+TIUDA_",""TEXT"")"))
 Q
