XBGXFR ; IHS/ADC/GTH - TRANSFERS GLOBAL TREES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; CREATED BY GIS 7/17/85 FOR MSM UNIX MUMPS (2.3)
 ; MODIFIED AND RENAMED BY EDE 12/21/86
 ;
START ;
 D SEARCH
 KILL FROM,TO,TALK
 Q
 ;
SEARCH ; 
 NEW (FROM,TO,TALK)
 S F="F",T="T",C=",",P=")",NF=$L(FROM,C)-1,NT=$L(TO,C)-1,L=1,F1=""
 S TF=FROM
 F I=1:1:30 S TF=TF_F_I_C
 S TT=TO
 F I=1:1:30 S TT=TT_F_I_C
 S Y=$E(FROM,1,$L(FROM)-1)_$S($E(FROM,$L(FROM))=",":")",1:"")
 I $D(@(Y))#2 S Z=TO_$P(FROM,"(",2),Z=$E(Z,1,$L(Z)-1)_")",@Z=@Y
EXTR ;
 S X=F_L,Y=$P(TF,C,1,L+NF)_P,@X=$O(@Y)
 I @X]"" D:$D(@(Y))#2 SUB S L=L+1,@(F_L)="" G EXTR
 S L=L-1
 Q:L=0
 G EXTR
 ;
SUB ;
 S Z=$P(TT,C,1,L+NT)_P,@Z=@Y
 W:$D(TALK) "."
 Q
 ;
EN(FROM,TO,TALK) ;PEP - Transfer global trees.
 Q:$G(FROM)=""
 Q:$G(TO)=""
 S TALK=$G(TALK)
 G START
 ;
