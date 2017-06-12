BHSPL2 ;IHS/MSC/MGH  - Health Summary for Items associated with Problem list ;09-Mar-2016 09:58;du
 ;;1.0;HEALTH SUMMARY COMPONENTS;**8,13**;Mar 17,2006;Build 6
 ;Patch 13 added normal/abnormal data
 ;===================================================================
POVP ;DISPLAY PROBLEMS USED BY LAST VISIT IN HEALTH SUMMARY
 N TARGET,X,LINE,INVDT,QUIT
 ;For Visit instructions and treatments, the default is the latest visit
 S NUM=1
 S TARGET=$$TMPGBL
 K @TARGET
 D CKP^GMTSUP Q:$D(GMTSQIT)
 ;Find the last visit for this patient
 S QUIT=0
 S INVDT="" F  S INVDT=$O(^AUPNVSIT("AA",DFN,INVDT)) Q:INVDT=""!(QUIT=1)  D
 .S VIEN="" S VIEN=$O(^AUPNVSIT("AA",DFN,INVDT,VIEN)) Q:VIEN=""!(QUIT=1)  D
 ..I $P($G(^AUPNVSIT(VIEN,0)),U,7)="A" S QUIT=1 D PROB(VIEN)
 Q
POVVST ;DISPLAY PROBLEMS USED BY VISITS IN HEALTH SUMMARY
 N TARGET,X,LINE,INVDT,QUIT,NUM,CNT
 ;For Visit instructions and treatments, the default is the latest visit
 S GMTSNDM=$G(GMTSNDM)
 I GMTSNDM<1 S GMTSNDM=999
 S NUM=1,CNT=0
 S TARGET=$$TMPGBL
 K @TARGET
 D CKP^GMTSUP Q:$D(GMTSQIT)
 ;Find the visits
 S QUIT=0
 S INVDT="" F  S INVDT=$O(^AUPNVSIT("AA",DFN,INVDT)) Q:INVDT=""!(CNT>GMTSNDM)  D
 .S VIEN="" S VIEN=$O(^AUPNVSIT("AA",DFN,INVDT,VIEN)) Q:VIEN=""!(CNT>GMTSNDM)  D
 ..I $P($G(^AUPNVSIT(VIEN,0)),U,7)="A" D
 ...S CNT=CNT+1
 ...D PROB(VIEN)
 Q
PROB(VIEN) ;Find problems used in this visit
 N LINE,VDT,STAT,PRIEN
 S PRIEN=0
 S VDT=$$GET1^DIQ(9000010,VIEN,.01)
 F  S PRIEN=$O(^AUPNPROB("AC",DFN,PRIEN)) Q:'PRIEN  D
 .;Check for which statuses to return
 .S STAT=$P($G(^AUPNPROB(PRIEN,0)),U,12)
 .Q:STAT="D"
 .I $D(^AUPNPROB(PRIEN,14,"B",VIEN))  D
 ..S TARGET=$$TMPGBL
 ..W !,"Visit Date: "_VDT,!
 ..D DETAIL(.TARGET,PRIEN,DFN)
 ..S LINE=0
 ..F  S LINE=$O(@TARGET@(LINE)) Q:LINE=""  D
 ...D CKP^GMTSUP Q:$D(GMTSQIT)  I GMTSNPG W !,"Problems for Visit",!
 ...W @TARGET@(LINE),!
 ..K TARGET
 Q
DETAIL(RET,IEN,DFN) ;Get a detail report on one problem
 N ZERO,CNT,PROB,CLASS,STATUS,ACLASS,PIP,ONSET,SNOMED,DESC,IN,OUT,CHK
 S VIEN=$G(VIEN)
 S CNT=0
 S ZERO=$G(^AUPNPROB(IEN,0))
 S ACT=$G(ACT),NUM=$G(NUM)
 D ADD2(""),ADD2("PROBLEM DATA")
 D ADD1($$GET1^DIQ(9000011,IEN,.07),"  ID:")
 S PROB=$$GET1^DIQ(9000011,IEN,.05)
 D ADD1(PROB,"Problem:")
 D ADD1($$GET1^DIQ(9000011,IEN,.01)," * Mapped ICD:")
 S CLASS=$$GET1^DIQ(9000011,IEN,.04)
 S STATUS=$$GET1^DIQ(9000011,IEN,.12)
 I CLASS'="" S STATUS=STATUS_" * Class: "_CLASS
 D ADD1(STATUS," * Status:")
 I $$GET1^DIQ(9000011,IEN,.13)="" S ONSET="UNKNOWN"
 E  S ONSET=$$GET1^DIQ(9000011,IEN,.13)
 D ADD1(ONSET," * Date of Onset:")
 D ADD1($$GET1^DIQ(9000011,IEN,.08)," * Date Entered:")
 D ADD1($$GET1^DIQ(9000011,IEN,1.04)," * Recorded By:")
 D ADD1($$GET1^DIQ(9000011,IEN,.03)," * Last Modified:")
 D ADD1($$GET1^DIQ(9000011,IEN,.14)," * Modified User:")
 S ACLASS=$$GET1^DIQ(9000011,IEN,.15)
 I ACLASS'="" D ADD1(ACLASS," * Asthma Class:")
 S PIP=$$GET1^DIQ(9000011,IEN,.19,"I")
 I PIP=1 D ADD1(PIP," * Pregnancy DX:")
 S SNOMED=$P($G(^AUPNPROB(IEN,800)),U,1)
 D ADD1(SNOMED," * Concept CT:")
 S DESC=$P($G(^AUPNPROB(IEN,800)),U,2)
 D ADD1(DESC," * Desc CT: ")
 S CHK=$$POVCHK(IEN,VIEN)
 D ADD1($P(CHK,U,1)," * POV: ")
 I $P(CHK,U,2)'="" D ADD1($P(CHK,U,2)," * ")
 D ADD2("")
 D NOTES
 D ICD(IEN)
 D QUAL(IEN)
 D CARE(IEN,DFN,"A")
 D VISIT(IEN,DFN,1,.VIEN)
 D CONSULT(IEN,DFN,NUM)
 Q
NOTES ; Get the notes for this problem
 N AIEN,IEN2,BY,WHEN,NUM,FAC,NARR,I,NOTES
 D NOTES^BGOPRBN(.NOTES,IEN,1)
 I $D(NOTES)>1 D ADD2("          NOTES")
 S I="" F  S I=$O(NOTES(I)) Q:I=""  D
 .S FAC=$P(NOTES(I),U,1)
 .S FAC=$$GET1^DIQ(9999999.06,FAC,.01)
 .S NUM=$P(NOTES(I),U,3)
 .S STAT=$P(NOTES(I),U,5) I STAT="A" S STATUS="ACTIVE"
 .S BY=$P(NOTES(I),U,7)
 .S BY=$$GET1^DIQ(200,BY,.01)
 .S WHEN=$$FMTE^XLFDT($P(NOTES(I),U,6))
 .S NARR=$P(NOTES(I),U,4)
 .D ADD2("Site: "_FAC_"  Number: "_NUM_" Status: "_STAT)
 .D ADD2("Entered By: "_BY_"   On: "_WHEN)
 .D ADD2(NARR)
 .D ADD2("")
 Q
ICD(IEN) ;Get any additional ICD codes for this problem
 N AIEN,IEN2
 I $D(^AUPNPROB(IEN,12)) D ADD2("     Additional ICD Codes")
 S IEN2=0 F  S IEN2=$O(^AUPNPROB(IEN,12,IEN2)) Q:'+IEN2  D
 .S AIEN=IEN2_","_IEN_","
 .D ADD2($$GET1^DIQ(9000011.12,AIEN,.01))
 Q
QUAL(IEN) ;Get any qualifiers for this problem
 N AIEN,IEN2,BY,WHEN,X,Q,FNUM
 I $D(^AUPNPROB(IEN,13))!($D(^AUPNPROB(IEN,17)))!($D(^AUPNPROB(IEN,18))) D ADD2("     QUALIFIERS")
 F X=13,17,18 D
 .S FNUM=$S(X=13:9000011.13,X=17:9000011.17,X=18:9000011.18)
 .S IEN2=0 F  S IEN2=$O(^AUPNPROB(IEN,X,IEN2)) Q:'+IEN2  D
 ..S AIEN=IEN2_","_IEN_","
 ..S BY=$$GET1^DIQ(FNUM,AIEN,.02)
 ..S WHEN=$$GET1^DIQ(FNUM,AIEN,.03)
 ..S Q=$$GET1^DIQ(FNUM,AIEN,.01)
 ..S Q=$$CONCEPT^BGOPAUD(Q)
 ..D ADD2(Q)
 ..D ADD2("Entered by: "_BY_"    On: "_WHEN)
 Q
 ;Find the latest number of entries for each section using the
 ;parameter and return them to the calling program
 ;Input is IEN of Problem
 ;         DFN of Patient
CARE(IEN,DFN,ACT) ;EP
 ;Start with all the goals
 N DATA,STR
 S DATA=""
 I $G(ACT)="" S ACT="A"
 D GET^BGOCPLAN(.DATA,IEN,DFN,"G",ACT,"")
 Q:'$D(^TMP("BGOPLAN",$J))
 D ADD2("")
 D ADD2("          GOALS")
 D PLAN
 ;Then do all the care plans
 K ^TMP("BGOPLAN",$J)
 N DATA,STR
 S DATA=""
 I $G(ACT)="" S ACT="A"
 D GET^BGOCPLAN(.DATA,IEN,DFN,"P",ACT,"")
 Q:'$D(^TMP("BGOPLAN",$J))
 D ADD2("")
 D ADD2("    CARE PLANS")
 D PLAN
 K ^TMP("BGOPLAN",$J)
 Q
VISIT(IEN,DFN,NUM,VIEN) ;visit instructions
 ;Next get all the visit instructions
 N DATA,STR
 S DATA=""
 I $G(NUM)="" S NUM=1
 D GET^BGOVVI(.DATA,DFN,IEN,NUM,"",.VIEN)
 Q:'$D(^TMP("BGOVIN",$J))
 D ADD2("")
 D ADD2("    VISIT INSTRUCTIONS")
 D VST
 ;Then do all the treatment/regimen entries
 K ^TMP("BGOVIN",$J)
 N DATA,STR,CT2
 S DATA="",CT2=0
 I $G(NUM)="" S NUM=1
 D GET^BGOVTR(.DATA,DFN,IEN,NUM,"",.VIEN)
 Q:'$D(^TMP("BGOVIN",$J))
 D ADD2("")
 D ADD2("    TREATMENT/REGIMENS")
 D TREAT
 K ^TMP("BGOVIN",$J)
 Q
 ;Get all the consults
CONSULT(IEN,DFN,NUM) ;FIND consults
 N DATA,STR,CT2,SER,SDATE,SSTAT
 S DATA=""
 I $G(NUM)="" S NUM=99999
 D GETCON^BGOVTR(.DATA,DFN,IEN,NUM,"")
 Q:'$D(^TMP("BGOVIN",$J))
 D ADD2("")
 D ADD2("     CONSULTS")
 S CT2=0
 F  S CT2=$O(^TMP("BGOVIN",$J,CT2)) Q:'+CT2  D
 .S STR=$G(^TMP("BGOVIN",$J,CT2))
 .S SER=$P(STR,U,2),SDATE=$P(STR,U,3),SSTAT=$P(STR,U,4)
 .D ADD2("CONSULT: "_SER)
 .D ADD2(" * Date Ordered: "_SDATE_"  Status: "_SSTAT)
 Q
PLAN ;GET ALL CARE PLANNING DATA
 N CT2,STR,STAT,SIGNED,CPIEN,SIGNBY,SIGNDT
 S CT2=0
 F  S CT2=$O(^TMP("BGOPLAN",$J,CT2)) Q:'+CT2  D
 .S STR=$G(^TMP("BGOPLAN",$J,CT2))
 .I $P(STR,U,1)="~t" D
 ..D ADD2($P(STR,U,2))
 .E  D
 ..S BY=$P(STR,U,4),WHEN=$P(STR,U,5)
 ..D ADD2(" * Entered by: "_BY_"    On: "_WHEN)
 ..S STAT=$P(STR,U,6)
 ..S STAT=$S(STAT="A":"Active",STAT="I":"Inactive",STAT="R":"Replaced")
 ..D ADD2(" * Status: "_STAT)
 ..S SIGNED=$P(STR,U,7)
 ..I SIGNED=1 D
 ...S CPIEN=$P(STR,U,2)
 ...S SIGNBY=$$GET1^DIQ(9000092,CPIEN,.07)
 ...S SIGNDT=$$GET1^DIQ(9000092,CPIEN,.08)
 ...D ADD2(" * Signed by: "_SIGNBY_"    on: "_SIGNDT)
 Q
VST ;GET ALL VISIT INSTRUCTIONS
 N CT2,STR,STAT,SIGNED,VIIEN,SIGNBY,SIGNDT,FAC,VDT,VCAT,EVDT,PRV,ENTBY,ENTDT,MODBY,MODDT
 S CT2=0
 F  S CT2=$O(^TMP("BGOVIN",$J,CT2)) Q:'+CT2  D
 .S STR=$G(^TMP("BGOVIN",$J,CT2))
 .I $P(STR,U,1)="~t" D
 ..D ADD2($P(STR,U,2))
 .E  D
 ..S VIIEN=$P(STR,U,2)
 ..S VDT=$P(STR,U,4)
 ..S VCAT=$P(STR,U,10)
 ..D ADD2("Visit Date: "_VDT_"  Category:"_VCAT)
 ..S FAC=$P(STR,U,5)
 ..D ADD2(" * Facility: "_FAC)
 ..S EVDT=$P(STR,U,8)
 ..S PRV=$P(STR,U,12)
 ..D ADD2(" * Provider: "_PRV)
 ..D ADD2(" * Event Date: "_EVDT)
 ..S SIGNBY=$$GET1^DIQ(9000010.58,VIIEN,.04)
 ..S ENTBY=$$GET1^DIQ(9000010.58,VIIEN,1217)
 ..S ENTDT=$$GET1^DIQ(9000010.58,VIIEN,1216)
 ..S MODBY=$$GET1^DIQ(9000010.58,VIIEN,1219)
 ..S MODDT=$$GET1^DIQ(9000010.58,VIIEN,1218)
 ..D ADD2(" * Entered by: "_ENTBY_"    On: "_ENTDT)
 ..D ADD2(" * Last Modified by: "_MODBY_"  On: "_MODDT)
 ..S SIGNDT=$P(STR,U,13)
 ..I SIGNDT'="" D ADD2(" * Signed by: "_SIGNBY_"    on: "_SIGNDT)
 Q
TREAT ; GET THE TREATMENT DATA
 N CT,STR,VIIEN,SNOMED,VDT,VCAT,FAC,EVDT,PRV,ENTBY,ENTDT,MODBY,MODDT
 F  S CT2=$O(^TMP("BGOVIN",$J,CT2)) Q:'+CT2  D
 .S STR=$G(^TMP("BGOVIN",$J,CT2))
 .S VIIEN=$P(STR,U,2)
 .S SNOMED=$P(STR,U,3)
 .S VDT=$P(STR,U,5)
 .S VCAT=$P(STR,U,11)
 .D ADD2("SNOMED TERM: "_SNOMED)
 .D ADD2(" * Visit Date: "_VDT_"  Category:"_VCAT)
 .S FAC=$P(STR,U,6)
 .D ADD2(" * Facility: "_FAC)
 .S EVDT=$P(STR,U,9)
 .S PRV=$P(STR,U,13)
 .D ADD2(" * Provider: "_PRV)
 .D ADD2(" * Event Date: "_EVDT)
 .S ENTBY=$$GET1^DIQ(9000010.58,VIIEN,1217)
 .S ENTDT=$$GET1^DIQ(9000010.58,VIIEN,1216)
 .S MODBY=$$GET1^DIQ(9000010.58,VIIEN,1219)
 .S MODDT=$$GET1^DIQ(9000010.58,VIIEN,1218)
 .D ADD2(" * Entered by: "_ENTBY_"    On: "_ENTDT)
 .D ADD2(" * Last Modified by: "_MODBY_"  On: "_MODDT)
 Q
LOOK(SNOMED) ;LOOKUP CODE
 N RET
 S RET=$P($$DESC^BSTSAPI(SNOMED),U,2)
 Q RET
TMPGBL() ;EP
 K ^TMP("BHSPL",$J) Q $NA(^($J))
ADD1(TXT,LBL) ;
 S CNT=CNT+1 S @RET@(CNT)=$S($D(LBL):$$LJ^XLFSTR(LBL,20),1:"")_$G(TXT),LBL=""
 Q
ADD2(TXT) ;
 S CNT=CNT+1 S @RET@(CNT)=TXT
 Q
POVCHK(PRIEN,VIEN) ;Check for different provider narrative or normal/abnormal Patch 13
 N VPOV,FOUND,NORM,VNAR
 S FOUND=0
 S VPOV=0 F  S VPOV=$O(^AUPNVPOV("AD",VIEN,VPOV)) Q:VPOV=""!(FOUND=1)  D
 .I $P($G(^AUPNVPOV(VPOV,0)),U,16)=PRIEN D
 ..S FOUND=1
 ..S NORM=$$GET1^DIQ(9000010.07,VPOV,.29)
 ..S VNAR=$$GET1^DIQ(9000010.07,VPOV,.04)
 Q VNAR_U_NORM
