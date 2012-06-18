AZHLRERP ; DSM/GTH - PROCESS ERRORS FROM UNIX FILES FOR RER ;  [ 02/19/93  9:28 AM ]
 ;;1.9X;DSM REMOTE ERROR REPORTING;;FEB 19, 1993
 ;
 Q
 ;
OPT ; Set option in OPTION file.
 ;;Option 'AZHL REMOTE ERROR UNIX FILE PROCESSING' will be placed
 ;;in the OPTION file for daily processing, beginning tomorrow morning
 ;;at 0630 AM.  You can change the frequency/time of scheduling by
 ;;using the TaskMan option thru the Kernel.
 I $P(^%ZOSF("OS"),"^")'="MSM-UNIX" W !!,"SORRY.  MSM-UNIX only.",! Q
 I $S('$D(DUZ(0)):1,DUZ(0)'="@":1,1:0) W !,"PROGRAMMER ACCESS REQUIRED",! Q
 NEW A,DA,DIC,DIE,DR
 D HOME^%ZIS,DT^DICRW
 W ! F %=1:1:4 S A=$P($T(OPT+%),";;",2) W $J("",IOM-$L(A)\2)_A,!!
 S DIR(0)="Y",DIR("A")="Process <DSCON> and <INRPT> errors",DIR("B")="Y",DIR("?")="Do you want to process (save) the <DSCON> and <INRPT> errors?",DIR("??")="^D Q2^AZHLRERP"
 D DIR Q:$D(DIRUT)
 S DIC="^DIC(19,",X=$P($T(OPT+1),"'",2),DIC("DR")="1///RER UNIX File Processing;4///R;20///"_$S(Y:"@",1:"S:0 %=""DSCON^INRPT""")_";25///IN^AZHLRERP;200///T+1@0630;202///1D"
 I $D(^DIC(19,"B",$E(X,1,30))) S DIE=DIC,DA=$O(^DIC(19,"B",$E(X,1,30),0)),DR=DIC("DR") D DIE I 1
 E  D FILE
 W !!,"Done.",!
 Q
 ;
IN ;EP - From TaskMan. Read in errors from remote site and place in FM file.
 ;
 NEW A,D,E,F,H,I,J,L,N,P,R,V,XMB,XMTEXT
 ; List files in uucppublic, open HFS, list files to ^TMP.
 S X=$$JOBWAIT^%HOSTCMD("ls -l /usr/spool/uucppublic/*z* > azhlrer.wrk")
 F A=0:0 S A=$O(^%ZIS(1,A)) Q:'A  I ^(A,"TYPE")="HFS" S IOP=$P(^%ZIS(1,A,0),U),%ZIS("IOPAR")="(""azhlrer.wrk"":""R"")" D ZIS Q:'POP
 Q:POP!('A)
 S D="/usr/spool/uucppublic/" K ^TMP($J)
 U IO F  R % Q:%=""  S %=$P(%,"/",5) I (%?2.4U4N1"z"3N.1".z")!(%?1"%"4N1"z"3N.1".z") S:$E(%,$L(%)-1,$L(%))=".z" X=$$JOBWAIT^%HOSTCMD("unpack "_D_%),%=$E(%,1,$L(%)-2) I (%?2.4U4N1"z"3N)!(%?1"%"4N1"z"3N) S ^TMP($J,"RER",%)=""
 S F="",X="ERR^AZHLRERP",@^%ZOSF("TRAP"),%=$O(^DIC(19,"B","AZHL REMOTE ERROR UNIX FILE PR",0)),A=$P($G(^DIC(19,%,20)),"""",2)
MAIN ;
 F  S F=$O(^TMP($J,"RER",F)) Q:F=""  D
 . U IO:(D_F) R L Q:'((L["<<< BEGIN '")&(L[", REMOTE ERROR REPORTING FOR '"))
 . S P=$P(L,"'",2),I=$P(L,"'",4),R=$P($P($P(L,","),"v",2)," ",2)
 . I '$D(^AZHLRER(I)) S (DINUM,X)=I,DIC="^AZHLRER(" D FILE
 . R L D VARS
 . F  Q:(L="")!($E(L,1,12)="     >>> END")  D
 .. S ^(I)=+$G(^TMP($J,"COUNT",P,H,I))+1
 .. I '$D(^AZHLRER(I,1,H)) S DIC="^AZHLRER("_I_",1,",(DINUM,X)=H,DA(1)=I S:'$D(^AZHLRER(I,1,0)) ^(0)="^8008907.01^" D FILE
 .. S DIC="^AZHLRER("_I_",1,"_H_",1,",(DINUM,X)=E,DA(2)=I,DA(1)=H S:'$D(^AZHLRER(I,1,H,1,0)) ^(0)="^8008907.11^" D FILE
 .. S E(1)=E,H(1)=H
 .. S:'$D(^AZHLRER(I,1,H,1,E,1,0)) ^(0)="^8008907.111^"
 .. F  Q:E'=E(1)!(H'=H(1))  D
 ... I V=0 D
 .... S $P(^AZHLRER(I,1,H,1,E,0),U,2)=P,$P(^(0),U,3)=R,$P(^(0),U,4)=$TR(V(2),"^","~"),$P(^(0),U,5)=$P($P(V(2),">"),"<",2),$P(^(0),U,6)=$P($P(V(2),":"),U,2)
 .... S ^AZHLRER("C",P,I,H,E)="",^AZHLRER("D",$P($P(V(2),">"),"<",2),I,H,E)="",^AZHLRER("E",$P($P(V(2),":"),U,2),I,H,E)=""
 .... Q
 ... E  S DIC="^AZHLRER("_I_",1,"_H_",1,"_E_",1,",DINUM=V,X=V(1),DA(3)=I,DA(2)=H,DA(1)=E D FILE S ^AZHLRER(I,1,H,1,E,1,V,1)=V(2)
 ... R L D VARS
 ... Q
 .. Q
 . S X=$$JOBWAIT^%HOSTCMD("rm "_D_F)
 . Q
 S X=^%ZOSF("ERRTN"),@^%ZOSF("TRAP") D ZISC S X=$$JOBWAIT^%HOSTCMD("rm azhlrer.wrk")
BULLETIN ; ^TMP($J,"COUNT",namespace,$H-date,facility)=count
 S (F,H,N)="",%=0 F  S N=$O(^TMP($J,"COUNT",N)) Q:N=""  F  S H=$O(^TMP($J,"COUNT",N,H)) Q:H=""  F  S F=$O(^TMP($J,"COUNT",N,H,F)) Q:F=""  S %=%+1,XMTEXT(%)="  "_N_", day "_H_", "_^(F)_" error"_$S(^(F)>1:"s",1:"")_" from "_F
 I $L($O(^TMP($J,"COUNT",""))) S XMB="AZHL RER",XMTEXT="XMTEXT(" D XMB
 K ^TMP($J)
PURGE S (DA(1),DA)=0 F  S DA(1)=$O(^AZHLRER("B",DA(1))) Q:'DA(1)  F  S DA=$O(^AZHLRER(DA(1),1,"B",DA)) Q:'DA  I (+$H-DA)>730 S DIK="^AZHLRER("_DA(1)_",1," D DIK
Q Q
 ;
FILE NEW A,D,E,F,H,I,J,L,N,P,R,V K DD,DO S DIC(0)="L" D FILE^DICN K DIC Q
DIE NEW A,D,E,F,H,I,J,L,N,P,R,V D ^DIE K DA,DR,DIE Q
DIK NEW A,D,E,F,H,I,J,L,N,P,R,V D ^DIK Q
DIR NEW A,D,E,F,H,I,J,L,N,P,R,V D ^DIR Q
VARS S H=$P(L,",",2),E=$P(L,",",3),V=$P($P(L,",",4),")"),V(1)=$P(L,"=",2),V(2)=$P(L,"=",3,99)
 I +V=0,A]"",A[$P($P(V(2),">"),"<",2) F  R L Q:L=""  I '($P(L,",",2)=H)!'($P(L,",",3)=E) G VARS
 Q
XMB NEW A,D,E,F,H,I,J,L,N,P,R,V D ^XMB Q
ZIS NEW A,D,E,F,H,I,J,L,N,P,R,V D ^%ZIS Q
ZISC NEW A,D,E,F,H,I,J,L,N,P,R,V D ^%ZISC Q
ERR ;EP - Possible entry if error ($ZT), probably due to incomplete file.
 S X=$$JOBWAIT^%HOSTCMD("rm "_D_F)
 G MAIN
Q2 ;EP - From DIR
 W ! F %=2:1:7 W $P($T(Q2+%),";;",2),!
 ;;If you answer 'Y', the <DSCON> and <INRPT> errors will be processed.
 ;;If you answer 'N', the <DSCON> and <INRPT> errors will be ignored.
 ;;                       -- Note --
 ;;The errors in the quoted string of the ENTRY ACTION field of option
 ;;AZHL REMOTE ERROR UNIX FILE PROCESSING, will not be processed.
 ;;Edit that field if you want to add or delete errors to be IGNORED.
 Q
