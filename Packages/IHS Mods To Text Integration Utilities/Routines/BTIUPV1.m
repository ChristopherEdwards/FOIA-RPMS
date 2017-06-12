BTIUPV1 ; IHS/MSC/MGH - Problem Objects ;27-Apr-2016 12:29;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1012,1013,1014,1016**;MAR 20, 2013;Build 10
 ;4/13/13
 ;IHS/MSC/MGH Patch 1016 added normal/abnormal qualifier
 ;
 Q
 ;Get the problems associated with the last visit and only the latest or items updated.
VST(DFN,TARGET) ;Problems updated this visit
 N PROB,CNT,RET,PRIEN,I,VST,FOUND
 S FOUND=0,CNT=0
 K @TARGET
 S INVDT="" F  S INVDT=$O(^AUPNVSIT("AA",DFN,INVDT)) Q:'+INVDT!(FOUND=1)  D
 .S VIEN="" F  S VIEN=$O(^AUPNVSIT("AA",DFN,INVDT,VIEN)) Q:'+VIEN!(FOUND=1)  D
 ..I "AIH"[$P($G(^AUPNVSIT(VIEN,0)),U,7) D
 ...D GETPRB(VIEN)
 I CNT=0 S @TARGET@(1,0)="No Problems used as POVs in this visit record"
 Q "~@"_$NA(@TARGET)
 ;
GETPRB(VIEN) ;Get problems to update
 S PRIEN=0
 F  S PRIEN=$O(^AUPNPROB("AC",DFN,PRIEN)) Q:'PRIEN  D
 .;Check for which statuses to return
 .S STAT=$P($G(^AUPNPROB(PRIEN,0)),U,12)
 .Q:STAT="D"
 .I $D(^AUPNPROB(PRIEN,14,"B",VIEN)) S FOUND=1 D GETDATA(PRIEN,VIEN)
 Q
GETDATA(PRIEN,VIEN) ;Get data for the problem
 N NARR,STATUS,ICD
 S NARR=$$GET1^DIQ(9000011,PRIEN,.05)
 D ADD("Problem: "_NARR)
 S STATUS=$$GET1^DIQ(9000011,PRIEN,.12)
 S ICD=$$GET1^DIQ(9000011,PRIEN,.01)
 D ADD(" -Mapped ICD:"_ICD_" Status: "_STATUS)
 D QUAL(PRIEN,.CNT)
 D FINDCP(PRIEN,"G",.CNT)
 D FINDCP(PRIEN,"P",.CNT)
 D VIDT(PRIEN,VIEN,.CNT)
 D ADD("")
 Q
ADD(DATA) ;add to list
 S CNT=CNT+1
 S @TARGET@(CNT,0)=DATA
 Q
QUAL(IEN,CNT) ;Get any qualifiers for this problem
 N AIEN,IEN2,BY,WHEN,X,FNUM,Q,QUAL
 S CNT=$G(CNT)
 I $D(^AUPNPROB(IEN,13))!($D(^AUPNPROB(IEN,17)))!($D(^AUPNPROB(IEN,18))) D ADD("   -QUALIFIERS:")
 F X=13,17,18 D
 .S QUAL=""
 .S FNUM=$S(X=13:9000011.13,X=17:9000011.17,X=18:9000011.18)
 .S IEN2=0 F  S IEN2=$O(^AUPNPROB(IEN,X,IEN2)) Q:'+IEN2  D
 ..S AIEN=IEN2_","_IEN_","
 ..S Q=$$GET1^DIQ(FNUM,AIEN,.01)
 ..S Q=$$CONCEPT^BGOPAUD(Q)
 ..I QUAL="" S QUAL=Q
 ..E  S QUAL=QUAL_" "_Q
 .I QUAL'="" D ADD("   "_QUAL)
 Q
FINDCP(PRIEN,TYPE,CNT) ;Find a care plan
 N INVDT,STATUS,EDATE,IEN,NODE,PRV,PRVNM,CPIEN,SIGN,NODE,Z,DONE,SIEN,PCNT,ARRAY
 S DONE=0,PCNT=0,ARRAY=""
 S CPIEN="" F  S CPIEN=$O(^AUPNCPL("APT",PRIEN,TYPE,CPIEN)) Q:CPIEN=""  D
 .S SIEN=$C(0) S SIEN=$O(^AUPNCPL(CPIEN,11,SIEN),-1)
 .S STATUS=$P($G(^AUPNCPL(CPIEN,11,SIEN,0)),U,1)
 .Q:STATUS'="A"
 .S INVDT=9999999-$P($G(^AUPNCPL(CPIEN,0)),U,5)
 .S ARRAY(INVDT,CPIEN)=""
 Q:$D(ARRAY)<10
 S INVDT="" F  S INVDT=$O(ARRAY(INVDT)) Q:'+INVDT  D
 .S CPIEN="" F  S CPIEN=$O(ARRAY(INVDT,CPIEN)) Q:'+CPIEN  D
 ..I PCNT=0 S PCNT=1 D
 ...I TYPE="P" D ADD("   -CARE PLANS:")
 ...I TYPE="G" D ADD("   -GOALS:")
 ..S NODE=$G(^AUPNCPL(CPIEN,0))
 ..S PRV=$$GET1^DIQ(9000092,CPIEN,.03,"I")
 ..S PRVNM=$$GET1^DIQ(9000092,CPIEN,.03)
 ..S SIGNDT=$$GET1^DIQ(9000092,CPIEN,.08,"I")
 ..S SIGNDT=$$FMTE^XLFDT($P(SIGNDT,".",1),5)
 ..S SIGN=$$GET1^DIQ(9000092,CPIEN,.07)
 ..S EDATE=$$GET1^DIQ(9000092,CPIEN,.05)
 ..Q:SIGN=""&(PRV'=DUZ)
 ..D TEXT(TYPE,CPIEN)
 Q
TEXT(TYPE,IEN) ;do the text
 N TXTIEN,TXT,PRNT,PRNT2,WRAP,LINE
 S (PRNT,PRNT2,WRAP)=""
 S TXTIEN=0 F  S TXTIEN=$O(^AUPNCPL(IEN,12,TXTIEN)) Q:'+TXTIEN  D
 .S TXT=$G(^AUPNCPL(IEN,12,TXTIEN,0))
 .S PRNT=PRNT2_TXT S PRNT2=""
 .I $L(PRNT)>500 S PRNT2=$E(PRNT,501,$L(PRNT))
 .D WRAP(.WRAP,PRNT,70)
 ;Process each wrapped line
 I $D(WRAP)>1 D PROC(.WRAP)
 Q
VIDT(PRIEN,VIEN,CNT) ; Visit Instructions by date
 ;Get last date entries for each date  of visit instruction
 N INVDT,IEN,EDATE,SIGN,STAT,FOUND,SDATE,EIE,SIGNDT
 S VCNT=0,FOUND=0,SDATE="",VSCNT=0
 S VIEN=$G(VIEN)
 S INVDT="" F  S INVDT=$O(^AUPNVVI("AE",DFN,PRIEN,INVDT)) Q:INVDT=""!(FOUND=1)  D
 .I +SDATE,SDATE'=$P(INVDT,".",1) S FOUND=1
 .S IEN="" F  S IEN=$O(^AUPNVVI("AE",DFN,PRIEN,INVDT,IEN)) Q:IEN=""  D
 ..S EIE=$$GET1^DIQ(9000010.58,IEN,.06,"I")
 ..Q:EIE=1
 ..S STAT=$P($G(^AUPNPROB(PRIEN,0)),U,12)
 ..Q:STAT="D"
 ..Q:+VIEN&(VIEN'=$P($G(^AUPNVVI(IEN,0)),U,3))
 ..I VSCNT=0 S VSCNT=VSCNT+1 D ADD("   -INSTRUCTIONS:")
 ..S EDATE=9999999-INVDT
 ..S EDATE=$$FMTE^XLFDT($P(EDATE,".",1),5)
 ..S SIGNDT=$$GET1^DIQ(9000010.58,IEN,.05,"I")
 ..S SIGNDT=$$FMTE^XLFDT($P(SIGNDT,".",1),5)
 ..S SIGN=$$GET1^DIQ(9000010.58,IEN,.04,"E")
 ..D TEXT2(IEN)
 ..;D ADD("   ("_EDATE_" by "_SIGN_")")
 Q
 ;
TEXT2(IEN) ;do the text
 N TXTIEN,WRAP,TXT,PRNT2,PRNT
 S (PRNT,PRNT2,WRAP)=""
 S TXTIEN=0 F  S TXTIEN=$O(^AUPNVVI(IEN,11,TXTIEN)) Q:'+TXTIEN  D
 .S TXT=$G(^AUPNVVI(IEN,11,TXTIEN,0))
 .S PRNT=PRNT2_TXT S PRNT2=""
 .;MSC/MGH P1014 matched to TEXT
 .I $L(PRNT)>500 S PRNT2=$E(PRNT,501,$L(PRNT))
 .D WRAP(.WRAP,PRNT,70)
 ;Process each wrapped line
 I $D(WRAP)>1 D PROC(.WRAP)
 Q
PROC(WRAP) ;Process the word wrap
 N I,LINE
 F I=1:1:WRAP D
 .I I=WRAP D
 ..I $L(WRAP(I))<45 D
 ...S LINE="   "_$G(WRAP(I))_" ("_SIGNDT_" by "_SIGN_")"
 ...D ADD(LINE)
 ..E  D
 ...D ADD("   "_$G(WRAP(I)))
 ...D ADD("   ("_SIGNDT_" by "_SIGN_")")
 .E  D ADD("   "_$G(WRAP(I)))
 Q
VTRDT(PRIEN,VIEN,CNT) ; Visit Treatment/Regimens  by date
 ;Get last (n) date entries for each problem  of treatments
 ;Default is 99
 N INVDT,IEN,SNO1,VCNT,EDATE,STAT,IN,OUT,ARR,X,TXT,FOUND,PROB,PRTCT
 S VIEN=$G(VIEN)
 S FOUND=0,PRTCT=0
 S INVDT="" F  S INVDT=$O(^AUPNVTXR("AF",DFN,INVDT)) Q:INVDT=""!(FOUND=1)  D
 .S SNO="" F  S SNO=$O(^AUPNVTXR("AF",DFN,INVDT,SNO)) Q:SNO=""  D
 ..S IEN="" F  S IEN=$O(^AUPNVTXR("AF",DFN,INVDT,SNO,IEN)) Q:IEN=""  D
 ...S PROB=$P($G(^AUPNVTXR(IEN,0)),U,4)
 ...Q:PROB'=PRIEN
 ...S STAT=$P($G(^AUPNPROB(PRIEN,0)),U,12)
 ...Q:STAT="D"
 ...Q:+VIEN&(VIEN'=$P($G(^AUPNVTXR(IEN,0)),U,3))
 ...S FOUND=1
 ...I PRTCT=0 S PRTCT=1 D ADD("   -TREATMENTS:")
 ...S EDATE=9999999-INVDT
 ...S EDATE=$$FMTE^XLFDT(EDATE,5)
 ...;D ADD("  -Treatment/Regimen Date: "_EDATE)
 ...S SNO1=$P($G(^AUPNVTXR(IEN,0)),U,1)
 ...S IN=SNO1_"^^^1",OUT="ARR"
 ...S X=$$CNCLKP^BSTSAPI(.OUT,.IN)
 ...I X>0 D
 ....S TXT=ARR(1,"PRE","TRM")
 ....D ADD("    "_TXT)
 Q
REFDT(PRIEN,VIEN,CNT) ; V referrals  by date
 ;Get last date entries for each problem  of visit referrals
 N INVDT,IEN,VCNT,EDATE,STAT,SNO,IN,OUT,ARR,X,TXT,FOUND,PRTCT,ARRAY
 S FOUND=0,PRTCT=0
 S SNO="" F  S SNO=$O(^AUPNVREF("AE",DFN,SNO)) Q:SNO=""  D
 .S INVDT="" F  S INVDT=$O(^AUPNVREF("AE",DFN,SNO,INVDT)) Q:INVDT=""  D
 ..S IEN="" F  S IEN=$O(^AUPNVREF("AE",DFN,SNO,INVDT,IEN)) Q:IEN=""  D
 ...S PROB=$P($G(^AUPNVREF(IEN,0)),U,4)
 ...Q:PROB'=PRIEN
 ...S STAT=$P($G(^AUPNPROB(PRIEN,0)),U,12)
 ...Q:STAT="D"
 ...Q:+VIEN&(VIEN'=$P($G(^AUPNVREF(IEN,0)),U,3))
 ...S ARRAY(INVDT,PRIEN,IEN)=""
 I $D(ARRAY)>10 D ADD("   -REFERRALS:")
 S INVDT="" F  S INVDT=$O(ARRAY(INVDT)) Q:INVDT=""!(FOUND=1)  D
 .S EDATE=9999999-INVDT
 .S EDATE=$P($$FMTE^XLFDT(EDATE,5),".")
 .;D ADD("  -Referral Date: "_EDATE)
 .S PRIEN="" F  S PRIEN=$O(ARRAY(INVDT,PRIEN)) Q:PRIEN=""  D
 ..S IEN="" F  S IEN=$O(ARRAY(INVDT,PRIEN,IEN)) Q:IEN=""  D
 ...S SNO=$P($G(^AUPNVREF(IEN,0)),U,1)
 ...S X=$$CONC^BSTSAPI(SNO_"^^^1")
 ...I +X D
 ....S TXT=$P(X,U,4)
 ....D ADD("   "_TXT)
 ....S PRV=$$GET1^DIQ(9000010.59,IEN,1202)
 ....I PRV="" S PRV=$$GET1^DIQ(9000010.59,IEN,1204)
 ....;D ADD("  -Provider: "_PRV)
 Q
EDU(PRIEN,VIEN,CNT) ;V education by date
 ;Get last date entries for each problem of visit education
 N EDU,PRCT
 S PRCT=0
 S EDU="" F  S EDU=$O(^AUPNVPED("AD",VIEN,EDU)) Q:EDU=""  D
 .I $P($G(^AUPNVPED(EDU,11)),U,3)=PRIEN D
 ..I PRCT=0 S PRCT=1 D ADD("   -EDUCATION:")
 ..D ADD("   "_$$GET1^DIQ(9000010.16,EDU,.01))
 D ADD("")
 Q
CONSULT(PRIEN,DFN,CNT) ;FIND consults
 N DATA,STR,CT2,SER,SDATE,SSTAT
 S DATA=""
 S NUM=99999
 D GETCON^BGOVTR(.DATA,DFN,PRIEN,NUM,"")
 Q:'$D(^TMP("BGOVIN",$J))
 D ADD("")
 D ADD("    -CONSULTS:")
 S CT2=0
 F  S CT2=$O(^TMP("BGOVIN",$J,CT2)) Q:'+CT2  D
 .S STR=$G(^TMP("BGOVIN",$J,CT2))
 .S SER=$P(STR,U,2),SDATE=$P(STR,U,3),SSTAT=$P(STR,U,4)
 .D ADD("  "_SER)
 .D ADD("  Date Ordered: "_SDATE_"  Status: "_SSTAT)
 Q
 ;Get the problems associated with multiple visits and only the latest or items updated.
MVST(DFN,TARGET,NUM) ;Problems updated this visit
 N PROB,CNT,RET,PRIEN,I,VST,FOUND,VCNT
 S FOUND=0,CNT=0,VCNT=0
 I $G(NUM)="" S NUM=999
 K @TARGET
 S INVDT="" F  S INVDT=$O(^AUPNVSIT("AA",DFN,INVDT)) Q:'+INVDT!(NUM>VCNT)  D
 .S VIEN="" F  S VIEN=$O(^AUPNVSIT("AA",DFN,INVDT,VIEN)) Q:'+VIEN!(NUM>VCNT)  D
 ..I "AIH"[$P($G(^AUPNVSIT(VIEN,0)),U,7) D
 ...S VCNT=VCNT+1
 ...D GETPRB(VIEN)
 I CNT=0 S @TARGET@(1,0)="No Problems used as POVs in this visit record"
 Q "~@"_$NA(@TARGET)
 ;
PBYSTAT(DFN,TARGET) ;Get problems by status
 N PRIEN,STAT,ARRAY,CNT,STATO
 S CNT=0
 K @TARGET
 S PRIEN="" F  S PRIEN=$O(^AUPNPROB("AC",DFN,PRIEN)) Q:'PRIEN  D
 .;Check for which statuses to return
 .S STATO=$$GET1^DIQ(9000011,PRIEN,.12)
 .I STATO="" S STATO="INACTIVE"
 .S STAT=$$GET1^DIQ(9000011,PRIEN,.12,"I")
 .Q:STAT="D"!(STAT="I")!(STAT="")
 .S ARRAY(STATO,PRIEN)=""
 S STAT="" F  S STAT=$O(ARRAY(STAT)) Q:STAT=""  D
 .D ADD("Status: "_STAT)
 .S PRIEN="" F  S PRIEN=$O(ARRAY(STAT,PRIEN)) Q:PRIEN=""  D
 ..D PRDATA(PRIEN)
 ..D ADD("")
 I CNT=0 S @TARGET@(1,0)="No Problems for this patient"
 Q "~@"_$NA(@TARGET)
PRDATA(PRIEN) ;Get data for a problem
 N NARR,ICD
 S NARR=$$GET1^DIQ(9000011,PRIEN,.05)
 D ADD(" Problem: "_NARR)
 S ICD=$$GET1^DIQ(9000011,PRIEN,.01)
 D ADD(" -Mapped ICD:"_ICD)
 D QUAL(PRIEN,.CNT)
 D FINDCP(PRIEN,"G",.CNT)
 D FINDCP(PRIEN,"P",.CNT)
 Q
WRAP(OUT,TEXT,RM,IND) ;EP - Wrap the text and insert in array
 ;
 NEW SP
 ;
 I $G(TEXT)="" S OUT=$G(OUT)+1,OUT(OUT)="" Q
 I $G(RM)="" Q
 I $G(IND)="" S IND=0
 S $P(SP," ",80)=" "
 ;
 ;Strip out $c(10)
 S TEXT=$TR(TEXT,$C(10))
 ;
 F  I $L(TEXT)>0 D  Q:$L(TEXT)=0
 . NEW PIECE,SPACE,LINE
 . S PIECE=$E(TEXT,1,RM)
 . ;
 . ;Handle Line feeds
 . I PIECE[$C(13) D  Q
 .. NEW LINE,I
 .. S LINE=$P(PIECE,$C(13)) S:LINE="" LINE=" "
 .. S OUT=$G(OUT)+1,OUT(OUT)=LINE
 .. F I=1:1:$L(PIECE) I $E(PIECE,I)=$C(13) Q
 .. S TEXT=$E(SP,1,IND)_$$STZ($E(TEXT,I+1,9999999999))
 . ;
 . ;Check if line is less than right margin
 . I $L(PIECE)<RM S OUT=$G(OUT)+1,OUT(OUT)=PIECE,TEXT="" Q
 . ;
 . ;Locate last space in line and handle if no space
 . F SPACE=$L(PIECE):-1:(IND+1) I $E(PIECE,SPACE)=" " Q
 . I (SPACE=(IND+1)) D  S:TEXT]"" TEXT=$E(SP,1,IND)_TEXT Q
 .. S LINE=PIECE,OUT=$G(OUT)+1,OUT(OUT)=LINE,TEXT=$$STZ($E(TEXT,RM+1,999999999))
 . ;
 . ;Handle line with space
 . S LINE=$E(PIECE,1,SPACE-1),OUT=$G(OUT)+1,OUT(OUT)=LINE,TEXT=$$STZ($E(TEXT,SPACE+1,999999999))
 . S:TEXT]"" TEXT=$E(SP,1,IND)_TEXT
 ;
 Q
 ;
STZ(TEXT) ;EP - Strip Leading Spaces
 NEW START
 F START=1:1:$L(TEXT) I $E(TEXT,START)'=" " Q
 Q $E(TEXT,START,9999999999)
 ;
VPOV(TARGET) ; returns diagnoses for current vuecentric visit context
 ;I $T(GETVAR^CIAVMEVT)="" S @TARGET@(1,0)="Invalid context variables" Q "~@"_$NA(@TARGET)
 NEW VST,I,X,CNT,RESULT
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1  S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 D GETPOV(.RESULT,VST)
 ;
 K @TARGET S CNT=0
 S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=RESULT(I)
 I 'CNT S @TARGET@(1,0)="No Diagnoses Found"
 Q "~@"_$NA(@TARGET)
 ;
GETPOV(RETURN,VIEN) ;return every diagnosis for current visit
 ; VISIT=Visit IEN
 ;
 NEW IEN,AIEN,FNUM,STRING,CNT,BTIU,LINE,ASTHMA,PCNT,CODE,PAT,CON,NARR,IEN2,Q,ARRAY,SNO
 K RETURN
 ;
 S IEN=0 F  S IEN=$O(^AUPNVPOV("AD",VIEN,IEN)) Q:'IEN  D
 . S ASTHMA=0
 . S NARR=$$GET1^DIQ(9000010.07,IEN,.04)
 . I $P(NARR,"|",1)["*" S NARR=$P(NARR,"|",2)
 . I $P(NARR,"|",2)=" " S NARR=$P(NARR,"|",1)
 . S ARRAY(NARR,IEN)=""
 S NARR="",IEN=0
 F  S NARR=$O(ARRAY(NARR)) Q:NARR=""  D
 .S IEN=0 S IEN=$O(ARRAY(NARR,IEN)) Q:IEN=""  D    ;Only get the first one
 .. S CNT=$G(CNT)+1,PCNT=$G(PCNT)+1
 .. K BTIU D ENP^XBDIQ1(9000010.07,IEN,".01:.29;1102","BTIU(","IE")
 .. S LINE=""
 .. I (BTIU(.12)="PRIMARY") S LINE=" [P] "         ;mark if primary dx
 .. S CODE=$G(BTIU(.01))
 .. S SNO=$G(BTIU(1102))
 .. S ASTHMA=$$CHECK^BGOASLK(CODE,SNO)
 .. I +ASTHMA D
 ... S PAT=BTIU(.02,"I")
 ... S CON=$$ACONTROL^BTIULO5(PAT)
 ... I CON'="" S LINE=LINE_" Control: "_CON
 .. F I=.06,.05,.09,.13,.11,.29 D                   ;check for other fields
 ... I (I=.09),BTIU(.09)]"" S LINE=LINE_"; "_$$ECODE^BTIULO5(IEN) Q
 ... I BTIU(I)]"" S LINE=LINE_"; "_BTIU(I)
 .. S RETURN(CNT)=$J(PCNT,2)_") "_NARR_LINE
 .. ;Return qualifiers
 ..F X=13,17,18,14 D
 ...S STRING=""
 ...S IEN2=0 F  S IEN2=$O(^AUPNVPOV(IEN,X,IEN2)) Q:'+IEN2  D
 ....S Q=""
 ....S FNUM=$S(X=13:9000010.0713,X=17:9000010.0717,X=18:9000010.0718,X=14:9000010.0714)
 ....S AIEN=IEN2_","_IEN_","
 ....S Q=$$GET1^DIQ(FNUM,AIEN,.01)
 ....S Q=$P($$CONC^BSTSAPI(Q_"^^^1"),U,4)
 ....S STRING=$S(STRING="":Q,1:STRING_" "_Q)
 ...I STRING'="" D
 ....S CNT=CNT+1
 ....S RETURN(CNT)="    "_STRING
 Q
 ;
