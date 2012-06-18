AZAXDPM1 ;IHS/PHXAO/AEF - FIND IHS PATIENT FILE POINTERS FOR PATIENT MERGE PROCESS
 ;;1.0;ANNE'S SPECIAL ROUTINES;;AUG 23, 2004
 ;;
 ;;THIS ROUTINE SEARCHES EACH POINTER TO THE IHS PATIENT FILE
 ;;FOR THE SPECIFIED POINTER VALUE
 ;;
EN ;EP -- MAIN ENTRY POINT
 ;
 N DFN,Y
 ;
 D ^XBKVAR
 D HOME^%ZIS
 ;
 D SEL(.Y)
 Q:Y'>0
 S DFN=+Y
 ;
 D DO(DFN)
 Q
SEL(DFN) ;
 ;----- SELECT DFN TO SEARCH FOR
 ;
 N DIR,X
 S DIR(0)="N"
 S DIR("A")="Select DFN to search for"
 D ^DIR
 Q +Y
DO(DFN) ;
 ;----- PROCESS POINTERS
 ;
 D QUE(DFN)
 Q
DQ ;EP -- QUEUED JOB STARTS HERE
 ;
 D PRT(DFN)
 D ^%ZISC
 Q
PRT(DFN) ;
 ;----- PRINT THE REPORT
 ;
 N CNT,D0,D1,D2,DUZ2,I,ROU,X
 W @IOF
 W !,"FINDING IHS 'PATIENT' FILE POINTERS FOR PATIENT ",$P($G(^DPT(DFN,0)),U),"    DFN #",DFN,!
 S CNT=0
 F I=1:1:208 D
 . S ROU="I"_I_"("_DFN_","_I_","_".CNT"_")"
 . D @ROU
 ;
 W !!,CNT," POINTERS FOUND",!
 Q
I1(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the USER MENU File (#112.6)
 ;
 D HDR("I1",I)
 S D0=0
 F  S D0=$O(^FHUM(D0)) Q:'D0  D
 . S X=$P(^FHUM(D0,0),U)
 . Q:+X'=DFN
 . Q:"^DFN(^AUPNPAT("'[$P(X,";",2)
 . D WRITE(D0,DFN,.CNT)
 Q
I2(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the NCI CANCER REGISTER PATIENT FILE File (#19259.02)
 ;
 D HDR("I2",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^CIMSCPAT(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I3(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the VEN EHP AUDIT TRAIL File (#19707.8)
 ;
 D HDR("I3",I)
 S D0=0
 F  S D0=$O(^VEN(7.8,D0)) Q:'D0  D
 . Q:$P($G(^VEN(7.8,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I4(DFN,I,CNT) ;
 ;----- PATIENT field (#.03) of the RCIS REFERRAL File (#90001)
 ;
 D HDR("I4",I)
 S D0=0
 F  S D0=$O(^BMCREF(D0)) Q:'D0  D
 . Q:$P($G(^BMCREF(D0,0)),U,3)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I5(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the RCIS DIAGNOSIS File (#90001.01)
 ;
 D HDR("I5",I)
 S D0=0
 F  S D0=$O(^BMCDX(D0)) Q:'D0  D
 . Q:$P($G(^BMCDX(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I6(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the RCIS PROCEDURE File (#90001.02)
 ;
 D HDR("I6",I)
 S D0=0
 F  S D0=$O(^BMCPX(D0)) Q:'D0  D
 . Q:$P($G(^BMCPX(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I7(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the RCIS CASE REVIEW COMMENTS File (#90001.03)
 ;
 D HDR("I7",I)
 S D0=0
 F  S D0=$O(^BMCCOM(D0)) Q:'D0  D
 . Q:$P($G(^BMCCOM(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I8(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the RCIS SECONDARY PROVIDER LETTER File (#90001.04)
 ;
 D HDR("I8",I)
 S D0=0
 F  S D0=$O(^BMCPROV(D0)) Q:'D0  D
 . Q:$P($G(^BMCPROV(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I9(DFN,I,CNT) ;
 ;----- PATIENT field (#.04) of the CHR RECORD File (#90002)
 ;
 D HDR("I9",I)
 S D0=0
 F  S D0=$O(^BCHR(D0)) Q:'D0  D
 . Q:$P($G(^BCHR(D0,0)),U,4)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I10(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CHR POV File (#90002.01)
 ;
 D HDR("I10",I)
 S D0=0
 F  S D0=$O(^BCHRPROB(D0)) Q:'D0  D
 . Q:$P($G(^BCHRPROB(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I11(DFN,I,CNT) ;
 ;----- PATIENT field (#101) of the A/R BILL/IHS File (#90050.01)
 ;
 D HDR("I11",I)
 S DUZ2=0
 F  S DUZ2=$O(^BARBL(DUZ2)) Q:'DUZ2  D
 . S D0=0
 . F  S D0=$O(^BARBL(DUZ2,D0)) Q:'D0  D
 . . Q:$P($G(^BARBL(DUZ2,D0,1)),U)'=DFN
 . . W !?5,DUZ2,?15,D0,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
I12(DFN,I,CNT) ;
 ;----- ACCOUNT field (#.01) of the A/R ACCOUNTS/IHS File (#90050.02)
 ;
 D HDR("I12",I)
 S DUZ2=0
 F  S DUZ2=$O(^BARAC(DUZ2)) Q:'DUZ2  D
 . S D0=0
 . F  S D0=$O(^BARAC(DUZ2,D0)) Q:'D0  D
 . . S X=$P($G(^BARAC(DUZ2,D0,0)),U)
 . . Q:+X'=DFN
 . . Q:"^DFN(^AUPNPAT("'[$P(X,";",2)
 . . W !?5,DUZ2,?15,D0,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
I13(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the PATIENT sub-field (#90050.0211) of the A/R ACCOUNTS/IHS File (#90050.02)
 ;
 D HDR("I13",I)
 S DUZ2=0
 F  S DUZ2=$O(^BARAC(DUZ2)) Q:'DUZ2  D
 . S D0=0
 . F  S D0=$O(^BARAC(DUZ2,D0)) Q:'D0  D
 . . S D1=0
 . . F  S D1=$O(^BARAC(DUZ2,D0,11,D1)) Q:'D1  D
 . . . Q:$P($G(^BARAC(DUZ2,D0,11,D1,0)),U)'=DFN
 . . . W !?5,DUZ2,?15,D0,?25,D1,?35,DFN
 . . . S CNT=$G(CNT)+1
 Q
I14(DFN,I,CNT) ;
 ;----- PATIENT (A/R) field (#5) of the A/R TRANSACTIONS/IHS File (#90050.03)
 ;
 D HDR("I14",I)
 S DUZ2=0
 F  S DUZ2=$O(^BARTR(DUZ2)) Q:'DUZ2  D
 . S D0=0
 . F  S D0=$O(^BARTR(DUZ2,D0)) Q:'D0  D
 . . Q:$P($G(^BARTR(DUZ2,D0,0)),U,5)'=DFN
 . . W !?5,DUZ2,?15,D0,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
I15(DFN,I,CNT) ;
 ;----- PATIENT field (#5) of the ITEM(S) sub-field (#90051.1101) of the A/R COLLECTION BATCH/IHS File (#90051.01)
 ;
 D HDR("I15",I)
 S DUZ2=0
 F  S DUZ2=$O(^BARCOL(DUZ2)) Q:'DUZ2  D
 . S D0=0
 . F  S D0=$O(^BARCOL(DUZ2,D0)) Q:'D0  D
 . . S D1=0
 . . F  S D1=$O(^BARCOL(DUZ2,D0,1,D1)) Q:'D1  D
 . . . Q:$P($G(^BARCOL(DUZ2,D0,1,D1,0)),U,6)'=DFN
 . . . W !?5,DUZ2,?15,D0,?25,D1,?35,DFN
 . . . S CNT=$G(CNT)+1
 Q
I16(DFN,I,CNT) ;
 ;----- A/R PATIENT field (#.12) of the A/R EDI 835 HOLDING File (#90056.07)
 ;
 D HDR("I16",I)
 S D0=0
 F  S D0=$O(^BAR835(D0)) Q:'D0  D
 . Q:$P($G(^BAR835(D0,1)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I17(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the BPC ORDERABLES File (#90080)
 ;
 D HDR("I17",I)
 S D0=0
 F  S D0=$O(^BPCORD(D0)) Q:'D0  D
 . Q:$P($G(^BPCORD(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I18(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the ASTHMA REGISTER File (#90181.01)
 ;
 D HDR("I18",I)
 S D0=DFN  ;DINUMED
 Q:'$D(^BATREG(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I19(DFN,I,CNT) ;
 ;----- PATIENT field (#.03) of the ROI LISTING RECORD File (#90264)
 ;
 D HDR("I19",I)
 S D0=0
 F  S D0=$O(^BRNREC(D0)) Q:'D0  D
 . Q:$P($G(^BRNREC(D0,0)),U,3)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I20(DFN,I,CNT) ;
 ;----- PATIENT field (#.03) of the BZD PYXIS REGISTRATION LOG File (#1410004)
 ;
 D HDR("I20",I)
 S D0=0
 F  S D0=$O(^BZDPLOG(D0)) Q:'D0  D
 . Q:$P($G(^BZDPLOG(D0,0)),U,3)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I21(DFN,I,CNT) ;
 ;----- Patient Pointer field (#.12) of the BZD PYXIS BILLS File (#1410005)
 ;
 D HDR("I21",I)
 S D0=0
 F  S D0=$O(^BZDPBILL(D0)) Q:'D0  D
 . Q:$P($G(^BZDPBILL(D0,0)),U,12)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I22(DFN,I,CNT) ;
 ;----- PATIENT field (#.03) of the ROI DISCLOSURE File (#1991075)
 ;
 D HDR("I22",I)
 S D0=0
 F  S D0=$O(^AZXAREC(D0)) Q:'D0  D
 . Q:$P($G(^AZXAREC(D0,0)),U,3)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I23(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the SUICIDE File (#8000000)
 ;
 D HDR("I23",I)
 S D0=0
 F  S D0=$O(^DIZ(8000000,D0)) Q:'D0  D
 . Q:$P($G(^DIZ(8000000,D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I24(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the PRENATAL REGISTER File (#8000001)
 ;
 D HDR("I24",I)
 S D0=0
 F  S D0=$O(^DIZ(8000001,D0)) Q:'D0  D
 . Q:$P($G(^DIZ(8000001,D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I25(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the EYE CLINIC RECALL File (#8000008)
 ;
 D HDR("I25",I)
 S D0=0
 F  S D0=$O(^DIZ(8000008,D0)) Q:'D0  D
 . Q:$P($G(^DIZ(8000008,D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I26(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the PHN IMM File (#8000014)
 ;
 D HDR("I26",I)
 S D0=0
 F  S D0=$O(^DIZ(8000014,D0)) Q:'D0  D
 . Q:$P($G(^DIZ(8000014,D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I27(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the DIABETIC PATIENTS File (#8000016)
 ;
 D HDR("I27",I)
 S D0=0
 F  S D0=$O(^DIZ(8000016,D0)) Q:'D0  D
 . Q:$P($G(^DIZ(8000016,D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I28(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the AZHQ 3P CLAIM DATA File (#8008604.3)
 ;
 D HDR("I28",I)
 S DUZ2=0
 F  S DUZ2=$O(^AZHQCLM(DUZ2)) Q:'DUZ2  D
 . S D0=0
 . F  S D0=$O(^AZHQCLM(DUZ2,D0)) Q:'D0  D
 . . Q:$P($G(^AZHQCLM(DUZ2,D0,0)),U)'=DFN
 . . W !?5,DUZ2,?15,D0,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
I29(DFN,I,CNT) ;
 ;----- REGISTERED PATIENT field (#4.1) of the AZHQ CHS DENIAL DATA File (#8008607)
 ;
 D HDR("I29",I)
 S D0=0
 F  S D0=$O(^AZHQDEN(D0)) Q:'D0  D
 . Q:$P($G(^AZHQDEN(D0,0)),U,5)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I30(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the AZHQ PROBLEM File (#8008611)
 ;
 D HDR("I30",I)
 S D0=0
 F  S D0=$O(^AZHQPROB(D0)) Q:'D0  D
 . Q:$P($G(^AZHQPROB(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I31(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the AZHQ PERSONAL HISTORY File (#8008613)
 ;
 D HDR("I31",I)
 S D0=0
 F  S D0=$O(^AZHQPH(D0)) Q:'D0  D
 . Q:$P($G(^AZHQPH(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I32(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the AZHQ FAMILY HISTORY File (#8008614)
 ;
 D HDR("I32",I)
 S D0=0
 F  S D0=$O(^AZHQFH(D0)) Q:'D0  D
 . Q:$P($G(^AZHQFH(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I33(DFN,I,CNT) ;
 ;----- PATIENT field (#.03) of the AZHQ QI OCC DIAGNOSIS File (#8008666.8)
 ;
 D HDR("I33",I)
 S D0=0
 F  S D0=$O(^AZHQOCC(8,D0)) Q:'D0  D
 . Q:$P($G(^AZHQOCC(8,D0,0)),U,3)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I34(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the  File (#8008670.07)
 ;
 D HDR("I34",I)
 W !?5,"<FILE CORRUPTED!>"
 Q
I35(DFN,I,CNT) ;
 ;----- PATIENT field (#.05) of the AZHQ 3P BILL File (#8008674.4)
 ;
 D HDR("I35",I)
 S DUZ2=0
 F  S DUZ2=$O(^AZHQBILL(DUZ2)) Q:'DUZ2  D
 . S D0=0
 . F  S D0=$O(^AZHQBILL(DUZ2,D0)) Q:'D0  D
 . . Q:$P($G(^AZHQBILL(DUZ2,D0,0)),U,5)'=DFN
 . . W !?5,DUZ2,?15,D0,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
I36(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.05) of the AZHQ VISIT File (#8008675)
 ;
 D HDR("I36",I)
 S D0=0
 F  S D0=$O(^AZHQVSIT(D0)) Q:'D0  D
 . Q:$P($G(^AZHQVSIT(D0,0)),U,5)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I37(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the AZHQ V HOSPITALIZATION File (#8008675.02)
 ;
 D HDR("I37",I)
 S D0=0
 F  S D0=$O(^AZHQVINP(D0)) Q:'D0  D
 . Q:$P($G(^AZHQVINP(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I38(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the AZHQ V POV File (#8008675.07)
 ;
 D HDR("I38",I)
 S D0=0
 F  S D0=$O(^AZHQVPOV(D0)) Q:'D0  D
 . Q:$P($G(^AZHQVPOV(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I39(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the AZHQ V PROCEDURE File (#8008675.08)
 ;
 D HDR("I39",I)
 S D0=0
 F  S D0=$O(^AZHQVPRC(D0)) Q:'D0  D
 . Q:$P($G(^AZHQVPRC(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I40(DFN,I,CNT) ;
 ;----- PATIENT field (#13.64) of the DOCUMENT sub-field (#8008680.01) of the AZHQ CHS FACILITY File (#8008680)
 ;
 D HDR("I40",I)
 S D0=0
 F  S D0=$O(^AZHQF(D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^AZHQF(D0,"D",D1)) Q:'D1  D
 . . Q:$P($G(^AZHQF(D0,"D",D1,0)),U,22)'=DFN
 . . W !?5,D0,?15,D1,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
I41(DFN,I,CNT) ;
 ;----- PATIENT field (#2) of the TRANSACTION RECORD sub-field (#8008680.02) of the DOCUMENT sub-field (#8008680.01) of the AZHQ CHS FACILITY File (#8008680)
 ;
 D HDR("I41",I)
 S D0=0
 F  S D0=$O(^AZHQF(D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^AZHQF(D0,"D",D1)) Q:'D1  D
 . . S D2=0
 . . F  S D2=$O(^AZHQF(D0,"D",D1,"T",D2)) Q:'D2  D
 . . . Q:$P($G(^AZHQF(D0,"D",D1,"T",D2,0)),U,3)'=DFN
 . . . W !?5,D0,?15,D1,?25,D2,?35,DFN
 . . . S CNT=$G(CNT)+1
 Q
I42(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the *PRENATAL File (#9000002)
 ;
 D HDR("I42",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AUPNPNTL(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I43(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the MEDICARE ELIGIBLE File (#9000003)
 ;
 D HDR("I43",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AUPNMCR(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I44(DFN,I,CNT) ;
 ;----- PATIENT POINTER field (#.02) of the POLICY HOLDER File (#9000003.1)
 ;
 D HDR("I44",I)
 S D0=0
 F  S D0=$O(^AUPN3PPH(D0)) Q:'D0  D
 . Q:$P($G(^AUPN3PPH(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I45(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the MEDICAID ELIGIBLE File (#9000004)
 ;
 D HDR("I45",I)
 S D0=0
 F  S D0=$O(^AUPNMCD(D0)) Q:'D0  D
 . Q:$P($G(^AUPNMCD(D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I46(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the RAILROAD ELIGIBLE File (#9000005)
 ;
 D HDR("I46",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AUPNRRE(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I47(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the PRIVATE INSURANCE ELIGIBLE File (#9000006)
 ;
 D HDR("I47",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AUPNPRVT(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I48(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the *SCHEDULED ENCOUNTER File (#9000007)
 ;
 D HDR("I48",I)
 S D0=0
 F  S D0=$O(^AUPNFSE(D0)) Q:'D0  D
 . Q:$P($G(^AUPNFSE(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I49(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the *SURVEILLANCE File (#9000008)
 ;
 D HDR("I49",I)
 S D0=0
 F  S D0=$O(^AUPNSURV(D0)) Q:'D0  D
 . Q:$P($G(^AUPNSURV(D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I50(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the *CLINICAL REMINDER File (#9000009)
 ;
 D HDR("I50",I)
 S D0=0
 F  S D0=$O(^AUPNCR(D0)) Q:'D0  D
 . Q:$P($G(^AUPNCR(D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I51(DFN,I,CNT) ;       
 ;----- PATIENT NAME field (#.05) of the VISIT File (#9000010)
 ;
 D HDR("I51",I)
 S D0=0
 F  S D0=$O(^AUPNVSIT(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVSIT(D0,0)),U,5)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I52(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V MEASUREMENT File (#9000010.01)
 ;
 D HDR("I52",I)
 S D0=0
 F  S D0=$O(^AUPNVMSR(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVMSR(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I53(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V HOSPITALIZATION File (#9000010.02)
 ;
 D HDR("I53",I)
 S D0=0
 F  S D0=$O(^AUPNVINP(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVINP(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I54(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V CHS File (#9000010.03)
 ;
 D HDR("I54",I)
 S D0=0
 F  S D0=$O(^AUPNVCHS(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVCHS(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I55(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V EYE GLASS File (#9000010.04)
 ;
 D HDR("I55",I)
 S D0=0
 F  S D0=$O(^AUPNVEYE(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVEYE(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I56(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V DENTAL File (#9000010.05)
 ;
 D HDR("I56",I)
 S D0=0
 F  S D0=$O(^AUPNVDEN(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVDEN(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I57(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V PROVIDER File (#9000010.06)
 ;
 D HDR("I57",I)
 S D0=0
 F  S D0=$O(^AUPNVPRV(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVPRV(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I58(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V POV File (#9000010.07)
 ;
 D HDR("I58",I)
 S D0=0
 F  S D0=$O(^AUPNVPOV(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVPOV(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I59(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V PROCEDURE File (#9000010.08)
 ;
 D HDR("I59",I)
 S D0=0
 F  S D0=$O(^AUPNVPRC(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVPRC(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I60(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V LAB File (#9000010.09)
 ;
 D HDR("I60",I)
 S D0=0
 F  S D0=$O(^AUPNVLAB(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVLAB(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I61(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V IMMUNIZATION File (#9000010.11)
 ;
 D HDR("I61",I)
 S D0=0
 F  S D0=$O(^AUPNVIMM(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVIMM(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I62(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V SKIN TEST File (#9000010.12)
 ;
 D HDR("I62",I)
 S D0=0
 F  S D0=$O(^AUPNVSK(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVSK(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I63(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V EXAM File (#9000010.13)
 ;
 D HDR("I63",I)
 S D0=0
 F  S D0=$O(^AUPNVXAM(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVXAM(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I64(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V MEDICATION File (#9000010.14)
 ;
 D HDR("I64",I)
 S D0=0
 F  S D0=$O(^AUPNVMED(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVMED(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I65(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V TREATMENT File (#9000010.15)
 ;
 D HDR("I65",I)
 S D0=0
 F  S D0=$O(^AUPNVTRT(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVTRT(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I66(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V PATIENT ED File (#9000010.16)
 ;
 D HDR("I66",I)
 S D0=0
 F  S D0=$O(^AUPNVPED(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVPED(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I67(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V PHYSICAL THERAPY File (#9000010.17)
 ;
 D HDR("I67",I)
 S D0=0
 F  S D0=$O(^AUPNVPT(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVPT(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I68(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V CPT File (#9000010.18)
 ;
 D HDR("I68",I)
 S D0=0
 F  S D0=$O(^AUPNVCPT(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVCPT(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I69(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V ACTIVITY TIME File (#9000010.19)
 ;
 D HDR("I69",I)
 S D0=0
 F  S D0=$O(^AUPNVTM(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVTM(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I70(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V DIAGNOSTIC PROCEDURE RESULT File (#9000010.21)
 ;
 D HDR("I70",I)
 S D0=0
 F  S D0=$O(^AUPNVDXP(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVDXP(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I71(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V RADIOLOGY File (#9000010.22)
 ;
 D HDR("I71",I)
 S D0=0
 F  S D0=$O(^AUPNVRAD(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVRAD(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I72(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V HEALTH FACTORS File (#9000010.23)
 ;
 D HDR("I72",I)
 S D0=0
 F  S D0=$O(^AUPNVHF(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVHF(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I73(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V PATHOLOGY File (#9000010.24)
 ;
 D HDR("I73",I)
 S D0=0
 F  S D0=$O(^AUPNVPTH(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVPTH(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I74(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V MICROBIOLOGY File (#9000010.25)
 ;
 D HDR("I74",I)
 S D0=0
 F  S D0=$O(^AUPNVMIC(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVMIC(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I75(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the V NOTE File (#9000010.28)
 ;
 D HDR("I75",I)
 S D0=0
 F  S D0=$O(^AUPNVNOT(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVNOT(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I76(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V EMERGENCY VISIT RECORD File (#9000010.29)
 ;
 D HDR("I76",I)
 S D0=0
 F  S D0=$O(^AUPNVER(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVER(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I77(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V BLOOD BANK File (#9000010.31)
 ;
 D HDR("I77",I)
 S D0=0
 F  S D0=$O(^AUPNVBB(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVBB(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I78(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V PHN File (#9000010.32)
 ;
 D HDR("I78",I)
 S D0=0
 F  S D0=$O(^AUPNVPHN(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVPHN(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I79(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V TRANSACTION CODES File (#9000010.33)
 ;
 D HDR("I79",I)
 S D0=0
 F  S D0=$O(^AUPNVTC(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVTC(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I80(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V NARRATIVE TEXT File (#9000010.34)
 ;
 D HDR("I80",I)
 S D0=0
 F  S D0=$O(^AUPNVNT(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVNT(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I81(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V ELDER CARE File (#9000010.35)
 ;
 D HDR("I81",I)
 S D0=0
 F  S D0=$O(^AUPNVELD(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVELD(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I82(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V TRANSACTION CHARGE File (#9000010.37)
 ;
 D HDR("I82",I)
 S D0=0
 F  S D0=$O(^AUPNVTRC(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVTRC(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I83(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V UNHF File (#9000010.38)
 ;
 D HDR("I83",I)
 S D0=0
 F  S D0=$O(^AUPNVUNH(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVUNH(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I84(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V TREATMENT CONTRACT File (#9000010.39)
 ;
 D HDR("I84",I)
 S D0=0
 F  S D0=$O(^AUPNVTXC(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVTXC(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I85(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V ASTHMA File (#9000010.41)
 ;
 D HDR("I85",I)
 S D0=0
 F  S D0=$O(^AUPNVAST(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVAST(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I86(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V PODIATRY File (#9000010.42)
 ;
 D HDR("I86",I)
 S D0=0
 F  S D0=$O(^AUPNVPOD(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVPOD(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I87(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V VA MOBILE VISIT RELATED File (#9000010.701)
 ;
 D HDR("I87",I)
 S D0=0
 F  S D0=$O(^AUPNVMVR(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVMVR(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I88(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V VA MOBILE VISIT TYPES File (#9000010.702)
 ;
 D HDR("I88",I)
 S D0=0
 F  S D0=$O(^AUPNVMVT(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVMVT(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I89(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V VA MOBILE PRES ACTIONS File (#9000010.703)
 ;
 D HDR("I89",I)
 S D0=0
 F  S D0=$O(^AUPNVMPA(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVMPA(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I90(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V VA MOBILE REFER FOR OUTP File (#9000010.704)
 ;
 D HDR("I90",I)
 S D0=0
 F  S D0=$O(^AUPNVMRO(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVMRO(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I91(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V VA MOBILE SPECIALTY OF REFER File (#9000010.705)
 ;
 D HDR("I91",I)
 S D0=0
 F  S D0=$O(^AUPNVMSP(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVMSP(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I92(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V VA MOBILE EXAMS ORDERED File (#9000010.706)
 ;
 D HDR("I92",I)
 S D0=0
 F  S D0=$O(^AUPNVMEO(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVMEO(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I93(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the V LINE ITEM (GOODS&SERVICES) File (#9000010.99)
 ;
 D HDR("I93",I)
 S D0=0
 F  S D0=$O(^AUPNVLI(D0)) Q:'D0  D
 . Q:$P($G(^AUPNVLI(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I94(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the PROBLEM File (#9000011)
 ;
 D HDR("I94",I)
 S D0=0
 F  S D0=$O(^AUPNPROB(D0)) Q:'D0  D
 . Q:$P($G(^AUPNPROB(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I95(DFN,I,CNT) ;       
 ;----- PATIENT NAME field (#.02) of the OFFSPRING HISTORY File (#9000012)
 ;
 D HDR("I95",I)
 S D0=0
 F  S D0=$O(^AUPNOFFH(D0)) Q:'D0  D
 . Q:$P($G(^AUPNOFFH(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I96(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the PERSONAL HISTORY File (#9000013)
 ;
 D HDR("I96",I)
 S D0=0
 F  S D0=$O(^AUPNPH(D0)) Q:'D0  D
 . Q:$P($G(^AUPNPH(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I97(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the FAMILY HISTORY File (#9000014)
 ;
 D HDR("I97",I)
 S D0=0
 F  S D0=$O(^AUPNFH(D0)) Q:'D0  D
 . Q:$P($G(^AUPNFH(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I98(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the *UNMET SURGICAL NEED File (#9000015)
 ;
 D HDR("I98",I)
 S D0=0
 F  S D0=$O(^AUPNUMS(D0)) Q:'D0  D
 . Q:$P($G(^AUPNUMS(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I99(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the *HISTORY OF PROCEDURES File     (#9000016)
 ;
 D HDR("I99",I)
 S D0=0
 F  S D0=$O(^AUPNHOS(D0)) Q:'D0  D
 . Q:$P($G(^AUPNHOS(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I100(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the REPRODUCTIVE FACTORS File (#9000017)
 ;
 D HDR("I100",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AUPNREP(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I101(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the HEALTH STATUS File (#9000019)
 ;
 D HDR("I101",I)
 S D0=0
 F  S D0=$O(^AUPNHF(D0)) Q:'D0  D
 . Q:$P($G(^AUPNHF(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I102(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the PT LAB RELATED DATA File (#9000020)
 ;
 D HDR("I102",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AUPNLABR(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I103(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the IHS HL7 SUPPLY INTERFACE File (#9000021)
 ;
 D HDR("I103",I)
 S D0=0
 F  S D0=$O(^AUPNSUP(D0)) Q:'D0  D
 . Q:$P($G(^AUPNSUP(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I104(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the PATIENT REFUSALS FOR SERVICE/NMI File (#9000022)
 ;
 D HDR("I104",I)
 S D0=0
 F  S D0=$O(^AUPNPREF(D0)) Q:'D0  D
 . Q:$P($G(^AUPNPREF(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I105(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the ELDER CARE File (#9000023)
 ;
 D HDR("I105",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AUPNELDC(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I106(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the BIRTH MEASUREMENT File (#9000024)
 ;
 D HDR("I106",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AUPNBMSR(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I107(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the HEALTH REMINDER OVERRIDE File (#9000025)
 ;
 D HDR("I107",I)
 S D0=0
 F  S D0=$O(^AUPNHMRO(D0)) Q:'D0  D
 . Q:$P($G(^AUPNHMRO(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I108(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the INCOME STATUS File (#9000026)
 ;
 D HDR("I108",I)
 S D0=0
 F  S D0=$O(^AUPNINCS(D0)) Q:'D0  D
 . Q:$P($G(^AUPNINCS(D0,0)),U,2)='DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I109(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the OPIOID STATUS File (#9000027)
 ;
 D HDR("I109",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AUPNOPIU(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I110(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the AUTO/LIABILITY File (#9000031)
 ;
 D HDR("I110",I)
 S D0=0
 F  S D0=$O(^AUPNAUTO(D0)) Q:'D0  D
 . Q:$P($G(^AUPNAUTO(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I111(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the WORKMAN'S COMP File (#9000032)       
 ;
 D HDR("I111",I)
 S D0=0
 F  S D0=$O(^AUPNWRKC(D0)) Q:'D0  D
 . Q:$P($G(^AUPNWRKC(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I112(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the PATIENT NAME CHANGES File (#9000033)
 ;
 D HDR("I112",I)
 S D0=0
 F  S D0=$O(^AUPNNAMC(D0)) Q:'D0  D
 . Q:$P($G(^AUPNNAMC(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I113(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the PATIENT'S LEGAL DOCS File (#9000034)
 ;
 D HDR("I113",I)
 S D0=0
 F  S D0=$O(^AUPNPLDC(D0)) Q:'D0  D
 . Q:$P($G(^AUPNPLDC(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I114(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CATEGORY PRIORITIZING File (#9000035)
 ;
 D HDR("I114",I)
 S D0=0
 F  S D0=$O(^AUPNICP(D0)) Q:'D0  D
 . Q:$P($G(^AUPNICP(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I115(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the PRE-CERTIFICATION File (#9000036)
 ;
 D HDR("I115",I)
 S D0=0
 F  S D0=$O(^AUPNPCRT(D0)) Q:'D0  D
 . Q:$P($G(^AUPNPCRT(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I116(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the MSP PATIENT File (#9000037)
 ;
 D HDR("I116",I)
 S D0=0
 F  S D0=$O(^AUPNMSP(D0)) Q:'D0  D
 . Q:$P($G(^AUPNMSP(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I117(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the NOTICE OF PRIVACY PRACTICES File (#9000038)
 ;
 D HDR("I117",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AUPNNPP(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I118(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the RESTRICTED HEALTH INFORMATION File (#9000039)
 ;
 D HDR("I118",I)
 S D0=0
 F  S D0=$O(^AUPNRHI(D0)) Q:'D0  D
 . Q:$P($G(^AUPNRHI(D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I119(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the PRIMARY CARE PROVIDER CHANGE LOG File (#9000096)
 ;
 D HDR("I119",I)
 S D0=0
 F  S D0=$O(^AUPNPRCL(D0)) Q:'D0  D
 . Q:$P($G(^AUPNPRCL(D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I120(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the OCCUPATIONAL HEALTH File (#9000097)
 ;
 D HDR("I120",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AUPNPOCC(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I121(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the PATIENT EXPOSURES File (#9000098)
 ;
 D HDR("I121",I)
 S D0=0
 F  S D0=$O(^AUPNPEXP(D0)) Q:'D0  D
 . Q:$P($G(^AUPNPEXP(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I122(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the PCC DATA ENTRY DM UPDATE File (#9001002.2)
 ;
 D HDR("I122",I)
 S D0=0
 F  S D0=$O(^APCDDMUP(D0)) Q:'D0  D
 . Q:$P($G(^APCDDMUP(D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I123(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the PATIENT sub-field (#9001500.01) of the REGISTER File (#9001500)
 ;
 D HDR("I123",I)
 S D0=0
 F  S D0=$O(^APCRREG(D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^APCRREG(D0,1,D1)) Q:'D1  D
 . . Q:$P($G(^APCRREG(D0,1,D1,0)),U)'=DFN
 . . W !?5,D0,?15,D1,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
I124(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the DENTAL FOLLOWUP File (#9002003.2)
 ;
 D HDR("I124",I)
 S D0=0
 F  S D0=$O(^ADEFOL(D0)) Q:'D0  D
 . Q:$P($G(^ADEFOL(D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I125(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the DENTAL DEFERRED SVCS REGISTER File (#9002003.4)
 ;
 D HDR("I125",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^ADEDSR(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I126(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the DENTAL PROCEDURE File (#9002007)        
 ;
 D HDR("I126",I)
 S D0=0
 F  S D0=$O(^ADEPCD(D0)) Q:'D0  D
 . Q:$P($G(^ADEPCD(D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I127(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the DENTAL PATIENT File (#9002010.2)
 ;
 D HDR("I127",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^ADEPAT(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I128(DFN,I,CNT) ;
 ;----- PATIENT field (#.08) of the MHSS RECORD File (#9002011)
 ;
 D HDR("I128",I)
 S D0=0
 F  S D0=$O(^AMHREC(D0)) Q:'D0  D
 . Q:$P($G(^AMHREC(D0,0)),U,8)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I129(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the MHSS RECORD PROBLEMS (POVS) File (#9002011.01)
 ;
 D HDR("I129",I)
 S D0=0
 F  S D0=$O(^AMHRPRO(D0)) Q:'D0  D
 . Q:$P($G(^AMHRPRO(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I130(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the MHSS RECORD PROVIDERS File (#9002011.02)
 ;
 D HDR("I130",I)
 S D0=0
 F  S D0=$O(^AMHRPROV(D0)) Q:'D0  D
 . Q:$P($G(^AMHRPROV(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I131(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the MHSS RECORD TREATED MEDICAL PROBS File (#9002011.03)
 ;
 D HDR("I131",I)
 S D0=0
 F  S D0=$O(^AMHRTMDP(D0)) Q:'D0  D
 . Q:$P($G(^AMHRTMDP(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I132(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the MHSS RECORD PROCEDURES (CPT) File (#9002011.04)
 ;
 D HDR("I132",I)
 S D0=0
 F  S D0=$O(^AMHRPROC(D0)) Q:'D0  D
 . Q:$P($G(^AMHRPROC(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I133(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the MHSS RECORD PATIENT EDUCATION File (#9002011.05)        
 ;
 D HDR("I133",I)
 S D0=0
 F  S D0=$O(^AMHREDU(D0)) Q:'D0  D
 . Q:$P($G(^AMHREDU(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I134(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the BH CD STAGING TOOL File (#9002011.06)
 ;
 D HDR("I134",I)
 S D0=0
 F  S D0=$O(^AMHRCDST(D0)) Q:'D0  D
 . Q:$P($G(^AMHRCDST(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I135(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the MHSS INTAKE File (#9002011.07)       
 ;
 D HDR("I135",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AMHPINTK(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I136(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the MHSS RECORD HEALTH FACTORS File (#9002011.08)
 ;
 D HDR("I136",I)
 S D0=0
 F  S D0=$O(^AMHRHF(D0)) Q:'D0  D
 . Q:$P($G(^AMHRHF(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I137(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the MHSS RECORD PREVENTION ACTIVITES File (#9002011.09)
 ;
 D HDR("I137",I)
 S D0=0
 F  S D0=$O(^AMHRPA(D0)) Q:'D0  D
 . Q:$P($G(^AMHRPA(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I138(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the MHSS RECORD NAVAJO REFERRAL FORM File (#9002011.11)
 ;
 D HDR("I138",I)
 S D0=0
 F  S D0=$O(^AMHRNRF(D0)) Q:'D0  D
 . Q:$P($G(^AMHRNRF(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I139(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the MHSS PATIENT PROBLEM LIST File (#9002011.51)
 ;
 D HDR("I139",I)
 S D0=0
 F  S D0=$O(^AMHPPROB(D0)) Q:'D0  D
 . Q:$P($G(^AMHPPROB(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I140(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the MHSS PATIENT PERSONAL HX File (#9002011.52)
 ;
 D HDR("I140",I)
 S D0=0
 F  S D0=$O(^AMHPPHX(D0)) Q:'D0  D
 . Q:$P($G(^AMHPPHX(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I141(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the MHSS PATIENT TREATMENT NOTES File (#9002011.53)
 ;
 D HDR("I141",I)
 S D0=0
 F  S D0=$O(^AMHPTP(D0)) Q:'D0  D
 . Q:$P($G(^AMHPTP(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I142(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the MHSS PATIENT DATA File (#9002011.55)
 ;
 D HDR("I142",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AMHPATR(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I143(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the MHSS PATIENT TREATMENT PLANS File (#9002011.56)
 ;
 D HDR("I143",I)
 S D0=0
 F  S D0=$O(^AMHPTXP(D0)) Q:'D0  D
 . Q:$P($G(^AMHPTXP(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I144(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the *MHSS PATIENT TX PLAN METHODS File (#9002011.57)
 ;
 D HDR("I144",I)
 S D0=0
 F  S D0=$O(^AMHPTXPG(D0)) Q:'D0  D
 . Q:$P($G(^AMHPTXPG(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I145(DFN,I,CNT) ;    
 ;----- PATIENT field (#.02) of the MHSS CASE DATES File (#9002011.58)
 ;
 D HDR("I145",I)
 S D0=0
 F  S D0=$O(^AMHPCASE(D0)) Q:'D0  D
 . Q:$P($G(^AMHPCASE(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I146(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the *MHSS PATIENT TP PROBLEMS File (#9002011.62)
 ;
 D HDR("I146",I)
 S D0=0
 F  S D0=$O(^AMHPTPP(D0)) Q:'D0  D
 . Q:$P($G(^AMHPTPP(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I147(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the *MHSS PATIENT TP GOALS 2 File (#9002011.63)
 ;
 D HDR("I147",I)
 S D0=0
 F  S D0=$O(^AMHPTPGL(D0)) Q:'D0  D
 . Q:$P($G(^AMHPTPGL(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I148(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the *MHSS PATIENT TP METHODS File (#9002011.64)
 ;
 D HDR("I148",I)
 S D0=0
 F  S D0=$O(^AMHPTPM(D0)) Q:'D0  D
 . Q:$P($G(^AMHPTPM(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I149(DFN,I,CNT) ;
 ;----- PATIENT field (#.04) of the MHSS SUICIDE FORMS File (#9002011.65)
 ;
 D HDR("I149",I)
 S D0=0
 F  S D0=$O(^AMHPSUIC(D0)) Q:'D0  D
 . Q:$P($G(^AMHPSUIC(D0,0)),U,4)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I150(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CHEF NUMBER sub-field (#9002064.11) of the CHS CHEF REGISTRY File (#9002064.1)
 ;
 D HDR("I150",I)
 S D0=0
 F  S D0=$O(^ACHSCHEF(D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^ACHSCHEF(D0,1,D1)) Q:'D1  D
 . . Q:$P($G(^ACHSCHEF(D0,1,D1,0)),U,2)'=DFN
 . . W !?5,D0,?15,D1,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
I151(DFN,I,CNT) ;
 ;----- REGISTERED PATIENT field (#6) of the CHS DEFERRED SERVICE NUMBER sub-field (#9002066.01) of the CHS DEFERRED SERVICE DATA File (#9002066)
 ;
 D HDR("I151",I)
 S D0=0
 F  S D0=$O(^ACHSDEF(D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^ACHSDEF(D0,"D",D1))  Q:'D1  D
 . . Q:$P($G(^ACHSDEF(D0,"D",D1,0)),U,6)'=DFN
 . . W !?5,D0,?15,D1,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
I152(DFN,I,CNT) ;
 ;----- REGISTERED PATIENT field (#7) of the DENIAL NUMBER sub-field (#9002071.01) of the CHS DENIAL DATA File (#9002071)
 ;
 D HDR("I152",I)
 S D0=0
 F  S D0=$O(^ACHSDEN(D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^ACHSDEN(D0,"D",D1)) Q:'D1  D
 . . Q:$P($G(^ACHSDEN(D0,"D",D1,0)),U,7)'=DFN
 . . W !?5,D0,?15,D1,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
I153(DFN,I,CNT) ;
 ;----- PATIENT field (#13.64) of the DOCUMENT sub-field (#9002080.01) of the CHS FACILITY File (#9002080)
 ;
 D HDR("I153",I)
 S D0=0
 F  S D0=$O(^ACHSF(D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^ACHSF(D0,"D",D1)) Q:'D1  D
 . . Q:$P($G(^ACHSF(D0,"D",D1,0)),U,22)'=DFN
 . . W !?5,D0,?15,D1,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
I154(DFN,I,CNT) ;
 ;----- PATIENT field (#2) of the TRANSACTION RECORD sub-field (#9002080.02) of the DOCUMENT sub-field (#9002080.01) of the CHS FACILITY File (#9002080)
 ;
 D HDR("I154",I)
 S D0=0
 F  S D0=$O(^ACHSF(D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^ACHSF(D0,"D",D1)) Q:'D1  D
 . . S D2=0
 . . F  S D2=$O(^ACHSF(D0,"D",D1,"T",D2)) Q:'D2  D
 . . . Q:$P($G(^ACHSF(D0,"D",D1,"T",D2,0)),U,3)'=DFN
 . . . W !?5,D0,?15,D1,?25,D2,?35,DFN
 . . . S CNT=$G(CNT)+1
 Q
I155(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the BI PATIENT File (#9002084)
 ;
 D HDR("I155",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^BIP(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I156(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the BI PATIENT IMMUNIZATIONS DUE File (#9002084.1)
 ;
 D HDR("I156",I)
 S D0=0
 F  S D0=$O(^BIPDUE(D0)) Q:'D0  D
 . Q:$P($G(^BIPDUE(D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I157(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the BI PATIENT CONTRAINDICATIONS File (#9002084.11)
 ;
 D HDR("I157",I)
 S D0=0
 F  S D0=$O(^BIPC(D0)) Q:'D0  D
 . Q:$P($G(^BIPC(D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I158(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the MCH PATIENT File (#9002085)
 ;
 D HDR("I158",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AMCH(85,D0))
 D WRITE(D0,DFN,.CNT)
 Q
I159(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the BW PATIENT File (#9002086)
 ;
 D HDR("I159",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^BWP(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I160(DFN,I,CNT) ;
 ;----- NAME field (#.02) of the QA CHS ADMISSION File (#9002157)
 ;
 D HDR("I160",I)
 S D0=0
 F  S D0=$O(^AQACHSAD(D0)) Q:'D0  D
 . Q:$P($G(^AQACHSAD(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I161(DFN,I,CNT) ;
 ;----- NAME field (#.02) of the QA IHS ADMISSION File (#9002159)
 ;
 D HDR("I161",I)
 S D0=0
 F  S D0=$O(^AQACIHS(D0)) Q:'D0  D
 . Q:$P($G(^AQACIHS(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I162(DFN,I,CNT) ;
 ;----- PATIENT field (#.03) of the QI OCC CRITERIA File (#9002166.5)
 ;
 D HDR("I162",I)
 S D0=0
 F  S D0=$O(^AQAOCC(5,D0)) Q:'D0  D
 . Q:$P($G(^AQAOCC(5,D0,0)),U,3)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I163(DFN,I,CNT) ;
 ;----- PATIENT field (#.03) of the QI OCC DRUG File (#9002166.6)
 ;
 D HDR("I163",I)
 S D0=0
 F  S D0=$O(^AQAOCC(6,D0)) Q:'D0  D
 . Q:$P($G(^AQAOCC(6,D0,0)),U,3)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I164(DFN,I,CNT) ;
 ;----- PATIENT field (#.03) of the QI OCC PROVIDER File (#9002166.7)
 ;
 D HDR("I164",I)
 S D0=0
 F  S D0=$O(^AQAOCC(7,D0)) Q:'D0  D
 . Q:$P($G(^AQAOCC(7,D0,0)),U,3)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I165(DFN,I,CNT) ;
 ;----- PATIENT field (#.03) of the QI OCC DIAGNOSIS File (#9002166.8)
 ;
 D HDR("I165",I)
 S D0=0
 F  S D0=$O(^AQAOCC(8,D0)) Q:'D0  D
 . Q:$P($G(^AQAOCC(8,D0,0)),U,3)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I166(DFN,I,CNT) ;
 ;----- PATIENT field (#.03) of the QI OCC PROCEDURE File (#9002166.9)
 ;
 D HDR("I166",I)
 S D0=0
 F  S D0=$O(^AQAOCC(9,D0)) Q:'D0  D
 . Q:$P($G(^AQAOCC(9,D0,0)),U,3)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I167(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.02) of the QI OCCURRENCE File (#9002167)
 ;
 D HDR("I167",I)
 S D0=0
 F  S D0=$O(^AQAOC(D0)) Q:'D0  D
 . Q:$P($G(^AQAOC(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I168(DFN,I,CNT) ;
 ;----- CLIENTS NAME field (#4) of the CDMIS VISIT File (#9002172.1)
 ;
 D HDR("I168",I)
 S D0=0
 F  S D0=$O(^ACDVIS(D0)) Q:'D0  D
 . Q:$P($G(^ACDVIS(D0,0)),U,5)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I169(DFN,I,CNT) ;
 ;----- CLIENT field (#.01) of the CLIENT sub-field (#9002172.81) of the CDMIS CLIENT CATEGORY File (#9002172.8)
 ;
 D HDR("I169",I)
 S D0=0
 F  S D0=$O(^ACDPAT(D0)) Q:'D0  D
 . S D1=DFN   ;DINUMED
 . Q:'$D(^ACDPAT(D0,1,D1))
 . W ?5,D0,?15,D1,?25,DFN
 . S CNT=$G(CNT)+1
 Q
I170(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CDMIS BILL File (#9002172.9
 ;
 D HDR("I170",I)
 S D0=0
 F  S D0=$O(^ACDBILL(D0)) Q:'D0  D
 . Q:$P($G(^ACDBILL(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I171(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the PATIENT sub-field (#9002227.01101) of the PT TAXONOMY File (#9002227)
 ;
 D HDR("I171",I)
 S D0=0
 F  S D0=$O(^ATXPAT(D0)) Q:'D0  D
 . S D1=DFN   ;DINUMED
 . Q:'$D(^ATXPAT(D0,11,D1))
 . W ?5,D0,?15,D1,?25,DFN
 . S CNT=$G(CNT)+1
 Q
I172(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CIC VISIT File (#9002230)
 ;
 D HDR("I172",I)
 S D0=0
 F  S D0=$O(^ACI(30,D0)) Q:'D0  D
 . Q:$P($G(^ACI(30,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I173(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CMS REGISTER File (#9002241)
 ;
 D HDR("I173",I)
 S D0=0
 F  S D0=$O(^ACM(41,D0)) Q:'D0  D
 . Q:$P($G(^ACM(41,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I174(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CMS COMPLICATION FOR THE CLIENT File (#9002242)
 ;
 D HDR("I174",I)
 S D0=0
 F  S D0=$O(^ACM(42,D0)) Q:'D0  D
 . Q:$P($G(^ACM(42,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I175(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CMS INTERVENTION PLAN File (#9002243)
 ;
 D HDR("I175",I)
 S D0=0
 F  S D0=$O(^ACM(43,D0)) Q:'D0  D
 . Q:$P($G(^ACM(43,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I176(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CMS DIAGNOSIS FOR THE CLIENT File (#9002244)
 ;
 D HDR("I176",I)
 S D0=0
 F  S D0=$O(^ACM(44,D0)) Q:'D0  D
 . Q:$P($G(^ACM(44,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I177(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CMS RISK FACTOR FOR THE CLIENT File (#9002245)
 ;
 D HDR("I177",I)
 S D0=0
 F  S D0=$O(^ACM(45,D0)) Q:'D0  D
 . Q:$P($G(^ACM(45,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I178(DFN,I,CNT) ;
 ;----- FAMILY MEMBER field (#.01) of the CMS FAMILY MEMBERS File (#9002246)
 ;
 D HDR("I178",I)
 S D0=0
 F  S D0=$O(^ACM(46,D0)) Q:'D0  D
 . Q:$P($G(^ACM(46,D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I179(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CMS FAMILY MEMBERS File (#9002246)
 ;
 D HDR("I179",I)
 S D0=0
 F  S D0=$O(^ACM(46,D0)) Q:'D0  D
 . Q:$P($G(^ACM(46,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I180(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CMS SERVICE FOR THE CLIENT File (#9002247)
 ;
 D HDR("I180",I)
 S D0=0
 F  S D0=$O(^ACM(47,D0)) Q:'D0  D
 . Q:$P($G(^ACM(47,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I181(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CMS CARE PLAN FOR THE CLIENT File (#9002248)
 ;
 D HDR("I181",I)
 S D0=0
 F  S D0=$O(^ACM(48,D0)) Q:'D0  D
 . Q:$P($G(^ACM(48,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I182(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CMS APPOINTMENT File (#9002249)
 ;
 D HDR("I182",I)
 S D0=0
 F  S D0=$O(^ACM(49,D0)) Q:'D0  D
 . Q:$P($G(^ACM(49,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I183(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CMS REGISTER CRITERIA FOR THE CLIENT File (#9002251)
 ;
 D HDR("I183",I)
 S D0=0
 F  S D0=$O(^ACM(51,D0)) Q:'D0  D
 . Q:$P($G(^ACM(51,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I184(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CMS ETIOLOGY FOR THIS CLIENT File (#9002253)
 ;
 D HDR("I184",I)
 S D0=0
 F  S D0=$O(^ACM(53,D0)) Q:'D0  D
 . Q:$P($G(^ACM(53,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I185(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CMS MEDICATIONS FOR THE CLIENT File (#9002254)
 ;
 D HDR("I185",I)
 S D0=0
 F  S D0=$O(^ACM(54,D0)) Q:'D0  D
 . Q:$P($G(^ACM(54,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I186(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the CMS MEASUREMENT File (#9002257)
 ;
 D HDR("I186",I)
 S D0=0
 F  S D0=$O(^ACM(57,D0)) Q:'D0  D
 . Q:$P($G(^ACM(57,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I187(DFN,I,CNT) ;
 ;----- PATIENT'S NAME field (#1) of the PRIVATE INS FACILITY BILLING File (#9002273.02)
 ;
 D HDR("I187",I)
 S D0=0
 F  S D0=$O(^ABPVFAC(D0)) Q:'D0  D
 . Q:$P($G(^ABPVFAC(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I188(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the 3P CLAIM DATA File (#9002274.3)
 ;
 D HDR("I188",I)
 S DUZ2=0
 F  S DUZ2=$O(^ABMDCLM(DUZ2)) Q:'DUZ2  D
 . S D0=0
 . F  S D0=$O(^ABMDCLM(DUZ2,D0)) Q:'D0  D
 . . Q:$P($G(^ABMDCLM(DUZ2,D0,0)),U)'=DFN
 . . W !?5,DUZ2,?15,D0,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
I189(DFN,I,CNT) ;
 ;----- PATIENT field (#.05) of the 3P BILL File (#9002274.4)
 ;
 D HDR("I189",I)
 S DUZ2=0
 F  S DUZ2=$O(^ABMDBILL(DUZ2)) Q:'DUZ2  D
 . S D0=0
 . F  S D0=$O(^ABMDBILL(DUZ2,D0)) Q:'D0  D
 . . Q:$P($G(^ABMDBILL(DUZ2,D0,0)),U,5)'=DFN
 . . W !?5,DUZ2,?15,D0,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
I190(DFN,I,CNT) ;
 ;----- PATIENT field (#5) of the ABSP LOG OF TRANSACTIONS File (#9002313.57)
 ;
 D HDR("I190",I)
 S D0=0
 F  S D0=$O(^ABSPTL(D0)) Q:'D0  D
 . Q:$P($G(^ABSPTL(D0,0)),U,6)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I191(DFN,I,CNT) ;
 ;----- PATIENT field (#5) of the ABSP TRANSACTION File (#9002313.59)
 ;
 D HDR("I191",I)
 S D0=0
 F  S D0=$O(^ABSPT(D0)) Q:'D0  D
 . Q:$P($G(^ABSPT(D0,0)),U,6)'=DFN
 . W !?5,D0,"  ",DFN
 . S CNT=$G(CNT)+1
 Q
I192(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the DAY SURGERY File (#9009012)
 ;
 D HDR("I192",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^ADGDS(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I193(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the DS INCOMPLETE CHART File (#9009012.5)
 ;
 D HDR("I193",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^ADGDSI(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I194(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the INCOMPLETE CHART File (#9009013)
 ;
 D HDR("I194",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^ADGIC(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I195(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the SCHEDULED VISIT File (#9009013.1)
 ;
 D HDR("I195",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^ADGAUTH(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I196(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the PATIENT sub-field (#9009015.01) of the WAITING LIST CLINIC File (#9009015)
 ;
 D HDR("I196",I)
 S D0=0
 F  S D0=$O(^ASDWL(D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^ASDWL(D0,1,D1)) Q:'D1  D
 . . Q:$P($G(^ASDWL(D0,1,D1,0)),U)'=DFN
 . . W !?5,D0,?15,D1,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
I197(DFN,I,CNT) ;
 ;----- PATIENT field (#.04) of the BLRA LAB AUDIT File (#9009027)
 ;
 D HDR("I197",I)
 S D0=0
 F  S D0=$O(^BLRALAB(9009027,D0)) Q:'D0  D
 . Q:$P($G(^BLRALAB(9009027,D0,0)),U,4)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I198(DFN,I,CNT) ;
 ;----- PATIENT field (#.04) of the APSP DUE REVIEW File (#9009032)
 ;
 D HDR("I198",I)
 S D0=0
 F  S D0=$O(^APSPDUE(32,D0)) Q:'D0  D
 . Q:$P($G(^APSPDUE(32,D0,0)),U,4)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I199(DFN,I,CNT) ;
 ;----- PATIENT field (#2) of the NON FORMULARY REQUESTS File (#9009035.1)
 ;
 D HDR("I199",I)
 S D0=0
 F  S D0=$O(^APSQNF(D0)) Q:'D0  D
 . Q:$P($G(^APSQNF(D0,0)),U,3)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I200(DFN,I,CNT) ;
 ;----- PATIENT field (#.04) of the ANS NURSE ACUITY RECORD File (#9009052)
 ;
 D HDR("I200",I)
 S D0=0
 F  S D0=$O(^ANSR(D0)) Q:'D0  D
 . Q:$P($G(^ANSR(D0,0)),U,4)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I201(DFN,I,CNT) ;
 ;----- PATIENTS ADDED field (#.01) of the PATIENTS ADDED sub-field (#9009062.021) of the AG ELIGIBILITY UPLOAD LOG File (#9009062.02)
 ;
 D HDR("I201",I)
 S D0=0
 F  S D0=$O(^AGELUPLG(D0)) Q:'D0  D
 . S D1=DFN   ;DINUMED
 . Q:'$D(^AGELUPLG(D0,1,D1))
 . W !?5,D0,?15,D1,?25,DFN
 . S CNT=$G(CNT)+1
 Q
I202(DFN,I,CNT) ;
 ;----- PATIENTS EDITED field (#.01) of the PATIENTS EDITED sub-field (#9009062.022) of the AG ELIGIBILITY UPLOAD LOG File (#9009062.02)
 ;
 D HDR("I202",I)
 S D0=0
 F  S D0=$O(^AGELUPLG(D0)) Q:'D0  D
 . S D1=DFN   ;DINUMED
 . Q:'$D(^AGELUPLG(D0,2,D1))
 . W !?5,D0,?15,D1,?25,DFN
 . S CNT=$G(CNT)+1
 Q
I203(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the AGVQ VERIQUEST PATIENT File (#9009062.08)
 ;
 D HDR("I203",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AGVQP(D0))
 D WRITE(D0,DFN,.CNT)
 Q
I204(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the AG MESSAGE TRANSACTIONS File (#9009063.1)
 ;
 D HDR("I204",I)
 S D0=0
 F  S D0=$O(^AGTXMSG(D0)) Q:'D0  D
 . Q:$P($G(^AGTXMSG(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I205(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the PATIENT sub-field (#9009065.05) of the REGISTRATION MAILING LIST File (#9009065)
 ;
 D HDR("I205",I)
 S D0=0
 F  S D0=$O(^AGADLIST(D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^AGADLIST(D0,1,D1)) Q:'D1  D
 . . Q:$P($G(^AGADLIST(D0,1,D1,0)),U)'=DFN
 . . W !?5,D0,?15,D1,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
I206(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the AGEV INSURANCE ELIGIBILITY HOLDING File (#9009066)
 ;
 D HDR("I206",I)
 S D0=0
 F  S D0=$O(^AGEVH(D0)) Q:'D0  D
 . Q:$P($G(^AGEVH(D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I207(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the ER VISIT File (#9009080)
 ;
 D HDR("I207",I)
 S D0=0
 F  S D0=$O(^AMERVSIT(D0)) Q:'D0  D
 . Q:$P($G(^AMERVSIT(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
I208(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the ER ADMISSION File (#9009081)
 ;
 D HDR("I208",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AMERADM(D0))
 D WRITE(D0,DFN,.CNT)
 Q
HDR(X,I) ;
 ;----- WRITE HEADER
 ;
 W !!,I,"  ",$T(@(X)+1),!
 Q
WRITE(D0,X,CNT) ;
 ;----- WRITE FINDINGS
 ;
 W !?5,D0,?15,X
 S CNT=$G(CNT)+1
 Q
QUE(DFN) ;
 ;
 N %ZIS,POP,ZTDESC,ZTIO,ZTRTN,ZTSAVE
 ;
 S ZTSAVE("DFN")=""
 S ZTRTN="DQ^AZAXDPM1"
 S ZTDESC="FIND 'IHS' PATIENT FILE POINTERS"
 ;
 S %ZIS="Q"
 D ^%ZIS
 Q:POP
 I $D(IO("Q")) D  Q
 . K IO("Q")
 . S ZTIO=ION_";"_IOST_";"_IOM_";"_IOSL
 . D ^%ZTLOAD
 . W !,"Task #",$G(ZTSK)," queued"
 D @ZTRTN
 Q
