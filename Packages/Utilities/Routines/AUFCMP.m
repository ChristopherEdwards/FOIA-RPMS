AUFCMP ; COMPARES FILEMAN FILES IN TWO UCIs [ 05/31/88  2:00 PM ]
 ;
 ; Ignores the following:
 ;   ^DD(file,field,1,0)
 ;   ^DD(file,field,21
 ;   ^DD(file,field,"DT"
 ;
 ; If a field does not exist in one file, a message is displayed and
 ;   all sub-nodes of that field are ignored.
 ;
 ; If the compare is limited to fields containing a particular GROUP,
 ;   the second pass, which checks for entries in the secondary UCI
 ;   not in the primary UCI, is not executed.  On the first pass the
 ;   the GROUP multiple in the secondary UCI is ignored.
 ;
START ;
 W !,"This program compares FileMan files in two different UCIs."
 S U="^"
 D ^%GUCI
 S AUFCMPU1=%UCI
 W !!,"Primary UCI is ",AUFCMPU1
 D GET2ND
 I AUFCMPU2="" W !!,"Bye",! D EOJ Q
 D ^AUDSET
 I '$D(^UTILITY("AUDSET",$J)) W !!,"No files selected",! D EOJ Q
 R !!,"Only check fields with GROUP: ",GROUP  I GROUP="" K GROUP
 S AUFCMPFL="" F AUFCMPL=0:0 S AUFCMPFL=$O(^UTILITY("AUDSET",$J,AUFCMPFL)) Q:AUFCMPFL'=+AUFCMPFL  D AUFCMPFL
 D EOJ
 Q
 ;
AUFCMPFL ;
 W !!,AUFCMPFL,!
 S AUFCMPG="DIC" D COMPARE
 S AUFCMPG="DD" D COMPARE
 S AUCDFILE=AUFCMPFL D SBTRACE S AUFCMPFL=AUCDFILE
 Q
 ;
COMPARE ;
 S AUFCMPP="^["""_AUFCMPU1_"""]"_AUFCMPG_"("_AUFCMPFL_","_$S(AUFCMPG="DIC":"0,",1:"")
 S AUFCMPS="^["""_AUFCMPU2_"""]"_AUFCMPG_"("_AUFCMPFL_","_$S(AUFCMPG="DIC":"0,",1:"")
 I '$D(@($E(AUFCMPS,1,$L(AUFCMPS)-1)_")")) W "  File not in ^"_AUFCMPG_" of secondary UCI" Q
 S AUGP=AUFCMPP,AUGS=AUFCMPS,AUGPASS=1
 D AUGCMP
 S AUGP=AUFCMPS,AUGS=AUFCMPP,AUGPASS=2
 D AUGCMP
 Q
 ;
SBTRACE ; CHECK ALL SUB-FILES
 K AUCDSFL S AUCDC=1,AUCDSFL="",AUCDSFL(AUCDC)=AUCDFILE
 F AUCDL=0:0 S AUCDI=$O(AUCDSFL("")) Q:AUCDI=""  S AUCDSF=AUCDSFL(AUCDI) D SBTRACE2 S AUCDI=$O(AUCDSFL("")) W "."  K AUCDSFL(AUCDI)
 K AUCDC,AUCDI,AUCDSF,AUCDSFL,AUCDY,AUCDZ
 Q
SBTRACE2 ;
 S AUCDI=0 F AUCDL=0:0 S AUCDI=$O(^DD(AUCDSF,"SB",AUCDI)) Q:AUCDI=""  W "." S AUCDC=AUCDC+1,AUCDSFL(AUCDC)=AUCDI D SBTRACE3
 Q
SBTRACE3 ;
 W !!,AUCDI,!
 S AUFCMPG="DD"
 S AUFCMPFL=AUCDI
 D COMPARE
 Q
 ;
GET2ND ; GET SECONDARY UCI
 S AUFCMPU2=""
 R !!,"Secondary UCI: ",X Q:X=""!(X="^")
 ;X ^%ZOSF("UCICHECK")
 ;I X'=Y W !!,"Invalid UCI",! Q
 S AUFCMPU2=X
 Q
 ;
EOJ ;
 K AUCDFILE,AUCDL
 K %UCI,%UCN,AUFCMPFL,AUFCMPG,AUFCMPL,AUFCMPP,AUFCMPS,AUFCMPU1,AUFCMPU2,X,Y
 Q
 ;
AUGCMP ; COMPARES GLOBAL TREES [ 02/16/88  10:11 AM ]
 ; CREATED BY GIS 7/17/85 FOR MSM UNIX MUMPS (2.3)
 I $D(GROUP),AUFCMPG="DD",AUGPASS=2 Q
 D SEARCH K AUGP,AUGS,AUGPASS Q
SEARCH ; 
EDE0 ;W !!,">>>>>>> ",AUGPASS," <<<<<<<",!!
 ;N (AUGP,AUGS,AUGPASS,GROUP)
 S T="T",C=",",P=")",NT=$L(AUGP,C)-1,L=1,T1=""
 S TT=AUGP F I=1:1:30 S TT=TT_T_I_C
EXTR S X=T_L,Y=$P(TT,C,1,L+NT)_P,@X=$O(@Y)
 I @X'="" D:$D(@(Y))#2 SUB S L=L+1,@(T_L)="" G EXTR
 S L=L-1 Q:L=0  G EXTR
SUB W "." S ZZ=AUGS_$P(Y,AUGP,2)
 I $D(@Y)
EDE1 ;W !,$ZR
 Q:$P($ZR,"DD(",2)?.".".N.".".N1",".".".N.".".N1",21,".E
 Q:$P($ZR,"DD(",2)?.".".N.".".N1",".".".N.".".N1",""DT""".E
 Q:$P($ZR,"DD(",2)?.".".N.".".N1",".".".N.".".N1",1,0)"
EDE2 ;W !,$ZR
 I $D(SKIP),SKIP=$E($ZR,1,$L(SKIP)) Q
 K SKIP
 I $D(GROUP),$P($ZR,"DD(",2)?.".".N.".".N1",".".".N.".".N1",0)" D CHKGROUP I NOGROUP S SKIP=$E($ZR,1,$L($ZR)-3) Q
 I '$D(@ZZ),$P($ZR,"DD(",2)?.".".N.".".N1",".".".N.".".N1",0)" W !,$ZR," <",$P(@Y,"^",1)," field does not exist>" S SKIP=$E($ZR,1,$L($ZR)-3) Q
 I $D(GROUP),$P($ZR,"DD(",2)?.".".N.".".N1",".".".N1",20,".E Q
 I '$D(@ZZ) W !,$ZR,"=",@Y," <does not exist>" Q
 Q:AUGPASS=2
 I @ZZ'=@Y W !,$ZR," <differs>",!,@ZZ,!,@Y Q
 Q
 ;
CHKGROUP ;
 S GDFN=0,NOGROUP=1,GROOT=$E($ZR,1,$L($ZR)-3)
EDE3 ;W !,GDFN,"-",GROOT,"-",$ZR
 F GL=0:0 S GDFN=$O(@(GROOT_",20,GDFN)")) Q:GDFN=""  I @(GROOT_",20,GDFN,0)")=GROUP S NOGROUP=0 Q
 I $D(@Y)
EDE4 ;W !,"NOGROUP=",NOGROUP," ","$ZR=",$ZR,!
 Q
