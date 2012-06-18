ZIBRPI ; IHS/ADC/GTH - REMOTE PATCH INSTALLATION ; [ 11/04/97  10:26 AM ]
 ;;3.0;IHS/VA UTILITIES;**1,2,3**;FEB 07, 1997
 ; XB*3*1 IHS/ADC/GTH 03-07-97 Correct spelling of uucppublic.
 ; XB*3*2 IHS/ADC/GTH 04-21-97 Correct patch file pattern match.
 ; XB*3*3 IHS/ADC/GTH 04-25-97 Correct patch file name handling.
 ;
 ; For a description of this utility, see the text in routine
 ; ZIBRPI2.
 ;
 ; D = Directory containing patch files
 ; D("OUT") = Directory with results files
 ; E = "Action" routine, named (A/B)9<namespace><patch_number>
 ; F = Name of a file containing a patch
 ; J = Today's Julian date
 ; L = Facility's Pseudo Prefix
 ; N = Namespace derived from the name of the file
 ; O = Operating System, and OS-specific commands
 ; P = PACKAGE file IEN
 ; V = Version derived from the name of the file
 ; W = Work file
 ;
 W !!,"EXECUTION UNAUTHORIZED.",!
 Q
 ;
OPT ;EP - Set option in OPTION file.  Called by a programmer.
 D OPT^ZIBRPI1
 Q
 ;
START ;EP - From TaskMan.
 NEW %ZIS,D,DA,DIC,E,F,I,J,L,N,O,P,POP,V,W,XMSUB,XMTEXT,XMY
 D HFS
 Q:POP
 D OS
 KILL ^TMP($J)
 ; rm xmit files over 2 weeks old.
 S L=$P(^AUTTLOC($P(^AUTTSITE(1,0),U),1),U,2) I '($L(L)=3) S L="RPI"
 D HC(O("LS")_D("OUT")_O("NS")_L_".* > "_W)
 S IOP=I,%ZIS("IOPAR")="("""_W_""":""R"")"
 D ZIS,JDT
 U IO
 ; Comment next line to keep xmit ("rpi") files over 2 wks old.
 F  R %:300 Q:%=""  S %=$P(%,"/",$L(%,"/")),X=+$P(%,".",2) I $P(%,".")=O("NS")_L,((+X>+J)!(+X<(+J-14))) D HC(O("RM")_D("OUT")_%)
 D HC(O("RM")_W)
 ; Initialize namespace, systems, and frequency.
 S %=+$P(^DIC(19,$O(^DIC(19,"B","ZIB REMOTE PATCH INSTALLATION",0)),20)," ",2),D=$P($P(^(20),"""",2),U)
 S:'("/\"[$E(D,$L(D))) D=D_$S(O["UNIX":"/",1:"\")
 D HC(O("LS")_D_"*.*"_" > "_W)
 S IOP=I,%ZIS("IOPAR")="("""_W_""":""R"")"
 D ZIS
 U IO
 ; The Q:%="" in the following line is non-standard MUMPS.
 F  R %:300 Q:%=""  S %=$P(%,"/",$L(%,"/")) I %?@O("PF") S ^TMP($J,"ZIBRPI",%)=""
 S F=""
 I '$L($O(^TMP($J,"ZIBRPI",""))) D ZISC D HC(O("RM")_W) KILL ^TMP($J) S:$D(ZTQUEUED) ZTREQ="@" Q
MAIN ;
 F  S F=$O(^TMP($J,"ZIBRPI",F)) Q:F=""  D  S ^TMP($J,"ZIBRPI",F)=% D:%="INSTALLED" HC(O("RM")_D_F)
 . S X=$E(F,1,4),X=$P(X,"_"),N=$$UP^XLFSTR(X)
 . I '$D(^DIC(9.4,"C",N)) S %="FAILED - Not an Installed Package" Q
 . S P=$O(^DIC(9.4,"C",N,0))
 . I 'P S %="FAILED - Bad ""C"" x-ref for "_N Q
 . I '$D(^DIC(9.4,P,"VERSION")) S %="FAILED - 'VERSION' Node Missing" Q
 . S V=+($E(F,5,6)_"."_$E(F,7,8))
 . I (+V)'=(+^DIC(9.4,P,"VERSION")) S %="FAILED - V "_^("VERSION")_" of "_N_" is Installed" Q
 . ; S E=$S("AB"[$E(N):$E(N),1:"B")_"9"_N_$P($P(F,".",2),"p",2) ; XB*3*3 IHS/ADC/GTH 04-25-97 Correct patch file name handling.
 . S E=$S("AB"[$E(N):$E(N),1:"B")_"9"_N_(+$P($P(F,".",2),"p",1)) ; XB*3*3 IHS/ADC/GTH 04-25-97 Correct patch file name handling.
 . U IO:(D_F)
 . R %:300
 . R %:300
 . ; The ZL and ZS in the following line are non-standard M commands.
 . F  R %:300 Q:%=""  S:%=E ^TMP($J,"B9",%)="" X "ZL  ZS @%"
 . S DA(1)=^DIC(9.4,P,"VERSION"),DA(1)=$O(^DIC(9.4,P,22,"B",DA(1)_$S(DA(1)[".":"",1:".0"),0))
 . I 'DA(1) S DA(1)=$P(^DIC(9.4,P,22,0),U,3)
 . S:'$D(^DIC(9.4,P,22,DA(1),"PAH",0)) ^(0)="^9.4901^^"
 . ; S X=N_"*"_V_"*"_$P($P(F,".",2),"p",2),DIC="^DIC(9.4,"_P_",22,"_DA(1)_",""PAH"",",DIC(0)="",DIC("DR")=".02///"_DT_";.03///.5",DA(2)=P ; XB*3*3 IHS/ADC/GTH 04-25-97 Correct patch file name handling.
 . S X=N_"*"_V_"*"_(+$P($P(F,".",2),"p",1)),DIC="^DIC(9.4,"_P_",22,"_DA(1)_",""PAH"",",DIC(0)="",DIC("DR")=".02///"_DT_";.03///.5",DA(2)=P ; XB*3*3 IHS/ADC/GTH 04-25-97 Correct patch file name handling.
 . D FILE
 . S %="INSTALLED"
 . Q
ENDMAIN ;
 D OS
 S %=0,F="",D=D("OUT")_O("NS")_L_"."_J
 U IO:(D:"W")
 F  S F=$O(^TMP($J,"ZIBRPI",F)) Q:F=""  W L,U,F,U,^(F),U,DT,! S %=%+1,XMTEXT(%)="Restore from file "_$E(F_$J("",14),1,14)_": "_^(F)
 U IO:(W)
 D ZISC,HC(O("RM")_W)
 ; uucp according to parameter: ENTRY ACTION of option.
 S %=+$P(^DIC(19,$O(^DIC(19,"B","ZIB REMOTE PATCH INSTALLATION",0)),20)," ",2),E=$P($P(^(20),"""",2),U,2)
 I O["UNIX" D
 . I '(%=2) D HC("uucp -r "_D_" "_$P($T(SYTM),";",3)_"!~")
 . I %>1 D HC("uucp -r -nroot "_D_" "_$P(^AUTTSITE(1,0),U,14)_"!~")
 . Q
 S XMTEXT="XMTEXT(",XMSUB=$P($P($T(ZIBRPI),";",2),"-",2),XMY(1)=""
 D XMD
 I E S %="" F  S %=$O(^TMP($J,"B9",%)) Q:%=""  D RTN(U_%)
 KILL ^TMP($J)
 S ZTREQ="@"
Q ;
 Q
 ;
DIE NEW D,E,F,I,J,L,N,O,P,V,W D ^DIE Q
DIR NEW D,E,F,I,J,L,N,O,P,V,W D ^DIR Q
DTC NEW D,E,F,I,J,L,N,O,P,V,W D ^%DTC Q
FILE NEW D,E,F,I,J,L,N,O,P,V,W KILL DD,DO D FILE^DICN Q
HC(%) NEW D,E,F,I,J,L,N,O,P,V,W S %=$$JOBWAIT^%HOSTCMD(%) Q
RTN(%) NEW D,E,F,I,J,L,N,O,P,V,W D @(%) Q
XMD NEW D,E,F,I,J,L,N,O,P,V,W D ^XMD Q
ZIS NEW D,E,F,I,J,L,N,O,P,V,W D ^%ZIS Q
ZISC NEW D,E,F,I,J,L,N,O,P,V,W D ^%ZISC Q
 ;
HFS ;
 ; F I=0:0 S I=$O(^%ZIS(1,I)) Q:'I  I ^(I,"TYPE")="HFS" S IOP=$P(^%ZIS(1,I,0),U),%ZIS("IOPAR")="(""/usr/spool/uucpublic/work.zib"":""W"")" D ZIS Q:'POP ; XB*3*1 IHS/ADC/GTH 03-07-97 Correct spelling of uucppublic.
 F I=0:0 S I=$O(^%ZIS(1,I)) Q:'I  I ^(I,"TYPE")="HFS" S IOP=$P(^%ZIS(1,I,0),U),%ZIS("IOPAR")="(""/usr/spool/uucppublic/work.zib"":""W"")" D ZIS Q:'POP  ; XB*3*1 IHS/ADC/GTH 03-07-97 Correct spelling of uucppublic.
 I 'I,'$D(POP) S POP=1
 Q:POP
 S I=$P(^%ZIS(1,I,0),U)
 Q
 ;
JDT ;
 NEW X1,X2
 S X2=$E(DT,1,3)_"0101",X1=DT
 D DTC
 S X=X+1,X="00"_X,J=$E(X,$L(X)-2,$L(X))
 Q
 ;
OS ; The "IN" directory is retrieved from the OPTION entry.
 S O=$P($P(^%ZOSF("OS"),","),"-",2),O("PF")=$P($T(PATTERN),";",3)
 S W=$P($T(WORK),";",3),O("NS")=$P($T(NS),";",3)
 I O["UNIX" S (D("IN"),D("OUT"))=$P($T(PUB),";",3),O("RM")="rm ",O("LS")="ls -l ",W=D("OUT")_W Q
 S %=$G(^AUTTSITE(1,1)),D("IN")=$P(%,U),D("OUT")=$P(%,U,2),O("RM")="DEL ",O("LS")="DIR /B "
 Q
 ;
 ; XB*3*2 IHS/ADC/GTH 04-21-97 Correct patch file pattern match.
 ;  Old PATTERN:
 ;;2.4L.2"_"4N1"."1"p"1.2N
SYTM ;;dpssyg
PATTERN ;;2.4L.2"_"4N1"."1.2N1"p"; XB*3*2 IHS/ADC/GTH 04-21-97 Correct patch file pattern match.
WORK ;;ZIBRPI.WRK
PUB ;;/usr/spool/uucppublic/
NS ;;ZIB_P
