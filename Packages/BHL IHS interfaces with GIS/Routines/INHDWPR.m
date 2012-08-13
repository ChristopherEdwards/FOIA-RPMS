INHDWPR ;JSH; 8 Apr 94 17:02;Print Utilities 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
PRTLIST ;Print specified entries from a file using a template
 ;DIC = file # or reference
 ;DA(n)=""  = entry #s to print
 ;DR  = template name
 N %,I,L,C,Q,DK,DPP,DI,Y,DX,DIK
 ;Build sort array
 S %=0 K ^UTILITY(U,$J) F I=0:0 S I=$O(DA(I)) Q:'I   S %=%+1,^UTILITY(U,$J,%,I)=""
P1 I +DIC Q:'$D(^DIC(DIC,0,"GL"))  S DIC=^DIC(DIC,0,"GL")
 I @("'$D("_DIC_"0))") Q
 S Y=$P(^(0),U,2),DI=DIC,DPP(1)=+Y_"^^^@",DK=+Y,Q="""",C=",",L=0
 S DPP(1,"IX")="^UTILITY(U,$J,"_DI_"^2",DPP=1
 S FLDS=DR,DHD=$G(DHD) S:$E(FLDS)'="[" FLDS="["_FLDS_"]"
 I FLDS'="[CAPTIONED]" K DA G N^DIP1
CAP ;Captioned output
 K DUOUT D ^%ZIS Q:POP  U IO
 S DIK=0 F  S DIK=$O(^UTILITY(U,$J,DIK)) Q:'DIK  S DA=$O(^(DIK,0)),E="N<1",N=-1,DD=+DPP(1) D GUY^DIQ Q:$G(DUOUT)  W !!
 D:'$G(DIPNCLOS) ^%ZISC K DR,DUOUT,DIPNCLOS Q
 ;
PRESORT ;Entry point for pre-sorted print
 ;DIC = file # or reference
 ;DA(n)=entry#  [n=1,2,3,...] entry #s to print
 ;DR  = template name
 N %,I,L,C,Q,DK,DPP,DI,Y,V,V1,DX,DIK
 ;Build sort array
 S V=$S($D(DA)#2:DA,1:"DA"),V1=$S(V["(":$E(V,1,$L(V)-1)_",",1:V_"(")
 S %=0 K ^UTILITY(U,$J) F  S V=$Q(@V) Q:$E(V,1,$L(V1))'=V1  S %=%+1,^UTILITY(U,$J,%,@V)=""
 G P1
