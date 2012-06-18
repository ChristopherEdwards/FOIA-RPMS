ACGSRQ6 ;IHS/OIRM/DSD/THL,AEF - CHECK CIS RECORD INTEGRITY CONT'D; [ 03/27/2000   2:22 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
 ;;CHECK CIS RECORD INTEGRITY CONT'D
EN ;EP;TO CHECK INTEGRITY OF CIS ENTRY
63 I ACG63=1,"A1A2A3B1B2"'[ACG13 D T S ^TMP("ACG",$J,ACG2,63,13)="63++"_ACG63_";13++"_ACG13_"^W !?5,""If Item 63 equals 1, Item 13 must be A1, A2, A3, B1 or B2."""
 I ACG63=1,"^15^16^17^"[(U_$E(ACG53,1,2)_U),ACG27?4N D T S ^TMP("ACG",$J,ACG2,63,53)="63++"_ACG63_";27++"_ACG27_"^W !?5,""If Item 63=1, Item 53 starts with 15, 16 or 17, Item 27 must not be numeric."""
 I ACG63="" S ACG63=2,$P(^ACGS(ACGRDA,"DT3"),U,8)=2
 I ACG63=2,ACG64'=""!(ACG65'="")!(ACG66'="") D
 .F ACGZZ=9:1:11 S $P(^ACGS(ACGRDA,"DT3"),U,ACGZZ)=""
 .S (ACG64,ACG65,ACG66)=""
64 I ACG64=1,"A1A2A3"'[ACG13 D T S ^TMP("ACG",$J,ACG2,64,13)="64++"_ACG64_";13++"_ACG13_"^W !?5,""If Item 64 equals 1, Item 13 must equal A1, A2 or A3."""
 I ACG64=1,ACG65="" D T S ^TMP("ACG",$J,ACG2,64,65,1)="64++"_ACG64_";65++"_ACG65_"^W !?5,""If Item 64 equals 1, Item 65 must equal 1 or 2."""
 I ACG64=2,ACG65'="" D
 .I ACG64=2,ACG65'="" S $P(^ACGS(ACGRDA,"DT3"),U,10)=""
65 I ACG65=1,ACG27]"" D
 .S ACG27DA=$O(^ACGPPC("B",ACG27,0)) I ACG27DA I $P(^ACGPPC(ACG27DA,0),U,4)=2,ACG26>100000 D
 ..D T
 ..S ^TMP("ACG",$J,ACG2,65,27)="65++"_ACG65_";27++"_ACG27_"^W !?5,""If Item 65 equals 1 and Item 27 not A&A, Item 26 must be less than $100,000."""
 I ACG65=1,5663'[ACG19 D
 .D T
 .S ^TMP("ACG",$J,ACG2,65,19)="65++"_ACG65_";19++"_ACG19_"^W !?5,""If Item 65 equals 1, Item 19 must be equal 56 or 63."""
 I ACG64="",ACG65'="" D
 .D T
 .S ^TMP("ACG",$J,ACG2,64,65)="64++"_ACG64_";65++"_ACG65_"^W !?5,""If Item 64 is NULL Item 65 must also be NULL."""
66 I ACG66'="","A1A2A3"'[ACG13 S $P(^ACGS(ACGRDA,"DT3"),U,11)="" ;S ^TMP("ACG",$J,ACG2,66,13)="66++"_ACG66_";13++"_ACG13_"^W !?5,""If Item 66 is not null, Item 13 must equal A1, A2 or A3."""
67 I ACG67'="",ACG13'="C5" S $P(^ACGS(ACGRDA,"DT3"),U,12)="" S ^TMP("ACG",$J,ACG2,67,13)="67++"_ACG67_";13++"_ACG13_"^W !?5,""If Item 67 is not null, Item 13 must equal C5."""
68 I ACG68'="",ACG13'="C5" S $P(^ACGS(ACGRDA,"DT3"),U,13)="" S ^TMP("ACG",$J,ACG2,68,13)="68++"_ACG68_";13++"_ACG13_"^W !?5,""If Item 68 is not null, Item 13 must equal C5."""
69 I ACG69'="",ACG13'="C5" S $P(^ACGS(ACGRDA,"DT3"),U,14)="" S ^TMP("ACG",$J,ACG2,69,13)="69++"_ACG69_";13++"_ACG13_"^W !?5,""If Item 69 is not null, Item 13 must equal C5."""
70 ;
 Q
T I '$D(^TMP("ACG",$J,ACG2)) S ^TMP("ACG",$J,"T")=^TMP("ACG",$J,"T")+1 W:'$D(ZTQUEUED)&($E(IOST,1,2)="C-") "."
 Q
