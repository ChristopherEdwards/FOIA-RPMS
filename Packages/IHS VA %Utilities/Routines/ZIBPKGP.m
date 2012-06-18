ZIBPKGP ; IHS/ADC/GTH - PROCESS IMPLEMENTATION STATUS FILES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 Q
 ;
OPT ; Set option in OPTION file.
 I $P(^%ZOSF("OS"),"^")'="MSM-UNIX" W !!,"SORRY.  MSM-UNIX only.",! Q
 I $S('$D(DUZ(0)):1,DUZ(0)'="@":1,1:0) W !,"PROGRAMMER ACCESS REQUIRED",! Q
 NEW DA,DIC,DIE,DR
 D HOME^%ZIS,DT^DICRW
 S X="ZIB IMPLEMENTATION STATUS",DR="W $J("""",IOM-$L(%)\2)_%,!!"
 W !
 F %="Option '"_X_"' will be placed","in the OPTION file for daily processing, beginning tomorrow morning","at 0530 AM.  You can change the frequency/time of scheduling by","using the TaskMan option thru the Kernel." X DR
 S DIC="^DIC(19,",DIC(0)="",DIC("DR")="1///ZIB Implementation Status;4///R;25///IN^ZIBPKGP;200///T+1@0530;202///1D"
 I $D(^DIC(19,"B",$E(X,1,30))) S DIE=DIC,DA=$O(^DIC(19,"B",$E(X,1,30),0)),DR=DIC("DR") D DIE I 1
 E  KILL DD,DO D FILE
 W !!,"Done.",!
 Q
 ;
IN ;EP - From TaskMan.
 ; A = Date of Installation
 ; D = Directory
 ; F = File
 ; L = ASUFAC Code
 ; P = Package Prefix
 ; S = Short Description of Package
 ; S(1) = 1st Subscript of ^DIZ(8009545 (Facility)
 ; S(2) = 2nd Subscript of ^DIZ(8009545 (Package)
 ; T = Patch
 ; V = Version
 ; Z = Line of Input
 ; Read in status files from remote site and place in FM file.
 ;
 NEW A,D,F,L,P,S,T,V,XMB,XMTEXT,Z
 S X=$$JOBWAIT^%HOSTCMD("ls -l /usr/spool/uucppublic/pkg* > zibpkg.wrk ; ls -l /usr/spool/uucppublic/rpi* >> zibpkg.wrk")
 F A=0:0 S A=$O(^%ZIS(1,A)) Q:'A  I ^(A,"TYPE")="HFS" S IOP=$P(^%ZIS(1,A,0),U),%ZIS("IOPAR")="(""zibpkg.wrk"":""R"")" D ZIS Q:'POP
 Q:POP!('A)
 KILL ^TMP($J)
 U IO
 F  R %:300 Q:%=""  S %=$P(%,"/",5) S:%?1"pkg"6N1"."3N ^TMP($J,"PKG",%)="" S:%?1"rpi"6N1"."3N ^TMP($J,"RPI",%)=""
 S F="",D="/usr/spool/uucppublic/"
MAIN ;
PKG ;
 F  S F=$O(^TMP($J,"PKG",F)) Q:F=""  U IO:(D_F) D
 . F  R Z:300 Q:(Z="")!(Z'?6N1"^"1U1.3UN1"^".E)  D
 .. S L=$P(Z,U),P=$P(Z,U,2),S=$P(Z,U,3),V=$P(Z,U,4),A=$P(Z,U,5)
 .. S:S="" S="error"
 .. D FAC
 .. S DA=S(2),DIE="^DIZ(8009545,"_S(1)_",1,",DR="1////"_V_";2////P;3////"_A
 .. D DIE
 .. S ^TMP($J,"PKG",F)=L
 ..Q
 . S X=$$JOBWAIT^%HOSTCMD("rm "_D_F)
 .Q
 ;
RPI ;
 F  S F=$O(^TMP($J,"RPI",F)) Q:F=""  U IO:(D_F) D
 . F  R Z:300 Q:(Z="")!(Z'?6N1"^"2.4L1".v"1.2N1"."1.2N.1A.2N1"p"1.3N1"^".E)  I $P(Z,U,3)="INSTALLED" D
 .. S L=$P(Z,U),T=$P(Z,U,2),A=$P(Z,U,4),P=$P(T,"."),V=$P($P(T,".v",2),"p"),T=$P($P(T,".v",2),"p",2)
 .. F XMB="P","V" S X=@XMB X ^DD("FUNC",$O(^DD("FUNC","B","UPPERCASE",0)),1) S @XMB=X
 .. S S=P
 .. D FAC
 .. S DA(2)=S(1),DA(1)=S(2),DA=T
 .. I '$D(^DIZ(8009545,DA(2),1,DA(1),1,0)) S ^(0)="^8009545.03^^"
 .. I '$D(^DIZ(8009545,DA(2),1,DA(1),1,DA)) S (X,DINUM)=DA,DIC="^DIZ(8009545,"_DA(2)_",1,"_DA(1)_",1,",DIC(0)="",DIC("DR")="1///"_A_";2///"_$P(Z,U,2) D FILE KILL DINUM I 1
 .. E  S DIE="^DIZ(8009545,"_DA(2)_",1,"_DA(1)_",1,"_DA_",",DR="1///"_A_";2///"_$P(Z,U,2) D DIE
 .. S ^TMP($J,"RPI",F)=L
 ..Q
 . S X=$$JOBWAIT^%HOSTCMD("rm "_D_F)
 .Q
 ;
ENDMAIN ;
 D ZISC
 S X=$$JOBWAIT^%HOSTCMD("rm zibpkg.wrk")
 ; ^TMP($J,"PKG",file)=facility
 S F="",%=0
 F  S F=$O(^TMP($J,"PKG",F)) Q:F=""  S %=%+1,XMTEXT(%)="  Application status received from "_^(F)
 S F=""
 F  S F=$O(^TMP($J,"RPI",F)) Q:F=""  I $L(^(F)) S %=%+1,XMTEXT(%)="  Patch application received from "_^(F)
 I $L($O(^TMP($J,"PKG",""))) S XMB="ZIB PKG",XMTEXT="XMTEXT(" D XMB
 KILL ^TMP($J)
Q ;
 Q
 ;
FAC ;
 I '$D(^DIZ(8009545,"B",$O(^AUTTLOC("C",L,0)))) S X=$O(^AUTTLOC("C",L,0)),DIC="^DIZ(8009545,",DIC(0)="" D FILE S S(1)=+Y I 1
 E  S S(1)=$O(^DIZ(8009545,"B",$O(^AUTTLOC("C",L,0)),0))
 I '$D(^DIZ(8009545,S(1),1,0)) S ^(0)="^8009545.02PA^^"
 I '$D(^DIC(9.4,"C",P)) S X=S,DIC="^DIC(9.4,",DIC(0)="",DIC("DR")="1///"_P_";2///"_S D FILE S S(2)=+Y I 1
 E  S S(2)=$O(^DIC(9.4,"C",P,0))
 I '$D(^DIZ(8009545,S(1),1,"B",S(2))) S X=S(2),DA(1)=S(1),DIC="^DIZ(8009545,"_S(1)_",1,",DIC(0)="" D FILE S S(2)=+Y I 1
 E  S S(2)=$O(^DIZ(8009545,S(1),1,"B",S(2),0))
 Q
 ;
FILE NEW A,D,DD,DO,F,L,P,S,T,V,Z D FILE^DICN KILL DIC Q
DIE NEW A,D,F,L,P,S,T,V,Z D ^DIE KILL DA,DR,DIE Q
XMB NEW A,D,F,L,P,S,T,V,Z D ^XMB Q
ZIS NEW A,D,F,L,P,S,T,V,Z D ^%ZIS Q
ZISC NEW A,D,F,L,P,S,T,V,Z D ^%ZISC Q
