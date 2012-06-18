XBFCMP ; IHS/ADC/GTH - COMPARES FILEMAN FILES IN TWO UCIs ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
 ; Ignores the following:
 ;   ^DD(file,0,"PT",
 ;   ^DD(file,field,1,0)
 ;   ^DD(file,field,21
 ;   ^DD(file,field,"DT"
 ;
 ; If a field does not exist in one file, a message is
 ; displayed and all sub-nodes of that field are ignored.
 ;
 ; If the compare is limited to fields containing a
 ; particular GROUP, the second pass, which checks for
 ; entries in the secondary UCI not in the primary UCI, is
 ; not executed.  On the first pass the GROUP multiple in the
 ; secondary UCI is ignored.
 ;
START ;
 NEW XBWHERE S XBWHERE=$S($$VERSION^%ZOSV(1)["Cache":"Namespace",1:"UCI") ;IHS/SET/GTH XB*3*9 10/29/2002
 NEW GROUP
 ; W !,"This program compares FileMan files in two different UCIs." ;IHS/SET/GTH XB*3*9 10/29/2002
 W !,"This program compares FileMan files in two different ",XBWHERE,"s." ;IHS/SET/GTH XB*3*9 10/29/2002
 S U="^"
 X ^%ZOSF("UCI")
 S XBFCMPU1=$P(Y,",",1)
 ;W !!,"Primary UCI is ",XBFCMPU1 ;IHS/SET/GTH XB*3*9 10/29/2002
 W !!,"Primary ",XBWHERE," is ",XBFCMPU1 ;IHS/SET/GTH XB*3*9 10/29/2002
 D GET2ND
 I XBFCMPU2="" W !!,"Bye",! D EOJ Q
 D ^XBDSET
 I '$D(^UTILITY("XBDSET",$J)) W !!,"No files selected",! D EOJ Q
 R !!,"Only check fields with GROUP: ",GROUP:$G(DTIME,999)
 I GROUP="" KILL GROUP
 S XBFCMPFL=""
 F XBFCMPL=0:0 S XBFCMPFL=$O(^UTILITY("XBDSET",$J,XBFCMPFL)) Q:XBFCMPFL'=+XBFCMPFL  D XBFCMPFL
 D EOJ
 Q
 ;
XBFCMPFL ;
 W !!,XBFCMPFL,!
 F XBFCMPG="DIC","DD" D COMPARE
 S XBCDFILE=XBFCMPFL
 D SBTRACE
 S XBFCMPFL=XBCDFILE
 Q
 ;
COMPARE ;
 S XBFCMPP="^["""_XBFCMPU1_"""]"_XBFCMPG_"("_XBFCMPFL_","_$S(XBFCMPG="DIC":"0,",1:"")
 S XBFCMPS="^["""_XBFCMPU2_"""]"_XBFCMPG_"("_XBFCMPFL_","_$S(XBFCMPG="DIC":"0,",1:"")
 ;I '$D(@($E(XBFCMPS,1,$L(XBFCMPS)-1)_")")) W "  File not in ^",XBFCMPG," of secondary UCI" Q ;IHS/SET/GTH XB*3*9 10/29/2002
 I '$D(@($E(XBFCMPS,1,$L(XBFCMPS)-1)_")")) W "  File not in ^",XBFCMPG," of secondary ",XBWHERE Q  ;IHS/SET/GTH XB*3*9 10/29/2002
 S XBGP=XBFCMPP,XBGS=XBFCMPS,XBGPASS=1
 D XBGCMP
 S XBGP=XBFCMPS,XBGS=XBFCMPP,XBGPASS=2
 D XBGCMP
 Q
 ;
SBTRACE ; CHECK ALL SUB-FILES
 KILL XBCDSFL
 S XBCDC=1,XBCDSFL="",XBCDSFL(XBCDC)=XBCDFILE
 F XBCDL=0:0 S XBCDI=$O(XBCDSFL("")) Q:XBCDI=""  S XBCDSF=XBCDSFL(XBCDI) D SBTRACE2 S XBCDI=$O(XBCDSFL("")) W "." KILL XBCDSFL(XBCDI)
 KILL XBCDC,XBCDI,XBCDSF,XBCDSFL,XBCDY,XBCDZ
 Q
 ;
SBTRACE2 ;
 S XBCDI=0
 F XBCDL=0:0 S XBCDI=$O(^DD(XBCDSF,"SB",XBCDI)) Q:XBCDI=""  W "." S XBCDC=XBCDC+1,XBCDSFL(XBCDC)=XBCDI D SBTRACE3
 Q
 ;
SBTRACE3 ;
 W !!,XBCDI,!
 S XBFCMPG="DD",XBFCMPFL=XBCDI
 D COMPARE
 Q
 ;
GET2ND ; GET SECONDARY UCI
 S XBFCMPU2=""
 ;R !!,"Secondary UCI: ",X:$G(DTIME,999) ;IHS/SET/GTH XB*3*9 10/29/2002
 W !!,"Secondary ",XBWHERE,": " R X:$G(DTIME,999) ;IHS/SET/GTH XB*3*9 10/29/2002
 Q:X=""!(X="^")
 S XBFCMPU2=X
 Q
 ;
EOJ ;
 KILL C,I,GDFN,GROOT,L,NOGROUP,NT,P,T,T1,T2,T3,T4,T5,T6,TT,ZZ
 KILL XBCDFILE,XBCDL
 KILL %UCI,%UCN,XBFCMPFL,XBFCMPG,XBFCMPL,XBFCMPP,XBFCMPS,XBFCMPU1,XBFCMPU2,X,Y
 Q
 ;
XBGCMP ; COMPARES GLOBAL TREES
 I $D(GROUP),XBFCMPG="DD",XBGPASS=2 Q
 D SEARCH
 KILL XBGP,XBGS,XBGPASS
 Q
 ;
SEARCH ; 
 S T="T",C=",",P=")",NT=$L(XBGP,C)-1,L=1,T1=""
 S TT=XBGP
 F I=1:1:30 S TT=TT_T_I_C
EXTR ;
 S X=T_L,Y=$P(TT,C,1,L+NT)_P,@X=$O(@Y)
 I @X]"" D:$D(@(Y))#2 SUB S L=L+1,@(T_L)="" G EXTR
 S L=L-1
 Q:L=0
 G EXTR
 ;
SUB ;
 W "."
 S ZZ=XBGS_$P(Y,XBGP,2)
 I $D(@Y)
 Q:$P($$MSMZR^ZIBNSSV,"DD(",2)?.".".N.".".N1",0,""PT""".E
 Q:$P($$MSMZR^ZIBNSSV,"DD(",2)?.".".N.".".N1",".".".N.".".N1",21,".E
 Q:$P($$MSMZR^ZIBNSSV,"DD(",2)?.".".N.".".N1",".".".N.".".N1",""DT""".E
 Q:$P($$MSMZR^ZIBNSSV,"DD(",2)?.".".N.".".N1",".".".N.".".N1",1,0)"
 I $D(SKIP),SKIP=$E($$MSMZR^ZIBNSSV,1,$L(SKIP)) Q
 KILL SKIP
 I $D(GROUP),$P($$MSMZR^ZIBNSSV,"DD(",2)?.".".N.".".N1",".".".N.".".N1",0)" D CHKGROUP I NOGROUP S SKIP=$E($$MSMZR^ZIBNSSV,1,$L($$MSMZR^ZIBNSSV)-3) Q
 I '$D(@ZZ),$P($$MSMZR^ZIBNSSV,"DD(",2)?.".".N.".".N1",".".".N.".".N1",0)" W !,$$MSMZR^ZIBNSSV," <",$P(@Y,"^",1)," field does not exist>" S SKIP=$E($$MSMZR^ZIBNSSV,1,$L($$MSMZR^ZIBNSSV)-3) Q
 I $D(GROUP),$P($$MSMZR^ZIBNSSV,"DD(",2)?.".".N.".".N1",".".".N1",20,".E Q
 I '$D(@ZZ) W !,$$MSMZR^ZIBNSSV,"=",@Y," <does not exist>" Q
 Q:XBGPASS=2
 I @ZZ'=@Y W !,$$MSMZR^ZIBNSSV," <differs>",!,@ZZ,!,@Y Q
 Q
 ;
CHKGROUP ;
 S GDFN=0,NOGROUP=1,GROOT=$E($$MSMZR^ZIBNSSV,1,$L($$MSMZR^ZIBNSSV)-3)
 F GL=0:0 S GDFN=$O(@(GROOT_",20,GDFN)")) Q:GDFN=""  I @(GROOT_",20,GDFN,0)")=GROUP S NOGROUP=0 Q
 I $D(@Y)
 Q
 ;
