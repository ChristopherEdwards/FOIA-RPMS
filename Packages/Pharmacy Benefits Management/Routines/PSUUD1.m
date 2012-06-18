PSUUD1 ;BIR/TJH - PBM UNIT DOSE MODULE ;12 AUG 1999
 ;;3.0;PHARMACY BENEFITS MANAGEMENT;**1,8,14,16,19**;Oct 15, 1998
 ;DBIA(s)
 ; Reference to file #55  supported by DBIA 2497
 ; Reference to file #7   supported by DBIA 2495
 ; Reference to file #50  supported by DBIA 221
 ; Reference to file #42  supported by DBIA 2440
 ; Reference to file #40.8 supported by DBIA 2438
 ; Reference to file #200  supported by DBIA 10060
 ; Reference to XUA4A72    supported by DBIA 1625
 ;
EN ; Entry point
 ;
 N PSUDOC1,PSUUDST
 D SETUP^PSUUD2 ; set up various arrays, variables needed for processing
L1 ; loop thru AUDS date index starting at PSDATE set in SETUP^PSUUD2
 S PSDATE=$O(^PS(55,"AUDS",PSDATE))
 I (PSDATE="")!(PSDATE>PSUEDTIM) G STEP2
 S PSPAT=0
L2 ; loop thru patient within date
 S PSPAT=$O(^PS(55,"AUDS",PSDATE,PSPAT))
 G:PSPAT'?1.N L1
 ; SCREEN OUT TEST PATIENTS
 G:$$TESTPAT^PSUTL1(PSPAT) L2
 S PSDOSE=0
L3 ; loop thru unit dose entries within patient
 S PSDOSE=$O(^PS(55,"AUDS",PSDATE,PSPAT,PSDOSE))
 G:PSDOSE'?1.N L2
 S ^XTMP("PSU_"_PSUJOB,"PSUHLD",PSDOSE)=""
 D GETS^PSUTL(55.06,"PSPAT,PSDOSE",".01;.5;1;9;10;26;34;68","PSUDOSE","I")
 D MOVEI^PSUTL("PSUDOSE")
 ;.01=order number, .5=patient ptr, 1=provider ptr, 9=original ward
 ;10=start date/time, 26=schedule, 34=stop date/time, 68=last ward
 I $L(PSUDOSE(34)),PSUDOSE(34)<PSUSDT G L3
 S PSUUDST=PSUDOSE(34)\1
 S PSUDOSE(10)=$P(PSUDOSE(10),".",1)
 S DFN=PSUDOSE(.5) D PID^VADPT
 S PSUSSN=$TR(VA("PID"),"^-","'")
 I $G(PSUSSN) S ^XTMP("PSU_"_PSUJOB,"PSUTDFN",DFN,PSUSSN)=""
 S PSUFACN=PSUSNDR,PSUX=$S($L(PSUDOSE(9)):PSUDOSE(9),1:PSUDOSE(68))
 I $L(PSUX) D
 .S PSUX1=$$VALI^PSUTL(42,PSUX,.015)
 .I PSUX1'="" S PSUFACN=$$VALI^PSUTL(40.8,PSUX1,1)
PROV ; collect provider data
 S (PSUVCL,PSUVS1,PSUVS2)=""
 S PSUVSSN=$$VALI^PSUTL(200,PSUDOSE(1),9)
 I PSUVSSN="" S PSUVSSN=999999999
 S ^XTMP("PSU_"_PSUJOB,"PSUPDR",PSUVSSN,PSUDOSE(1))=""
 S PSUDOC(9)=PSUVSSN
 ;
 S PSUVCP=$$VALI^PSUTL(200,PSUDOSE(1),53.5) ; class pointer
 I PSUVCP'="" D
 .S PSUVCL=$$VALI^PSUTL(7,PSUVCP,1)
 .I PSUVCL="" S PSUVCL=$$VALI^PSUTL(7,PSUVCP,.01)
 S PSUVSV=$$VAL^PSUTL(200,PSUDOSE(1),29) ; points to # 49,.01
 S PSUVSVX=$$UPPER^PSUTL(PSUVSV),PSUVSV=""
 I $L(PSUVSVX),$D(PSECT(PSUVSVX)) S PSUVSV=PSECT(PSUVSVX) ; convert to abbrev. if found in list.
 S PSUSPSTR=$$GET^XUA4A72(PSUDOSE(1),PSDATE)
 S PSUVS1=$P(PSUSPSTR,U,3),PSUVS2=$P(PSUSPSTR,U,4)
 D GETM^PSUTL(55.06,"PSPAT,PSDOSE","71*^.01;.02;.03;.05","^TMP($J,""PSUTA"")","IE")
 I $D(^TMP($J,"PSUTA")) D DISAMT^PSUUD2 ; set up dispensed amount summary array PSUDAS
 D TMPUD^PSUUD2 ; store Unit Dose info in REC1
DISD ; Dispense Drug 55.06,2 Mult --> 55.07 ^PS(55,PAT,5,DOSE,1,DISP,0)
 S PSUDDX=0
DISDL1 S PSUDDX=$O(^PS(55,PSPAT,5,PSDOSE,1,PSUDDX)) G:PSUDDX'?1.N DISDX
 D GETS^PSUTL(55.07,"PSPAT,PSDOSE,PSUDDX",".01;.02;.03","PSUDISD","I")
 ; .01 = drug pointer, .02 = units per dose, .03 = inactive date
 D MOVEI^PSUTL("PSUDISD")
 I $G(PSUDISD(.01))="" G DISDL1 ; missing data, go back and try another
 I $L(PSUDISD(.03)),PSUDISD(.03)<PSUSDT G DISDL1
 S:PSUDISD(.02)="" PSUDISD(.02)=1 ; default to 1 if not filled per Lina B.
 D GETS^PSUTL(50,PSUDISD(.01),".01;2;14.5;16;20;21;22;25;31;51;52;3","PSUDRUG","I")
 I '$D(PSUDRUG) F I=.01,2,14.5,16,20,21,22,25,31,51,52,3 S PSUDRUG(I,"I")=""
 D MOVEI^PSUTL("PSUDRUG")
 I PSUDRUG(.01)="" S PSUDRUG(.01)="Unknown Generic Name"
 I PSUDRUG(21)="" S PSUDRUG(21)="Unknown VA Product Name"
 I PSUDRUG(31)="" S PSUDRUG(31)="No NDC"
 I PSUDRUG(51)=1 S PSUDRUG(51)="N/F"
 I PSUDRUG(52) S PSUDRUG(52)="N/F"
 S PSUDNFI="",PSUDNFR="" ; National Formulary Indicator & Restriction
 I $$VERSION^XPDUTL("PSN")'<4 D  ; check for v.4 or greater of NDF
 .S PSUDNFI=$$FORMI^PSNAPIS(PSUDRUG(20),PSUDRUG(22))
 .S PSUDNFR=$$FORMR^PSNAPIS(PSUDRUG(20),PSUDRUG(22))
 D TMPDD^PSUUD2 ; store dispense drug data in ^XTMP global
 D LAB^PSULR0("UD",PSUFACN,PSUDOSE(.01),PSUDOSE(.5),PSUDRUG(.01),PSUDRUG(2))
 G DISDL1
DISDX ; end of dispense drug, go back for next one.
 G L3
 ;
STEP2 ; done with data collection, go back to ^PSUUD0
 Q
 ;
