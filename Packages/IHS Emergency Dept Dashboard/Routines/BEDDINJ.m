BEDDINJ ;GDIT/HS/BEE-BEDD Retrieve Injury Information ; 08 Nov 2011  12:00 PM
 ;;2.0;BEDD DASHBOARD;;Jun 04, 2014;Build 13
 ;
 ;This routine is included in the BEDD XML 2.0 install and is not in the KIDS
 ; 
 Q
ISINJ(VIEN) ;Return whether visit is injury related or not
 ;
 NEW EXEC,ISINJ,INJ,OBJID
 ;
 I $G(VIEN)="" Q 0
 ;
 S EXEC="S OBJID=$O(^BEDD.EDVISITI(""ADIdx"",VIEN,""""))" X EXEC
 I OBJID="" Q 0
 ;
 ;Check if it is an injury
 S EXEC="S INJ=##CLASS(BEDD.EDVISIT).%OpenId("_OBJID_",0)" X EXEC
 S EXEC="S ISINJ=INJ.Injury" X EXEC
 S INJ=$S($G(ISINJ)="YES":1,1:0)
 ;
 Q INJ
 ;
INJURY(VIEN,INJURY) ;Return injury related information entered on the dashboard
 ;
 I $G(VIEN)="" Q
 ;
 NEW OBJID,EXEC,INJ,ICIEN,INLOC,INSCO,INSPO,ISINJ,INDAT,MVLOC,INSET,INJEQ,WKREL
 ;
 ;Get the BEDD Object Id
 S (ISINJ,ICIEN,OBJID,INLOC,INSCO,INSPO,INDAT,MVLOC,INSET,INJEQ,WKREL)=""
 S EXEC="S OBJID=$O(^BEDD.EDVISITI(""ADIdx"",VIEN,""""))" X EXEC
 I OBJID="" Q
 ;
 S EXEC="S INJ=##CLASS(BEDD.EDVISIT).%OpenId("_OBJID_",0)" X EXEC
 S EXEC="S ISINJ=INJ.Injury" X EXEC
 S EXEC="S ICIEN=INJ.PtInjury.InjCauseIEN" X EXEC
 S EXEC="S INLOC=INJ.PtInjury.InjLocat" X EXEC
 S EXEC="S INSCO=INJ.PtInjury.AtFaultInsurance" X EXEC
 S EXEC="S INSPO=INJ.PtInjury.AtFaultInsPolicy" X EXEC
 S EXEC="S INDAT=INJ.PtInjury.InjDtTm" X EXEC
 S EXEC="S MVLOC=INJ.PtInjury.MVCLoc" X EXEC
 S EXEC="S INSET=INJ.PtInjury.InjSet" X EXEC
 S EXEC="S INJEQ=INJ.PtInjury.SafetyEquip" X EXEC
 S EXEC="S WKREL=INJ.PtInjury.WrkRel" X EXEC
 S INJ=""
 ;
 S INJURY("OBJID")=OBJID
 S INJURY("ISINJ")=ISINJ
 S INJURY("ICIEN")=ICIEN
 S INJURY("INLOC")=$E(INLOC,1,100)
 S INJURY("INSCO")=INSCO
 S INJURY("INSPO")=INSPO
 S INJURY("INDAT")=INDAT
 S INJURY("MVLOC")=MVLOC
 S INJURY("INSET")=INSET
 S INJURY("INJEQ")=INJEQ
 S INJURY("WKREL")=$S(WKREL="YES":1,1:0)
 ;
 Q
 ;
UPDINJ(VIEN) ;Update the BEDD injury information
 ;
 I $G(VIEN)="" Q
 ;
 NEW OBJID,EXEC,INJ,ISINJ,STS,AUPNVSIT
 ;
 ;Get the BEDD Object Id
 S (ISINJ,OBJID)=""
 S EXEC="S OBJID=$O(^BEDD.EDVISITI(""ADIdx"",VIEN,""""))" X EXEC
 I OBJID="" Q
 ;
 ;Format Injury
 S ISINJ=$G(^TMP("AMER",$J,2,2)) S ISINJ=$S(ISINJ=1:"YES",1:"NO")
 ;
 S EXEC="S INJ=##CLASS(BEDD.EDVISIT).%OpenId("_OBJID_",0)" X EXEC
 ;
 ;Injury YES/NO
 S EXEC="S INJ.Injury=ISINJ" X EXEC
 ;
 ;Injury Cause
 S EXEC="S INJ.PtInjury.InjCauseIEN=$G(^TMP(""AMER"",$J,2,33))" X EXEC
 ;
 ;Injury Town Location
 S EXEC="I $G(^TMP(""AMER"",$J,2,31))]"""" S INJ.PtInjury.InjLocat=$G(^TMP(""AMER"",$J,2,31))" X EXEC
 ;S EXEC="S INSCO=INJ.PtInjury.AtFaultInsurance" X EXEC
 ;S EXEC="S INSPO=INJ.PtInjury.AtFaultInsPolicy" X EXEC
 ;
 ;Injury Date/Time
 S EXEC="S INJ.PtInjury.InjDtTm=$G(^TMP(""AMER"",$J,2,32))" X EXEC
 ;
 ;Injury - MVC Location
 S EXEC="S INJ.PtInjury.MVCLoc=$G(^TMP(""AMER"",$J,2,41))" X EXEC
 ;
 ;Injury - Driver Insurance Company
 S EXEC="S INJ.PtInjury.AtFaultInsurance=$G(^TMP(""AMER"",$J,2,42))" X EXEC
 ;
 ;Injury - Driver Insurance Policy
 S EXEC="S INJ.PtInjury.AtFaultInsPolicy=$G(^TMP(""AMER"",$J,2,43))" X EXEC
 ;
 ;Injury - Setting
 S EXEC="S INJ.PtInjury.InjSet=$G(^TMP(""AMER"",$J,2,34))" X EXEC
 ;
 ;Injury - Safety Equipment
 S EXEC="S INJ.PtInjury.SafetyEquip=$G(^TMP(""AMER"",$J,2,35))" X EXEC
 ;
 ;Save the entry
 S EXEC="S STS=INJ.%Save()" X EXEC
 S INJ=""
 ;
 ;Flag visit as updated
 S AUPNVSIT=VIEN D MOD^AUPNVSIT
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
