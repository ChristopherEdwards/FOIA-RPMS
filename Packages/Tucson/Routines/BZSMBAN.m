BZSMBAN ;IHS/BZSM/EDE - OPTION HEADERS [ 03/27/2003  3:38 PM ]
 ;;1.0;TUCSON AREA OFFICE W/O;;MAR 14, 2003
 ;
 ;****** Send this routine with each new patch with **n** in piece
 ;****** 3 so the patch level can be displayed as part of the
 ;****** menu header.
 ;
HDR ;EP - Screen header.
 D:'$D(BZSASFCD) SETVARS ;   set variables if 1st time thru
 Q:$G(BZSQUIT)  ;            quit if fatal error
 ; make sure reverse video hasn't been lost
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 S BZSMT=$P($G(XQY0),U,2)
 S:BZSMT="" BZSMT="TAO Write Off Old Bills Main Menu"
 S BZSPNV=BZSPNM_" "_BZSVER
 ; if unable to set reverse video use " instead, F must=0 
 NEW A,D,F,I,L,N,R,V
 S F=0
 W @IOF ;                    reverse video on/off must not wrap
 I IORVON'="""" S A=$X W IORVON,IORVOFF S D=$X S:D>A F=D-A ;compute length of revvideo
 S L=18,R=61,D=R-L+1,N=R-L-1
 W !,$$CTR($$REPEAT^XLFSTR("*",D)),!
 W ?L,"*",$$CTR(BZSPNV,N),?R,"*",!
 W ?L,"*",$$CTR($$LOC(),N),?R,"*",!
 W ?L,"*",?(L+(((R-L)-$L(BZSMT))\2)),IORVON,BZSMT,IORVOFF,?R+F,"*",!
 W $$CTR($$REPEAT^XLFSTR("*",D)),!
 K BZSMT,BZSPNV,BZSNULL
 Q
 ;
SETVARS ;EP - SET PACKAGE VARIABLES
 S:'$D(U) U="^" ;                insure U is correct
 ; set form feed, set to null if IOF not available
 D:'$D(IOF) HOME^%ZIS ;          make sure screen vars there
 S BZSNULL=""
 I '$D(IOF) S IOF="BZSNULL" ;    write null if no form feed
 ; check site Kernel variables
 I '$D(DUZ(2)) D  S BZSQUIT=1 Q
 .  W !!,"DUZ(2) has not been set by the KERNEL.",!
 .  W "Please contact your System Support person.",!!
 .  Q
 ; insure site exists
 I '$D(^DIC(4,DUZ(2),0)) D  S BZSQUIT=1 Q
 .  W !!,"The DUZ(2) site does not exist.  DUZ(2)="_DUZ(2),!
 .  W "Please contact your System Support person.",!!
 .  Q
 S BZSSITE=DUZ(2) ;                save site IEN
 ; get site name
 S BZSSTNM=$P(^DIC(4,DUZ(2),0),U)
 ; set asufac code
 S BZSASFCD=$P(^AUTTLOC(DUZ(2),0),U,10)
 ; check fileman access
 I $G(DUZ(0))'["V",$G(DUZ(0))'["@" D  S BZSQUIT=1 Q
 .  W !!,"You do not have the appropriate FileMan access.",!
 .  W "Please contact your System Support person.",!!
 .  Q
 ; set BZSTOP to highest level option
 I $G(XQY0)'="",$G(BZSTOP)="" S BZSTOP=XQY0
 ; set package version and package name
 S (BZSPNM,BZSVER)=""
 NEW Y
 S Y=$O(^DIC(9.4,"C","BZSM",""))
 I Y D
 .  S BZSVER=$G(^DIC(9.4,Y,"VERSION"))
 .  Q:BZSVER=""
 .  S BZSVER="V"_BZSVER
 .  S BZSPNM=$P($G(^DIC(9.4,Y,0)),U) ;get package name
 .  Q
 ; add patch level to version
 S X=$T(+2),X=$P(X,";;",2),X=$P(X,";",3),X=$P(X,"**",2),X=$P(X,",",$L(X,","))
 S:X]"" BZSVER=BZSVER_"P"_X
 ; insure package name
 S:$G(BZSPNM)="" BZSPNM="TUCSON AREA OFFICE WRITE OFF"
 ; set reverse video
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 I $G(IORVON)="" S (IORVON,IORVOFF)="""" ;use " if no reverse video
 ; set right margin if it isn't set already
 S:'$D(IOM) IOM=80 ;               default margin to 80 if unknown
 Q
 ;
 ;==========
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
LJRF(X,Y,Z) ;EP - left justify X in a field Y wide, right filling with Z.
 NEW L,M
 I $L(X)'<Y Q $E(X,1,Y-1)_Z
 S L=Y-$L(X)
 S $P(M,Z,L)=Z
 Q X_M
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;==========
 ;
BOHDR ; BACK OUT HEADER
 ; this entry point allows an option to display the header of
 ; a menu being backed into from a selected item that is a run
 ; routine.  option file header field help indicates the header
 ; for a menu option should be re-executed when being backed
 ; into from a selected item but it only works if the selected
 ; item is a menu.
 ;
 NEW XQY0
 S XQY0=$P($G(XQSV),U,3,4) ;              get parent menu
 S:XQY0="" XQY0="^Parent Menu Unknown" ;  default if xqsv not there
 D HDR
 Q
