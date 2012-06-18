BEHOENIN ;MSC/IND/DKM - Installation Support ;16-Sep-2010 20:28;PLS
 ;;1.1;BEH COMPONENTS;**005001,005004,005005**;Mar 20, 2007
 ;=================================================================
PREINIT ;EP - Preinitialization
 Q
POSTINIT ;EP - Postinitialization
 D VPOV
 Q
 ; Add a report to the ORRPW ADT VISITS report header.
ADDCHILD(RPT) ;
 N X,Y
 S X=$$FIND1^DIC(101.24,,"X","ORRPW ADT VISITS")
 S Y=$$FIND1^DIC(101.24,,"X",RPT)
 I X,Y D:'$O(^ORD(101.24,X,10,"B",Y,0))
 .N FDA
 .S FDA(101.241,"+1,"_X_",",.01)="`"_Y
 .D UPDATE^DIE("E","FDA")
 Q
GETUNLK ;
 N DATA,DAYS
 S GBL=$NA(^TMP("BEHOENCX"))
 S DAYS=$$GET^XPAR("SYS","BEHOENCX VISIT LOCKED")
 D:'DAYS ADD^XPAR("SYS","BEHOENCX VISIT LOCKED",,3)
 D ENVAL^XPAR(GBL,"BEHOENCX VISIT LOCK OVERRIDE",,,1)
 D REMUNLK
 Q
 ;
REMUNLK ;
 N ENT
 S ENT=""
 F  S ENT=$O(^TMP("BEHOENCX",ENT)) Q:ENT=""  D
 .D NDEL^XPAR(ENT,"BEHOENCX VISIT LOCK OVERRIDE")
 Q
SETUNLK ;
 N ENT,INT,VAL
 S ENT=""
 F  S ENT=$O(^TMP("BEHOENCX",ENT)) Q:ENT=""  D
 .S INT=0 F  S INT=$O(^TMP("BEHOENCX",ENT,INT)) Q:'INT  D
 ..S VAL=$$GET^XPAR("SYS","BEHOENCX VISIT LOCKED")
 ..S VAL=$S(VAL:VAL,1:2)
 ..S VAL=$$FMADD^XLFDT($$DT^XLFDT(),VAL)
 ..D ADD^XPAR(ENT,"BEHOENCX VISIT LOCK OVERRIDE","`"_INT,VAL)
 K ^TMP("BEHOENCX")
 Q
VPOV ;Repoint any text provider narratives
 ;First,find the date this patch was first installed
 N P6
 S P6="" S P6=$O(^XPD(9.7,"B","EHR*1.1*6",P6)) Q:P6=""  D
 .S IDATE=$P(^XPD(9.7,P6,0),U,3)
 .Q:IDATE=""
 .D FIXNAR
 Q
FIXNAR ;Loop through and find all POVs since patch 6 was installed
 ;check for text in the .o4 field and fix
 N DAT,CNT,VIEN,VPOV,NAR,NIEN
 S DAT=IDATE,CNT=0
 F  S DAT=$O(^AUPNVSIT("B",DAT)) Q:'DAT  D
 .F VIEN=0:0 S VIEN=$O(^AUPNVSIT("B",DAT,VIEN)) Q:'VIEN  D
 ..F VPOV=0:0 S VPOV=$O(^AUPNVPOV("AD",VIEN,VPOV)) Q:'VPOV  D
 ...N X
 ...S X=$G(^AUPNVPOV(VPOV,0))
 ...S NAR=$P(X,U,4)
 ...I +NAR=0 D
 ....S NIEN=$$FNDNARR(NAR,1)
 ....S $P(^AUPNVPOV(VPOV,0),U,4)=NIEN,CNT=CNT+1
 ....D MES("Repaired VPOV record #"_VPOV)
 D MES("Bad entries detected and repaired: "_CNT)
 Q
 ; Display message in MSG and optionally set quit flag to QUIT
MES(MSG,QUIT) ; EP
 D BMES^XPDUTL("  "_$G(MSG))
 S:$G(QUIT) XPDQUIT=QUIT
 Q
 ; Find/create narrative text in narrative file, returning IEN
FNDNARR(NARR,CREATE) ;EP
 N IEN,FDA,TRC,RET
 Q:'$L(NARR) ""
 S NARR=$$STRPNAR^BEHOENPC(NARR)  ;P7
 S IEN=0,TRC=$E(NARR,1,30),NARR=$E(NARR,1,160),CREATE=$G(CREATE,1)
 F  S IEN=$O(^AUTNPOV("B",TRC,IEN)) Q:'IEN  Q:$P($G(^AUTNPOV(IEN,0)),U)=NARR
 Q:IEN!'CREATE IEN
 S FDA(9999999.27,"+1,",.01)=NARR
 D UPDATE^DIE("E","FDA","IEN")
 Q +$G(IEN(1))
