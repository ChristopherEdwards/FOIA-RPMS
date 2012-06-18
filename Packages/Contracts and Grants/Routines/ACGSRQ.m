ACGSRQ ;IHS/OIRM/DSD/THL,AEF - CHECK CIS RECORD INTEGRITY; [ 03/27/2000   2:22 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
 ;;THIS ROUTINE AND ITS SEQUENTIAL ROUTINES CHECK CIS RECORD INTEGRITY
 ;;AS EACH CONTRACT ACTION IS ENTERED OR EDITED
EN D:'$D(ACGQUIT) EN1
EXIT F ACG=0:1:70 S X="ACG"_ACG K @X
 K ACGRD
 Q
EN1 K ^TMP("ACG",$J)
 S ACGRD=0
 F  S ACGRD=$O(^ACGS("C",ACGRD)) Q:'ACGRD  I $D(^ACGS(ACGRD,"IHS")),$P(^("IHS"),U,23)=1 S ACGRDA=0 F  S ACGRDA=$O(^ACGS("C",ACGRD,ACGRDA)) Q:'ACGRDA  D EN2
 Q
EN2 ;XEP;TO CHECK INTEGRITY OF CIS ENTRY
 D ^ACGSRQF1
 S:'$D(ACGRD)#2 ACGRD=$P(^ACGS(ACGRDA,0),U,3)
 S:ACG2="" ACG2=ACGRDA
 S ACG=""
 S:'$D(^TMP("ACG",$J,"T")) ^TMP("ACG",$J,"T")=0
1 I ACG1'?1U&("DIALSQRCMTUBOGN"'[ACG1) D T S ^TMP("ACG",$J,ACG2,1)="1++"_ACG1_"^W !?5,""Item 1 is required."""
 I "DIALS"[ACG1 F ACG=19:1:23,25,27,29:1:32,45,58,63 S X=@("ACG"_ACG) I X="" D T S ^TMP("ACG",$J,ACG2,1,ACG)=ACG_"++"_@("ACG"_ACG)_"^W !?5,""If Item 1 equals D, I, A, L, or S, Item "_ACG_" is required."""
 I "CMR"[ACG1 F ACG=19:1:20,23,58,63 S X=@("ACG"_ACG) I X="" D T S ^TMP("ACG",$J,ACG2,1,ACG)=ACG_"++"_@("ACG"_ACG)_"^W !?5,""If Item 1 equals C, M, or R, Item "_ACG_" is required."""
 I ACG1="Q" F ACG=19,21,23,25,27,58,63 S X=@("ACG"_ACG) I X="" D T S ^TMP("ACG",$J,ACG2,1,ACG)=ACG_"++"_@("ACG"_ACG)_"^W !?5,""If Item 1 equals Q, Item "_ACG_" is required."""
 I "BGNO"[ACG1 F ACG=22,23,25,27,56:1:58 S X=@("ACG"_ACG) I X="" D T S ^TMP("ACG",$J,ACG2,1,ACG)=ACG_"++"_@("ACG"_ACG)_"^W !?5,""If Item 1 equals B, G, N or O, Item "_ACG_" is required."""
 I ACG1="B" F ACG=19,20,23,25,30 S X=@("ACG"_ACG) I X="" D T S ^TMP("ACG",$J,ACG2,1,ACG)=ACG_"++"_@("ACG"_ACG)_"^W !?5,""If Item 1 equals B, Item "_ACG_" is required."""
 I ACG1="O" F ACG=23,27:1:27 S X=@("ACG"_ACG) I X="" D T S ^TMP("ACG",$J,ACG2,1,ACG)=ACG_"++"_@("ACG"_ACG)_"^W !?5,""If Item 1 equals O, Item "_ACG_" is required."""
 I "TU"[ACG1 F ACG=23,45,56,57,63 S X=@("ACG"_ACG) I X="" D T S ^TMP("ACG",$J,ACG2,1,ACG)=ACG_"++"_@("ACG"_ACG)_"^W !?5,""If Item 1 equals T or U, Item "_ACG_" is required."""
2 I "BGNO"[ACG1,$L(ACG2)<9!($L(ACG2)>14) D T S ^TMP("ACG",$J,ACG2,2)="2++"_ACG2_"^W !?5,""Item 2 is required and must be 9-14 characters in length."""
3 I "BGNO"[ACG1,$L(ACG3)<8!($L(ACG3)>14) D T S ^TMP("ACG",$J,ACG2,3)="1++"_ACG1_";3++"_ACG3_"^W !?5,""Item 3 is required and must be 8-14 characters in length."""
4 I "ADILSG"[ACG1,ACG4=""!(ACG4'?3N)!($S(ACG4'="":'$D(^ACGPO("C",ACG4)),1:1)) D
 .D T S ^TMP("ACG",$J,ACG2,4)="1++"_ACG1_";4++"_ACG4_"^W !?5,""Item 4 is required and must be numeric, 3 characters in length"",!?5,""and correspond to a valid Contracting Office number."""
5 I "ADILSBGQ"[ACG1,ACG5="" D T S ^TMP("ACG",$J,ACG2,5)="1++"_ACG1_";5++"_ACG5_"^W !?5,""Item 5 is required and must be no more than 40 characters in length."""
6 I "ADILSBGQ"[ACG1,ACG6=""!($L(ACG6)>30) D T S ^TMP("ACG",$J,ACG2,6)="1++"_ACG1_";6++"_ACG6_"^W !?5,""Item 6 is required and must be no more than 30 characters in length."""
7 I "ADILSBGQ"[ACG1,ACG7=""!($L(ACG7)>23) D T S ^TMP("ACG",$J,ACG2,7)="1++"_ACG1_";7++"_ACG7_"^W !?5,""Item 7 is required and must be no more than 23 characters in length."""
8 I "ADILSBGQ"[ACG1,ACG8=""!($L(ACG8)>19) D T S ^TMP("ACG",$J,ACG2,8)="1++"_ACG1_";8++"_ACG8_"^W !?5,""Item 8 is required and must be a valid state or country name, no more than 19 characters in length."""
9 I "ADILSBGQ"[ACG1,ACG9=""!($L(ACG9)>5) D T S ^TMP("ACG",$J,ACG2,9)="1++"_ACG1_";9++"_ACG9_"^W !?5,""Item 9 is required and must be the 5 digit ZIP code."""
10 I "ADILSBQ"[ACG1,ACG10=""!(ACG10'?3N) D T S ^TMP("ACG",$J,ACG2,10)="1++"_ACG1_";10++"_ACG10_"^W !?5,""Item 10 is required and must be three numeric digits."",!?5,""Use '099' for multiple congressional districts."""
11 I "ADILS"[ACG1,ACG11=""!("12"'[$E(ACG11))!($E(ACG11)=1&($L(ACG11)'=12))!($E(ACG11)=1&($E(ACG11,11,12)'?1U1N))!($E(ACG11)=2&($L(ACG11)'=10)) D
 .D T S ^TMP("ACG",$J,ACG2,11)="1++"_ACG1_";11++"_ACG11_"^W !?5,""Item 11 is required and must be 10 or 12 characters in length."",!?5,""If the first character is '1' characters 11 and 12 are required."""
 D ^ACGSRQ1
 Q
T I '$D(^TMP("ACG",$J,ACG2)) S ^TMP("ACG",$J,"T")=^TMP("ACG",$J,"T")+1 W:'$D(ZTQUEUED)&($E(IOST,1,2)="C-") "."
 Q
