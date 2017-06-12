BEDD2PST ;GDIT/HS/BEE-BEDD VERSION 2.0 POST INSTALL ROUTINE ; 08 Nov 2011  12:00 PM
 ;;2.0;BEDD DASHBOARD;;Jun 04, 2014;Build 13
 ;
 Q
 ;
PST ;Post Install for BEDD Version 2.0
 ;
 NEW BEDD,STAT,EXEC,GLB
 ;
 ;Get list of current dashboard patients
 D BEDDLST^BEDDUTIL(.BEDD)
 ;
 ;Define the index global
 S EXEC="S GLB=$NA(^BEDD.EDDiagnosisI(""ObjIdx""))" X EXEC
 ;
 ;Loop through the current patients and get their dx values
 S STAT="" F  S STAT=$O(BEDD("SUM",STAT)) Q:STAT=""  D
 . NEW OBJID
 . S OBJID="" F  S OBJID=$O(BEDD("SUM",STAT,OBJID)) Q:OBJID=""  D
 .. NEW SPOBJID,DXID,VSTCL,EXEC,VIEN,DECDT,NDECDT
 .. ;
 .. ;Open the visit class
 .. S EXEC="S VSTCL=##CLASS(BEDD.EDVISIT).%OpenId(OBJID)" X EXEC
 .. ;
 .. ;Get the visit IEN
 .. S VIEN=""
 .. S EXEC="S VIEN=VSTCL.VIEN" X EXEC
 .. Q:VIEN=""
 .. ;
 .. ;Get the decision to admit date
 .. S DECDT=""
 .. S EXEC="S DECDT=VSTCL.DecAdmDt" X EXEC
 .. ;
 .. ;Get the decision to admit from PCC
 .. S NDECDT=$$GET1^DIQ(9000010,VIEN_",",1116,"I")
 .. ;
 .. ;If new is blank, fill with old
 .. I NDECDT="",DECDT]"" D
 ... NEW DECUPD,ERROR
 ... S DECUPD(9000010,VIEN_",",1116)=DECDT
 ... D FILE^DIE("","DECUPD","ERROR")
 .. ;
 .. ;Add space to the front
 .. S SPOBJID=" "_OBJID
 .. ;
 .. ;Loop through the entries
 .. S DXID="" F  S DXID=$O(@GLB@(SPOBJID,DXID)) Q:DXID=""  D
 ... NEW DXCL,EXEC,CDIEN,CODE,DFN,PRM,NARR,AMERPOV,AMERVERR,STS
 ... ;
 ... ;Open the diagnosis class
 ... S EXEC="S DXCL=##CLASS(BEDD.EDDiagnosis).%OpenId(DXID)" X EXEC
 ... ;
 ... ;Get any V POV entries - If any already on file, quit
 ... S AMERVERR=$$POV^AMERUTIL("",VIEN,.AMERPOV)
 ... I +AMERVERR Q
 ... ;
 ... ;Get the Code IEN
 ... S CDIEN=""
 ... S EXEC="S CDIEN=DXCL.CodeIEN" X EXEC
 ... Q:CDIEN=""
 ... ;
 ... ;Get the code
 ... S CODE=""
 ... S EXEC="S CODE=DXCL.Code" X EXEC
 ... Q:CODE=""
 ... ;
 ... ;Get primary/secondary
 ... S PRM=""
 ... S EXEC="S PRM=DXCL.PrimaryDiag" X EXEC
 ... Q:PRM=""
 ... ;
 ... ;Get the narrative
 ... S NARR=""
 ... S EXEC="S NARR=DXCL.DiagNarrative" X EXEC
 ... ;
 ... ;Get the DFN
 ... S DFN=""
 ... S EXEC="S DFN=DXCL.DFN" X EXEC
 ... Q:DFN=""
 ... ;
 ... ;Set up the V POV entry
 ... S STS=$$SAVE^BEDDPOV("",CDIEN,NARR,PRM,CODE,"NO",VIEN,DUZ,DFN)
 ;
 Q
