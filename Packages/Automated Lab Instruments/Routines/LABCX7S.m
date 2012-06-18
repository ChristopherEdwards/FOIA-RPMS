LABCX7S ; IHS/DIR/FJE - ; [ 05/27/2003  6:53 AM ]
 ;;5.2;LA;**1016**;MAY 27, 2003
DOC ;Used to start and stop the CX7s
0 S A=0 F I=1:1 S A=$O(^LAB(62.4,"D","CX7",A)) Q:'A  S VAR="D"_I,@VAR=A
 I '$D(D1) W *7,*7,!!,"YOU HAVE NO DEVICES DEFINED IN THE AUTO INSTRUMENT FILE AS A CX7!!" K A,I,VAR Q  ;JPC FIXED SPELLING OF INSTRUMENT
 S D=I-1 F I=1:1:D S VAR="D"_I,T=@VAR D ASK
EXIT F I=1:1:D S VAR="D"_I K @VAR
 K A,I,J,VAR,D,T,NAME,ANS,OPT,LTA,POP,X
 Q
ASK ;
 S NAME=$P(^LAB(62.4,T,0),U)
 W !!,"Do you want to ",OPT," device ",T,", ",NAME,"? N// "
 R ANS:30 I ANS'["Y" W "    No action taken" Q
 D @OPT Q
 Q
START ;
 S IOP=$P(^LAB(62.4,T,0),U,2)
 I IOP="" W !,*7,"This does NOT have a device in file 62.4." Q
 S LTA=$O(^%ZIS(1,"B",IOP,0))
 I LTA="" W !,*7,"This device is NOT in the DEVICE file." Q
 S LTA=$P(^%ZIS(1,LTA,0),U,2)
 I LTA="" W !,*7,"Invalid device name in the DEVICE file" Q
 D ^%ZIS ;***JPC - CHECK POP AFTER %ZIS, NOT %ZISC
 I POP K IOP W !,"The interface for device ",T," is already running, no action needed." Q  ;JPC - ADDED KILL IOP
 I 'POP D ^%ZISC K IOP H 5 S X="J DQ^LABCX7"_T_":(NAME=""Lab CX7 "_T_""",IN="""_LTA_""")" X X ;JPC/JK3 ADDED 'NAME=' PARAM, CLOSE DEVICE
 W "   Job Started" Q
STOP ;
 S ^LA("STOP",T)="" W *7,"   Interface is now down"
 Q
