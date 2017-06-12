BEDDSYNC ;GDIT/HS/BEE-SYNC BEDD WITH AMER/PCC ; 08 Nov 2011  12:00 PM
 ;;2.0;BEDD DASHBOARD;;Jun 04, 2014;Build 13
 ;
 ;This routine is included in the BEDD XML 2.0 install and is not in the KIDS
 ; 
 Q
 ;
 NEW AUPNVSIT
 ;
SYNC() ;EP - SYNC BEDD with AMER/PCC
 ;
 I $G(AUPNVSIT)="" Q
 ;
 NEW OBJID,EXEC,INJ,ISINJ,STS,AMERDA,INJCS,INJTWN,INJDT,INJMVC
 NEW INJICO,INJIPO,INJSET,INJSAF
 ;
 ;Get the ER VISIT Id
 S AMERDA=$O(^AMERVSIT("AD",AUPNVSIT,"")) Q:AMERDA=""
 ;
 ;Get the BEDD Object Id
 S (ISINJ,INJCS,INJTWN,OBJID,INJDT,INJMVC,INJICO,INJIPO,INJSET,INJSAF)=""
 S EXEC="S OBJID=$O(^BEDD.EDVISITI(""ADIdx"",AUPNVSIT,""""))" X EXEC
 I OBJID="" Q
 ;
 ;SYNC up injury information
 ;
 ;Format Is Injury
 S ISINJ=$$GET1^DIQ(9009080,AMERDA_",",3.1,"I"),ISINJ=$S(ISINJ=1:"YES",1:"NO")
 ;
 ;Open the class entry
 S EXEC="S INJ=##CLASS(BEDD.EDVISIT).%OpenId("_OBJID_",0)" X EXEC
 ;
 ;Injury YES/NO
 S EXEC="S INJ.Injury=ISINJ" X EXEC
 ;
 ;Injury Cause
 S INJCS=$$GET1^DIQ(9009080,AMERDA_",",3.2,"I"),INJCS=$S(INJCS]"":INJCS,1:"@")
 S EXEC="S INJ.PtInjury.InjCauseIEN=INJCS" X EXEC
 ;
 ;Injury Town Location
 S INJTWN=$$GET1^DIQ(9009080,AMERDA_",",3.6,"I"),INJTWN=$S(INJTWN]"":INJTWN,1:"@")
 S EXEC="S INJ.PtInjury.InjLocat=INJTWN" X EXEC
 ;
 ;Injury Date/Time
 S INJDT=$$GET1^DIQ(9009080,AMERDA_",",3.4,"I"),INJDT=$S(INJDT]"":INJDT,1:"@")
 S EXEC="S INJ.PtInjury.InjDtTm=INJDT" X EXEC
 ;
 ;Injury - MVC Location
 S INJMVC=$$GET1^DIQ(9009080,AMERDA_",",13.1,"I"),INJMVC=$S(INJMVC]"":INJMVC,1:"@")
 S EXEC="S INJ.PtInjury.MVCLoc=INJMVC" X EXEC
 ;
 ;Injury - Driver Insurance Company
 S INJICO=$$GET1^DIQ(9009080,AMERDA_",",13.2,"I"),INJICO=$S(INJICO]"":INJICO,1:"@")
 S EXEC="S INJ.PtInjury.AtFaultInsurance=INJICO" X EXEC
 ;
 ;Injury - Driver Insurance Policy
 S INJIPO=$$GET1^DIQ(9009080,AMERDA_",",13.3,"I"),INJIPO=$S(INJIPO]"":INJIPO,1:"@")
 S EXEC="S INJ.PtInjury.AtFaultInsPolicy=INJIPO" X EXEC
 ;
 ;Injury - Setting
 S INJSET=$$GET1^DIQ(9009080,AMERDA_",",3.3,"I"),INJSET=$S(INJSET]"":INJSET,1:"@")
 S EXEC="S INJ.PtInjury.InjSet=INJSET" X EXEC
 ;
 ;Injury - Safety Equipment
 S INJSAF=$$GET1^DIQ(9009080,AMERDA_",",3.5,"I"),INJSAF=$S(INJSAF]"":INJSAF,1:"@")
 S EXEC="S INJ.PtInjury.SafetyEquip=INJSAF" X EXEC
 ;
 ;Save the entry
 S EXEC="S STS=INJ.%Save()" X EXEC
 S INJ=""
 ;
 Q
 ;
INJFLD(VIEN,FIELD,VALUE) ;Update the specific BEDD injury field
 ;
 I $G(VIEN)="" Q
 ;
 NEW OBJID,EXEC,INJ,STS,AUPNVSIT
 ;
 ;Get the BEDD Object Id
 S (OBJID)=""
 S EXEC="S OBJID=$O(^BEDD.EDVISITI(""ADIdx"",VIEN,""""))" X EXEC
 I OBJID="" Q
 ;
 ;Format Injury
 I (FIELD="INJ.Injury")!(FIELD="INJ.PtInjury.WrkRel") S VALUE=$S(VALUE=1:"YES",1:"NO")
 ;
 ;Open the entry
 S EXEC="S INJ=##CLASS(BEDD.EDVISIT).%OpenId("_OBJID_",0)" X EXEC
 ;
 ;Assemble the entry to save
 S EXEC="S "_FIELD_"="""_VALUE_"""" X EXEC
 ;
 ;Save the entry
 S EXEC="S STS=INJ.%Save()" X EXEC
 S INJ=""
 ;
 ;Flag visit as updated
 S AUPNVSIT=VIEN D MOD^AUPNVSIT
 Q
