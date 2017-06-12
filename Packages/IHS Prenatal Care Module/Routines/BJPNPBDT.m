BJPNPBDT ;GDIT/HS/BEE-Prenatal Care Module - Retrieve Detail History ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;;Feb 24, 2015;Build 63
 ;
 Q
 ;
DET(DATA,PIP) ;EP - BJPN PROBLEM DETAIL
 ;
 ;This RPC returns the problem detail for a Problem entry (including past deletes)
 ;
 ;Input:
 ; PIP - Pointer to Prenatal Problem file entry
 ;
 NEW UID,II,TMP,PRBIEN,RET,VIEW,TCNT,ACNT,LINE,TMP1
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPBDT",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S TMP=$NA(^TMP("BJPNPDT1",UID))
 K @TMP
 S RET=$NA(^TMP("BJPNPDET",UID))
 K @RET
 ;
 S $P(LINE,"-",60)="-"
 ;
 S II=0
 ;NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPBDT D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(II)="T01024REPORT_TEXT"_$C(30)
 ;
 I $G(PIP)="" S BMXSEC="INVALID PIP IEN" G XDET
 ;
 ;Get the IPL pointer
 S PRBIEN=$$GET1^DIQ(90680.01,PIP_",",.1,"I") I PRBIEN="" S BMXSEC="Invalid IPL pointer in PIP entry" G XDET
 ;
 ;Retrieve the audit history
 D ACOMP^BJPNFAUD(.RET,PIP,PRBIEN)
 ;
 ;Compile the information by date/time and user
 S ADT="",(ACNT,TCNT)=0 F  S ADT=$O(@RET@(ADT)) Q:ADT=""  S USER="" F  S USER=$O(@RET@(ADT,USER)) Q:USER=""  D
 . ;
 . NEW N,V,G,CHG
 . ;
 . ;Update event counter
 . S ACNT=ACNT+1
 . D SV("",LINE)
 . ;
 . S G=$NA(@RET@(ADT,USER))
 . ;
 . ;See if the last one
 . I '$$NEXT(.RET,ADT,USER) D
 .. D SV("","CURRENT PIP/IPL DISPLAY")
 .. D SV()
 . ;
 . ;IPL Change Header
 . D SV("","IPL Listing:")
 . D SV()
 . ;
 . ;IPL Add/Edit
 . I $D(@G@("DIAGNOSIS")) D
 .. S N=@G@("DIAGNOSIS")
 .. I $P(N,U)="" S VIEW("IPL.01")=$P(N,U,2),CHG("IPL.01")="Problem diagnosis added to IPL" Q
 .. S VIEW("IPL.01")=$P(N,U,2),CHG("IPL.01")="IPL Problem diagnosis changed to"
 . I $D(VIEW("IPL.01")) D SV("IPL.01","Problem diagnosis")
 . ;
 . ;Provider Text
 . I $D(@G@("PROVIDER NARRATIVE")) D
 .. S N=$P(@G@("PROVIDER NARRATIVE"),U,2)
 .. S VIEW("IPL.05")=N_U_$S(N]"":"",1:"^1")
 .. S CHG("IPL.05")="Provider Narrative set to"
 . I $D(VIEW("IPL.05")) D SV("IPL.05","Provider Narrative")
 . ;
 . ;IPL Status
 . I $D(@G@("STATUS")) D
 .. S N=$P(@G@("STATUS"),U,2)
 .. S VIEW("IPL.12")=N_U_$S(N]"":"",1:"^1")
 .. S CHG("IPL.12")="IPL Status set to"
 . I $D(VIEW("IPL.12")) D SV("IPL.12","IPL Status")
 . ;
 . ;IPL Class
 . I $D(@G@("CLASS")) D
 .. S N=$P(@G@("CLASS"),U,2)
 .. S VIEW("IPL.04")=N_$S(N]"":"",1:"^1")
 .. S CHG("IPL.04")="IPL Class set to"
 . I $D(VIEW("IPL.04")) D SV("IPL.04","IPL Class")
 . ;
 . ;Date of Onset
 . I $D(@G@("DATE OF ONSET")) D
 .. S N=$P(@G@("DATE OF ONSET"),U,2)
 .. S VIEW("IPL.13")=N_$S(N]"":"",1:"^1")
 .. S CHG("IPL.13")="IPL Date of Onset set to"
 . I $D(VIEW("IPL.13")) D SV("IPL.13","IPL Date of Onset")
 . ;
 . ;IPL PIP
 . I $D(@G@("PIP")) D
 .. S N=$P(@G@("PIP"),U,2)
 .. S VIEW("IPL.19")=N_$S(N]"":"",1:"^1")
 .. S CHG("IPL.19")="IPL PIP set to"
 . I $D(VIEW("IPL.19")) D SV("IPL.19","IPL PIP")
 . ;
 . ;POV - Ambulatory
 . I $D(@G@("USE AS POV (VISIT)")) D
 .. ;
 .. ;Determine if an add or remove POV
 .. S N=@G@("USE AS POV (VISIT)")
 .. ;
 .. ;Add
 .. I $P(N,U,2)]"" D
 ... S VIEW("APOV."_$P(N,U,3))=$P(N,U,2)
 ... S CHG("APOV."_$P(N,U,3))="Problem set as POV for visit"
 .. ;
 .. ;Remove
 .. I $P(N,U,2)="" D
 ... S VIEW("APOV."_$P(N,U,3))=$P(N,U)_U_1
 ... S CHG("APOV."_$P(N,U,3))="Problem removed as POV for visit"
 . I $O(VIEW("APOV."))["APOV." D
 .. NEW POV
 .. D SV()
 .. S POV="APOV." F  S POV=$O(VIEW(POV)) Q:POV'["APOV."  D
 ... I $P(VIEW(POV),U,2)'=1 D SV(POV,"Problem used as POV for visit") Q
 ... S VIEW(POV)=$P(VIEW(POV),U) D SV(POV,"")
 ... K VIEW(POV)
 . ;
 . ;POV - Inpatient
 . I $D(@G@("USED FOR INPATIENT")) D
 .. ;
 .. ;Determine if an add or remove POV
 .. S N=@G@("USED FOR INPATIENT")
 .. ;
 .. ;Add
 .. I $P(N,U,2)]"" D
 ... S VIEW("IPOV."_$P(N,U,3))=$P(N,U,2)
 ... S CHG("IPOV."_$P(N,U,3))="Problem set as POV for inpatient visit"
 .. ;
 .. ;Remove
 .. I $P(N,U,2)="" D
 ... S VIEW("IPOV."_$P(N,U,3))=$P(N,U)_U_1
 ... S CHG("IPOV."_$P(N,U,3))="Problem removed as POV for inpatient visit"
 . I $O(VIEW("IPOV."))["IPOV." D
 .. NEW POV
 .. D SV()
 .. S POV="IPOV." F  S POV=$O(VIEW(POV)) Q:POV'["IPOV."  D
 ... I $P(VIEW(POV),U,2)'=1 D SV(POV,"Problem used as POV for inpatient visit") Q
 ... S VIEW(POV)=$P(VIEW(POV),U) D SV(POV,"")
 ... K VIEW(POV)
 . ; 
 . ;Severity Qualifier
 . I $D(@G@("SEVERITY")) D
 .. S N=$P(@G@("SEVERITY"),U,2)
 .. S VIEW("IPL.SEV")=$P($$CONC^BSTSAPI(N_"^^^1"),U,4)_$S(N]"":"",1:"^1")
 .. S CHG("IPL.SEV")="Severity Qualifier set to"
 . I $D(VIEW("IPL.SEV")) D SV("IPL.SEV","Severity Qualifier")
 . ;
 . ;PIP Change Header
 . D SV()
 . D SV("","PIP Listing:")
 . D SV()
 . ;
 . ;PIP Add/Edit
 . I $D(@G@("PLACEHOLDER FIELD")) D SV("","Problem Added to PIP")
 . ;
 . ;PIP Status
 . I $D(@G@("CURRENT STATUS")) D
 .. S N=$P(@G@("CURRENT STATUS"),U,2)
 .. S VIEW("PIP.08")=N_$S(N]"":"",1:"^1")
 .. S CHG("PIP.08")="PIP Status set to"
 . I $D(VIEW("PIP.08")) D SV("PIP.08","PIP Status")
 . ;
 . ;PIP Scope
 . I $D(@G@("CURRENT SCOPE")) D
 .. S N=$P(@G@("CURRENT SCOPE"),U,2)
 .. S VIEW("PIP.07")=N_$S(N]"":"",1:"^1")
 .. S CHG("PIP.07")="PIP Scope set to"
 . I $D(VIEW("PIP.07")) D SV("PIP.07","PIP Scope")
 . ;
 . ;PIP Priority
 . I $D(@G@("CURRENT PRIORITY")) D
 .. S N=$P(@G@("CURRENT PRIORITY"),U,2)
 .. S VIEW("PIP.06")=N_$S(N]"":"",1:"^1")
 .. S CHG("PIP.06")="PIP Priority set to"
 . I $D(VIEW("PIP.06")) D SV("PIP.06","PIP Priority")
 . ;
 . ;PIP Definitive EDD
 . I $D(@G@("CURRENT DEFINITIVE EDD")) D
 .. S N=$P(@G@("CURRENT DEFINITIVE EDD"),U,2)
 .. S VIEW("PIP.09")=N_$S(N]"":"",1:"^1")
 .. S CHG("PIP.09")="PIP Problem Definitive EDD set to"
 . I $D(VIEW("PIP.09")) D SV("PIP.09","PIP Problem Definitive EDD")
 . ;
 . ;PIP
 . I $D(@G@("PIPF")) D
 .. S N=$P(@G@("PIPF"),U,2)
 .. S VIEW("PIP.5.02")=N_$S(N]"":"",1:"^1")
 .. S CHG("PIP.5.02")="PIP Flag set to"
 . I $D(VIEW("PIP.5.02")) D SV("PIP.5.02","PIP Flag")
 . ;
 . ;PIP Date
 . I $D(@G@("PIP DATE")) D
 .. S N=$P(@G@("PIP DATE"),U,2)
 .. S VIEW("PIP.5.01")=N_$S(N]"":"",1:"^1")
 .. S CHG("PIP.5.01")="PIP Flag Date set to"
 . I $D(VIEW("PIP.5.01")) D SV("PIP.5.01","PIP Flag Date")
 . ;
 . ;PIP User
 . I $D(@G@("PIP USER")) D
 .. S N=$P(@G@("PIP USER"),U,2)
 .. S VIEW("PIP.5.03")=N_$S(N]"":"",1:"^1")
 .. S CHG("PIP.5.03")="PIP Flag User set to"
 . I $D(VIEW("PIP.5.03")) D SV("PIP.5.03","PIP Flag User")
 . ;
 . ;Goal Notes
 . I $O(@G@("GOAL."))["GOAL." D
 .. NEW GENT
 .. ;
 .. ;Loop through each entry
 .. S GENT="GOAL." F  S GENT=$O(@G@(GENT)) Q:GENT'["GOAL."  D
 ... ;
 ... NEW CSTS,XSTS,N,NIEN
 ... S CSTS=$P(GENT,".",2)
 ... S XSTS=@G@(GENT)
 ... S N="",NIEN=0 F  S NIEN=$O(^AUPNCPL(CSTS,12,NIEN)) Q:'+NIEN  D
 .... S N=N_$S(N]"":$C(13)_$C(10),1:"")_$G(^AUPNCPL(CSTS,12,NIEN,0))
 ... S VIEW("GOAL."_CSTS_".A")=XSTS_$S(XSTS="ACTIVE":"",1:"^2")
 ... S VIEW("GOAL."_CSTS_".N")=N_$S(XSTS="ACTIVE":"",1:"^2")
 ... S CHG("GOAL."_CSTS_".A")="Goal Note status set to"
 ... S:XSTS="ACTIVE" CHG("GOAL."_CSTS_".N")="Goal Note set to"
 . I $O(VIEW("GOAL."))["GOAL." D
 .. D SV(),SV("","GOAL NOTES"),SV()
 .. NEW GENT
 .. S GENT="GOAL." F  S GENT=$O(VIEW(GENT)) Q:GENT'["GOAL."  D
 ... NEW STS,NOTE
 ... I GENT[".A" D SV(GENT,"Goal Note status")
 ... I GENT[".N" D SV(GENT,"Goal Note"),SV()
 ... I $P(VIEW(GENT),U,2)=2 K VIEW(GENT)
 . ;
 . ;Care Plans
 . I $O(@G@("CARE."))["CARE." D
 .. NEW GENT
 .. ;
 .. ;Loop through each entry
 .. S GENT="CARE." F  S GENT=$O(@G@(GENT)) Q:GENT'["CARE."  D
 ... ;
 ... NEW CSTS,XSTS,N,NIEN
 ... S CSTS=$P(GENT,".",2)
 ... S XSTS=@G@(GENT)
 ... S N="",NIEN=0 F  S NIEN=$O(^AUPNCPL(CSTS,12,NIEN)) Q:'+NIEN  D
 .... S N=N_$S(N]"":$C(13)_$C(10),1:"")_$G(^AUPNCPL(CSTS,12,NIEN,0))
 ... S VIEW("CARE."_CSTS_".A")=XSTS_$S(XSTS="ACTIVE":"",1:"^2")
 ... S VIEW("CARE."_CSTS_".N")=N_$S(XSTS="ACTIVE":"",1:"^2")
 ... S CHG("CARE."_CSTS_".A")="Care Plan status set to"
 ... S:XSTS="ACTIVE" CHG("CARE."_CSTS_".N")="Care Plan set to"
 . I $O(VIEW("CARE."))["CARE." D
 .. D SV(),SV("","CARE PLANS"),SV()
 .. NEW GENT
 .. S GENT="CARE." F  S GENT=$O(VIEW(GENT)) Q:GENT'["CARE."  D
 ... NEW STS,NOTE
 ... I GENT[".A" D SV(GENT,"Care Plan status")
 ... I GENT[".N" D SV(GENT,"Care Plan"),SV()
 ... I $P(VIEW(GENT),U,2)=2 K VIEW(GENT)
 . ;
 . ;Visit Instructions
 . I $O(@G@("VINS."))["VINS." D
 .. NEW VENT
 .. ;
 .. ;Loop through each entry
 .. S VENT="VINS." F  S VENT=$O(@G@(VENT)) Q:VENT'["VINS."  D
 ... ;
 ... NEW CSTS,XSTS,N,NIEN,VDT
 ... S CSTS=$P(VENT,".",2)
 ... S N="",NIEN=0 F  S NIEN=$O(^AUPNVVI(CSTS,11,NIEN)) Q:'+NIEN  D
 .... S N=N_$S(N]"":$C(13)_$C(10),1:"")_$G(^AUPNVVI(CSTS,11,NIEN,0))
 ... S VIEW("VINS."_CSTS_".N")=N
 ... S VIEW("VINS."_CSTS_".D")=$$GET1^DIQ(9000010.58,CSTS_",",.03,"E")
 ... S CHG("VINS."_CSTS_".N")="Visit Instruction set to"
 . I $O(VIEW("VINS."))["VINS." D
 .. D SV(),SV("","VISIT INSTRUCTIONS"),SV()
 .. NEW VENT
 .. S VENT="VINS." F  S VENT=$O(VIEW(VENT)) Q:VENT'["VINS."  D
 ... I VENT[".D" D SV(VENT,"Visit Date")
 ... I VENT[".N" D SV(VENT,"Visit Instruction"),SV()
 . ;
 . ;Treatment Regimen
 . I $O(@G@("VTR."))["VTR." D
 .. NEW VENT
 .. ;
 .. ;Loop through each entry
 .. S VENT="VTR." F  S VENT=$O(@G@(VENT)) Q:VENT'["VTR."  D
 ... ;
 ... NEW CSTS,XSTS,N,NIEN,VDT
 ... S CSTS=$P(VENT,".",2)
 ... S N=$$GET1^DIQ(9000010.61,CSTS_",",.01,"I") Q:N=""
 ... S N=$P($$CONC^BSTSAPI(N_"^^^1"),U,4) Q:N=""
 ... S VIEW("VTR."_CSTS_".N")=N
 ... S VIEW("VTR."_CSTS_".D")=$$GET1^DIQ(9000010.61,CSTS_",",.03,"E")
 ... S CHG("VTR."_CSTS_".N")="Treatment Regimen set to"
 . I $O(VIEW("VTR."))["VTR." D
 .. D SV(),SV("","TREATMENT REGIMEN"),SV()
 .. NEW VENT
 .. S VENT="VTR." F  S VENT=$O(VIEW(VENT)) Q:VENT'["VTR."  D
 ... I VENT[".D" D SV(VENT,"Visit Date")
 ... I VENT[".N" D SV(VENT,"Treatment Regimen"),SV()
 . ;
 . ;Education
 . I $O(@G@("VEDU."))["VEDU." D
 .. NEW VENT
 .. ;
 .. ;Loop through each entry
 .. S VENT="VEDU." F  S VENT=$O(@G@(VENT)) Q:VENT'["VEDU."  D
 ... ;
 ... NEW CSTS,XSTS,N,NIEN,VDT,SCNT,SMD,RED,TIM
 ... S CSTS=$P(VENT,".",2),SCNT=0
 ... S N=$$GET1^DIQ(9000010.16,CSTS_",",.01,"E") Q:N=""
 ... ;S N=$P($$CONC^BSTSAPI(N_"^^^1"),U,4) Q:N=""
 ... S VIEW("VEDU."_CSTS_".N")=N
 ... S VIEW("VEDU."_CSTS_".D")=$$GET1^DIQ(9000010.16,CSTS_",",.03,"E")
 ... S CHG("VEDU."_CSTS_".N")="Patient Education set to"
 ... ;
 ... ;Snomed
 ... S SMD=$$GET1^DIQ(9000010.16,CSTS_",",1301,"I") I SMD]"" D
 .... S SCNT=SCNT+1
 .... S CHG("VEDU."_CSTS_".S1."_SCNT)="SNOMED Topic set to"
 .... S VIEW("VEDU."_CSTS_".S1."_SCNT)=$P($$CONC^BSTSAPI(SMD_"^^^1"),U,4)
 ... S SMD=""  F  S SMD=$O(^AUPNVPED(CSTS,26,"B",SMD)) Q:SMD=""  D
 .... S SCNT=SCNT+1
 .... S CHG("VEDU."_CSTS_".S2."_SCNT)="SNOMED set to"
 .... S VIEW("VEDU."_CSTS_".S2."_SCNT)=$P($$CONC^BSTSAPI(SMD_"^^^1"),U,4)
 ... ;
 ... ;Readiness to learn
 ... S RED=$$GET1^DIQ(9000010.16,CSTS_",",1102,"E") I RED]"" D
 .... S CHG("VEDU."_CSTS_".R1")="Readiness to learn set to"
 .... S VIEW("VEDU."_CSTS_".R1")=RED
 ... ;
 ... ;Length of Educ (Minutes)
 ... S TIM=$$GET1^DIQ(9000010.16,CSTS_",",.08,"I") I TIM]"" D
 .... S CHG("VEDU."_CSTS_".R2")="Length of education (minutes) set to"
 .... S VIEW("VEDU."_CSTS_".R2")=TIM
 . I $O(VIEW("VEDU."))["VEDU." D
 .. D SV(),SV("","PATIENT EDUCATION")
 .. NEW VENT
 .. S VENT="VEDU." F  S VENT=$O(VIEW(VENT)) Q:VENT'["VEDU."  D
 ... I VENT[".D" D SV(),SV(VENT,"Visit Date")
 ... I VENT[".N" D SV(VENT,"Patient Education")
 ... I VENT[".S1" D SV(VENT,"SNOMED Topic")
 ... I VENT[".S2" D SV(VENT,"SNOMED")
 ... I VENT[".R2" D SV(VENT,"Length of education (minutes)")
 ... I VENT[".R1" D SV(VENT,"Readiness to learn")
 . ;
 . ;Tack on Change on/by
 . D SV()
 . D SV("","Changes made on: "_$$FMTE^BJPNPRL(ADT))
 . D SV("","Changes made by: "_$$GET1^DIQ(200,USER_",",".01","E"))
 . D SV(),SV()
 . ;
 . ;Display current information if this is the last entry
 . ;
 . ;There is another entry
 . I $$NEXT(.RET,ADT,USER) Q
 . ;
 . ;Qualifiers
 . D QUAL(PRBIEN)
 . ;
 . ;See if the last one
 . I '$$NEXT(.RET,ADT,USER) D
 .. D SV(),SV("",LINE)
 .. D SV("","PIP/IPL ACTIVITY HISTORY")
 .. D SV()
 ;
 S ACNT="" F  S ACNT=$O(@TMP@(ACNT),-1) Q:ACNT=""  D
 . S TCNT="" F  S TCNT=$O(@TMP@(ACNT,TCNT)) Q:TCNT=""  D
 .. S II=II+1,@DATA@(II)=@TMP@(ACNT,TCNT)_$C(13)_$C(10)
 I II>0 S @DATA@(II)=$G(@DATA@(II))_$C(30)
 ;
XDET I $G(RET)]"" K @RET
 I $G(TMP)]"" K @TMP
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
NEXT(RET,ADT,USER) ;Check if there is an entry after this one
 ;
 ;First see if there is another user entry
 I $O(@RET@(ADT,USER))]"" Q 1
 ;
 ;Now see if there is another date
 I $O(@RET@(ADT))]"" Q 1
 ;
 Q 0
 ;
SV(P,F) ;Increment the scratch entry
 ;
 S P=$G(P),F=$G(F)
 ;
 ;Skip a line
 I P="",F="" S TCNT=TCNT+1,@TMP@(ACNT,TCNT)="" Q
 ;
 ;Non-data line
 I P="",F]"" S TCNT=TCNT+1,@TMP@(ACNT,TCNT)=F Q
 ;
 ;Data line
 S TCNT=TCNT+1,@TMP@(ACNT,TCNT)=$S($D(CHG(P)):CHG(P),1:F)_": "
 S @TMP@(ACNT,TCNT)=@TMP@(ACNT,TCNT)_$S($P(VIEW(P),U)]"":$P(VIEW(P),U),$P(VIEW(P),U,2)=1:"<Value Deleted>",1:"")
 ;
 ;Clear delete flag
 S:$P(VIEW(P),U,2)=1 VIEW(P)=$P(VIEW(P),U)
 ;
 Q
 ;
QUAL(IEN) ;Get any qualifiers for this problem
 NEW AIEN,IEN2,BY,WHEN,X,FNUM,Q,FIRST
 I $D(^AUPNPROB(IEN,13))!($D(^AUPNPROB(IEN,17)))!($D(^AUPNPROB(IEN,18))) D SV("","QUALIFIERS")
 F X=13,17,18 D
 . S FIRST=0
 . S FNUM=$S(X=13:9000011.13,X=17:9000011.17,X=18:9000011.18)
 . S IEN2=0 F  S IEN2=$O(^AUPNPROB(IEN,X,IEN2)) Q:'+IEN2  D
 .. S AIEN=IEN2_","_IEN_","
 .. S Q=$$GET1^DIQ(FNUM,AIEN,.01)
 .. ;
 .. ;Skip Qualifier Attributes entry
 .. I X=13,Q=246112005 Q
 .. I X=18,Q=263502005 Q
 .. ;
 .. ;Print header
 .. I FIRST=0 D
 ... I X=13 D SV(),SV("","Severity:")
 ... I X=18 D SV(),SV("","Clinical Course:")
 ... S FIRST=1
 .. ;
 .. ;Display the entry
 .. S Q=$$CONCEPT^BGOPAUD(Q)
 .. D SV("",Q)
 .. I X=13 D
 ... S BY=$$GET1^DIQ(FNUM,AIEN,.02)
 ... S WHEN=$$GET1^DIQ(FNUM,AIEN,.03)
 ... D SV("","Entered by: "_BY_"    On: "_WHEN)
 Q
ICD(IEN) ;Get any additional ICD codes for this problem
 N AIEN,IEN2
 I $D(^AUPNPROB(IEN,12)) D ADD2("     Additional ICD Codes")
 S IEN2=0 F  S IEN2=$O(^AUPNPROB(IEN,12,IEN2)) Q:'+IEN2  D
 .S AIEN=IEN2_","_IEN_","
 .D ADD2($$GET1^DIQ(9000011.12,AIEN,.01))
 Q
ADD1(TXT,LBL) ;
 ;S CNT=CNT+1 S @RET@(CNT)=$S($D(LBL):$$LJ^XLFSTR(LBL,20),1:"")_$G(TXT),LBL=""
 Q
ADD2(TXT) ;
 ;S CNT=CNT+1 S @RET@(CNT)=TXT
 Q
