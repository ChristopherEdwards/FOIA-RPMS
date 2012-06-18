ACHS ;IHS/ITSC/PMF - CHS SUB-ROUTINES ; [ 01/18/2005  1:14 PM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**2,4,5,7,12,17,18**;JUNE 11,2001
 ;
AD(P) ;EP - Pth piece of AREA DIR info
 Q $P($G(^ACHSDENR(DUZ(2),200)),U,P)
C(X,Y) ;EP - Center X in field len Y
 Q $J("",$S($D(Y):Y,$D(IOM):IOM,1:80)-$L(X)\2)_X
AOP(N,P) ;EP -N=node, P=piece, ret AO Par
 Q $P($G(^ACHSAOP(DUZ(2),N)),U,P)
SUD(P) ;EP - Pth piece of SU DIR info
 Q $P($G(^ACHSDENR(DUZ(2),100)),U,P)
ASF(F) ;EP - Ret ASUFAC given DUZ(2)
 Q:'$D(F) -1
 Q:'F -1
 S F=$P($G(^AUTTLOC(F,0)),U,10)
 Q:'($L(F)=6) -1
 ;ACHS*3.1*4 3/27/02 pmf allow alpha in ASUFAC
 ;Q:'(F?6N) -1  ;ACHS*3.1*4
 I F'?6NA Q -1  ;ACHS*3.1*4
 Q F
BM ;EP - Set bot mar to ACHSBM
 S ACHSBM=IOSL-10
 I '$D(IO("S")),'$D(ZTQUEUED),IO=IO(0) S ACHSBM=IOSL-4
 Q
BRPT ;EP - Stand beg of rpt
 I $D(ACHSQIO) F  S IOP=ACHSQIO D ^%ZIS Q:'POP  H 30
 D BM,NOW
 S ACHSTIME=$$C^XBFUNC($G(ACHSTIME),80)
 S ACHSLOC=$$C^XBFUNC($$LOC,80)
 S ACHSPG=0
 S ACHSUSR=$$USR
 U IO
 Q
CLEAN(FROM) ;EP fr ACHSAVAR-clean err glb > 90 days
 S:FROM="" FROM=$H-90_",00000"
 F  S FROM=$O(^ACHSERR(FROM),-1) Q:FROM=""  D
 .K ^ACHSERR(FROM)
 Q
 ;IF USER-Manager-WARN THEM OF ERR MESS IN ^ACHSERR-CALLED AT THE ENTRY ACT FOR OPT
ISMGR(TMPDUZ) ;EP fr opt ACHSMENU
 Q:'$D(^ACHSERR)
 D VIDEO
 S $P(LINE,"-",IOM+1)=""
 S KEYNUM=$O(^DIC(19.1,"B","ACHSZMENU",""))  ;GET KEY
 Q:'$D(^VA(200,TMPDUZ,51,"B",KEYNUM))
 W !!,$G(IOBON),$G(IORVON),"You have error messages concerning missing"
 W !,"facility or area parameters!!",$G(IOBOFF),$G(IORVOFF)
 W !!,"Please take a look at global ^ACHSERR"
 W !!!,"Press return to continue..."
 D READ^ACHSFU
 D ISMGRHD      ;HEADER FOR THE ERR MESS FILE
 S %H=""
 F  S %H=$O(^ACHSERR(%H)) Q:%H=""  D
 .D YX^%DTC S NOW=Y
 .I $Y>(IOSL-2),(IO(0)=IO) W !!,"Press return to continue..." D READ^ACHSFU D ISMGRHD
 .W !!,NOW,?25,$G(^ACHSERR(%H))
 W !!!,"Press return to continue..."
 D READ^ACHSFU
 K LINE,%H,NOW,KEYNUM
 Q
 ;HDER FOR ABOVE SUB
ISMGRHD ;EP
 W @IOF
 W !,"DATE",?15,"TIME",?25,"MESSAGE"
 W !,LINE
 Q
CLOSEALL ;EP - Close all HFS dev
 S ACHS=""
 F  S ACHS=$O(IO(1,ACHS)) Q:'ACHS  S IO=ACHS D ^%ZISC
 Q
DIR(O,A,B,Q,H,R) ;EP - ^DIR interface
 I '$L($G(O)) Q -1
 N DIR
 S DIR(0)=O
 I $L($G(A)) S DIR("A")=A I $L($O(A(""))) S O="" F  S O=$O(A(O)) Q:'$L(O)  S DIR("A",O)=A(O)
 I $L($G(B)) S DIR("B")=B
 I $L($G(Q)) S DIR("?")=Q
 I $L($G(H)) S DIR("??")=H
 I $G(R) F A=1:1:R W !
 K O,A,B,Q,H,R,DTOUT,DUOUT,DIRUT,DIROUT
 D ^DIR
 Q Y
CPI ;EP
 W !?21,"*** CONFIDENTIAL PATIENT INFORMATION ***"
 Q
DATE(A,N,M) ;EP - prmpt for dt
 ;  A = "B" or "E";  N = Report Name;M = Modifier for prompt
 K DTOUT,DUOUT,DIRUT,DIROUT
 I '$L($G(A)) Q -1
 I '("BE"[$E(A)) Q -1
 I '$D(N) Q -1
 S A="Enter The "_$S(A="B":"BEGINNING",1:"ENDING")_$S($L($G(M)):" "_M,1:"")_" Date For The "_N_" Report"
 K N,M
 F  W !! S Y=$$DIR^XBDIR("DO^::E",A) Q:'(Y>DT)  D FUDT
 Q Y
DIC(D,O,A,B,S) ;EP - DIC Lookup
 N DIC
 S DIC=D,DIC(0)=$G(O)
 I $L($G(A)) S DIC("A")=A
 I $L($G(B)) S DIC("B")=B
 D ^DIC
 Q Y
DIE(DR,Z) ;EP - Ed Doc fld
 I $G(Z) F %=1:1:Z W !
 S DA=ACHSDIEN,DA(1)=DUZ(2),DIE="^ACHSF("_DUZ(2)_",""D"","
 I '$$LOCK("^ACHSF(DUZ(2),""D"",ACHSDIEN)","+") S DUOUT="" Q 0
 D ^DIE
 I '$$LOCK("^ACHSF(DUZ(2),""D"",ACHSDIEN)","-") S DUOUT="" Q 0
 I $D(Y) Q 0
 Q 1
DIET(DR,Z) ;EP - Ed Trans fields
 I $G(Z) F %=1:1:Z W !
 S DA=ACHSTIEN,DA(1)=ACHSDIEN,DA(2)=DUZ(2),DIE="^ACHSF("_DUZ(2)_",""D"","_ACHSDIEN_",""T"","
 I '$$LOCK("^ACHSF(DUZ(2),""D"",ACHSDIEN,""T"",ACHSTIEN)","+") S DUOUT="" Q 0
 D ^DIE
 I '$$LOCK("^ACHSF(DUZ(2),""D"",ACHSDIEN,""T"",ACHSTIEN)","-") S DUOUT="" Q 0
 I $D(Y) Q 0
 Q 1
DF(S,P) ;EP - Ret Def Svc fr node S, piece P
 NEW Y
 S Y=$G(ACHSA)
 I Y="" S Y=$G(ACHSDA)
 I Y="" Q 0
 ;End New Code;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 ;1/3/02  pmf mod nxt ln to get the rght var ACHS*3.1*2
 ;Q $P($G(^ACHSDEF(DUZ(2),"D",ACHSDA,S)),U,P)
 Q $P($G(^ACHSDEF(DUZ(2),"D",Y,S)),U,P)
DN(S,P) ;EP - Ret Denial data from node S, piece P
 Q $P($G(^ACHSDEN(DUZ(2),"D",ACHSA,S)),U,P)
DOC(S,P) ;EP - Ret Doc data from node S, piece P
 Q $P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,S)),U,P)
EBB(B,E) ;EP - Compare Beg and End dates for a rep
 I '(E<B) Q 0
 W !!,*7,"The END date is before the BEGINNING date."
 Q 1
ERPT ;EP - Stand end of a rep
 D ^%ZISC
 K ACHS,ACHSBDT,ACHSBM,ACHSEDT,ACHSIO,ACHSLOC,ACHSPG,ACHSQIO,ACHSRPT,ACHST1,ACHST2,ACHST3,ACHSTIME,ACHSUSR,ACHSX,ACHSY,DTOUT,DUOUT,X2,X3,Y
 K ACHD,ACHDBDT,ACHDBM,ACHDEDT,ACHDHAT,ACHDIO,ACHDLOC,ACHDPG,ACHDQIO,ACHDRPT,ACHDT1,ACHDT2,ACHDT3,ACHDTIME,ACHDUSR,ACHDX,ACHDY,DTOUT,DUOUT,X2,X3,Y
 Q
EX() ;EP - Ret file Exp dir
 ;I $$OS=1 Q "/usr/spool/uucppublic/" ;ACHS*3.1*17 2/4/2010 IHS.OIT.FCJ CHG NXT LINE
 I $$OS=1,$L($P($G(^AUTTSITE(1,1)),U,2)) Q $P($G(^AUTTSITE(1,1)),U,2) ;unx
 I $$OS=2,$L($P($G(^AUTTSITE(1,1)),U,2)) Q $P($G(^AUTTSITE(1,1)),U,2)
 Q "C:\EXPORT\"
FC(Y) ;EP - Ret Fin Code of site Y (DUZ(2))
 N X
 I Y="" Q "UNDEFINED"
 S X=$P($G(^AUTTLOC(Y,0)),U,4)
 I X="" Q "UNDEFINED"
 Q $P($G(^AUTTAREA(X,0),"UNDEFINED"),U,3)_$E($P($G(^AUTTLOC(Y,0),"UNDEFINED"),U,17),2,3)
FMT ;EP
 S:'$D(X2) X2="2$"
 S:'$D(X3) X3=0
 D COMMA^%DTC
 S:'X3 X=$P(X," ")
 W X
 K X2,X3
 Q
FUDT ;EP
 W !!,*7,"Do not use future dates."
 Q
FYSEL(X) ;EP
 D:'$G(X) SB1^ACHSFU
 N MIN,MAX
 ; FY selection if in the CHS globals
 F %=0:0 S %=$O(ACHSFYWK(DUZ(2),%)) Q:'%  S MIN=$S('$D(MIN):%,1:MIN),MAX=%
 S O="N^"_MIN_":"_MAX_":0",B=MAX
 K MIN,MAX
 Q $$DIR^XBDIR(O,"ENTER FISCAL YEAR",B,"","Invalid FY, Enter FY with all 4 digits","^D SB1^ACHSFU",1)
GDT(JDT) ;EP - Given Julian Date, ret Gregorian Date-Ext format.
 Q:'$G(JDT) -1
 Q:JDT<0 -1
 Q:JDT>366 -1
 Q $$HTE^XLFDT($P($$FMTH^XLFDT($S(JDT>$$JDT(DT):($E(DT,1,3)-1),1:$E(DT,1,3))_"0101"),",")+JDT-1)
 ;
 Q "NOT FOUND"
H ;EP - menu header
 ;D VIDEO
 W @IOF
 D STATUSLN
 D VIDEO
 ;ACHS*3.1*18 6.30.2010 IHS.OIT.FCJ ADDED NXT 4 LINES
 S X=$O(^DIC(9.4,"C","ACHS",0))  ;ACHS*3.1*18
 S V=$G(^DIC(9.4,X,"VERSION"))   ;ACHS*3.1*18
 S A=$O(^DIC(9.4,X,22,"B",V,0))  ;ACHS*3.1*18
 S P=0 F  S P=$O(^DIC(9.4,X,22,A,"PAH","B",P)) Q:P'?1.N.N  S P1=P     ;ACHS*3.1*18
 S MENTITLE=$J("",2*$L(IORVON)-1)_IORVON_$P(XQY0,U,2)_IORVOFF
 ;W !!!,$$C^XBFUNC($P($T(ACHS+1),";",4)_", "_$$CV^XBFUNC("ACHS")),!,$$C^XBFUNC($$LOC()),!,$$C^XBFUNC(MENTITLE) ;ACHS*3.1*18 6.30.2010 IHS.OIT.FCJ
 W !!,$$C^XBFUNC($P($T(ACHS+1),";",4)),!,$$C^XBFUNC("VERSION: "_$$CV^XBFUNC("ACHS")_" PATCH "_P1),!,$$C^XBFUNC($$LOC()),!,$$C^XBFUNC(MENTITLE) ;ACHS*3.1*18 6.30.2010 IHS.OIT.FCJ
 Q
STATUSLN ;
 I $$VERSION^%ZOSV(1)["NT" Q
 ;S DX=0,DY=IOSL-1
 S JOB=$J
 X ^%ZOSF("UCI")   ;GET CURRENT UCI,VOL
 S MYLINE="Device: "_$G(IO)_" Job no.: "_JOB_"  Unix Device: "_$G(IO("ZIO"))_"  [UCI,VOL]: "_Y
 D PREP^XGF
 D SAY^XGF(1,1,MYLINE,"R1")
 D CLEAN^XGF
 Q
 ;
HELP(L,R) ;EP - Dis at label L, routine R.
 N X
 W !
 F %=1:1 S X=$T(@L+%^@R) Q:($P(X,";",3)="###")!(X="")  D
 . I $P(X,";",3)="@" W @($P(X,";",4)) Q
 . W !?4,$P(X,";",3)
 .Q
 Q
 ;
HRN(P,L) ;EP - Ret HRN for DFN P, DUZ(2) L.
 ;ITSC/SET/JVK ACHS*3.1*12 ADD BELOW COMMENT FOR IHS/OKCAO/POC PAWNEE BEN. PKG.
 ;I +$P($G(^AUTTLOC(DUZ(2),0)),U,1)=505613 Q $$GET1^DIQ(1808000,P_",",1
 Q $P($G(^AUPNPAT(P,41,L,0)),U,2)
 ;
IM() ;EP - ReT file Imp dir
 ;I $$OS=1 Q "/usr/spool/uucppublic/" ;ACHS*3.1*17 2/4/2010 IHS.OIT.FCJ CHG TO NXT LN
 I $$OS=1,$L($P($G(^AUTTSITE(1,1)),U)) Q $P($G(^AUTTSITE(1,1)),U) ;UNIX IMPORT PATH
 I $$OS=2,$L($P($G(^AUTTSITE(1,1)),U)) Q $P($G(^AUTTSITE(1,1)),U) ;DOS IMPORT PATH
 Q "C:\IMPORT\"
 ;
INSURED(DFN,ACHSDATE) ;EP - Does pt have INS on a dt
 I $$MCR^AUPNPAT2(DFN,ACHSDATE) Q 1
 I $$MCD^AUPNPAT2(DFN,ACHSDATE) Q 1
 I $$PI^AUPNPAT2(DFN,ACHSDATE) Q 1
 I $$RRE(DFN,ACHSDATE) Q 1
 Q 0
 ;
JDT(X1,ACHS) ;EP - Given FM dt, Ret Julian Dt. IF ACHS, 3 places.
 Q:'$D(X1) -1
 Q:'(X1?7N) -1
 S X2=$E(X1,1,3)_"0101"
 D ^%DTC
 I '$G(ACHS) Q X+1
 S ACHS=X+1,ACHS="000"_ACHS
 Q $E(ACHS,$L(ACHS)-2,$L(ACHS))
 ;
JTF(JDT) ;EP - Given Julian dt ret fm dt
 Q:'$G(JDT) -1
 Q:JDT<0 -1
 Q:JDT>366 -1
 Q $$FMADD^XLFDT($S(JDT>$$JDT(DT):($E(DT,1,3)-1),1:$E(DT,1,3))_"0101",JDT-1)
 ;
L(F,N) ;EP - F = File #; N = Field #.
 Q:$D(ZTQUEUED)!$D(IO("S"))!($G(IOST)'["C-")
 W !?($L($P($G(^DD(F,N,0)),U))+1),"|",$$REPEAT^XLFSTR("-",+$P($P($G(^DD(F,N,0)),U,5),">",2)),"|"
 Q
 ;
LOC() ;EP - Ret loc
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P($G(^DIC(4,DUZ(2),0)),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;
LOCK(V,M) ;EP - LOCK var V, mode M (+/-).
 I '$L($G(M)) W !,"MODE NOT DEFINED IN LOCK CALL." D RTRN Q 0
 I '("+-"[$G(M)) W !,"BAD MODE PARAMETER IN LOCK CALL." D RTRN Q 0
 N C,L
 S C=0,L=10
 G:M="-" LOCK1
 F  LOCK +@V:3 G:$T LOCK2 G:C=L LOCK2 D LOCKMSG
 Q:$T  ;FCJ
LOCK1 ;
 F  LOCK -@V:3 Q:$T  Q:C=L  D LOCKMSG
LOCK2 ;
 E  W:'$D(ZTQUEUED) *7,*7,!,$S(M="-":"UN",1:""),"LOCK OF '",V,"' FAILED.",!!,"NOTIFY PROGRAMMER IMMEDIATELY." D RTRN I 0
 Q $T
 ;
LOCKMSG ;
 S C=C+1
 Q:$D(ZTQUEUED)
 W !,$S(M="-":"UN",1:""),"LOCK of node '",V,"' failed.  Retry ",C," of ",L,"."
 Q
 ;
LOGO ;EP - Dis logo-main menu
 N A,D,I,L,N,R,V
 S L=18,R=61,D=R-L+1,N=R-L-1
 ;
 S I=$O(^DIC(9.4,"C","ACHS",0))  ;CHECK FOR IEN OF ACHS PACKAGE ENTRY
 I I="" W !!,"PACKAGE FILE ENTRY FOR THE 'CONTRACT HEALTH MGMT SYSTEM' IS INCOMPLETE!",!,"INFORM YOUR SITE MANAGER IMMEDIATELY!!" Q
 ;
 S V=$G(^DIC(9.4,I,"VERSION"))   ;CHECK CURRENT VERSION NUMBER
 I V="" W !!,"PACKAGE FILE ENTRY FOR THE 'CONTRACT HEALTH MGMT SYSTEM' IS INCOMPLETE!",!,"INFORM YOUR SITE MANAGER IMMEDIATELY!!"
 ;
 S A=$O(^DIC(9.4,I,22,"B",V,0))   ;  
 S Y=$$FMTE^XLFDT($P($G(^DIC(9.4,I,22,A,0)),U,2))   ;'DATE DISTIBUTED'
 S P=0 F  S P=$O(^DIC(9.4,I,22,A,"PAH","B",P)) Q:P'?1.N.N  S P1=P     ;ACHS*3.1*18 6.30.2010 IHS.OIT.FCJ ADDED LINE, SPLIT NXT LINE AND ADDED PATCH #
 W @IOF,!,$$C^XBFUNC($$REPEAT^XLFSTR("*",D)),!?L,"*",$$C^XBFUNC("Indian Health Service",N),?R,"*",!?L,"*",$$C^XBFUNC($P($T(ACHS+1),";",4),N),?R,"*"
 W !?L,"*",$$C^XBFUNC("Version "_V_" Patch "_P1_", "_Y,N),?R,"*",!,$$C^XBFUNC($$REPEAT^XLFSTR("*",D))
 W !!,$$C^XBFUNC($$LOC())
 Q
NOW ;EP - Set cur time into ACHSTIME
 S ACHSTIME=$$HTE^XLFDT($H)
 Q
OS() ;EP - Ret OS fr ^%ZOSF("OS") or RPMS Site file.
 I $G(^%ZOSF("OS"))["MSM-UNIX" Q 1
 I $G(^%ZOSF("OS"))["MSM-PC" Q 2
 ;IHS/SET/JVK ACHS*3.1*7 ADDED FOR CACHE SITES
 I $G(^%ZOSF("OS"))["OpenM-NT",($P($G(^AUTTSITE(1,0)),U,21)) Q $P($G(^AUTTSITE(1,0)),U,21)
 I $P($G(^AUTTSITE(1,0)),U,21) Q $P($G(^AUTTSITE(1,0)),U,21)
 Q 1 ; Default is UNIX if "OS" and RPMS SITE can't determine.
PARM(N,P) ;EP - N = node, P= piece, return the fac parameter value.
 Q $P($G(^ACHSF(DUZ(2),N)),U,P)
PB() ;EP - Print/Browse.
 Q $$DIR^XBDIR("SO^P:PRINT Output;B:BROWSE Output on Screen","Do you want to ","PRINT","","","",2)
PTLK ;EP  Stand pt lookup using DIC.
 N ACHSDUZ2
 I $$PARM(2,5)="Y" S ACHSDUZ2=DUZ(2),DUZ(2)=0
 ;ITSC/SET/JVK ACHS*3.1*12 ADD BELOW FOR IHS/OKCAO/POC PAWNEE BEN
 I +$P($G(^AUTTLOC(DUZ(2),0)),U,10)=505613 D
 .D PAWNEE
 .Q
 ;Below REDONE IN THE ELSE D LOOP
 ;S DIC="^AUPNPAT(",DIC(0)="AEMQ",AUPNLK("INAC")=""
 ;I $G(DFN),$D(^DPT(DFN,0)) S DIC("B")=$P($G(^DPT(DFN,0)),U)
 ;D ^DIC
 ;K DFN,DIC,AUPNLK("INAC")
 ;I Y'<1 S DFN=+Y
 E  D
 .S DIC="^AUPNPAT(",DIC(0)="AEMQ",AUPNLK("INAC")=""
 .I $G(DFN),$D(^DPT(DFN,0)) S DIC("B")=$P($G(^DPT(DFN,0)),U)
 .D ^DIC
 .K DFN,DIC,AUPNLK("INAC")
 .I Y'<1 S DFN=+Y
 ;ITSC/SET/JVK END CHGS
 I $G(ACHSDUZ2) S ACHSYAYA=ACHSDUZ2,DUZ(2)=ACHSDUZ2
 K ACHSYAYA
 Q
RPL(X,Y,Z) ;EP - In X, Replace Y with Z.
 F  Q:'$F(X,Y)  S X=$P(X,Y,1)_Z_$P(X,Y,2,999)
 Q X
RTRN ;EP - ask usr to press RET
 S ACHSQUIT=0
 I IOST["C-",'$D(IO("S")) S Y=$$DIR^XBDIR("E","Press RETURN To Continue or Escape or ^ to Cancel...","","","",1) X ^%ZOSF("TRMRD") I Y=0!(Y=27)!(X=U) S ACHSQUIT=1 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 Q
SB(X) ;EP - Strip leading & trailing blanks from X.
 X ^DD("FUNC",$O(^DD("FUNC","B","STRIPBLANKS",0)),1)
 Q X
TRAN(S,P) ;EP -  Ret Transaction data from node S, piece P
 ; S will always be 0.
 Q $P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",ACHSTIEN,S)),U,P)
USR() ;EP - Ret name of current user for ^VA(200.
 I $G(DUZ)="" Q "DUZ UNDEFINED"
 I $G(DUZ)=0 Q "DUZ IS 0"
 I $D(^VA(200,DUZ,0))#2 Q $P(^VA(200,DUZ,0),U,1)
 Q "UNK"
VIDEO ;EP - Set reverse video vars
 S X="IORVON;IORVOFF;IOBON;IOBOFF;IOINORM" D ENDR^%ZISS
 ;At list vars code for normal follows codes for blinking and reverse.
 S IZZZNORM=$G(IOINORM)
 Q
YN ;EP
 W !!,"Enter a ""Y"" for YES or an ""N"" for NO."
 Q
HDR ;EP - Print menu header.
 S X=$O(^DIC(19,"B",X,0))
 I X="" W !!,"MENU HEADER CANNOT BE PRINTED!" Q
 S X=$P($G(^DIC(19,X,0)),U,2)
 G SHDR
PHDR ;EP - Print parent menu header.
 S X=$P($G(^DIC(19,+^XUTL("XQ",$J,^XUTL("XQ",$J,"T")-1),0)),U,2)
 Q:'$L(X)
 S Y=+^XUTL("XQ",$J,^XUTL("XQ",$J,"T")-1)
 I Y=0 W !!,"PARENT MENU CANNOT BE FOUND IN XUTL!" Q
 S Y=$P($G(^DIC(19,Y,0)),U)
 I Y="ACHSMENU" D LOGO Q
SHDR ;EP - Screen header.
 I '$D(IORVOFF) D VIDEO
 W @IOF,!,$$C^XBFUNC($P($T(ACHS+1),";",4)),!,$$C^XBFUNC($$LOC()),!,$$C^XBFUNC(X),!!
 Q
ZEROTH(A,B,C,D,E,F,G,H,I,J,K) ;EP - Return 0th node.  A is file #, rest fields.
 N Z
 I '$G(A) Q -1
 I '$G(B) Q -1
 F Z=67:1:75 Q:'$G(@($C(Z)))  S A=+$P($G(^DD(A,B,0)),U,2),B=@($C(Z))
 I 'A!('B) Q -1
 I '$D(^DD(A,B,0)) Q -1
 Q U_$P($G(^DD(A,B,0)),U,2)
RRE(P,D) ; Does pt have Railroad insurance on date?  1 = yes, 0 = no.
 ; I = IEN in ^AUPNRRE multiple.
 I '$G(P) Q 0
 I '$G(D) Q 0
 N I,Y
 S Y=0,U="^"
 I '$D(^DPT(P,0)) G RREX
 I $P($G(^DPT(P,0)),U,19) G RREX
 I '$D(^AUPNPAT(P,0)) G RREX
 I '$D(^AUPNRRE(P,11)) G RREX
 I $D(^DPT(P,.35)),$P(^DPT(P,.35),U)]"",$P($G(^DPT(P,.35)),U)<D G RREX
 S I=0
 F  S I=$O(^AUPNRRE(P,11,I)) Q:I'=+I  D
 . Q:$P(^AUPNRRE(P,11,I,0),U)>D
 . I $P($G(^AUPNRRE(P,11,I,0)),U,2)]"",$P($G(^AUPNRRE(P,11,I,0)),U,2)<D Q
 . S Y=1
 .Q
RREX ;
 Q Y
FY(%) ;EP - Given a FY, return beg/end dates.
 NEW X,Y
 S X=$P($G(^ACHSF(DUZ(2),0)),U,6),Y=+$P($G(^ACHSF(DUZ(2),0)),U,7)
 S %=$S(%>50:2,1:3)_%-Y
 S X=%_X
 S %=$E(X,1,3)
 S Y=%+$S($E(X,4,7)="0101":0,1:1) ; Year
 S %=$E(X,4,5) I $E(X,6,7)="01" S %=%-1 I '% S %=12
 S %="0"_%,%=$E(%,$L(%)-1,$L(%)) ; Month
 S Y=$E(Y,1,3)_%_$P("31^28^31^30^31^30^31^31^30^31^30^31",U,%) ; Day
 I $E(Y,4,5)="02",'((1700+$E(Y,1,3))#4) S Y=$E(Y,1,5)_"29"
 I $E(X,4,5)=$E(Y,4,5) S %=$E(X,6,7),%=%-1,%="0"_%,%=$E(%,$L(%)-1,$L(%)),Y=$E(Y,1,5)_%
 Q X_U_Y
PAWNEE ;ITSC/SET/JVK ACHS*3.1*12 ADD FOR IHS/OKCAO/POC PAWNEE BEN PKG
 S DIC=1808000,DIC(0)="IQAZEM" S:+$G(DFN) DIC("B")=$P($G(^DPT(DFN,0)),U)
 D ^DIC K DIC
 I $D(DUOUT)!(+Y<0) K DFN Q
 S DFN=+Y,ACHSBPNO=$P($G(^AZOPBPP(+Y,0)),U,2)
 W !,"PAWNEE BENEFIT NUMBER: ",ACHSBPNO
 S PBEXDT=+$P($G(^AZOPBPP(+Y,0)),U,3),Y=PBEXDT X ^DD("DD")
 I PBEXDT<DT W !!,*7,"PBPP Eligibility Card Expired on ",Y,"  --TRANSACTION CANCELLED" K DFN Q
 Q
