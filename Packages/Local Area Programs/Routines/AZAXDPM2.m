AZAXDPM2 ;IHS/PHXAO/AEF - FIND VA PATIENT FILE POINTERS FOR PATIENT MERGE PROCESS
 ;;1.0;ANNE'S SPECIAL ROUTINES;;AUG 23, 2004
 ;;
 ;;THIS ROUTINE SEARCHES EACH POINTER TO THE VA PATIENT FILE FOR THE
 ;;SPECIFIED POINTER VALUE
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
 D QUE(DFN)
 ;
 Q
SEL(DFN) ;
 ;----- SELECT DFN TO SEARCH FOR
 ;
 N DIR,X
 S DIR(0)="N"
 S DIR("A")="Select DFN to search for"
 D ^DIR
 Q +Y
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
 W !,"FINDING 'VA PATIENT' FILE POINTERS FOR PATIENT ",$P($G(^DPT(DFN,0)),U),"    DFN #",DFN,!
 S CNT=0
 F I=1:1:60 D
 . S ROU="V"_I_"("_DFN_","_I_","_".CNT"_")"
 . D @ROU
 ;
 W !!,CNT," POINTERS FOUND",!
 Q
V1(DFN,I,CNT) ;
 ;----- MERGED TO PATIENT field (#.082) of the VA PATIENT File (#2)
 ;
 D HDR("V1",I)
 W !?5,"<NOT APPLICABLE>"
 Q
V2(DFN,I,CNT) ;
 ;----- COLLATERAL SPONSOR'S NAME field (#.3601) of the VA PATIENT File (#2)
 ;
 D HDR("V2",I)
 S D0=0
 F  S D0=$O(^DPT(D0)) Q:'D0  D
 . Q:$P($G(^DPT(D0,.36)),U,11)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V3(DFN,I,CNT) ;
 ;----- RECORD1 field (#.01) of the DUPLICATE RECORD File (#15)
 ;
 D HDR("V3",I)
 W !?5,"<NOT APPLICABLE>"
 Q
V4(DFN,I,CNT) ;
 ;----- RECORD2 field (#.02) of the DUPLICATE RECORD File (#15)
 ;
 D HDR("V4",I)
 W !?5,"<NOT APPLICABLE>"
 Q
V5(DFN,I,CNT) ;
 ;----- MFI PATIENT field (#999999903) of the DUPLICATE RECORD File (#15)
 ;
 D HDR("V5",I)
 W !?5,"<NOT APPLICABLE>"
 Q
V6(DFN,I,CNT) ;
 ;----- MERGED FROM field (#.01) of the MERGE IMAGES File (#15.4)
 ;
 D HDR("V6",I)
 W !?5,"<NOT APPLICABLE>"
 Q
V7(DFN,I,CNT) ;
 ;----- MERGED TO field (#.02) of the MERGE IMAGES File (#15.4)
 ;
 D HDR("V7",I)
 W !?5,"<NOT APPLICABLE>"
 Q
V8(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the SCHEDULED ADMISSION File (#41.1)
 ;
 D HDR("V8",I)
 S D0=0
 F  S D0=$O(^DGS(41.1,D0)) Q:'D0  D
 . Q:$P($G(^DGS(41.1,D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V9(DFN,I,CNT) ;
 ;----- *SCHEDULED ADMISSION PATIENT field (#.01) of the *SCHEDULED ADMISSION PATIENT sub-field (#42.182) of the WARD LOCATION File (#42)
 ;
 D HDR("V9",I)
 S D0=0
 F  S D0=$O(^DIC(42,D0)) Q:'D0  D
 . S D1=DFN   ;DINUMED
 . Q:'$D(^DIC(42,D0,"RSV",D1))
 . W !?5,D0,?15,D1,?25,DFN
 . S CNT=$G(CNT)+1
 Q
V10(DFN,I,CNT) ;
 ;----- PATIENT field (#.05) of the G&L CORRECTIONS File (#43.5)
 ;
 D HDR("V10",I)
 S D0=0
 F  S D0=$O(^DGS(43.5,D0)) Q:'D0  D
 . Q:$P($G(^DGS(43.5,D0,0)),U,5)'=DFN
 . W !?5,D0,"   ",DFN
 . S CNT=$G(CNT)+1
 Q
V11(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the PATIENT sub-field (#44.003) of the APPOINTMENT sub-field (#44.001) of the HOSPITAL LOCATION File (#44)
 ;
 D HDR("V11",I)
 S D0=0
 F  S D0=$O(^SC(D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^SC(D0,"S",D1)) Q:'D1  D
 . . S D2=0
 . . F  S D2=$O(^SC(D0,"S",D1,1,D2)) Q:'D2  D
 . . . Q:$P($G(^SC(D0,"S",D1,1,D2,0)),U)'=DFN
 . . . W !?5,D0,?15,D1,?25,D2,?35,DFN
 . . . S CNT=$G(CNT)+1
 Q
V12(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the PATIENT sub-field (#44.007) of the CHART CHECK sub-field (#44.006) of the HOSPITAL LOCATION File (#44)
 ;
 D HDR("V12",I)
 S D0=0
 F  S D0=$O(^SC(D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^SC(D0,"C",D1)) Q:'D1  D
 . . S D2=0
 . . F  S D2=$O(^SC(D0,"C",D1,1,D2)) Q:'D2  D
 . . . Q:$P($G(^SC(D0,"C",D1,1,D2,0)),U)'=DFN
 . . . W !?5,D0,?15,D1,?25,D2,?35,DFN
 . . . S CNT=$G(CNT)+1
 Q
V13(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the CENSUS WORKFILE File (#45.85)
 ;
 D HDR("V13",I)
 S D0=0
 F  S D0=$O(^DG(45.85,D0)) Q:'D0  D
 . Q:$P($G(^DG(45.85,D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V14(DFN,I,CNT) ;
 ;----- PATIENT field (#7) of the DUE ANSWER SHEET File (#50.0731)
 ;
 D HDR("V14",I)
 S D0=0
 F  S D0=$O(^PS(50.0731,D0)) Q:'D0  D
 . Q:$P($G(^PS(50.0731,D0,0)),U,8)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V15(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the PATIENT sub-field (#50.801) of the IV STATS File (#50.8)
 ;
 D HDR("V15",I)
 S D0=0
 F  S D0=$O(^PS(50.8,D0))  Q:'D0  D
 . S D1=0
 . F  S D1=$O(^PS(50.8,D0,1,D1)) Q:'D1  D
 . . Q:$P($G(^PS(50.8,D0,1,D1,0)),U)'=DFN
 . . W !?5,D0,?15,D1,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
V16(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the PATIENT sub-field (#50.806) of the IV DRUG sub-field (#50.805) of the DATE sub-field (#50.803) of the IV STATS File (#50.8)
 ;
 D HDR("V16",I)
 S D0=0
 F  S D0=$O(^PS(50.8,D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^PS(50.8,D0,2,D1)) Q:'D1  D
 . . S D2=0
 . . F  S D2=$O(^PS(50.8,D0,2,D1,2,D2)) Q:'D2  D
 . . . S D3=DFN   ;DINUMED
 . . . Q:'$D(^PS(50.8,D0,2,D1,2,D2,1,D3))
 . . . W !?5,D0,?15,D1,?25,D2,?35,D3,?45,DFN
 . . . S CNT=$G(CNT)+1
 Q
V17(DFN,I,CNT) ;
 ;----- PATIENT field (#2) of the PRESCRIPTION File (#52)
 ;
 D HDR("V17",I)
 S D0=0
 F  S D0=$O(^PSRX(D0)) Q:'D0  D
 . Q:$P($G(^PSRX(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V18(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the PATIENT NOTIFICATION (Rx READY) File (#52.11)
 ;
 D HDR("V18",I)
 S D0=0
 F  S D0=$O(^PS(52.11,D0)) Q:'D0  D
 . Q:$P($G(^PS(52.11,D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V19(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#1) of the RX VERIFY File (#52.4)
 ;
 D HDR("V19",I)
 S D0=0
 F  S D0=$O(^PS(52.4,D0)) Q:'D0  D
 . Q:$P($G(^PS(52.4,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V20(DFN,I,CNT) ;
 ;----- PATIENT field (#1) of the *REFILL WITH NON VERIFIED NEWS File (#52.41)
 ;
 D HDR("V20",I)
 S D0=0
 F  S D0=$O(^PS(52.41,D0)) Q:'D0  D
 . Q:$P($G(^PS(52.41,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V21(DFN,I,CNT) ;
 ;----- PATIENT field (#.03) of the RX SUSPENSE File (#52.5)
 ;
 D HDR("V21",I)
 S D0=0
 F  S D0=$O(^PS(52.5,D0)) Q:'D0  D
 . Q:$P($G(^PS(52.5,D0,0)),U,3)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V22(DFN,I,CNT) ;
 ;----- PATIENT # field (#1) of the PHARMACY ARCHIVE File (#52.8)
 ;
 D HDR("V22",I)
 S D0=0
 F  S D0=$O(^PSOARC(D0)) Q:'D0  D
 . Q:$P($G(^PSOARC(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V23(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the LABEL/PROFILE sub-field (#52.9001) of the PHARMACY PRINTED QUEUE File (#52.9)
 ;
 D HDR("V23",I)
 S D0=0
 F  S D0=$O(^PS(52.9,D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^PS(52.9,D0,1,D1)) Q:'D1  D
 . . Q:$P($G(^PS(52.9,D0,1,D1,0)),U)'=DFN
 . . W !?5,D0,?15,D1,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
V24(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.5) of the NON-VERIFIED ORDERS File (#53.1)
 ;
 D HDR("V24",I)
 S D0=0
 F  S D0=$O(^PS(53.1,D0)) Q:'D0  D
 . Q:$P($G(^PS(53.1,D0,0)),U,15)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V25(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the PATIENT sub-field (#53.401) of the PRE-EXCHANGE NEEDS File (#53.4)
 ;
 D HDR("V25",I)
 S D0=0
 F  S D0=$O(^PS(53.4,D0)) Q:'D0  D
 . S D1=DFN   ;DINUMED
 . Q:'$D(^PS(53.4,D0,1,D1))
 . W !?5,D0,?15,D1,?25,DFN
 . S CNT=$G(CNT)+1
 Q
V26(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the PATIENT sub-field (#53.4102) of the USER OR WARD sub-field (#53.4101) of the UNIT DOSE LABELS File (#53.41)
 ;
 D HDR("V26",I)
 S D0=0
 F  S D0=$O(^PS(53.41,D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^PS(53.41,D0,1,D1)) Q:'D1  D
 . . S D2=DFN   ;DINUMED
 . . Q:'$D(^PS(53.41,D0,1,D1,1,D2))
 . . W !?5,D0,?15,D1,?25,D2,?35,DFN
 . . S CNT=$G(CNT)+1
 Q
V27(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the PATIENT sub-field (#53.43011) of the REPORT NUMBER sub-field (#53.4301) of the MISCELLANEOUS REPORT FILE File (#53.43)
 ;
 D HDR("V27",I)
 S D0=0
 F  S D0=$O(^PS(53.43,D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^PS(53.43,D0,1,D1)) Q:'D1  D
 . . S D2=DFN   ;DINUMED
 . . Q:'$D(^PS(53.43,D0,1,D1,1,D2))
 . . W !?5,D0,?15,D1,?25,D2,?35,DFN
 . . S CNT=$G(CNT)+1
 Q
V28(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the PATIENT sub-field (#53.4401) of the PHYSICIANS' ORDERS File (#53.44)
 ;
 D HDR("V28",I)
 S D0=0
 F  S D0=$O(^PS(53.44,D0)) Q:'D0  D
 . S D1=DFN   ;DINUMED
 . Q:'$D(^PS(53.44,D0,1,D1))
 . W !?5,D0,?15,D1,?25,DFN
 . S CNT=$G(CNT)+1
 Q
V29(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the PHARMACY PATIENT File (#55)
 ;
 D HDR("V29",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^PS(55,D0))
 D WRITE(D0,DFN,.CNT)
 Q
V30(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.5) of the UNIT DOSE sub-field (#55.06) of the PHARMACY PATIENT File (#55)
 ;
 D HDR("V30",I)
 S D0=0
 F  S D0=$O(^PS(55,D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^PS(55,D0,5,D1)) Q:'D1  D
 . . Q:$P($G(^PS(55,D0,5,D1,0)),U,15)'=DFN
 . . W !?5,D0,?15,D1,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
V31(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#2) of the WKLD LOG FILE File (#64.03)
 ;
 D HDR("V31",I)
 S D0=0
 F  S D0=$O(^LRO(64.03,D0)) Q:'D0  D
 . S X=$P($G(^LRO(64.03,D0,0)),U,3)   ;VARIABLE POINTER
 . Q:+X'=DFN
 . Q:$P(X,";",2)'="DPT("
 . D WRITE(D0,DFN,.CNT)
 Q
V32(DFN,I,CNT) ;
 ;----- PATIENT field (#9) of the ACCESSION WKLD CODE TIME sub-field (#64.1111) of the WKLD CODE sub-field (#64.111) of the DATE sub-field (#64.11) of the WKLD DATA File (#64.1)
 ;
 D HDR("V32",I)
 S D0=0
 F  S D0=$O(^LRO(64.1,D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^LRO(64.1,D0,1,D1)) Q:'D1  D
 . . S D2=0
 . . F  S D2=$O(^LRO(64.1,D0,1,D1,1,D2)) Q:'D2  D
 . . . S D3=0
 . . . F  S D3=$O(^LRO(64.1,D0,1,D1,1,D2,1,D3)) Q:'D3  D
 . . . . S X=$P($G(^LRO(64.1,D0,1,D1,1,D2,1,D3,0)),U,10)   ;VARIABLE POINTER
 . . . . Q:+X'=DFN
 . . . . Q:$P(X,";",2)'="DPT("
 . . . . W !?5,D0,?15,D1,?25,D2,?35,D3,?45,DFN
 . . . . S CNT=$G(CNT)+1
 Q
V33(DFN,I,CNT) ;
 ;----- VA PATIENT NUMBER field (#.07) of the DATE/TIME UNIT RELOCATION sub-field (#65.03) of the BLOOD INVENTORY File (#65)
 ;
 D HDR("V33",I)
 S D0=0
 F  S D0=$O(^LRD(65,D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^LRD(65,D0,3,D1)) Q:'D1  D
 . . Q:$P($G(^LRD(65,D0,3,D1,0)),U,7)'=DFN
 . . W !?5,D0,?15,D1,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
V34(DFN,I,CNT) ;
 ;----- PATIENT FILE REF field (#2) of the REFERRAL PATIENT File (#67)
 ;
 D HDR("V34",I)
 S D0=0
 F  S D0=$O(^LRT(67,D0)) Q:'D0  D
 . Q:$P($G(^LRT(67,D0,"DPT")),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V35(DFN,I,CNT) ;
 ;----- Patient Name field (#3) of the REFERRAL PATIENT File (#67)
 ;
 D HDR("V35",I)
 S D0=0
 F  S D0=$O(^LRT(67,D0)) Q:'D0  D
 . S X=$P($G(^LRT(67,D0,3)),U)   ;VARIABLE POINTER
 . Q:+X'=DFN
 . Q:$P(X,";",2)'="DPT("
 . D WRITE(D0,DFN,.CNT)
 Q
V36(DFN,I,CNT) ;
 ;----- VA PATIENT NUMBER field (#.06) of the LRDFN sub-field (#69.3) of the USER REQUEST LIST sub-field (#69.28) of the LAB SECTION PRINT File (#69.2)
 ;
 D HDR("V36",I)
 S D0=0
 F  S D0=$O(^LRO(69.2,D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^LRO(69.2,D0,7,D1)) Q:'D1  D
 . . S D2=0
 . . F  S D2=$O(^LRO(69.2,D0,7,D1,1,D2)) Q:'D2  D
 . . . Q:$P($G(^LRO(69.2,D0,7,D1,1,D2,0)),U,6)'=DFN
 . . . W !?5,D0,?15,D1,?25,D2,?35,DFN
 . . . S CNT=$G(CNT)+1
 Q
V37(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the RADIOLOGY PATIENT File (#70)
 ;
 D HDR("V37",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^RADPT(D0))
 D WRITE(D0,DFN,.CNT)
 Q
V38(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#2) of the RADIOLOGY REPORTS File (#74)
 ;
 D HDR("V38",I)
 S D0=0
 F  S D0=$O(^RARPT(D0)) Q:'D0  D
 . Q:$P($G(^RARPT(D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V39(DFN,I,CNT) ;
 ;----- *PATIENT field (#9) of the REPORT DISTRIBUTION File (#74.4)
 ;
 D HDR("V39",I)
 S D0=0
 F  S D0=$O(^RABTCH(74.4,D0)) Q:'D0  D
 . Q:$P($G(^RABTCH(74.4,D0,0)),U,9)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V40(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the RADIOLOGY ORDERS File (#75.1)
 ;
 D HDR("V40",I)
 S D0=0
 F  S D0=$O(^RAO(75.1,D0)) Q:'D0  D
 . Q:$P($G(^RAO(75.1,D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V41(DFN,I,CNT) ;
 ;----- OBJECT OF ORDER field (#.02) of the ORDER File (#100)
 ;
 D HDR("V41",I)
 S D0=0
 F  S D0=$O(^OR(100,D0)) Q:'D0  D
 . S X=$P($G(^OR(100,D0,0)),U,2)   ;VARIABLE POINTER
 . Q:+X'=DFN
 . Q:$P(X,";",2)'="DPT("
 . D WRITE(D0,DFN,.CNT)
 Q
V42(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the OE/RR PATIENT File (#100.2)
 ;
 D HDR("V42",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^OR(100.2,D0))
 D WRITE(D0,DFN,.CNT)
 Q
V43(DFN,I,CNT) ;
 ;----- MEMBER field (#.01) of the MEMBER sub-field (#100.2101) of the OE/RR LIST File (#100.21)
 ;
 D HDR("V43",I)
 S D0=0
 F  S D0=$O(^OR(100.21,D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^OR(100.21,D0,10,D1)) Q:'D1  D
 . . S X=$P($G(^OR(100.21,D0,10,D1,0)),U)   ;VARIABLE POINTER
 . . Q:+X'=DFN
 . . Q:$P(X,";",2)'="DPT("
 . . W !?5,D0,?15,D1,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
V44(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the PATIENT ALLERGIES File (#120.8)
 ;
 D HDR("V44",I)
 S D0=0
 F  S D0=$O(^GMR(120.8,D0)) Q:'D0  D
 . Q:$P($G(^GMR(120.8,D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V45(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the ADVERSE REACTION REPORTING File (#120.85)
 ;
 D HDR("V45",I)
 S D0=0
 F  S D0=$O(^GMR(120.85,D0)) Q:'D0  D
 . Q:$P($G(^GMR(120.85,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V46(DFN,I,CNT) ;
 ;----- PATIENT field (#.03) of the PATIENT MOVEMENT File (#405)
 ;
 D HDR("V46",I)
 S D0=0
 F  S D0=$O(^DGPM(D0)) Q:'D0  D
 . Q:$P($G(^DGPM(D0,0)),U,3)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V47(DFN,I,CNT) ;
 ;----- PATIENT field (#2) of the SCHEDULING VISITS File (#409.5)
 ;
 D HDR("V47",I)
 S D0=0
 F  S D0=$O(^SDV(D0)) Q:'D0  D
 . Q:$P($G(^SDV(D0,0)),U,2)='DFN
 . W !?5,D0,"   ",DFN
 . S CNT=$G(CNT)+1
 Q
V48(DFN,I,CNT) ;
 ;----- PATIENT field (#8) of the INTERFACE CRITERIA File (#4001.1)
 ;
 D HDR("V48",I)
 S D0=0
 F  S D0=$O(^DIZ(4001.1,D0)) Q:'D0  D
 . Q:$P($G(^DIZ(4001.1,D0,8)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V49(DFN,I,CNT) ;
 ;----- PATIENT field (#.04) of the ALERT TRACKING File (#8992.1)
 ;
 D HDR("V49",I)
 S D0=0
 F  S D0=$O(^XTV(8992.1,D0)) Q:'D0  D
 . Q:$P($G(^XTV(8992.1,D0,0)),U,4)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V50(DFN,I,CNT) ;
 ;----- PATIENT field (#1.1) of the VEN QUEUE File (#19707.2)
 ;
 D HDR("V50",I)
 S D0=0
 F  S D0=$O(^VEN(7.2,D0)) Q:'D0  D
 . Q:$P($G(^VEN(7.2,D0,1)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V51(DFN,I,CNT) ;
 ;----- DEMO PATIENT field (#.14) of the VEN EHP CONFIGURATION File (#19707.5)
 ;
 D HDR("V51",I)
 S D0=0
 F  S D0=$O(^VEN(7.5,D0)) Q:'D0  D
 . Q:$P($G(^VEN(7.5,D0,0)),U,14)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V52(DFN,I,CNT) ;
 ;----- PATIENT field (#.07) of the VEN EHP ERROR LOG File (#19707.7)
 ;
 D HDR("V52",I)
 S D0=0
 F  S D0=$O(^VEN(7.7,D0)) Q:'D0  D
 . Q:$P($G(^VEN(7.7,D0,0)),U,7)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V53(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the AZA MEDICAID MASTER LIST File (#1180007)
 ;
 D HDR("V53",I)
 S D0=0
 F  S D0=$O(^AZAMASTR(D0)) Q:'D0  D
 . Q:$P($G(^AZAMASTR(D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V54(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the APC DATA File (#1800018)
 ;
 D HDR("V54",I)
 S D0=0
 F  S D0=$O(^AAPCRCDS(D0)) Q:'D0  D
 . Q:$P($G(^AAPCRCDS(D0,0)),U)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V55(DFN,I,CNT) ;
 ;----- NAME field (#.01) of the PATIENT File (#9000001)
 ;
 D HDR("V55",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AUPNPAT(D0))
 D WRITE(D0,DFN,.CNT)
 Q
V56(DFN,I,CNT) ;
 ;----- PATIENT field (#.01) of the PODIATRY HISTORY File (#9000028)     
 ;
 D HDR("V56",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^AUPNPOD(D0))
 D WRITE(D0,DFN,.CNT)
 Q
V57(DFN,I,CNT) ;
 ;----- PATIENT NAME field (#.01) of the ABSP COMBINED INSURANCE File (#9002313.1)
 ;
 D HDR("V57",I)
 S D0=DFN   ;DINUMED
 Q:'$D(^ABSPCOMB(D0))
 D WRITE(D0,DFN,.CNT)
 Q
V58(DFN,I,CNT) ;
 ;----- PATIENT field (#1.04) of the LINE ITEMS sub-field (#9002313.512) of the ABSP DATA INPUT File (#9002313.51)
 ;
 D HDR("V58",I)
 S D0=0
 F  S D0=$O(^ABSP(9002313.51,D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^ABSP(9002313.51,D0,2,D1)) Q:'D1  D
 . . Q:$P($G(^ABSP(9002313.51,D0,2,D1,1)),U,4)'=DFN
 . . W !?5,D0,?15,D1,?25,DFN
 . . S CNT=$G(CNT)+1
 Q
V59(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the APSP INTERVENTION File (#9009032.4)
 ;
 D HDR("V59",I)
 S D0=0
 F  S D0=$O(^APSPQA(32.4,D0)) Q:'D0  D
 . Q:$P($G(^APSPQA(32.4,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
 Q
V60(DFN,I,CNT) ;
 ;----- PATIENT field (#.02) of the APSP PRIMARY CARE VISIT File (#9009032.6)
 ;
 D HDR("V60",I)
 S D0=0
 F  S D0=$O(^APSPQA(32.6,D0)) Q:'D0  D
 . Q:$P($G(^APSPQA(32.6,D0,0)),U,2)'=DFN
 . D WRITE(D0,DFN,.CNT)
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
 S ZTRTN="DQ^AZAXDPM2"
 S ZTDESC="FIND VA PATIENT FILE POINTERS"
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
