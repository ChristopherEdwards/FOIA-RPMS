BJPNAPI2 ;GDIT/HS/BEE-Prenatal Care Module V2.0 API Calls ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**8**;Feb 24, 2015;Build 25
 ;
 Q
 ;
PIP(TARGET,DFN,TYPE,ASTS,VIEN,VONLY,VLAST,PARM,XICG) ;Returns PIPA/PIPN - PIP-Active/Inactive Information
 ;
 ;Input:
 ;  DFN - Patient IEN
 ; TYPE - "C" - Returns list of problem entries on the PIP.
 ;              For each problem entry, returns any information for each entry
 ;              entered within the date range for the current pregnancy.
 ;        "A" - Returns list of problem entries on the PIP.
 ;              For each problem entry, returns ALL information for each entry,
 ;              regardless of whether they apply to the current pregnancy
 ;              or to prior pregnancies.
 ;  ASTS - All Statuses - (Optional) If 1, return both Active and Inactive
 ;              Problems. Otherwise, just return Active problems. 
 ; VIEN - Visit IEN - If populated, only return problems that were set as the POV
 ;              for that visit. Return only visit instructions associated with that visit
 ;  VONLY - 1 - (Optional) Used with VIEN, return only visit instructions/OB Notes for the 
 ;              specified visit
 ;  VLAST - 1 - (Optional) Used with VIEN and VONLY. If 1, get previous instruction/OB Notes if
 ;               there is no instruction on current visit
 ; PARM - (Optional) - Formatting parameter which can contain one or more of the following codes
 ;                   - 'V' - Do NOT display the date beside visit instructions/OB Notes
 ;                   - 'P' - Do NOT display the date entered for the problem
 ;                   - 'H' - Do Not display a hyphen next to each care plan, goal, and visit instruction
 ;                   - 'O' - Include OB Notes
 ;                   - So as an example, passing "VP" would not display either date listed, but the hyphen
 ;                     would still display
 ;  XICG  - 1 - (Optional) - Exclude Inactive Care Plans and Goals regardles of TYPE 
 ;
 ;Input validation
 S ASTS=$G(ASTS)
 I $G(DFN)="" S @TARGET@(1,0)="Invalid DFN" Q "~@"_$NA(@TARGET)
 I $G(TYPE)="" S @TARGET@(1,0)="Invalid TYPE" Q "~@"_$NA(@TARGET)
 ;
 I (",C,A,")'[TYPE D  Q "~@"_$NA(@TARGET)
 . S @TARGET@(1,0)="Invalid TYPE - Must be C or A"
 S VIEN=$G(VIEN) I VIEN]"",$$GET1^DIQ(9000010,VIEN_",",.01,"I")="" D  Q "~@"_$NA(@TARGET)
 . S @TARGET@(1,0)="Invalid VIEN"
 ;
 S VONLY=$G(VONLY) S:VIEN="" VONLY=""
 S VLAST=$G(VLAST) S:VIEN="" VLAST=""
 S XICG=$G(XICG)
 S PARM=$G(PARM)
 ;
 NEW II,CNT,RESULT,PRBIEN,PCNT,UID,TMP,NEDT
 ;
 ;Reset output
 K @TARGET
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
 . NEW BPIEN
 . S BPIEN="" F  S BPIEN=$O(^BJPNPL("F",DFN,PRBIEN,BPIEN)) Q:BPIEN=""  D
 .. D PROC(PRBIEN,BPIEN,ASTS,TMP,VIEN,VONLY,VLAST,PARM)
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
PROC(PRBIEN,BPIEN,ASTS,TMP,VIEN,VONLY,VLAST,PARM) ;EP - Process one entry
 ;
 NEW DEL,PNR,OEDT,OEBY,CNT,WRAP,PDSP,STS,LINE,SPACE,BGO,API,IVOB
 NEW X1,X2,X,DEDD,BRNG,ERNG,GOAL,VISIT,CARE,VSTDT,NVDT,NPDT,NHYP,OBN
 ;
 ;Define formatting parameters
 S NVDT=$S(PARM["V":1,1:"")
 S NPDT=$S(PARM["P":1,1:"")
 S NHYP=$S(PARM["H":1,1:"")
 S IVOB=$S(PARM["O":1,1:"")
 ;
 ;Get the visit date
 S VSTDT="" S:VIEN]"" VSTDT=$$GET1^DIQ(9000010,VIEN_",",.01,"I")
 ;
 S $P(SPACE," ",80)=" "
 ;
 ;Skip deletes
 S DEL=$$GET1^DIQ(90680.01,BPIEN_",",2.01,"I") Q:DEL]""  ;PIP Delete
 S DEL=$$GET1^DIQ(9000011,PRBIEN_",",2.02,"I") I DEL]"" Q  ;IPL Delete
 ;
 ;Retrieve the entry from the API results
 S BGO=$O(@TMP@("P",PRBIEN,"")) Q:BGO=""   ;Quit if no IPL entry
 S API=$G(@TMP@("P",PRBIEN,BGO)) Q:API=""
 ;
 ;If passed in only return POV problems
 I VIEN]"",$P(API,U,31)="" Q
 ;
 ;Status - Active Only
 S STS=$$GET1^DIQ(90680.01,BPIEN_",",.08,"I")
 I '$G(ASTS),STS'="A" Q
 ;
 ;Provider Text
 S PNR=$P(API,U,8)
 ;
 ;Tack on Inactive
 I STS'="A" S PNR="(i)"_PNR
 ;
 ;Original Entry Date
 S OEDT=$$FMTE^XLFDT($$GET1^DIQ(9000011,PRBIEN_",",.08,"I"),"2D")
 ;
 ;Original Entry By
 S OEBY=$$GET1^DIQ(9000011,PRBIEN_",",1.03,"E")
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
 S II=II+1,RESULT(II)=$E(SPACE,1,4)_"(Entered"_$S(NPDT:"",1:" "_OEDT)_$S(OEBY]"":" by ",1:"")_OEBY_")"
 ;
 ;Pull Definitive EDD
 S DEDD=$$GET1^DIQ(90680.01,BPIEN_",",.09,"I")
 S X1=DEDD,X2=-280 D C^%DTC S BRNG=X
 S X1=DEDD,X2=NEDT D C^%DTC S ERNG=X
 ;
 ;Reset Notes Entries
 S (GOAL,CARE,VISIT,OBN)=""
 ;
 ;Loop through goals
 I 'VONLY S BGO="" F  S BGO=$O(@TMP@("G",PRBIEN,BGO)) Q:BGO=""  D
 . ;
 . NEW APIRES,VISIT,NIEN,IENS,DA,SCO,WRAP
 . NEW DTTM,MDBY,ILMBY,NOTE,NSTS,SIGN
 . ;
 . S SIGN=""
 . S APIRES=$G(@TMP@("G",PRBIEN,BGO,0)) Q:APIRES=""
 . ;
 . ;Skip Inactive Goals for Current Display
 . S NSTS=$P(APIRES,U,6),NSTS=$S(NSTS="A":"a",1:"i")
 . I TYPE="C",NSTS'="a" Q
 . ;
 . ;Skip Inactive Goals if override set
 . I XICG=1,NSTS'="a" Q
 . ;
 . ;Get note date/time entered and by
 . S (DTTM,ILMBY)=""
 . ;
 . ;Note IEN
 . S NIEN=$P(APIRES,U,2) Q:NIEN=""
 . ;
 . ;Get note date/time entered and by - Goal
 . S DA=$O(^AUPNCPL(NIEN,11,"B","A",""),-1) Q:DA=""
 . S DA(1)=NIEN,IENS=$$IENS^DILF(.DA)
 . S DTTM=$$GET1^DIQ(9000092.11,IENS,".03","I")
 . S ILMBY=$$GET1^DIQ(9000092.11,IENS,".02","I")
 . S SIGN=$P(APIRES,U,7)
 . ;
 . Q:DTTM=""
 . S MDBY=$$GET1^DIQ(200,ILMBY_",",".01","E")
 . ;
 . ;Get Note
 . S NOTE=$P($G(@TMP@("G",PRBIEN,BGO,1)),U,2)
 . Q:NOTE=""
 . ;
 . ;Note Status
 . S NSTS=$S(VIEN]"":" ",TYPE="C":" ",XICG=1:" ",1:" ("_NSTS_") ")
 . ;
 . ;Determined signed/unsigned
 . S SIGN=$S(SIGN]"":"S",1:"U")
 . ;
 . ;Set up record
 . ;
 . ;Display Header
 . I 'GOAL D
 .. NEW WRAP
 .. D WRAP^BJPNPRNT(.WRAP,"Goal Notes",75,2)
 .. S II=II+1,RESULT(II)=$E(SPACE,1,6)_$G(WRAP(1))
 .. S GOAL=1
 . ;
 . ;Handle Wrapping
 . D WRAP^BJPNPRNT(.WRAP,$S(NHYP:"",1:"-")_NSTS_NOTE_" ("_$$FMTE^XLFDT(DTTM,"2D")_$S(MDBY]"":" by ",1:"")_MDBY_")",72,2)
 . ;
 . ;Process each wrapped line
 . S WRAP="" F LINE=1:1 S WRAP=$O(WRAP(WRAP)) Q:WRAP=""  D
 .. S II=II+1,RESULT(II)=$E(SPACE,1,8)_WRAP(WRAP)
 ;
 ;Loop through care plans
 I 'VONLY S BGO="" F  S BGO=$O(@TMP@("C",PRBIEN,BGO)) Q:BGO=""  D
 . ;
 . NEW APIRES,VISIT,NIEN,IENS,DA,SCO,WRAP
 . NEW DTTM,MDBY,ILMBY,NOTE,NSTS,SIGN
 . ;
 . S SIGN=""
 . S APIRES=$G(@TMP@("C",PRBIEN,BGO,0)) Q:APIRES=""
 . ;
 . ;Skip Inactive Care Plans for Current Display
 . S NSTS=$P(APIRES,U,6),NSTS=$S(NSTS="A":"a",1:"i")
 . I TYPE="C",NSTS'="a" Q
 . ;
 . ;Skip Inactive Care Plans if override set
 . I XICG=1,NSTS'="a" Q
 . ;
 . ;Get note date/time entered and by
 . S (DTTM,ILMBY)=""
 . ;
 . ;Note IEN
 . S NIEN=$P(APIRES,U,2) Q:NIEN=""
 . ;
 . ;Get note date/time entered and by - Goal
 . S DA=$O(^AUPNCPL(NIEN,11,"B","A",""),-1) Q:DA=""
 . S DA(1)=NIEN,IENS=$$IENS^DILF(.DA)
 . S DTTM=$$GET1^DIQ(9000092.11,IENS,".03","I")
 . S ILMBY=$$GET1^DIQ(9000092.11,IENS,".02","I")
 . S SIGN=$P(APIRES,U,7)
 . ;
 . Q:DTTM=""
 . S MDBY=$$GET1^DIQ(200,ILMBY_",",".01","E")
 . ;
 . ;Get Note
 . S NOTE=$P($G(@TMP@("C",PRBIEN,BGO,1)),U,2)
 . Q:NOTE=""
 . ;
 . ;Note Status
 . S NSTS=$S(VIEN]"":" ",TYPE="C":" ",XICG=1:" ",1:" ("_NSTS_") ")
 . ;
 . ;Determined signed/unsigned
 . S SIGN=$S(SIGN]"":"S",1:"U")
 . ;
 . ;Set up record
 . ;
 . ;Display Header
 . I 'CARE D
 .. ;
 .. ;Skip a line if there were goals
 .. I GOAL S II=II+1,RESULT(II)=" "
 .. ;
 .. NEW WRAP
 .. D WRAP^BJPNPRNT(.WRAP,"Care Plan",75,2)
 .. S II=II+1,RESULT(II)=$E(SPACE,1,6)_$G(WRAP(1))
 .. S CARE=1
 . ;
 . ;Handle Wrapping
 . D WRAP^BJPNPRNT(.WRAP,$S(NHYP:"",1:"-")_NSTS_NOTE_" ("_$$FMTE^XLFDT(DTTM,"2D")_$S(MDBY]"":" by ",1:"")_MDBY_")",72,2)
 . ;
 . ;Process each wrapped line
 . S WRAP="" F LINE=1:1 S WRAP=$O(WRAP(WRAP)) Q:WRAP=""  D
 .. S II=II+1,RESULT(II)=$E(SPACE,1,8)_WRAP(WRAP)
 ;
 ;Loop through OB Notes (Return All)
 I IVOB S BGO="" F  S BGO=$O(@TMP@("O",PRBIEN,BGO)) Q:BGO=""  D
 . ;
 . NEW APIRES,NIEN,IENS,DA,SCO,WRAP,SKIP
 . NEW DTTM,MDBY,ILMBY,NOTE,NSTS,SIGN,VSIT
 . ;
 . S SIGN=""
 . S APIRES=$G(@TMP@("O",PRBIEN,BGO,0)) Q:APIRES=""
 . ;
 . ;Filter out unmatch visits, if desired
 . S VSIT=$P(APIRES,U,9)
 . I 'VLAST,VIEN]"",VSIT'=VIEN Q
 . ;
 . ;See if only last note should be displayed
 . S SKIP="" I VLAST D  Q:SKIP
 .. NEW VDT
 .. S VDT=$$GET1^DIQ(9000010,VSIT_",",.01,"I")
 .. I VDT>VSTDT S SKIP=1
 .. I VSIT'=VIEN,VISIT S SKIP=1
 . ;
 . ;Get note date/time entered and by
 . S (DTTM,ILMBY)=""
 . ;
 . ;Note IEN
 . S NIEN=$P(APIRES,U,2) Q:NIEN=""
 . ;
 . ;Get note date/time entered and by - V VISIT INSTRUCTIONS
 . S (DTTM,ILMBY)=""
 . S DTTM=$$GET1^DIQ(9000010.43,NIEN_",",1216,"I")
 . S ILMBY=$$GET1^DIQ(9000010.43,NIEN_",",1217,"I")
 . S SIGN=$P(APIRES,U,13)
 . ;
 . Q:DTTM=""
 . S MDBY=$$GET1^DIQ(200,ILMBY_",",".01","E")
 . ;
 . ;Get Note
 . S NOTE=$P($G(@TMP@("O",PRBIEN,BGO,1)),U,2)
 . Q:NOTE=""
 . ;
 . ;Note Status
 . S NSTS="i"
 . I DEDD]"",DTTM'<BRNG,DTTM'>ERNG S NSTS="a"
 . ;
 . ;Quit if current display and out of pregnancy range
 . I TYPE="C",NSTS="i" Q
 . ;
 . S NSTS=$S(VIEN]"":" ",TYPE="C":" ",1:" ("_NSTS_") ")
 . ;
 . ;Determined signed/unsigned
 . S SIGN=$S(SIGN]"":"S",1:"U")
 . ;
 . ;Set up record
 . ;
 . ;Display Header
 . I 'OBN D
 .. ;
 .. ;Skip a line if there were goals
 .. I GOAL!CARE S II=II+1,RESULT(II)=" "
 .. ;
 .. NEW WRAP
 .. D WRAP^BJPNPRNT(.WRAP,"OB Brief Note",75,2)
 .. S II=II+1,RESULT(II)=$E(SPACE,1,6)_$G(WRAP(1))
 .. S OBN=1
 . ;
 . ;Handle Wrapping
 . D WRAP^BJPNPRNT(.WRAP,$S(NHYP:"",1:"-")_NSTS_NOTE_" ("_$S('NVDT:$$FMTE^XLFDT(DTTM,"2D")_" ",1:"")_$S(MDBY]"":"by ",1:"")_MDBY_")",72,2)
 . ;
 . ;Process each wrapped line
 . S WRAP="" F LINE=1:1 S WRAP=$O(WRAP(WRAP)) Q:WRAP=""  D
 .. S II=II+1,RESULT(II)=$E(SPACE,1,8)_WRAP(WRAP)
 ;
 ;Loop through Visit Instructions (Return All)
 S BGO="" F  S BGO=$O(@TMP@("I",PRBIEN,BGO)) Q:BGO=""  D
 . ;
 . NEW APIRES,NIEN,IENS,DA,SCO,WRAP,SKIP
 . NEW DTTM,MDBY,ILMBY,NOTE,NSTS,SIGN,VSIT
 . ;
 . S SIGN=""
 . S APIRES=$G(@TMP@("I",PRBIEN,BGO,0)) Q:APIRES=""
 . ;
 . ;Filter out unmatch visits, if desired
 . S VSIT=$P(APIRES,U,9)
 . I 'VLAST,VIEN]"",VSIT'=VIEN Q
 . ;
 . ;See if only last note should be displayed
 . S SKIP="" I VLAST D  Q:SKIP
 .. NEW VDT
 .. S VDT=$$GET1^DIQ(9000010,VSIT_",",.01,"I")
 .. I VDT>VSTDT S SKIP=1
 .. I VSIT'=VIEN,VISIT S SKIP=1
 . ;
 . ;Get note date/time entered and by
 . S (DTTM,ILMBY)=""
 . ;
 . ;Note IEN
 . S NIEN=$P(APIRES,U,2) Q:NIEN=""
 . ;
 . ;Get note date/time entered and by - V VISIT INSTRUCTIONS
 . S (DTTM,ILMBY)=""
 . S DTTM=$$GET1^DIQ(9000010.58,NIEN_",",1216,"I")
 . S ILMBY=$$GET1^DIQ(9000010.58,NIEN_",",1217,"I")
 . S SIGN=$P(APIRES,U,13)
 . ;
 . Q:DTTM=""
 . S MDBY=$$GET1^DIQ(200,ILMBY_",",".01","E")
 . ;
 . ;Get Note
 . S NOTE=$P($G(@TMP@("I",PRBIEN,BGO,1)),U,2)
 . Q:NOTE=""
 . ;
 . ;Note Status
 . S NSTS="i"
 . I DEDD]"",DTTM'<BRNG,DTTM'>ERNG S NSTS="a"
 . ;
 . ;Quit if current display and out of pregnancy range
 . I TYPE="C",NSTS="i" Q
 . ;
 . S NSTS=$S(VIEN]"":" ",TYPE="C":" ",1:" ("_NSTS_") ")
 . ;
 . ;Determined signed/unsigned
 . S SIGN=$S(SIGN]"":"S",1:"U")
 . ;
 . ;Set up record
 . ;
 . ;Display Header
 . I 'VISIT D
 .. ;
 .. ;Skip a line if there were goals
 .. I GOAL!CARE!OBN S II=II+1,RESULT(II)=" "
 .. ;
 .. NEW WRAP
 .. D WRAP^BJPNPRNT(.WRAP,"Visit Instructions",75,2)
 .. S II=II+1,RESULT(II)=$E(SPACE,1,6)_$G(WRAP(1))
 .. S VISIT=1
 . ;
 . ;Handle Wrapping
 . D WRAP^BJPNPRNT(.WRAP,$S(NHYP:"",1:"-")_NSTS_NOTE_" ("_$S('NVDT:$$FMTE^XLFDT(DTTM,"2D")_" ",1:"")_$S(MDBY]"":"by ",1:"")_MDBY_")",72,2)
 . ;
 . ;Process each wrapped line
 . S WRAP="" F LINE=1:1 S WRAP=$O(WRAP(WRAP)) Q:WRAP=""  D
 .. S II=II+1,RESULT(II)=$E(SPACE,1,8)_WRAP(WRAP)
 ;
 Q
