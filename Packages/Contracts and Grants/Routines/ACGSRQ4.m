ACGSRQ4 ;IHS/OIRM/DSD/THL,AEF - CHECK CIS RECORD INTEGRITY CONT'D; [ 03/27/2000   2:22 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
 ;;CHECK CIS RECORD INTEGRITY CONT'D
EN ;EP;TO CHECK INTEGRITY OF CIS ENTRY
27 I "ADILS"[ACG1,ACG27="" D T S ^TMP("ACG",$J,ACG2,27)="27++"_ACG27_";++"_"^W !?5,""Item 27 is required."""
 I $E(ACG27)="A",ACG1'="G" D T S ^TMP("ACG",$J,ACG2,27,1)="27++"_ACG27_";1++"_ACG1_"^W !?5,""If Item 27 begins with A, Item 1 must equal G."""
 I ACG27]"" S X=$O(^ACGPPC("B",ACG27,0)) I X,$D(^ACGPPC(X,0)) S X=$P(^ACGPPC(X,0),U,4),ACG27DA=$S(X=1:1,1:2)
 E  S ACG27DA="NOT ENTERED" D T S ^TMP("ACG",$J,ACG2,27)="27++"_ACG27_";++"_"^W !?5,""Item 27 is required."""
 I "ADILS"[ACG1,ACG27DA,ACG27DA'=ACG16 D T S ^TMP("ACG",$J,ACG2,27,16)="27++"_ACG27_";16++"_ACG16_"^W !?5,""Item 27 must be from an A&A group compatible with Item 16."""
28 I "ADILSOQG"[ACG1 D
 .I '+ACG28 D R28
 .I ACG28="" D T S ^TMP("ACG",$J,ACG2,1,28)="1++"_ACG1_";28++"_ACG28_"^W !?5,""If Item 1 equals A, D, I, L, S, O, Q or G, Item 28 is required."",!?5,""Check GEOGRAPHICAL LOCATION to ensure that STATE and PLACE CODE are entered."""
 .I ACG28'="",$E(ACG28,1,7)'?7N D T S ^TMP("ACG",$J,ACG2,28)="28++"_ACG28_"^W !?5,""Item 28 must begin with the State code followed by the 5-digit Place Code"",!?5,""followed by the name of the location where service is performed."""
29 ;
30 I "ADILSB"[ACG1,"12"'[ACG30 D
 .S $P(^ACGS(ACGRDA,"DT1"),U,9)=$S(ACG30["Y":1,1:2),ACG30=$P(^("DT1"),U,9)
 .I ACG30=1,"A1A2A3"'[ACG13 D
 ..D T S ^TMP("ACG",$J,ACG2,30,13)="30++"_ACG30_";13++"_ACG13_"^W !?5,""If Item 30 equals 1, Item 13 must be A1, A2 or A3."""
31 I "ADILS"[ACG1 D
 .I ACG51=1,ACG31'="" D T S ^TMP("ACG",$J,ACG2,31,51)="51++"_ACG51_";31++"_ACG31_"^W !?5,""If Item 51 equals 1, Item 31 must be null."""
 .I "ABCD"[ACG31,"E1E2"'[ACG13 D T S ^TMP("ACG",$J,ACG2,31,13)="31++"_ACG31_";13++"_ACG13_"^W !?5,""If Item 31 equals A, B, C or D, Item 13 must equal E1 or E2."""
32 ;
33 ;
34 I "ADILSMRC"[ACG1 D
 .I ACG34="" D T S ^TMP("ACG",$J,ACG2,1,34)="1++"_ACG1_";34++"_ACG34_"^W !?5,""If Item 1 equals A, D, I, L, S, O, Q or G, Item 34 is required."""
 .I ACG34'="",ACG34>ACG23 D T S ^TMP("ACG",$J,ACG2,34,23)="34++"_ACG34_";23++"_ACG23_"^W !?5,""If Item 1 not equal B, O, P or Q, Item 34 must be < or = Item 23"""
35 I "ADILS"[ACG1,ACG16=1,ACG35="" D T S ^TMP("ACG",$J,ACG2,1,35,16)="1++"_ACG1_";16++"_ACG16_";35++"_ACG35_"^W !?5,""If Item 1 is A, D, I, L, or S, and Item 16 equals 1, Item 35 must not be null."""
36 ;
37 I "ADILSCMR"[ACG1,+ACG26,ACG37="" D R37 D
 .I ACG37="" D T S ^TMP("ACG",$J,ACG2,1,26,37)="1++"_ACG1_";26++"_ACG26_";37++"_ACG37_"^W !?5,""If Item 1 equals A, C, D, I, L, M, R, or S, and Item 26 is not 0,"",!?5,""Item 37 must not be null."""
38 ;
39 ;
40 ;
41 ;
42 ;
43 ;
44 ;
 D ^ACGSRQ5
 Q
T I '$D(^TMP("ACG",$J,ACG2)) S ^TMP("ACG",$J,"T")=^TMP("ACG",$J,"T")+1 W:'$D(ZTQUEUED)&($E(IOST,1,2)="C-") "."
 Q
R28 S ACG28=$P(^ACGS(ACGRD,"DT1"),U,7),$P(^ACGS(ACGRDA,"DT1"),U,7)=ACG28
 Q
R37 S ACG37=$P(^ACGS(ACGRD,"DT2"),U,2)
 I ACG37'="",$L(ACG37)=7 S $P(^ACGS(ACGRDA,"DT2"),U,2)=ACG37
 E  S ACG37=""
 Q
