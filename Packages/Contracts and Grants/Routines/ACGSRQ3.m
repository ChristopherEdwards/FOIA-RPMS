ACGSRQ3 ;IHS/OIRM/DSD/THL,AEF - CHECK CIS RECORD INTEGRITY CONT'D; [ 03/27/2000   2:22 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
 ;;CHECK CIS RECORD INTEGRITY CONT'D
EN ;EP;TO CHECK INTEGRITY OF CIS ENTRY
19 I "ADILSMCRQ"[ACG1 D
 .I ACG19>49,ACG19<60,ACG20>3 D T S ^TMP("ACG",$J,ACG2,19,20,1)="19++"_ACG19_";20++"_ACG20_"^W !?5,""If Item 19 equals 50-59, Item 20 must equal 1, 2 or 3."""
 .I ACG19>59,ACG20'=4 D T S ^TMP("ACG",$J,ACG2,19,20,2)="18++"_ACG18_";20++"_ACG20_"^W !?5,""If Item 19 equals 60-63, Item 20 must equal 4."""
 .I "50525355"[ACG19,"A2A3C5"'[ACG13 D T S ^TMP("ACG",$J,ACG2,19,13,1)="19++"_ACG19_";13++"_ACG13_"^W !?5,""If Item 19 equals 50, 52, 53 or 55, Item 13 must equal A2, A3 or C5."""
 .I ACG19=60,ACG13'="A1" D T S ^TMP("ACG",$J,ACG2,19,13,2)="19++"_ACG19_";13++"_ACG13_"^W !?5,""If Item 19 equals 60, Item 13 must equal A1."""
 .I ACG19=60,ACG12'="B" D T S ^TMP("ACG",$J,ACG2,19,12)="19++"_ACG19_";12++"_ACG12_"^W !?5,""If Item 19 equals 60, Item 12 must equal B."""
 .I ACG19=60,ACG18'=81 D T S ^TMP("ACG",$J,ACG2,19,18)="19++"_ACG19_";18++"_ACG18_"^W !?5,""If Item 19 equals 60, Item 18 must equal 81."""
 .I ACG19=59,ACG13="A1",ACG12'="A" D T S ^TMP("ACG",$J,ACG2,19,13,12)="19++"_ACG19_";13++"_ACG13_";12++"_ACG12_"^W !?5,""If Item 19 equals 59 and Item 13 equals A1, Item 12 must equal A."""
 .I ACG20>4,ACG19'="" D T S ^TMP("ACG",$J,ACG2,19,20)="20++"_ACG20_";19++"_ACG19_"^W !?5,""If Item 20 equals 5 or 6, Item 19 must null."""
20 I "ADILSMCRB"[ACG1 D
 .I ACG51=1,ACG20'="" D T S ^TMP("ACG",$J,ACG2,20,51)="51++"_ACG51_";20++"_ACG20_"^W !?5,""If Item 51 equals 1, Item 20 must be null."""
 .I ACG17="4A",ACG20>2 D T S ^TMP("ACG",$J,ACG2,20,17)="17++"_ACG17_";20++"_ACG20_"^W !?5,""If Item 17 equals 4A, Item 20 must equal 1 or 2."""
21 I "ADILSMCRTU"[ACG1,ACG51=1,ACG20'="" D T S ^TMP("ACG",$J,ACG2,21,51)="51++"_ACG51_";21++"_ACG21_"^W !?5,""If Item 51 equals 1, Item 21 must be null."""
22 ;
23 I ACG23<800000 D T S ^TMP("ACG",$J,ACG2,23)="23++"_ACG23_"^W !?5,""Item 23 is invalid."""
 I ACG23>990000 D T S ^TMP("ACG",$J,ACG2,23)="23++"_ACG23_"^W !?5,""Item 23 is invalid."""
24 I ACG24<800000 D T S ^TMP("ACG",$J,ACG2,24)="24++"_ACG24_"^W !?5,""Item 24 is invalid."""
 I ACG24>990000 D T S ^TMP("ACG",$J,ACG2,24)="24++"_ACG24_"^W !?5,""Item 24 is invalid."""
25 I "ADILSQTUBG"[ACG1 D
 .I ACG25<800000 D T S ^TMP("ACG",$J,ACG2,25)="25++"_ACG25_"^W !?5,""Item 25 is invalid."""
 .I ACG25>990000 D T S ^TMP("ACG",$J,ACG2,25)="25++"_ACG25_"^W !?5,""Item 25 is invalid."""
26 ;
 D ^ACGSRQ4
 Q
T I '$D(^TMP("ACG",$J,ACG2)) S ^TMP("ACG",$J,"T")=^TMP("ACG",$J,"T")+1 W:'$D(ZTQUEUED)&($E(IOST,1,2)="C-") "."
 Q
