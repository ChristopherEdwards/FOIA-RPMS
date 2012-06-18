ACGSRQ5 ;IHS/OIRM/DSD/THL,AEF - CHECK CIS RECORD INTEGRITY CONT'D; [ 03/27/2000   2:22 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
 ;;CHECK CIS RECORD INTEGRITY CONT'D
EN ;EP;TO CHECK INTEGRITY OF CIS ENTRY
45 I ACG26>100000,ACG45="" D T S ^TMP("ACG",$J,ACG2,45)="26++"_ACG26_";45++"_ACG45_"^W !?5,""Synopsis is required if Item 26 greater than $100,000."""
 I ACG45=2,ACG18'=77 D T S ^TMP("ACG",$J,ACG2,45)="45++"_ACG45_";18++"_ACG18_"^W !?5,""I Synopsis is 2, Item 18 must equal 77."""
46 ;
47 ;
48 ;
49 ;
50 ;
51 I "ABCDGILMOQRSTU"[ACG1 D
 .I "12"'[ACG51 D T S ^TMP("ACG",$J,ACG2,51)="51++"_ACG51_"^W !?5,""Item 51 is required and must be '1' or '2'."""
 .I ACG51=1,ACG12'=""&(ACG13'="")&(ACG15'="")&(ACG17'="")&(ACG18'="")&(ACG20'="")&(ACG21'="")&(ACG30'="")&(ACG31'="")&(ACG33'="")&(ACG45'="")&(ACG52'="")&(ACG62'="") D
 ..D T S ^TMP("ACG",$J,ACG2,51)="51++"_ACG51_"^W !?5,""If Item 51=1, Items 12, 13, 15, 17, 18, 20, 21, 30, 31, 33, 45, 52 and 62 must be null."""
52 ;
53 I "ABCDGILMOQRSTU"[ACG1 D
 .I ACG53=""!(ACG53'?4N) D T S ^TMP("ACG",$J,ACG2,1,53)="1++"_ACG1_";53++"_ACG53_"^W !?5,""If Item 1 equals A, D, I, L, S, O, Q or G, Item 53 is required."""
 .I "^15^16^17^"[(U_$E(ACG53,1,2)_U),"A1A2A3B1B2"[ACG13,ACG63'=1 D T S ^TMP("ACG",$J,ACG2,53,63)="53++"_ACG53_";63++"_ACG63_"^W !?5,""If Item 53=15, 16 or 17, & Item 13=A1, A2, A3, B1 or B2, Item 63 must be coded '1'."""
54 ;
55 ;
56 I ACG56=1,"A1A2A3"[ACG13 D T S ^TMP("ACG",$J,ACG2,56,13)="56++"_ACG56_";13++"_ACG13_"^W !?5,""If Item 56 equals 1, Item 13 must not equal A1, A2 or A3."""
 I ACG56=1,ACG62="B" D T S ^TMP("ACG",$J,ACG2,56,62)="56++"_ACG56_";62++"_ACG62_"^W !?5,""If Item 56 equals 1, Item 62 must not equal B."""
57 ;
58 ;
59 ;
60 ;
61 ;
62 I "ADILSMCRTQ"[ACG1 D
 .I ACG62="" D T S ^TMP("ACG",$J,ACG2,1,62)="1++"_ACG1_";62++"_ACG62_"^W !,""Item 62 is required.""" Q
 .I ACG18="",ACG62="A",ACG19<50!(ACG19>59) D T S ^TMP("ACG",$J,ACG2,18,62,19)="18++"_ACG18_";62++"_ACG62_";";"_19++"_ACG19_"^W !?5,""If Item 18 is null and Item 62 equals A, Item 19 must equal 50-59."""
 .I ACG62="D",ACG52'=1&(ACG52'=2) D T S ^TMP("ACG",$J,ACG2,62,52)="62++"_ACG62_";52++"_ACG52_"^W !?5,""If Item 62 equals D, Item 52 must equal 1 or 2."""
 .I ACG62="C",ACG18'=81 D T S ^TMP("ACG",$J,ACG2,62,18)="62++"_ACG62_";18++"_ACG18_"^W !?5,""If Item 62 equals C, Item 18 must equal 81."""
 .I ACG62="B" D
 ..I "MCRTU"'[ACG1 D T S ^TMP("ACG",$J,ACG2,62,1)="62++"_ACG62_";1++"_ACG1_"^W !?5,""If Item 62 equals B, Item 1 must equal M, C, R, T or U."""
 ..I ACG56=1 D T S ^TMP("ACG",$J,ACG2,62,56)="62++"_ACG62_";56++"_ACG56_"^W !?5,""If Item 62 equals B, Item 56 must not equal 1."""
 ..I ACG15'=10 D T S ^TMP("ACG",$J,ACG2,62,15)="62++"_ACG62_";15++"_ACG15_"^W !?5,""If Item 62 equals B, Item 15 must equal 10."""
 ..I ACG52'="" D T S ^TMP("ACG",$J,ACG2,62,52)="62++"_ACG62_";52++"_ACG52_"^W !?5,""If Item 62 equals B, Item 52 must be null."""
 D ^ACGSRQ6
 Q
T I '$D(^TMP("ACG",$J,ACG2)) S ^TMP("ACG",$J,"T")=^TMP("ACG",$J,"T")+1 W:'$D(ZTQUEUED)&($E(IOST,1,2)="C-") "."
 Q
