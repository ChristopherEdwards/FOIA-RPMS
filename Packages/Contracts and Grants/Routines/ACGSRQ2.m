ACGSRQ2 ;IHS/OIRM/DSD/THL,AEF - CHECK CIS RECORD INTEGRITY CONT'D; [ 03/27/2000   2:22 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
 ;;CHECK CIS RECORD INTEGRITY CONT'D
EN ;EP;TO CHECK INTEGRITY OF CIS ENTRY
17 I "ADILSMCRBQ"[ACG1 D
 .I ACG17="" D T S ^TMP("ACG",$J,ACG2,1,17)="1++"_ACG1_";17++"_ACG17_"^W !?5,""Item 17 is required if Item 1 equals A, D, I, L, S, C, M, R, B or Q.""" Q
 .I ACG51=1,ACG17'="" D T S ^TMP("ACG",$J,ACG2,17,51)="51++"_ACG51_";17++"_ACG17_"^W !?5,""If Item 51 equals 1, Item 17 must be null."""
 .I ACG17="4K" D
 ..I ACG18=""!(ACG18<70)!(ACG18>84) D T S ^TMP("ACG",$J,ACG2,17,18,2)="17++"_ACG17_";18++"_ACG18_"^W !?5,""If Item 17 equals 4K, Item 18 must equal 70-84."""
 ..I ACG19<60!(ACG19>63) D T S ^TMP("ACG",$J,ACG2,17,19,2)="17++"_ACG17_";19++"_ACG19_"^W !?5,""If Item 17 equals 4K, Item 19 must equal 60-63."""
 ..I ACG20<4 D T S ^TMP("ACG",$J,ACG2,17,20,2)="17++"_ACG17_";20++"_ACG20_"^W !?5,""If Item 17 equals 4K, Item 20 must equal 4, 5 or 6."""
 .I ACG17'="4K" D
 ..I ACG19<50!(ACG19>59) D T S ^TMP("ACG",$J,ACG2,17,19,1)="17++"_ACG17_";19++"_ACG19_"^W !?5,""If Item 17 equals 4A-4J, Item 19 must equal 50-59."""
 ..I ACG20>4 D T S ^TMP("ACG",$J,ACG2,17,20,1)="17++"_ACG17_";20++"_ACG20_"^W !?5,""If Item 17 equals 4A-4J, Item 20 must equal 1, 2 or 3."""
 .I ACG17="4A",ACG20>3 D T S ^TMP("ACG",$J,ACG2,17,20,3)="17++"_ACG17_";20++"_ACG20_"^W !?5,""If Item 17 equals 4A, Item 20 must equal 1 or 2."""
 .I ACG17="4I","C1C2"'[$E(ACG27,1,2)&($E(ACG27)'="A") D T S ^TMP("ACG",$J,ACG2,17,27,1)="17++"_ACG17_";27++"_ACG27_"^W !?5,""If Item 17 equals 4I, Item 27 must begin with A or C1 or C2."""
 .I ACG17="4E",$E(ACG27)'="A" D T S ^TMP("ACG",$J,ACG2,17,27,2)="17++"_ACG17_";27++"_ACG27_"^W !?5,""If Item 17 equals 4E, Item 27 must begin with A."""
 .I ACG17="4D","C1C2"'[$E(ACG27,1,2) D T S ^TMP("ACG",$J,ACG2,17,27,3)="17++"_ACG17_";27++"_ACG27_"^W !?5,""If Item 17 equals 4D, Item 27 must begin with C1 or C2."""
 .I ACG19=59,ACG13="A1",ACG17'="4J" D T S ^TMP("ACG",$J,ACG2,17,19,3)="17++"_ACG17_";19++"_ACG19_"^W !?5,""If Item 19 equals 59 and Item 13=A1, Item 17 must equal 4J."""
18 I ACG18'="","ADILSMCRBQ"[ACG1 D
 .I ACG51=1 D T S ^TMP("ACG",$J,ACG2,18,51)="51++"_ACG51_";18++"_ACG18_"^W !?5,""If Item 51 equals 1, Item 18 must be null."""
 .I ACG17'="4K" D T S ^TMP("ACG",$J,ACG2,18,17)="18++"_ACG18_";17++"_ACG17_"^W !?5,""If Item 18 is entered, Item 17 must equal 4K."""
 .I ACG18>69,ACG19'>59 D T S ^TMP("ACG",$J,ACG2,18,19)="18++"_ACG18_";19++"_ACG19_"^W !?5,""If Item 18 equals 70-84, Item 19 must equal 60-63."""
 .I ACG18>69,ACG20<4 D T S ^TMP("ACG",$J,ACG2,18,20)="18++"_ACG18_";20++"_ACG20_"^W !?5,""If Item 18 equals 70-84, Item 20 must equal 4, 5 or 6"""
 .I ACG18=72,$E(ACG27)'="A" D T S ^TMP("ACG",$J,ACG2,18,27)="18++"_ACG18_";27++"_ACG27_"^W !?5,""If Item 18 equals 72, Item 27 must begin with A."""
 .I ACG18=82,ACG12'="B" D T S ^TMP("ACG",$J,ACG2,18,12)="18++"_ACG18_";12++"_ACG12_"^W !?5,""If Item 18 equals 82, Item 12 must equal B."""
 .I ACG18=74!(ACG52=1),ACG12'="B" D T S ^TMP("ACG",$J,ACG2,18,52,12)="18++"_ACG18_";12++"_ACG12_"^W !?5,""If Item 18 equals 74 or Item 52 equals 1, Item 12 must equal B."""
 D ^ACGSRQ3
 Q
T I '$D(^TMP("ACG",$J,ACG2)) S ^TMP("ACG",$J,"T")=^TMP("ACG",$J,"T")+1 W:'$D(ZTQUEUED)&($E(IOST,1,2)="C-") "."
 Q
