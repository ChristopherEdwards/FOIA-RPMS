ACGSRQ1 ;IHS/OIRM/DSD/THL,AEF - CHECK CIS RECORD INTEGRITY CONT'D; [ 03/27/2000   2:22 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
 ;;CHECK CIS RECORD INTEGRITY CONT'D
EN ;EP;TO CHECK INTEGRITY OF CIS ENTRY
 ;.I ACG13="D4",ACG12'="A",ACG18="" S $P(^ACGS(ACGRDA,"DT"),U,18)=81
12 I "ADILGSQMCRB"[ACG1 D
 .I ACG12="" D T S ^TMP("ACG",$J,ACG2,1,12)="1++"_ACG1_";12++"_ACG12_"^W !?5,""Item 12 is required if Item 1 equals A, D, I, L, S, C, M, R, B or Q.""" Q
 .I "ABCD"'[ACG12 D T S ^TMP("ACG",$J,ACG2,12)="12++"_ACG12_"^W !?5,""The code for Item 12 must equal A, B, C or D.""" Q
 .I ACG12="A",ACG18'="" D T S ^TMP("ACG",$J,ACG2,12,18,1)="12++"_ACG12_";18++"_ACG18_"^W !?5,""If Item 12 equals A then Item 18 must be null."""
 .I ACG12'="A",'ACG18!(ACG18<70)!(ACG18>84) D T S ^TMP("ACG",$J,ACG2,12,18,2)="12++"_ACG12_";18++"_ACG18_"^W !?5,""If Item 12 equals B or C or D, then Item 18 must equal from 70-84."""
 .I ACG12="A",ACG17=""!(ACG17="4K") D T S ^TMP("ACG",$J,ACG2,12,17,1)="12++"_ACG12_";17++"_ACG17_"^W !?5,""If Item 12 equals A, Item 17 cannot be null or equal 4K."""
 .I ACG12'="A",ACG17=""!(ACG17'="4K") D T S ^TMP("ACG",$J,ACG2,12,17,2)="12++"_ACG12_";17++"_ACG17_"^W !?5,""If Item 12 equals B or C or D, Item 17 must equal 4K."""
 .I ACG12="A",ACG19=""!(ACG19<50!(ACG19>59)) D T S ^TMP("ACG",$J,ACG2,12,19,1)="12++"_ACG12_";19++"_ACG19_"^W !?5,""If Item 12 equals A, Item 19 must equal from 50-59."""
 .I ACG12'="A",ACG19=""!(ACG19<60) D T S ^TMP("ACG",$J,ACG2,12,19,2)="12++"_ACG12_";19++"_ACG19_"^W !?5,""If Item 12 equals B or C or D, Item 19 must equal from 60-63."""
 .I ACG12="A",ACG20=""!(ACG20=4) D T S ^TMP("ACG",$J,ACG2,12,20)="12++"_ACG12_";20++"_ACG20_"^W !?5,""If Item 12 equals A, Item 20 must equal 1, 2 or 3."""
 .I ACG18=74!(ACG18=82)!(ACG52=1),ACG12'="B" D T S ^TMP("ACG",$J,ACG2,12,18,52)="18++"_ACG18_";12++"_ACG12_"^W !?5,""If Item 18 equals 74 or 82 or Item 52 equals 1, Item 12 must equal b."""
 .I ACG19=60,ACG13="A1",ACG12'="B" D T S ^TMP("ACG",$J,ACG2,12,19,13)="19++"_ACG19_";12++"_ACG12_"^W !?5,""If Item 19 equals 60 and Item 13 equals A1, Item 12 must equal B.""" I "ADILS"[ACG1,ACG51'=1 D
13 I "ADILS"[ACG1 D
 .I ACG13="" D T S ^TMP("ACG",$J,ACG2,1,13)="1++"_ACG1_";13++"_ACG13_"^W !?5,""Item 13 is required if Item 1 equals A, D, I, L, or S."",!?5,""Check CONTRACTOR DATA to ensure that TYPE OF BUSINESS is entered.""" Q
 .I ACG13'="A1",ACG19=59!(ACG19=60) D T S ^TMP("ACG",$J,ACG2,13,19,1)="13++"_ACG13_";19++"_ACG19_"^W !?5,""If Item 19 equal 59 or 60, Item 13 must equal A1."""
 .I ACG13="A1",ACG19'=59&(ACG19'=60) D T S ^TMP("ACG",$J,ACG2,13,19,2)="13++"_ACG13_";19++"_ACG19_"^W !?5,""If Item 13 equals A1, Item 19 must equal 59 or 60."""
 .S ACG=$P(^ACGS($P(^ACGS(ACGRDA,0),U,3),"DT"),U,13)
 .I ACG S ACG=$P(^AUTTTOB(ACG,0),U) I ACG13'=ACG D
 ..D T
 ..S ^TMP("ACG",$J,ACG2,13,ACG)="13++"_ACG13_";13++"_ACG_"^W !?5,""The Type of Business is not the same as that of the original contract action."""
14 ;
15 I "ADILS"[ACG1 D
 .I ACG15="" D T S ^TMP("ACG",$J,ACG2,1,15)="1++"_ACG1_";15++"_ACG15_"^W !?5,""Item 15 is required if Item 1 equals A, D, I, L, or S.""" Q
 .I ACG51=1,ACG15'="" D T S ^TMP("ACG",$J,ACG2,15,51)="51++"_ACG51_";15++"_ACG15_"^W !?5,""If Item 51 equals 1, Item 15 must be null."""
16 ;
 D ^ACGSRQ2
 Q
T I '$D(^TMP("ACG",$J,ACG2)) S ^TMP("ACG",$J,"T")=^TMP("ACG",$J,"T")+1 W:'$D(ZTQUEUED)&($E(IOST,1,2)="C-") "."
 Q
