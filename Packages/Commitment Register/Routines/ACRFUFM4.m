ACRFUFM4 ;IHS/OIT/FJE - UFMS VENDOR FILE SUMMARY 3 ; [ 12/26/2006  10:56 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**22**;NOV 5, 2001
 ;
 ;    New routine ACR*2.1*22
 Q
PRINTSUM ;EP - PRINT VENDORS MISSING DATA
 ;SELECT DEVICE TO PRINT REPORT
 ;
 ;D HEADER
 ;D VM^ACRFMENU
 ;S DIR(0)="S^N:DUPLICATE NAMES;D:DUPLICATE DUN"
 ;S DIR=DIR(0)_"A:DUPLICATE ADDRESS LINE 1;"
 ;S DIR(0)=DIR(0)_"R:DUPLICATE REMIT ADDRESS LINE 1;"
 ;S DIR(0)=DIR(0)_"T:DUPLICATE EIN;E:DUPLICATE EIN+SUFFUX;"
 ;S DIR(0)=DIR(0)_"C:DUPLICATE BANK ROUTING #;B:DUPLICATE BANK ACCOUNT;"
 S DIR(0)="S^N:DUPLICATE NAMES;"
 S DIR(0)=DIR(0)_"D:DUPLICATE DUNS;"
 S DIR(0)=DIR(0)_"A:DUPLICATE ADDRESS LINE 1;"
 S DIR(0)=DIR(0)_"R:DUPLICATE REMIT ADDRESS LINE 1;"
 S DIR(0)=DIR(0)_"T:DUPLICATE EIN;"
 S DIR(0)=DIR(0)_"E:DUPLICATE EIN+SUFFIX;"
 S DIR(0)=DIR(0)_"B:DUPLICATE BANK ACCOUNTS;"
 S DIR(0)=DIR(0)_"S:SUMMARY OF DUPLICATES;"
 S DIR(0)=DIR(0)_"H:HELP"
 S DIR("A")="UFMS DUPLICATE VENDOR INFORMATION REPORT"
 S DIR("B")="S"
 KILL DA,ACROUT,ACRQUIT
 D DIR^ACRFDIC
 Q:$D(ACRQUIT)
 ;Q:'"NDARTEBC"[Y
 Q:'"NDARTEBSH"[Y
 S ACRFVY=Y
 S (ZTRTN,ACRRTN)="SUM^ACRFUFM4"
 S ZTDESC="VENDORS SUMMARY DIAGNOSIS"
 K ACRHFS,ACRDIR,ACRFILE
 S ACR("HFS")=""
 D ^ACRFZIS
 K ACR("HFS")
 I $D(ACRHFS) D
 .S ACRDIR=ZISH1
 .S ACRFILE=ZISH2
 .D SUM
 .D PROCHFS^ACRFVLK2
 Q
SUM ;EP - GATHER ACTIVE VENDORS MISSING DATA
 K ACRFV0,ACRFV11,ACRFV13,ACRFV19,ACRFVREC,ACROUT,ACRFVNAM
 S X="VENDORS UFMS READINESS SUMMARY REPORT"
 D EN^ACRFUFM2("")
 I $D(ACRHFS)&($D(%FILE)) D
 .U %FILE
 .W X,!
 E  W !!?80-$L(X)/2,X
 S Y=DT X ^DD("DD")
 I $D(ACRHFS)&($D(%FILE)) D
 .U %FILE
 .W Y,!
 E  W !?80-$L(X)/2,Y
 I "N"[ACRFVY D HEAD1
 I "D"[ACRFVY D HEAD2
 I "A"[ACRFVY D HEAD3
 I "R"[ACRFVY D HEAD4
 I "T"[ACRFVY D HEAD5
 I "E"[ACRFVY D HEAD6
 ;I "C"[ACRFVY D HEAD7
 I "B"[ACRFVY D HEAD8
 I "H"[ACRFVY D HEAD9
 I "S"[ACRFVY D HEAD10
 S (ACRFVREC,ACRFVXCT,ACRFVXT,ACRFVXN,ACRFVXD,ACRFVXA1)=0
 S (ACRFVXR1,ACRFVXE1,ACRFVXE2)=0
 S (ACRFVXB1,ACRFVXB2)=0
 F  S ACRFVREC=$O(^TMP("ACRAVEN",$J,ACRFVREC)) Q:'ACRFVREC!($D(ACROUT))  D
 .S ACRFV0=$G(^AUTTVNDR(ACRFVREC,0))
 .Q:$G(ACRFV0)=""
 .S ACRFV11=$G(^AUTTVNDR(ACRFVREC,11))
 .S ACRFV13=$G(^AUTTVNDR(ACRFVREC,13))
 .S ACRFV14=$G(^AUTTVNDR(ACRFVREC,14))
 .S ACRFV19=$G(^AUTTVNDR(ACRFVREC,19))       ;BANKING INFO
 .S ACRFVNAM=$P(ACRFV0,U)
 .S ACRFVXT=ACRFVXT+1  ;TO GET TOTAL IN VENDOR FILE
 .I $P(ACRFV0,U,5)="" D
 ..S ACRFVXCT=ACRFVXCT+1
 ..;IF VENDOR HAS DUP NAME
 ..S ACRFVX=$P(ACRFV0,U,1) D
 ...Q:ACRFVX=""
 ...I $D(^TMP("ACR",$J,"NAM",ACRFVX)) D
 ....S ACRFVXN=ACRFVXN+1
 ....S ^TMP("ACR",$J,"NAMD",ACRFVREC)=ACRFVREC_U_ACRFVX
 ....S ACRFVX1=$P(^TMP("ACR",$J,"NAM",ACRFVX),U,1)
 ....S ACRFVX2=$P(^TMP("ACR",$J,"NAM",ACRFVX),U,2)
 ....S ACRFVX3=$P(^TMP("ACR",$J,"NAM",ACRFVX),U,3)
 ....S ^TMP("ACR",$J,"NAMD",ACRFVX1)=ACRFVX2_U_ACRFVX3
 ...S ^TMP("ACR",$J,"NAM",ACRFVX)=ACRFVREC_U_ACRFVREC_U_ACRFVX
 ..;IF VENDOR HAS DUP DUNS
 ..S ACRFVX=$P(ACRFV0,U,7) D
 ...Q:ACRFVX=""
 ...I $D(^TMP("ACR",$J,"DUNS",ACRFVX)) D
 ....S ACRFVXD=ACRFVXD+1
 ....S ^TMP("ACR",$J,"DUND",ACRFVREC)=ACRFVNAM_U_ACRFVX
 ....S ACRFVX1=$P(^TMP("ACR",$J,"DUNS",ACRFVX),U,1)
 ....S ACRFVX2=$P(^TMP("ACR",$J,"DUNS",ACRFVX),U,2)
 ....S ACRFVX3=$P(^TMP("ACR",$J,"DUNS",ACRFVX),U,3)
 ....S ^TMP("ACR",$J,"DUND",ACRFVX1)=ACRFVX2_U_ACRFVX3
 ...S ^TMP("ACR",$J,"DUNS",ACRFVX)=ACRFVREC_U_ACRFVNAM_U_ACRFVX
 ..;IF VENDOR HAS DUP ADDRESS LINE 1
 ..S ACRFVX=$P(ACRFV13,U,1) D
 ...Q:ACRFVX=""
 ...I $D(^TMP("ACR",$J,"AD1",ACRFVX)) D
 ....S ACRFVXA1=ACRFVXA1+1
 ....S ^TMP("ACR",$J,"AD1D",ACRFVREC)=ACRFVNAM_U_ACRFVX
 ....S ACRFVX1=$P(^TMP("ACR",$J,"AD1",ACRFVX),U,1)
 ....S ACRFVX2=$P(^TMP("ACR",$J,"AD1",ACRFVX),U,2)
 ....S ACRFVX3=$P(^TMP("ACR",$J,"AD1",ACRFVX),U,3)
 ....S ^TMP("ACR",$J,"AD1D",ACRFVX1)=ACRFVX2_U_ACRFVX3
 ...S ^TMP("ACR",$J,"AD1",ACRFVX)=ACRFVREC_U_ACRFVNAM_U_ACRFVX
 ..;IF VENDOR HAS DUP REMIT ADDRESS LINE 1
 ..S ACRFVX=$P(ACRFV14,U,1) D
 ...Q:ACRFVX=""
 ...I $D(^TMP("ACR",$J,"RAD1",ACRFVX)) D
 ....S ACRFVXR1=ACRFVXR1+1
 ....S ^TMP("ACR",$J,"RAD1D",ACRFVREC)=ACRFVNAM_U_ACRFVX
 ....S ACRFVX1=$P(^TMP("ACR",$J,"RAD1",ACRFVX),U,1)
 ....S ACRFVX2=$P(^TMP("ACR",$J,"RAD1",ACRFVX),U,2)
 ....S ACRFVX3=$P(^TMP("ACR",$J,"RAD1",ACRFVX),U,3)
 ....S ^TMP("ACR",$J,"RAD1D",ACRFVX1)=ACRFVX2_U_ACRFVX3
 ...S ^TMP("ACR",$J,"RAD1",ACRFVX)=ACRFVREC_U_ACRFVNAM_U_ACRFVX
 ..;IF VENDOR IS ACTIVE & EIN IS DUPLICATE
 ..S ACRFVX=$P(ACRFV11,U,1) D
 ...Q:ACRFVX=""
 ...I $D(^TMP("ACR",$J,"TIN",ACRFVX)) D
 ....S ACRFVXE1=ACRFVXE1+1
 ....S ^TMP("ACR",$J,"TIND",ACRFVREC)=ACRFVNAM_U_ACRFVX
 ....S ACRFVX1=$P(^TMP("ACR",$J,"TIN",ACRFVX),U,1)
 ....S ACRFVX2=$P(^TMP("ACR",$J,"TIN",ACRFVX),U,2)
 ....S ACRFVX3=$P(^TMP("ACR",$J,"TIN",ACRFVX),U,3)
 ....S ^TMP("ACR",$J,"TIND",ACRFVX1)=ACRFVX2_U_ACRFVX3
 ...S ^TMP("ACR",$J,"TIN",ACRFVX)=ACRFVREC_U_ACRFVNAM_U_ACRFVX
 ..;IF VENDOR IS ACTIVE & EIN+SUFFIX IS DUPLICATE
 ..S ACRFVX=$P(ACRFV11,U,13) D
 ...Q:ACRFVX=""
 ...I $D(^TMP("ACR",$J,"EIN",ACRFVX)) D
 ....S ACRFVXE2=ACRFVXE2+1
 ....S ^TMP("ACR",$J,"EIND",ACRFVREC)=ACRFVNAM_U_ACRFVX
 ....S ACRFVX1=$P(^TMP("ACR",$J,"EIN",ACRFVX),U,1)
 ....S ACRFVX2=$P(^TMP("ACR",$J,"EIN",ACRFVX),U,2)
 ....S ACRFVX3=$P(^TMP("ACR",$J,"EIN",ACRFVX),U,3)
 ....S ^TMP("ACR",$J,"EIND",ACRFVX1)=ACRFVX2_U_ACRFVX3
 ...S ^TMP("ACR",$J,"EIN",ACRFVX)=ACRFVREC_U_ACRFVNAM_U_ACRFVX
 ..;IF VENDOR IS ACTIVE & BANK INFO IS DUPLICATE
 ..S ACRFVXR=$P(ACRFV19,U,2) D          ;ROUTING NUMBER
 ...Q:ACRFVXR=""
 ...S ACRFVXA=$P(ACRFV19,U,3)           ;ACCOUNT NUMBER
 ...S ACRFVX=ACRFVXR_"-"_ACRFVXA        ;COMBINE ROUTING AND ACCOUNT NUMBERS
 ...I $D(^TMP("ACR",$J,"BR1",ACRFVX)) D
 ....S ACRFVXB1=ACRFVXB1+1
 ....S ^TMP("ACR",$J,"BR1D",ACRFVREC)=ACRFVNAM_U_ACRFVX
 ....S ACRFVX1=$P(^TMP("ACR",$J,"BR1",ACRFVX),U,1)
 ....S ACRFVX2=$P(^TMP("ACR",$J,"BR1",ACRFVX),U,2)
 ....S ACRFVX3=$P(^TMP("ACR",$J,"BR1",ACRFVX),U,3)
 ....S ^TMP("ACR",$J,"BR1D",ACRFVX1)=ACRFVX2_U_ACRFVX3
 ...S ^TMP("ACR",$J,"BR1",ACRFVX)=ACRFVREC_U_ACRFVNAM_U_ACRFVX
 ..;S ACRFVX=$P(ACRFV19,U,3) D
 ..;.Q:ACRFVX=""
 ..;.I $D(^TMP("ACR",$J,"BR2",ACRFVX)) D
 ..;..S ACRFVXB2=ACRFVXB2+1
 ..;..S ^TMP("ACR",$J,"BR2D",ACRFVREC)=ACRFVNAM_U_ACRFVX
 ..;..S ACRFVX1=$P(^TMP("ACR",$J,"BR2",ACRFVX),U,1)
 ..;..S ACRFVX2=$P(^TMP("ACR",$J,"BR2",ACRFVX),U,2)
 ..;..S ACRFVX3=$P(^TMP("ACR",$J,"BR2",ACRFVX),U,3)
 ..;..S ^TMP("ACR",$J,"BR2D",ACRFVX1)=ACRFVX2_U_ACRFVX3
 ..;.S ^TMP("ACR",$J,"BR2",ACRFVX)=ACRFVREC_U_ACRFVNAM_U_ACRFVX
 ;
 S ACRFVC=""
 S ACRFVNAM=""
 S ACRFVREC=""
 I ACRFVY="N" S ACRFVC="NAMD"
 I ACRFVY="D" S ACRFVC="DUND"
 I ACRFVY="A" S ACRFVC="AD1D"
 I ACRFVY="R" S ACRFVC="RAD1D"
 I ACRFVY="T" S ACRFVC="TIND"
 I ACRFVY="E" S ACRFVC="EIND"
 I ACRFVY="B" S ACRFVC="BR1D"
 I ACRFVY="S" K ^TMP("ACR",$J) D BLDSUM Q
 I ACRFVY="H" K ^TMP("ACR",$J) D HELP Q
 S ACRFVREC=""
 F  S ACRFVREC=$O(^TMP("ACR",$J,ACRFVC,ACRFVREC)) Q:ACRFVREC=""!($D(ACROUT))  D
 .S ACRFVX1=$P(^TMP("ACR",$J,ACRFVC,ACRFVREC),U,1)
 .S ACRFVX2=$P(^TMP("ACR",$J,ACRFVC,ACRFVREC),U,2)
 .I ACRFVX1="" S ACRFVX1="UNK1"
 .I ACRFVX2="" S ACRFVX2="UNK2"
 .S ^TMP("ACR",$J,"SORT",ACRFVX2,ACRFVX1,ACRFVREC)=""
 S (ACRFVX1,ACRFVX2,ACRFVREC)=""
 F  S ACRFVX2=$O(^TMP("ACR",$J,"SORT",ACRFVX2)) Q:ACRFVX2=""!($D(ACROUT))  D
 .S ACRFVX1="" F  S ACRFVX1=$O(^TMP("ACR",$J,"SORT",ACRFVX2,ACRFVX1)) Q:ACRFVX1=""!($D(ACROUT))  D
 ..S ACRFVREC="" F  S ACRFVREC=$O(^TMP("ACR",$J,"SORT",ACRFVX2,ACRFVX1,ACRFVREC)) Q:ACRFVREC=""!($D(ACROUT))  D
 ...I $D(ACRHFS)&($D(%FILE)) D  Q
 ....U %FILE
 ....W !,ACRFVX2_U_ACRFVX1
 ...W !,ACRFVX2,?34,ACRFVX1
 ...I '$D(ACRHFS),$Y>(IOSL-4) D PAUSE^ACRFWARN W @IOF Q
 I '$D(ACRHFS) D PAUSE^ACRFWARN W @IOF
 K ^TMP("ACR",$J)
 Q
BLDSUM ;BUILDS SUMMARY TMP GLOBAL
 S ^TMP("ACR",$J,"1")="Active Vendors"_U_ACRFVXCT
 S ^TMP("ACR",$J,"2")="Duplicate Names"_U_ACRFVXN
 S ^TMP("ACR",$J,"3")="Duplicate DUNS"_U_ACRFVXD
 S ^TMP("ACR",$J,"4")="Duplicate Address Line 1"_U_ACRFVXA1
 S ^TMP("ACR",$J,"5")="Duplicate Remit Address Line 1"_U_ACRFVXR1
 S ^TMP("ACR",$J,"6")="Duplicate EIN"_U_ACRFVXE1
 S ^TMP("ACR",$J,"7")="Duplicate EIN_Suffix"_U_ACRFVXE2
 ;S ^TMP("ACR",$J,"8")="Duplicate Bank Routing"_U_ACRFVXB1
 ;S ^TMP("ACR",$J,"9")="Duplicate Bank Acct"_U_ACRFVXB2
 S ^TMP("ACR",$J,"8")="Duplicate Bank Accounts"_U_ACRFVXB1
 S ACRFVREC="" F  S ACRFVREC=$O(^TMP("ACR",$J,ACRFVREC)) Q:ACRFVREC=""!($D(ACROUT))  D
 .I $D(ACRHFS)&($D(%FILE)) D  Q
 ..U %FILE
 ..W !,^TMP("ACR",$J,ACRFVREC)
 .W !,$P(^TMP("ACR",$J,ACRFVREC),U,1),?34,$P(^TMP("ACR",$J,ACRFVREC),U,2)
 .I '$D(ACRHFS),$Y>(IOSL-4) D PAUSE^ACRFWARN W @IOF Q
 I '$D(ACRHFS) D PAUSE^ACRFWARN W @IOF
 K ^TMP("ACR",$J)
 Q
HEAD1 ;EP - HEADING1 if detailed
 I $D(ACRHFS)&($D(%FILE)) D  Q
 .U %FILE
 .W "DUPLICATE NAME"_U_"VENDOR IEN"
 W !,"DUPLICATE NAME",?34,"VENDOR IEN"
 W !,"-------------------------------------------------------------------------------"
 Q
HEAD2 ;EP - HEADING1 if detailed
 I $D(ACRHFS)&($D(%FILE)) D  Q
 .U %FILE
 .W "DUPLICATE DUNS"_U_"VENDOR IEN"
 W !,"DUPLICATE DUNS",?34,"VENDOR IEN"
 W !,"-------------------------------------------------------------------------------"
 Q
HEAD3 ;EP - HEADING1 if detailed
 I $D(ACRHFS)&($D(%FILE)) D  Q
 .U %FILE
 .W "DUPLICATE ADDRESS LINE 1"_U_"VENDOR IEN"
 W !,"DUPLICATE ADDRESS LINE 1",?34,"VENDOR IEN"
 W !,"-------------------------------------------------------------------------------"
 Q
HEAD4 ;EP - HEADING1 if detailed
 I $D(ACRHFS)&($D(%FILE)) D  Q
 .U %FILE
 .W "DUPLICATE REMIT ADDRESS LINE 1"_U_"VENDOR IEN"
 W !,"DUPLICATE REMIT ADDRESS LINE 1",?34,"VENDOR IEN"
 W !,"-------------------------------------------------------------------------------"
 Q
HEAD5 ;EP - HEADING1 if detailed
 I $D(ACRHFS)&($D(%FILE)) D  Q
 .U %FILE
 .W "DUPLICATE EIN"_U_"VENDOR IEN"
 W !,"DUPLICATE EIN",?34,"VENDOR IEN"
 W !,"-------------------------------------------------------------------------------"
 Q
HEAD6 ;EP - HEADING1 if detailed
 I $D(ACRHFS)&($D(%FILE)) D  Q
 .U %FILE
 .W "DUPLICATE EIN+SUFFIX"_U_"VENDOR IEN"
 W !,"DUPLICATE EIN+SUFFIX",?34,"VENDOR IEN"
 W !,"-------------------------------------------------------------------------------"
 Q
HEAD7 ;EP - HEADING1 if detailed
 I $D(ACRHFS)&($D(%FILE)) D  Q
 .U %FILE
 .W "DUPLICATE BANK ACCOUNTS"_U_"VENDOR IEN"
 W !,"DUPLICATE BANK ACCOUNTS",?34,"VENDOR IEN"
 W !,"-------------------------------------------------------------------------------"
 Q
HEAD8 ;EP - HEADING1 if detailed
 I $D(ACRHFS)&($D(%FILE)) D  Q
 .U %FILE
 .W "DUPLICATE BANK ACCOUNTS"_U_"VENDOR IEN"
 W !,"DUPLICATE BANK ACCOUNTS",?34,"VENDOR IEN"
 W !,"-------------------------------------------------------------------------------"
 Q
HEAD9 ;EP - HEADING3-if Help
 I $D(ACRHFS)&($D(%FILE)) D  Q
 .U %FILE
 .W "Vendor DUPLICATE Help"_U_""
 W !,"Vendor DUPLICATE Help",?34,""
 W !,"-------------------------------------------------------------------------------"
 Q
HEAD10 ;EP - HEADING1 if detailed
 I $D(ACRHFS)&($D(%FILE)) D  Q
 .U %FILE
 .W "DUPLICATE SUMMARY"_U_"TOTAL"
 W !,"DUPLICATE SUMMARY",?34,"TOTAL"
 W !,"-------------------------------------------------------------------------------"
 Q
HELP  ;EP HELP INFORMATION FOR SUMMARY REPORT
 S ^TMP("ACR",$J,"1")="The Code for each Vendor is grouped by dashes 0-0000-0000-0000-0000"
 S ^TMP("ACR",$J,"2")="DUNS, Address, Remit Address, TAX ID Info, Bank Info, Misc Info"
 S ^TMP("ACR",$J,"3")="If the Code is zero (0) the specific data appears to be good."
 S ^TMP("ACR",$J,"4")="If the Code is numeric then the program has found a problem with the data"
 S ^TMP("ACR",$J,"5")="First - number:DUNS 1=missing DUNS, 2=DUNS not 9 or 9+4 in length,"
 S ^TMP("ACR",$J,"6")="                   4=DUNS contains alpha characters, 6 both of the above"
 S ^TMP("ACR",$J,"7")="Second - Group:Address 1=address line 1 ,2=city, 3=state, 4=Zip code"
 S ^TMP("ACR",$J,"8")="  Address Line 1:  1=missing"
 S ^TMP("ACR",$J,"9")="  City:            1=missing"
 S ^TMP("ACR",$J,"10")="  State:           1=missing"
 S ^TMP("ACR",$J,"11")="  ZIP Code:        1=missing, 2=not 9 digits, 4=alpha char, 6=both"
 S ^TMP("ACR",$J,"12")="Third - Group:Remit Address 1=address line 1,2=city,3=state,4=Zip code"
 S ^TMP("ACR",$J,"13")="  Address Line 1:  1=missing"
 S ^TMP("ACR",$J,"14")="  City:            1=missing"
 S ^TMP("ACR",$J,"15")="  State:           1=missing"
 S ^TMP("ACR",$J,"16")="  ZIP Code:        1=missing, 2=not 9 digits, 4=alpha char, 6=both"
 S ^TMP("ACR",$J,"17")="Fourth - Group:Tax ID 1=EIN, 2=suffix, 3=proper EIN, 4=proper suffix"
 S ^TMP("ACR",$J,"18")="  EIN:             1=missing"
 S ^TMP("ACR",$J,"19")="  Suffix:          1=missing"
 S ^TMP("ACR",$J,"20")="  EIN Info:        1=not 10 digits, 2=first digit not 1 or 2, 4=contains alpha"
 S ^TMP("ACR",$J,"21")="  Suffix Info:     1=not 2 in length, 2=first not alpha, 4=second not numeric"
 S ^TMP("ACR",$J,"22")="Fifth - Group:Bank ID 1=Type, 2=Routing, 3=Account, 4=Routing CheckSum"
 S ^TMP("ACR",$J,"23")="  Type:            1=missing"
 S ^TMP("ACR",$J,"24")="  Routing:         1=missing"
 S ^TMP("ACR",$J,"25")="  Account:         1=missing"
 S ^TMP("ACR",$J,"26")="  CheckSum:        1=not valid, 2=not 9 digits, 4=contains alpha char"
 S ACRFVREC="" F  S ACRFVREC=$O(^TMP("ACR",$J,ACRFVREC)) Q:ACRFVREC=""!($D(ACROUT))  D
 .I $D(ACRHFS)&($D(%FILE)) D  Q
 ..U %FILE
 ..W !,^TMP("ACR",$J,ACRFVREC)
 .W !,$P(^TMP("ACR",$J,ACRFVREC),U,1),?34,$P(^TMP("ACR",$J,ACRFVREC),U,2)
 .I '$D(ACRHFS),$Y>(IOSL-4) D PAUSE^ACRFWARN W @IOF Q
 I '$D(ACRHFS) D PAUSE^ACRFWARN W @IOF
 K ^TMP("ACR",$J)
 Q
