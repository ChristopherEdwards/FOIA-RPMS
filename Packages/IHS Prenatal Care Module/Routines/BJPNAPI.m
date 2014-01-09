BJPNAPI ;GDIT/HS/BEE-Prenatal Care Module API Calls ; 08 May 2012  12:00 PM
 ;;1.0;PRENATAL CARE MODULE;;Dec 06, 2012;Build 61
 ;
 Q
 ;
APIP(TARGET,DFN,TYPE,ASTS) ;PEP - Returns Prenatal PIP Entry Information
 ;
 ;Input:
 ;  DFN - Patient IEN
 ; TYPE - "C" - Returns list of ALL ACTIVE problem entries on the PIP.
 ;              For each problem entry, returns any notes for each entry
 ;              entered within the date range for the current pregancy.
 ;        "A" - Returns list of ALL ACTIVE problem entries on the PIP.
 ;              For each problem entry, returns ALL notes for each entry,
 ;              regardless of whether they apply to the current pregnancy
 ;              or to prior pregnancies.
 ;  ASTS - All Statuses (Optional) - If 1, return both Active and Inactive.
 ;                                   Problems. Otherwise, just return
 ;                                   Active problems.
 ;
 ;Input validation
 S ASTS=$G(ASTS)
 I $G(DFN)="" S @TARGET@(1,0)="Invalid DFN" Q "~@"_$NA(@TARGET)
 I $G(TYPE)="" S @TARGET@(1,0)="Invalid TYPE" Q "~@"_$NA(@TARGET)
 I (",C,A,")'[TYPE D  Q "~@"_$NA(@TARGET)
 . S @TARGET@(1,0)="Invalid TYPE - Must be C or A"
 S VIEN=$G(VIEN) I VIEN]"",$$GET1^DIQ(9000010,VIEN_",",.01,"I")="" D  Q "~@"_$NA(@TARGET)
 . S @TARGET@(1,0)="Invalid VIEN"
 ;
 NEW II,CNT,RESULT,PKIEN,PCNT,SPACE
 ;
 ;Reset output
 K @TARGET
 ;
 ;Loop through PIP - Process each entry
 S PKIEN="",II=0,PCNT=0 F  S PKIEN=$O(^BJPNPL("AC",DFN,PKIEN)) Q:PKIEN=""  D
 . NEW PLIEN,LINE
 . S PLIEN="" F  S PLIEN=$O(^BJPNPL("AC",DFN,PKIEN,PLIEN)) Q:PLIEN=""  D PROC(PLIEN,ASTS)
 ;
 ;Clear out scratch global
 K ^TMP("BJPNPRL",$J)
 ;
 ;Define Output
 S (II,CNT)=0 F  S II=$O(RESULT(II)) Q:'II  D
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=RESULT(II)
 I 'CNT S @TARGET@(1,0)="No Active Problems for Current Pregnanacy"
 Q "~@"_$NA(@TARGET)
 ;
LPIP(TARGET,DFN,LNOTE) ;PEP - Returns Prenatal Problems for LATEST prenatal visit
 ;
 ;Returns a list of all prenatal problem entries on the PIP that were used
 ;as the POV for the LATEST (most recent) prenatal visit for the patient. For
 ;each entry, displays the notes entered for that visit
 ;
 ;Input:
 ;              DFN - Patient IEN
 ; LNOTE (optional) - If 1, return last previous note(s) if current notes are blank
 ;
 NEW PIEN,VIEN,CVIEN,VDT,CDT,X
 S LNOTE=$G(LNOTE)
 ;
 S (CDT,CVIEN,PIEN)="" F  S PIEN=$O(^AUPNVOB("AC",DFN,PIEN)) Q:PIEN=""  D
 . S VIEN=$$GET1^DIQ(9000010.43,PIEN_",",.03,"I") Q:VIEN=""  D
 .. S VDT=$$GET1^DIQ(9000010,VIEN_",",".01","I") Q:VDT=""
 .. I VDT>CDT S CVIEN=VIEN,CDT=VDT
 I CVIEN="" S @TARGET@(1,0)="Could not find Prenatal Visit" Q "~@"_$NA(@TARGET)
 ;
 ;Retrieve information for latest visit
 S X=$$VPIP(TARGET,DFN,CVIEN,LNOTE)
 Q "~@"_$NA(@TARGET)
 ;
VPIP(TARGET,DFN,VIEN,LNOTE) ;PEP - Returns Prenatal POV Problems for a Visit
 ;
 ;Returns a list of all prenatal problem entries on the PIP that were used
 ;as the POV for the specified visit. For each entry, displays the notes
 ;entered for that visit.
 ;
 ;Input:
 ;  DFN - Patient IEN
 ; VIEN (optional) - Visit IEN - If blank VIEN is pulled from Context
 ; LNOTE (optional) - If 1, return last previous note(s) if current notes are blank 
 ;
 ;Input validation
 S LNOTE=$G(LNOTE)
 I $G(DFN)="" S @TARGET@(1,0)="Invalid DFN" Q "~@"_$NA(@TARGET)
 S VIEN=$G(VIEN) I VIEN]"",$$GET1^DIQ(9000010,VIEN_",",.01,"I")="" D  Q "~@"_$NA(@TARGET)
 . S @TARGET@(1,0)="Invalid VIEN"
 ;
 NEW II,CNT,RESULT,VFIEN,PCNT,SPACE,PARY,X
 ;
 ;Pull visit from context
 I VIEN="" D  I VIEN="" Q "~@"_$NA(@TARGET)
 . NEW VST,X
 . I $T(GETVAR^CIAVMEVT)="" S @TARGET@(1,0)="Invalid context variables" Q
 . S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 . I VST="" S @TARGET@(1,0)="Invalid visit" Q
 . S X="BEHOENCX" X ^%ZOSF("TEST")
 . I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid visit" Q
 . S VIEN=VST
 ;
 I VIEN="" S @TARGET@(1,0)="No Visit Identified" Q "~@"_$NA(@TARGET)
 ;
 ;Reset output
 K @TARGET
 ;
 ;Loop through V OB - Process each entry
 S VFIEN="" F  S VFIEN=$O(^AUPNVOB("AF",DFN,VIEN,VFIEN)) Q:VFIEN=""  D
 . NEW PLIEN,STS,PNAR,OEDT,OEBY
 . ;
 . ;Retrieve pointer to PIP entry
 . S PLIEN=$$GET1^DIQ(9000010.43,VFIEN_",",".01","I") Q:'PLIEN
 . ;
 . ;Check for delete
 . I $$GET1^DIQ(9000010.43,VFIEN_",","2.01","I")]"" K PARY(PLIEN) Q
 . ;
 . ;Check to see if this problem was a POV
 . I $$VPOV^BJPNPUP(VIEN,PLIEN)'="Y" Q
 . ;
 . ;Check status - only include Actives
 . S STS=$$GET1^DIQ(9000010.43,VFIEN_",",.09,"I")
 . S $P(PARY(PLIEN),U,4)=STS
 . ;
 . ;Provider Narrative
 . S PNAR=$$GET1^DIQ(9000010.43,VFIEN_",",".11","E")
 . S $P(PARY(PLIEN),U)=PNAR
 . ;
 . ;Original Entry Date
 . S OEDT=$$FMTE^XLFDT($$GET1^DIQ(9000010.43,VFIEN_",","1216","I"),"2D")
 . S $P(PARY(PLIEN),U,2)=OEDT
 . ;
 . ;Original Entry By
 . S OEBY=$$GET1^DIQ(9000010.43,VFIEN_",","1217","E")
 . S $P(PARY(PLIEN),U,3)=OEBY
 ;
 ;Now loop through results and pull notes
 S II=0,PCNT=0,CNT=0,PLIEN="" F  S PLIEN=$O(PARY(PLIEN)) Q:PLIEN=""  D
 . ;
 . NEW OEDT,OEBY,STS
 . ;
 . ;Only include actives
 . I $P(PARY(PLIEN),U,4)'="A" Q
 . S OEDT=$$FMTE^XLFDT($P(PARY(PLIEN),U,2),"2D")
 . S OEBY=$P(PARY(PLIEN),U,3)
 . S PNAR=$P(PARY(PLIEN),U)
 . ;
 . ;Set up entries
 . D VPROC(PLIEN,VIEN,PNAR,OEDT,OEBY,LNOTE)
 ;
 ;Clear out scratch global
 K ^TMP("BJPNPRL",$J)
 ;
 ;Define Output
 S (II,CNT)=0 F  S II=$O(RESULT(II)) Q:'II  D
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=RESULT(II)
 I 'CNT S @TARGET@(1,0)="No Problems Listed as POV for Visit"
 Q "~@"_$NA(@TARGET)
 ;
PROC(PLIEN,ASTS) ;EP - Process one entry
 ;
 NEW DEL,SMD,STRM,PTX,PNR,OEDT,OEBY,CNT,WRAP,PDSP,STS,LINE
 ;
 S $P(SPACE," ",80)=" "
 ;
 ;Skip deletes
 S DEL=$$GET1^DIQ(90680.01,PLIEN_",",2.01,"I") Q:DEL]""
 ;
 ;Status - Active Only
 S STS=$$GET1^DIQ(90680.01,PLIEN_",",.08,"I")
 I '$G(ASTS),STS'="A" Q
 ;
 ;SNOMED Term
 S SMD=$$GET1^DIQ(90680.01,PLIEN_",",.03,"I") Q:SMD=""
 S STRM=$$GET1^DIQ(90680.02,SMD_",",.02,"E") Q:STRM=""
 ;
 ;Provider Text
 S PTX=$$GET1^DIQ(90680.01,PLIEN_",",.05,"E")
 ;
 ;Provider Narrative
 S PNR=STRM_"| "_PTX
 ;
 ;Tack on Inactive
 I STS'="A" S PNR="(i)"_PNR
 ;
 ;Original Entry Date
 S OEDT=$$FMTE^XLFDT($$GET1^DIQ(90680.01,PLIEN_",",1.01,"I"),"2D")
 ;
 ;Original Entry By
 S OEBY=$$GET1^DIQ(90680.01,PLIEN_",",1.02,"E")
 ;
 ;Problem Count
 S PCNT=PCNT+1 I PCNT>1 S II=II+1,RESULT(II)=" "
 S PDSP=PCNT_")  ",PDSP=$E(PDSP,1,4)
 ;
 ;Handle Wrapping
 D WRAP^BJPNPRNT(.WRAP,PNR,76)
 ;
 ;Process each wrapped line
 S WRAP="" F LINE=1:1 S WRAP=$O(WRAP(WRAP)) Q:WRAP=""  D
 . S II=II+1,RESULT(II)=$S(LINE=1:PDSP,1:($E(SPACE,1,4)))_WRAP(WRAP)
 ;
 ;Tack on Date/By
 S II=II+1,RESULT(II)=$E(SPACE,1,4)_"(Entered "_OEDT_$S(OEBY]"":" by ",1:"")_OEBY_")"
 ;
 D NOTES^BJPNPRL("",DFN,PLIEN,1)
 ;
 ;Loop through each entry
 S CNT=0 F  S CNT=$O(^TMP("BJPNPRL",$J,CNT)) Q:CNT=""  D  I TYPE="N" Q
 . ;
 . NEW ENTRY,WRAP,LMDT,LMBY,NOTE,LINE,SCO
 . S ENTRY=$G(^TMP("BJPNPRL",$J,CNT))
 . ;
 . ;Skip Last Entry
 . I ENTRY=$C(31) Q
 . ;
 . ;Process All/Current
 . I TYPE="C",$P(ENTRY,U,6)="A" Q
 . ;
 . ;Get LMDT
 . S LMDT=$$FMTE^XLFDT($$DATE^BJPNPRUT($P(ENTRY,U,7)),"2D")
 . ;
 . ;Scope
 . S SCO=$S(TYPE="C":"",1:(" ("_$P(ENTRY,U,6)_")"))
 . ;
 . ;Get LMBY
 . S LMBY=$P(ENTRY,U,8)
 . ;
 . ;Get Note
 . S NOTE=$TR($P(ENTRY,U,9),$C(30))
 . ;
 . ;Handle Wrapping
 . D WRAP^BJPNPRNT(.WRAP,"*"_LMDT_SCO_$S(LMBY]"":" by ",1:"")_LMBY_" - "_NOTE,75,4)
 . ;
 . ;Process each wrapped line
 . S WRAP="" F LINE=1:1 S WRAP=$O(WRAP(WRAP)) Q:WRAP=""  D
 .. S II=II+1,RESULT(II)=$E(SPACE,1,4)_WRAP(WRAP)
 Q
 ;
VPROC(PLIEN,VIEN,PNAR,OEDT,OEBY,LNOTE) ;EP - Process one V entry
 ;
 NEW DEL,SMD,STRM,PTX,PNR,CNT,WRAP,PDSP,LINE,VNOTES,LVST
 ;
 S $P(SPACE," ",80)=" "
 S LNOTE=$G(LNOTE)
 ;
 ;Problem Count
 S PCNT=PCNT+1 I PCNT>1 S II=II+1,RESULT(II)=" "
 S PDSP=PCNT_")  ",PDSP=$E(PDSP,1,4)
 ;
 ;Handle Wrapping
 D WRAP^BJPNPRNT(.WRAP,PNAR,76)
 ;
 ;Process each wrapped line
 S WRAP="" F LINE=1:1 S WRAP=$O(WRAP(WRAP)) Q:WRAP=""  D
 . S II=II+1,RESULT(II)=$S(LINE=1:PDSP,1:($E(SPACE,1,4)))_WRAP(WRAP)
 ;
 ;Tack on Date/By
 S II=II+1,RESULT(II)=$E(SPACE,1,4)_"(Entered "_OEDT_$S(OEBY]"":" by ",1:"")_OEBY_")"
 ;
 D NOTES^BJPNPRL("",DFN,PLIEN,1)
 ;
 ;Get current visit date and get latest visit (cur date and prior) with notes
 S LVST=VIEN
 I LNOTE D
 . S CNT=0 F  S CNT=$O(^TMP("BJPNPRL",$J,CNT)) Q:CNT=""  D
 .. NEW VDT,CVIEN,NODE,CVDT,LVDT
 .. S NODE=^TMP("BJPNPRL",$J,CNT)
 .. S VDT=$$DATE^BJPNPRUT($P(NODE,U,5)) Q:VDT=""
 .. S CVIEN=$P(NODE,U,4) Q:CVIEN=""
 .. S VNOTES(VDT,CVIEN,CNT)=^TMP("BJPNPRL",$J,CNT)
 . ;
 . S CVDT=$$GET1^DIQ(9000010,VIEN_",",.01,"I")_"001"
 . S LVDT=$O(VNOTES((CVDT_"001")),-1) Q:LVDT=""
 . S LVST=$O(VNOTES(LVDT,""),-1)
 ;
 ;Loop through each entry
 S CNT=0 F  S CNT=$O(^TMP("BJPNPRL",$J,CNT)) Q:CNT=""  D
 . ;
 . NEW ENTRY,WRAP,LMDT,LMBY,NOTE,LINE
 . S ENTRY=$G(^TMP("BJPNPRL",$J,CNT))
 . ;
 . ;Skip Last Entry
 . I ENTRY=$C(31) Q
 . ;
 . ;Check for visit match
 . I LVST'=$P(ENTRY,U,4) Q
 . ;
 . ;Get LMDT
 . S LMDT=$$FMTE^XLFDT($$DATE^BJPNPRUT($P(ENTRY,U,7)),"2D")
 . ;
 . ;Get LMBY
 . S LMBY=$P(ENTRY,U,8)
 . ;
 . ;Get Note
 . S NOTE=$TR($P(ENTRY,U,9),$C(30))
 . ;
 . ;Handle Wrapping
 . D WRAP^BJPNPRNT(.WRAP,"*"_LMDT_$S(LMBY]"":" by ",1:"")_LMBY_" - "_NOTE,75,4)
 . ;
 . ;Process each wrapped line
 . S WRAP="" F LINE=1:1 S WRAP=$O(WRAP(WRAP)) Q:WRAP=""  D
 .. S II=II+1,RESULT(II)=$E(SPACE,1,4)_WRAP(WRAP)
 Q
