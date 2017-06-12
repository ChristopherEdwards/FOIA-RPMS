BGOCPTP3 ; IHS/MSC/MGH - Store a SNOMED association ;14-Apr-2016 12:37;du
 ;;1.1;BGO COMPONENTS;**14,19,20**;Mar 20, 2007;Build 6
 ;---------------------------------------------
 ;Store a SNOMED association
 ;Input = DFN [1] ^ VIEN [2] SNOMED CT [3] ^ ICD [4] ^LOCATION [5] ^ PROVIDER [6] ^ normal/abnormal [7]
 ;Patch 19 added NORM to input
STORE(RET,INP) ;EP Store POV and possibly problem
 N DFN,VIEN,SNOMED,DESC,ICD,FAC,CANDUP,ICDIEN,VDT,PROB,VPOV,FOUND,X,ICD2,STRING,PRV
 N DEL,MATCH,SPROB,TYPE,SNODATA,NORM,STAT
 S DFN=$P(INP,U,1)
 Q:'DFN
 S VIEN=$P(INP,U,2)
 Q:'VIEN
 S SNO=$P(INP,U,3)
 Q:'SNO
 S ICD=$P(INP,U,4)
 S FAC=$$GET1^DIQ(9000010,VIEN,.06,"I")
 S PRV=$P(INP,U,6)
 S VDT=+$G(^AUPNVSIT(VIEN,0))
 S NORM=$P(INP,U,7)
 ;IHS/MSC/MGH Changed to use new API P14
 ;S X=$$CONC^BSTSAPI(SNO_"^^^1")
 S X=$$CONC^AUPNSICD(SNO_"^^^1")
 S STAT=$P(X,U,9)
 S DESC=$P(X,U,3)
 S ICD2=$P($P(X,U,5),";",1)
 I ICD2'["." S ICD2=ICD2_"."
 I ICD2'=""&(ICD2'=ICD) S ICD=ICD2
 S SNODATA=$TR($P(X,U,5),";","|")
 ;Validate its a good code
 I $$AICD^BGOUTL2 D
 .S ICDIEN=$P($$CODEN^ICDEX(ICD,80),"~",1)
 E  D
 .S ICDIEN=$S($E(ICD)="`":$E(TYPE,2,99),1:$O(^ICD9("AB",TYPE_" "),0))
 I 'ICDIEN S RET=$$ERR^BGOUTL(1094) Q
 D CHECK^BGOVPOV(.RET,ICDIEN_U_DFN_U_VDT_U_SNO_U_"")
 Q:RET
 ;Check for duplicate visits
 S FOUND=0
 S VPOV="" F  S VPOV=$O(^AUPNVPOV("AD",VIEN,VPOV))  Q:'+VPOV!(FOUND=1)  D
 .I $P($G(^AUPNVPOV(VPOV,0)),U,1)=ICDIEN S FOUND=1
 I FOUND=1 S RET="-1^Duplicate. Snomed/code already recorded as POV for this visit"
 Q:RET
 ;Next, see if this already exists as a problem on the patients list
 S MATCH=0,SPROB=""
 S PROB="" F  S PROB=$O(^AUPNPROB("APCT",DFN,SNO,PROB)) Q:PROB=""!(MATCH=1)  D
 .S DEL=$$GET1^DIQ(9000011,PROB,2.02)
 .I DEL="" S MATCH=1,SPROB=PROB
 I 'SPROB S SPROB=$$ADDPROB(DFN,SNO,DESC,SNODATA,FAC,"",STAT)
 Q:'SPROB
 S STRING=""_U_VIEN_U_SPROB_U_DFN_U_""_U_DESC_U_SNO_U_SNODATA_U_U_PRV
 I NORM="" D SET^BGOVPOV(.RET,STRING)
 E  D SET^BGOVPOV(.RET,STRING,"","",NORM)
 Q
 ;
ADDPROB(DFN,SNO,DESC,ICD,FAC,SPEC,STAT) ;Add the problem is it isn't in the list
 N DATA,LIST
 ;IHS/MSC/MGH added routine status P20
 I STAT="" S STAT="Episodic"
 S LIST(0)="P"_U_SNO_U_DESC_U_""_U_ICD_U_FAC_U_""_U_STAT
 D SET^BGOPROB(.DATA,DFN,"",VIEN,.LIST,.SPEC)
 Q DATA
 ;
TMPGBL(X) ;EP
 K ^TMP("BGOMAP",$J) Q $NA(^($J))
RPT ; EP Report to return codes that are unmapped to SNOMED or are still ICD9  procedure codes
 N BGORPT,DIR,Y,ZTRTN
 W @IOF
 W !,"Unconverted ICD9 diagnosis or procedure codes",!!
 S DIR(0)="SO^D:Diagnosis Missing SNOMED;P:ICD-9 Procedure Codes"
 S DIR("A")="Select Report to Run "
 S DIR("B")="D"
 S DIR("?")="Running the diagnosis report will find ICD associations not mapped to SNOMED, Report P will find ICD diagnosis codes that are ICD-9"
 D ^DIR
 S BGORPT=Y
 S ZTRTN="OUT^BGOCPTP3"
 D DEVICE
 Q
DEVICE ; Device handling
 ; Call with: ZTRTN
 N %ZIS
 S %ZIS="Q" D ^%ZIS Q:POP
 G:$D(IO("Q")) QUE
NOQUE ; Call report directly
 D @ZTRTN
 Q
QUE ; Queue output
 N %,ZTDTH,ZTIO,ZTSAVE,ZTSK
 Q:'$D(ZTRTN)
 K IO("Q") S ZTSAVE("BGORPT")=""
 S:'$D(ZTDESC) ZTDESC="Pring Unconverted ICD9 DX or procedure codes report" S ZTIO=ION
 D ^%ZTLOAD W !,$S($D(ZTSK):"Request Queued!",1:"Request Cancelled!")
 K ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE
 D HOME^%ZIS
 Q
OUT ;Run the report
 N I,J,NAME,CPT,CNAME,PNAME,PCPT,ASSOC
 D HDR(BGORPT)
 S I=0 F  S I=$O(^BGOCPTPR(I)) Q:I=""  D
 .S NAME=$P($G(^BGOCPTPR(I,0)),U,1)
 .S PNAME=0
 .S J=0 F  S J=$O(^BGOCPTPR(I,1,J)) Q:J=""  D
 ..S CPT=$P($G(^BGOCPTPR(I,1,J,0)),U,1)
 ..S CNAME=$P($G(^BGOCPTPR(I,1,J,0)),U,2)
 ..S PCPT=0
 ..S K="" F  S K=$O(^BGOCPTPR(I,1,J,1,K)) Q:K=""  D
 ...S ASSOC=$P($G(^BGOCPTPR(I,1,J,1,K,0)),U,1)
 ...I $P(ASSOC,";",2)="ICD9("&(BGORPT="D") D SNOMED
 ...I $P(ASSOC,";",2)="ICD0("&(BGORPT="P") D PROC
 Q
HDR(TYP) ;PRINT HEADER
 N LIN,DTYP
 S DTYP=$S(TYP="D":"ICD DX to SNOMED",TYP="P":"ICD9 to ICD10 procedures",1:"")
 I IOST["C-" W @IOF
 W !,"Unconverted codes report for "_DTYP,!
 W !,"Superbill",?20,"CPT IEN",?30,"Code",?40,"ICD",?50,"Text"
 W ! F LIN=1:1:72 W "-"
 W !
 Q
SNOMED ;If SNOMED fields are not filled in add this to the report list
 N TXT,ICDIEN,ICDCODE,TXT,CPTCODE
 I $P($G(^BGOCPTPR(I,1,J,1,K,0)),U,8)="" D
 .S ICDIEN=$P(ASSOC,";",1)
 .S CPTCODE=$$GET1^DIQ(81,CPT,.01)
 .I $$AICD^BGOUTL2 D
 ..S TXT=$P($$ICDDX^ICDEX(ICDIEN,$$NOW^XLFDT,"","I"),U,4)
 ..S ICDCODE=$P($$ICDDX^ICDEX(ICDIEN,$$NOW^XLFDT,"","I"),U,2)
 .E  D
 ..S TXT=$P($$ICDDX^ICDCODE(ICDIEN,$$NOW^XLFDT),U,4)
 ..S ICDCODE=$P($$ICDDX^ICDCODE(ICDIEN,$$NOW^XLFDT),U,2)
 .I $Y+4>IOSL,IOST["P-" W @IOF D HDR
 .W !,NAME,?20,J,?30,CPTCODE,?40,ICDCODE,?50,TXT
 Q
 ;If the selected item is an ICD-9 procedure add it to the report list
PROC ;If procedures is ICD-9 code add to report list
 N TXT,ICDIEN,ICDCODE,TXT,CPTCODE
 I $P($G(^BGOCPTPR(I,1,J,1,K,0)),U,8)="" D
 .S ICDIEN=$P(ASSOC,";",1)
 .S CPTCODE=$$GET1^DIQ(81,CPT,.01)
 .I $$AICD^BGOUTL2 D
 ..S DATA=$$ICDOP^ICDEX(ICDIEN,$$NOW^XLFDT,"","I")
 .E  S DATA=$$ICDOP^ICDCODE(ICDIEN,$$NOW^XLFDT,"","I")
 .I $P(DATA,U,15)=2 D
 ..S TXT=$P(DATA,U,5)
 ..S ICDCODE=$P(DATA,U,2)
 ..I $Y+4>IOSL,IOST["P-" W @IOF D HDR
 ..W !,NAME,?20,J,?30,CPTCODE,?40,ICDCODE,?50,TXT
 Q
AUTOQ ;Queue this item to run
 S IMP=$$IMP^ICDEX("10D",DT)
 I $$NOW^XLFDT<IMP D
 .W !,"Implementation date has not occurred."
 .W !,"Schedule the task to run within 6hrs of Implementation date."
 Q:'$$FIND1^DIC(19,"","MX","BGO CPT UPDATE ASSOCIATIONS")
 I $$FIND1^DIC(19.2,"","MX","BGO CPT UPDATE ASSOCIATONS") D
 .D EDIT^XUTMOPT("BGO CPT UPDATE ASSOCIATONS")
 E  D
 .D RESCH^XUTMOPT("BGO CPT UPDATE ASSOCIATIONS","","","","L")
 .D EDIT^XUTMOPT("BGO CPT UPDATE ASSOCIATIONS")
 Q
 Q
CHANGE ; Update and change all SNOMED ICD associations over to ICD-10 codes
 D ICD10^BGOCPTP3
 Q
ICD10 ;EP Entry to update SNOMED ICD associations
 N I,J,NAME,CPT,CNAME,PNAME,PCPT,IMP
 S IMP=$$IMP^ICDEX("10D",DT)
 I $$NOW^XLFDT<IMP W !,"Implementation date has not occurred. Cannot update items" Q
 D HDR2
 S I=0 F  S I=$O(^BGOCPTPR(I)) Q:I=""  D
 .S NAME=$P($G(^BGOCPTPR(I,0)),U,1)
 .S PNAME=0
 .S J=0 F  S J=$O(^BGOCPTPR(I,1,J)) Q:J=""  D
 ..S CPT=$P($G(^BGOCPTPR(I,1,J,0)),U,1)
 ..S CNAME=$P($G(^BGOCPTPR(I,1,J,0)),U,2)
 ..S PCPT=0
 ..S K="" F  S K=$O(^BGOCPTPR(I,1,J,1,K)) Q:K=""  D
 ...S ASSOC=$P($G(^BGOCPTPR(I,1,J,1,K,0)),U,1)
 ...I $P(ASSOC,";",2)="ICD9("&(BGORPT="D") D SNOUP
 Q
HDR2 ;EP
 N LIN,DTYP
 I IOST["C-" W @IOF
 W !,"List of ICD-9 codes updated to ICD-10 for Super Bill Associations",!
 W !,"Superbill",?20,"CPT IEN",?30,"Code",?40,"ICD",?50,"Text"
 W ! F LIN=1:1:72 W "-"
 W !
 Q
SNOUP ;Update the association
 N TXT,ICD,ICDCODE,TXT,CPTCODE,SNO
 Q:$P($G(^BGOCPTPR(I,1,J,1,K,0)),U,8)=""   ;Must have been converted to snomed
 S SNO=$P($G(^BGOCPTPR(I,1,J,1,K,0)),U,8)
 ;IHS/MSC/MGH Changed to use new api
 ;S SNODATA=$$CONC^BSTSAPI(SNO_"^^^1")
 S SNODATA=$$CONC^AUPNSICD(SNO_"^^^1")
 S ICD=$P($P(SNODATA,U,5),";",1)
 I ICD="" S ICD="ZZZ.999"
 S ICDIEN=$P($$CODEN^ICDEX(ICD,80),"~",1)
 S CPTCODE=$$GET1^DIQ(81,CPT,.01)
 S TXT=$P($$ICDDX^ICDEX(ICDIEN,$$NOW^XLFDT,"","I"),U,4)
 S ICDCODE=$P($$ICDDX^ICDEX(ICDIEN,$$NOW^XLFDT,"","I"),U,2)
 S IENS=K_","_J_","_I_","
 S FDA=$NA(FDA(90362.3121,IENS))
 S @FDA@(.01)=NEWCODE_";ICD0("
 S RET2=$$UPDATE^BGOUTL(.FDA,"@",.IEN)
 I 'RET2 D
 .I $Y+4>IOSL,IOST["P-" W @IOF D HDR2
 .W !,NAME,?20,J,?30,CPTCODE,?40,ICDCODE,?50,TXT
 Q
