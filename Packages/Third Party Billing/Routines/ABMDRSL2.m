ABMDRSL2 ; IHS/ASDST/DMJ - Selective Report Parameters-PART 3 ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 12
 ;   Added code so only brief and statistical will be asked
 ;   for pending report
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
PTYP ;EP
 K DIR
 S DIR(0)="SO^1:INDIAN BENEFICIARY PATIENTS;2:NON-BENEFICIARY PATIENTS"
 S DIR("A")="Select the PATIENT ELIGIBILITY STATUS"
 S DIR("?")="Selection of an Eligibility Status will restrict the report to only those visits in which the patient is of the type designated."
 D ^DIR
 K DIR
 Q:$D(DIRUT)
 S ABMY("PTYP")=Y
 S ABMY("PTYP","NM")=Y(0)
 Q
 ;
RTYP ;EP
 K DIR
 S DIR(0)="SO^1:BRIEF LISTING (80 Width);2:EXTENDED LISTING (132 Width);3:STATISTICAL SUMMARY ONLY"_$S($D(ABM("COST")):";4:ITEMIZED COST REPORT",1:"")
 I $G(ABM("REASON"))="PEND" S DIR(0)="SO^1:BRIEF LISTING (80 Width);2:STATISTICAL SUMMARY ONLY"
 S DIR("A")="Select TYPE of LISTING to Display"
 D ^DIR
 K DIR
 Q:$D(DIRUT)
 S ABM("RTYP")=Y
 S ABM("RTYP","NM")=Y(0)
 K ABM(132)
 I $D(ABM("REASON")),(Y=2) S (Y,ABM("RTYP"))=3
 I Y=2 S ABM(132)="" Q
 I Y>2,+$G(ABMP("TYP"))'=0 S ABM(132)=""
 Q
 ;
DX ;EP
 K DIR,ABMY("DX")
 W !!,"ENTRY of ICD DIAGNOSIS RANGE:",!,"============================="
 ;
DLOW ;
 S DIR(0)="PO^80:QEAM"
 S DIR("A")="Low ICD Code"
 D ^DIR
 K DIR
 Q:$D(DIRUT)
 G DLOW:+Y<1
 S ABMY("DX",1)=$P($$DX^ABMCVAPI(+Y,""),U,2)  ;CSV-c
 ;
DHI ;
 S DIR(0)="PO^80:QEAM"
 S DIR("A")="High ICD Code"
 D ^DIR
 K DIR
 G DX:$D(DIRUT)
 G DHI:+Y<1
 S ABMY("DX",2)=$P($$DX^ABMCVAPI(+Y,""),U,2)  ;CSV-c
 I ABMY("DX",1)>ABMY("DX",2)!('+ABMY("DX",1)&($E(ABMY("DX",1),2,9)>$E(ABMY("DX",2),2,9))) W !!,*7,"INPUT ERROR: Low Diagnosis is Greater than than the High, TRY AGAIN!",!! G DX
 W !
 S DIR(0)="S^A:ALL DIAGNOSIS;P:PRIMARY DIAGNOSIS ONLY"
 S DIR("B")="A"
 S DIR("A")="For each visit, Check [A]ll Diagnosis or just the [P]rimary"
 S DIR("?")="Enter either 'A' to have ALL of the Diagnosis checked for consistency with the range specified, or 'P' for checking just the Primary Diagnosis."
 D ^DIR
 Q:$D(DIRUT)
 S:Y="A" ABMY("DX","ALL")=""
 Q
 ;
PX ;EP
 K DIR,ABMY("PX")
 W !!,"ENTRY of CPT PROCEDURE RANGE:",!,"============================="
 ;
PLOW ;
 S DIR(0)="PO^81:QEAM"
 S DIR("A")="Low CPT Code"
 D ^DIR
 K DIR
 Q:$D(DIRUT)
 G PLOW:+Y<1
 S ABMY("PX",1)=$P($$CPT^ABMCVAPI(+Y,""),U,2)  ;CSV-c
 ;
PHI ;
 S DIR(0)="PO^81:QEAM"
 S DIR("A")="High CPT Code"
 D ^DIR
 K DIR
 G PX:$D(DIRUT)
 G PHI:+Y<1
 S ABMY("PX",2)=$P($$CPT^ABMCVAPI(+Y,""),U,2)  ;CSV-c
 I ABMY("PX",1)>ABMY("PX",2) W !!,*7,"INPUT ERROR: Low CPT Code is Greater than than the High, TRY AGAIN!",!! G PX
 Q
