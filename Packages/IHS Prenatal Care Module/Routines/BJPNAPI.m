BJPNAPI ;GDIT/HS/BEE-Prenatal Care Module API Calls ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**8**;Feb 24, 2015;Build 25
 ;
 Q
 ;
PIPA(TARGET,DFN,PARM) ;PEP - Returns PIPA - Active All Notes
 ;
 ;This API returns all Active problems on the prenatal PIP for a patient. For
 ;each problem entry, ALL ACTIVE goals and Care Plans and ALL Visit Instructions associated
 ;with that problem will be returned (even if outside of the current pregnancy window).
 ;
 ;Input:
 ;  DFN - Patient IEN
 ; PARM - (Optional) - Formatting parameter which can contain one or more of the following codes
 ;                   - 'V' - Do NOT display the date beside visit instructions/OB Notes
 ;                   - 'P' - Do NOT display the date entered for the problem
 ;                   - 'H' - Do Not display a hyphen next to each care plan, goal, and visit instruction
 ;                   - 'O' - Include OB Notes
 ;                   - So as an example, passing "VP" would not display either date listed, but the hyphen
 ;                     would still display
 ;
 ;Reset output
 K @TARGET
 ;
 Q $$PIP^BJPNAPI2(TARGET,$G(DFN),"A","","","","",$G(PARM),1)
 ;
PIPN(TARGET,DFN,PARM) ;PEP - Returns PIPN - Active/Inactive All Notes
 ;
 ;This API returns all Active and Inactive problems on the prenatal PIP for a patient. For
 ;each problem entry, ALL ACTIVE and INACTIVE goals and Care Plans, and ALL Visit Instructions associated
 ;with that problem will be returned.
 ;
 ;Input:
 ;  DFN - Patient IEN
 ; PARM - (Optional) - Formatting parameter which can contain one or more of the following codes
 ;                   - 'V' - Do NOT display the date beside visit instructions/OB Notes
 ;                   - 'P' - Do NOT display the date entered for the problem
 ;                   - 'H' - Do Not display a hyphen next to each care plan, goal, and visit instruction
 ;                   - 'O' - Include OB Notes
 ;                   - So as an example, passing "VP" would not display either date listed, but the hyphen
 ;                     would still display
 ;
 ;Reset output
 K @TARGET
 ; 
 Q $$PIP^BJPNAPI2(TARGET,$G(DFN),"A",1,"","","",$G(PARM))
 ;
PIPC(TARGET,DFN,PARM) ;PEP - Returns PIPC - Active All Current Notes
 ;
 ;This API returns all Active problems on the prenatal PIP for a patient. For
 ;each problem entry, ALL ACTIVE goals, Care Plans, and Visit Instructions associated
 ;with that problem FOR THE CURRENT PREGNANCY WINDOW will be returned.
 ;
 ;Input:
 ;  DFN - Patient IEN
 ; PARM - (Optional) - Formatting parameter which can contain one or more of the following codes
 ;                   - 'V' - Do NOT display the date beside visit instructions/OB Notes
 ;                   - 'P' - Do NOT display the date entered for the problem
 ;                   - 'H' - Do Not display a hyphen next to each care plan, goal, and visit instruction
 ;                   - 'O' - Include OB Notes
 ;                   - So as an example, passing "VP" would not display either date listed, but the hyphen
 ;                     would still display
 ;
 ;Reset output
 K @TARGET
 ;
 Q $$PIP^BJPNAPI2(TARGET,$G(DFN),"C","","","","",$G(PARM))
 ;
VPOV(TARGET,DFN,VIEN,PARM) ;PEP - Returns VPOV - Returns POV Active Problems for visit (just VI notes)
 ;
 ;This API returns all active and inactive problems on a patients PIP that were selected as a POV
 ;for the specified visit. Only associated visit instructions are returned.
 ;
 ;Input:
 ;  DFN - Patient IEN
 ; VIEN - Visit IEN - If not passed in, attempt to pull from CONTEXT
 ; PARM - (Optional) - Formatting parameter which can contain one or more of the following codes
 ;                   - 'V' - Do NOT display the date beside visit instructions/OB Notes
 ;                   - 'P' - Do NOT display the date entered for the problem
 ;                   - 'O' - Include OB Notes
 ;                   - So as an example, passing "VP" would not display either date listed
 ;
 ;Reset output
 K @TARGET
 ;
 S VIEN=$G(VIEN)
 I $G(DFN)="" S @TARGET@(1,0)="Invalid DFN" Q "~@"_$NA(@TARGET)
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
 Q $$PIP^BJPNAPI2(TARGET,$G(DFN),"A",1,$G(VIEN),1,"",$G(PARM))
 ;
APOV(TARGET,DFN,VIEN,PARM) ;PEP - Returns VPOV - Returns POV Active Problems for visit (all notes)
 ;
 ;This API returns all problems on a patients PIP that were selected as a POV
 ;for the specified visit. Only associated visit instructions as well as all active
 ;care plans and goals are returned.
 ;
 ;Input:
 ;  DFN - Patient IEN
 ; VIEN - Visit IEN - If not passed in, attempt to pull from CONTEXT
 ; PARM - (Optional) - Formatting parameter which can contain one or more of the following codes
 ;                   - 'V' - Do NOT display the date beside visit instructions/OB Notes
 ;                   - 'P' - Do NOT display the date entered for the problem
 ;                   - 'H' - Do Not display a hyphen next to each care plan, goal, and visit instruction
 ;                   - 'O' - Include OB Notes
 ;                   - So as an example, passing "VP" would not display either date listed, but the hyphen
 ;                     would still display
 ;
 ;Reset output
 K @TARGET
 ;
 I $G(DFN)="" S @TARGET@(1,0)="Invalid DFN" Q "~@"_$NA(@TARGET)
 S VIEN=$G(VIEN)
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
 Q $$PIP^BJPNAPI2(TARGET,$G(DFN),"A",1,$G(VIEN),"","",$G(PARM))
 ;
APIP(TARGET,DFN,TYPE,ASTS,PARM) ;PEP - Returns Prenatal PIP Entry Information
 ;
 ;Input:
 ;  DFN - Patient IEN
 ; TYPE - "C" - Returns list of ALL ACTIVE problem entries on the PIP.
 ;              For each problem entry, returns any notes for each entry
 ;              entered within the date range for the current pregnancy.
 ;        "A" - Returns list of ALL ACTIVE problem entries on the PIP.
 ;              For each problem entry, returns ALL notes for each entry,
 ;              regardless of whether they apply to the current pregnancy
 ;              or to prior pregnancies.
 ;  ASTS - All Statuses (Optional) - If 1, return both Active and Inactive
 ;                                   Problems. Otherwise, just return
 ;                                   Active problems.
 ; PARM - (Optional) - Formatting parameter which can contain one or more of the following codes
 ;                   - 'V' - Do NOT display the date beside visit instructions/OB Notes
 ;                   - 'P' - Do NOT display the date entered for the problem
 ;                   - 'H' - Do Not display a hyphen next to each care plan, goal, and visit instruction
 ;                   - 'O' - Include OB Notes
 ;                   - So as an example, passing "VP" would not display either date listed, but the hyphen
 ;                     would still display
 ;
 ;Reset output
 K @TARGET
 ;
 ;Input validation
 S ASTS=$G(ASTS)
 S PARM=$G(PARM)
 I $G(DFN)="" S @TARGET@(1,0)="Invalid DFN" Q "~@"_$NA(@TARGET)
 I $G(TYPE)="" S @TARGET@(1,0)="Invalid TYPE" Q "~@"_$NA(@TARGET)
 I (",C,A,")'[TYPE D  Q "~@"_$NA(@TARGET)
 . S @TARGET@(1,0)="Invalid TYPE - Must be C or A"
 S VIEN=$G(VIEN) I VIEN]"",$$GET1^DIQ(9000010,VIEN_",",.01,"I")="" D  Q "~@"_$NA(@TARGET)
 . S @TARGET@(1,0)="Invalid VIEN"
 ;
 NEW II,CNT,RESULT,PRBIEN,PCNT,SPACE,TMP,UID,NEDT
 ;
 ;Define task id
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 ;
 ;Definitive EDD date range check
 D GETPAR^CIAVMRPC(.NEDT,"BJPN POST DEDD DAYS","SYS",1,"I","")
 ;
 ;If blank default to 70
 I +$G(NEDT)<1 S NEDT=70
 ;
 ;Call EHR API and format results into usable data
 D COMP^BJPNUTIL(DFN,UID,VIEN)
 S TMP=$NA(^TMP("BJPNIPL",UID))  ;Define compiled data reference
 ;
 ;Loop through PIP - Process each entry
 S PRBIEN="",II=0,PCNT=0 F  S PRBIEN=$O(^BJPNPL("F",DFN,PRBIEN)) Q:PRBIEN=""  D
 . NEW BPIEN,LINE
 . S BPIEN="" F  S BPIEN=$O(^BJPNPL("F",DFN,PRBIEN,BPIEN)) Q:BPIEN=""  D PROC^BJPNAPI1(PRBIEN,BPIEN,ASTS,PARM,PCNT,.II,TYPE,TMP,.RESULT)
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
LPIP(TARGET,DFN,LNOTE,PARM) ;PEP - Returns Prenatal Problems for LATEST prenatal visit
 ;
 ;Returns a list of all prenatal problem entries on the PIP that were used
 ;as the POV for the LATEST (most recent) prenatal visit for the patient. For
 ;each entry, displays the visit instructions entered for that visit (or the
 ;latest visit instruction entered - see LNOTE)
 ;
 ;Input:
 ;              DFN - Patient IEN
 ; LNOTE (optional) - If 1, for each POV problem for the visit, pull the latest
 ;                    visit instruction entered. If none were entered for the 
 ;                    visit, look back to previous visit(s) to get the last one
 ;                    and return it.
 ;                    If not 1, do not look to get the latest visit instruction
 ;                    from the previous visit(s) if the current visit didn't have
 ;                    any.
 ; PARM - (Optional) - Formatting parameter which can contain one or more of the following codes
 ;                   - 'V' - Do NOT display the date beside visit instructions/OB Notes
 ;                   - 'P' - Do NOT display the date entered for the problem
 ;                   - 'H' - Do Not display a hyphen next to each care plan, goal, and visit instruction
 ;                   - 'O' - Include OB Notes
 ;                   - So as an example, passing "VP" would not display either date listed, but the hyphen
 ;                     would still display
 ;
 NEW VIEN,X,PRBIEN,RLIST,PBLIST
 ;
 ;Reset output
 K @TARGET
 ;
 S LNOTE=$G(LNOTE)
 I $G(DFN)="" S @TARGET@(1,0)="Invalid DFN" Q "~@"_$NA(@TARGET)
 ;
 ;Get ordered list of prenatal visits
 D PVST(DFN,.ORLIST,.PBLIST)
 ;
 ;Get current visit
 S VIEN=$G(ORLIST(1))
 I VIEN="" S @TARGET@(1,0)="Could not find Prenatal Visit" Q "~@"_$NA(@TARGET)
 ;
 Q $$PIP^BJPNAPI2(TARGET,$G(DFN),"A",1,$G(VIEN),1,$G(LNOTE),$G(PARM))
 ;
 ;Get list of prenatal visits
PVST(DFN,ORLIST,PBLIST) ;Return list of prenatal POV visits and problems for patient
 ;
 ;This function returns a list of patient visits that have a POV that points to a
 ;problem on the patient's PIP
 ;
 ;Input
 ;   DFN - Patient IEN
 ;
 ;Output
 ; ORLIST(#) - Array of visits, ranked newest to oldest
 ;
 NEW PRBIEN,INVTM,ORD,DPLIST
 ;
 ;Loop through prenatal PIP problems and assemble list of associated IPL entries
 S PRBIEN="" F  S PRBIEN=$O(^BJPNPL("F",DFN,PRBIEN)) Q:PRBIEN=""  D
 . NEW BPIEN
 . S BPIEN="" F  S BPIEN=$O(^BJPNPL("F",DFN,PRBIEN,BPIEN)) Q:BPIEN=""  D
 .. NEW DEL
 .. ;
 .. ;Skip deletes
 .. S DEL=$$GET1^DIQ(90680.01,PRBIEN_",",2.01,"I") Q:DEL]""  ;PIP Delete
 .. S DEL=$$GET1^DIQ(9000011,PRBIEN_",",2.02,"I") Q:DEL]""  ;IPL Delete
 .. ;
 .. ;Add entry to list
 .. S PBLIST(PRBIEN)=BPIEN
 ;
 ;Now loop through the V POV and find the last V POV entry for a PIP problem
 S INVTM="",ORD=0 F  S INVTM=$O(^AUPNVPOV("AA",DFN,INVTM)) Q:INVTM=""  D
 . NEW VPVIEN
 . S VPVIEN="" F  S VPVIEN=$O(^AUPNVPOV("AA",DFN,INVTM,VPVIEN),-1) Q:VPVIEN=""  D
 .. NEW PRBIEN,VIEN
 .. ;
 .. ;Get the IPL entry
 .. S PRBIEN=$$GET1^DIQ(9000010.07,VPVIEN_",",.16,"I") Q:PRBIEN=""
 .. ;
 .. ;Quit if not a prenatal problem
 .. I '$D(PBLIST(PRBIEN)) Q
 .. ;
 .. ;Get the VIEN
 .. S VIEN=$$GET1^DIQ(9000010.07,VPVIEN_",",.03,"I") Q:VIEN=""
 .. Q:$D(DPLIST(VIEN))   ;Quit if visit already filed
 .. ;
 .. ;Set up the ordered list
 .. S ORD=ORD+1,ORLIST(ORD)=VIEN
 .. S DPLIST(VIEN)=""
 Q
 ;
VPIP(TARGET,DFN,VIEN,LNOTE,PARM) ;PEP - Returns Prenatal POV Problems for a Visit
 ;
 ;Returns a list of all prenatal problem entries on the PIP that were used
 ;as the POV for the specified visit. For each entry, displays the visit instructions
 ;entered for that visit (or the latest visit instruction entered - see LNOTE).
 ;
 ;Input:
 ;              DFN - Patient IEN
 ;  VIEN (optional) - Visit IEN - If blank VIEN is pulled from Context
 ; LNOTE (optional) - If 1, for each POV problem for the visit, pull the latest
 ;                    visit instruction entered. If none were entered for the 
 ;                    visit, look back to previous visit(s) to get the last one
 ;                    and return it.
 ;                    If not 1, do not look to get the latest visit instruction
 ;                    from the previous visit(s) if the current visit didn't have
 ;                    any.
 ; PARM - (Optional) - Formatting parameter which can contain one or more of the following codes
 ;                   - 'V' - Do NOT display the date beside visit instructions/OB Notes
 ;                   - 'P' - Do NOT display the date entered for the problem
 ;                   - 'H' - Do Not display a hyphen next to each care plan, goal, and visit instruction
 ;                   - 'O' - Include OB Notes
 ;                   - So as an example, passing "VP" would not display either date listed, but the hyphen
 ;                     would still display
 ;
 ;Reset output
 K @TARGET
 ;                     
 ;Input validation
 S LNOTE=$G(LNOTE)
 I $G(DFN)="" S @TARGET@(1,0)="Invalid DFN" Q "~@"_$NA(@TARGET)
 S VIEN=$G(VIEN) I VIEN]"",$$GET1^DIQ(9000010,VIEN_",",.01,"I")="" D  Q "~@"_$NA(@TARGET)
 . S @TARGET@(1,0)="Invalid VIEN"
 ;
 NEW II,CNT,RESULT,VFIEN,PCNT,SPACE,PARY,X,TMP,UID,TMP,PBLIST,ORLIST,PRBIEN
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
 ;Get the prenatal problems and visit
 ;
 I VIEN="" S @TARGET@(1,0)="No Visit Identified" Q "~@"_$NA(@TARGET)
 ;
 Q $$PIP^BJPNAPI2(TARGET,DFN,"A",1,VIEN,1,LNOTE,$G(PARM))
