DGPMEX ;ALB/MIR - EXTENDED BED CONTROL ; [ 03/23/2004  9:49 AM ]
 ;;5.3;Registration;**40,59,1005**;Aug 13, 1993
 ;IHS/ANMC/LJF 03/02/2001 added kill of patient variables
 ;                        removed calls to PTF code
 ;             01/09/2002 fixed code to see duplicate admissions
 ;IHS/ITSC/WAR 03/11/04 Changed ^DIC(4 to using $$GET1^DIQ
 ;IHS/OIT/LJF  04/06/2006 PATCH 1005 don't ask name if called by CODE option
 ;
 S DGPMEX=1
EN D Q1 K ^UTILITY("DGPMVN",$J),^UTILITY("DGPMVD",$J)
 ;
 ;IHS/OIT/LJF 04/06/2006 PATCH 1005 don't ask name again if called by CODE
 ;W ! D LO^DGUTL S DIC="^DPT(",DIC(0)="AZEQM" D ^DIC G Q:Y'>0 S DFN=+Y
 W ! D LO^DGUTL G Q:$G(BDGCODE) S DIC="^DPT(",DIC(0)="AZEQM" D ^DIC G Q:Y'>0 S DFN=+Y
 ;
 I '$D(^DGPM("APTT1",DFN)) W !,"No admissions on file",! G EN
EN1 ;S C=0 F I=0:0 S I=$O(^DGPM("ATID1",DFN,I)) Q:'I  S N=$O(^(I,0)) I $D(^DGPM(+N,0)) S D=^(0),C=C+1,^UTILITY("DGPMVN",$J,C)=N_"^"_D,^UTILITY("DGPMVD",$J,+D)=N,^UTILITY("DGPMVDA",$J,N)=C  ;IHS/ANMC/LJF 1/09/2002
 S C=0 F I=0:0 S I=$O(^DGPM("ATID1",DFN,I)) Q:'I  S N=0 F  S N=$O(^DGPM("ATID1",DFN,I,N)) Q:'N  I $D(^DGPM(+N,0)) S D=^(0),C=C+1,^UTILITY("DGPMVN",$J,C)=N_"^"_D,^UTILITY("DGPMVD",$J,+D)=N,^UTILITY("DGPMVDA",$J,N)=C  ;IHS/ANMC/LJF 1/09/2002
 S (DGER,DGOK)=0 W !,"CHOOSE FROM:" F I=0:0 S I=$O(^UTILITY("DGPMVN",$J,I)) Q:'I  S DGI=I,DGX=$P(^(I),"^",2,20) D W1 I '(I#5) D BREAK Q:DGER!DGOK
 G EN:DGER I DGI#5 D BREAK G EN:DGER
 S DGPMCA=+^UTILITY("DGPMVN",$J,DGOK),DGPMAN=$S($D(^DGPM(+DGPMCA,0)):^(0),1:""),^DISV(DUZ,"DGPMEX",DFN)=DGPMCA
 ;I $D(DGPMEX) D PTF^DGPMV21 I $G(DGPME)]"" K DGPME G EN  ;IHS/ANMC/LJF 3/02/2001
 K DGPME D ENEX^DGPMV20 I '$D(DGPMEX) G EN
 I DGFL=2 G Q
ASK K ^UTILITY("DGPMVN",$J),^UTILITY("DGPMVD",$J)
 ;
 ;IHS/ANMC/LJF 3/02/2001 added lines below to check lockout parameter
 I $$LOCKED^BDGPAR(BDGDIV,+^DGPM(DGPMCA,0)) D  G Q
 . W !!?10,"*** CAN'T EDIT A MOVEMENT OLDER THAN LOCK OUT DATE. ***"
 . W !?18,"*** CONTACT APPLICATION COORDINATOR ***" D PAUSE^BDGF
 ;IHS/ANMC/LJF 3/02/2001 end of new code
 ;
 W !!?10,"CHOOSE FROM:",!?15,"1 - Admit Patient",!?15,"2 - Transfer Patient",!?15,"3 - Discharge Patient",!?10,"Select Option: " R X:DTIME G:X["^"!'$T!(X="") EN
 S Z="^1  ADMIT PATIENT^2  TRANSFER PATIENT^3  DISCHARGE PATIENT^ADMIT PATIENT^TRANSFER PATIENT^DISCHARGE PATIENT^" D IN^DGHELP
 I %=-1 W !?5,"Enter:",!?10,"1 or A to edit admission",!?10,"2 or T to enter/edit a transfer",!?10,"3 or D to enter/edit the discharge" G ASK
 S DGPMT=$S(X="A":1,X="T":2,X="D":3,1:X) I DGPMT'=1 D CA^DGPMV
 I DGPMT=1 D
 .L +^DGPM("C",DFN):0 I '$T D  Q
 ..W !!,"    ** This patient's inpatient or lodger activity is being **",!,"    ** edited by another employee.  Please try again later. **",!
 .D PTF^DGPMV22(DFN,DGPMCA,.DGPME,DGPMCA) I $G(DGPME)]"" W !,DGPME,! Q
 .S (DGPMY,DGPMHY)=+DGPMAN,(DGPMN,DGPM1X,DGPMOUT)=0,DGPMDA=DGPMCA D UC^DGPMV,DT^DGPMV3
 .L -^DGPM("C",DFN)
 G EN
Q K DGPMEX
 D KILL^AUPNPAT   ;IHS/ANMC/LJF 3/02/2001
Q1 K DIC,DFN,DGER,DGFL,DGI,DGPMAN,DGPMCA,DGPMN,DGPMDA,DGPMOUT,DGPMT,DGPMUC,DGX D Q^DGPMV3,Q^DGPMV2,Q^DGPMV1
 Q
BREAK W !,"CHOOSE 1-",DGI W:$D(^UTILITY("DGPMVN",$J,DGI+1)) !,"<RETURN> TO CONTINUE",!,"OR '^' TO QUIT" W ": " R X:DTIME I $S('$T!(X["^"):1,X=""&'$D(^UTILITY("DGPMVN",$J,DGI+1)):1,1:0) S DGER=1 Q
 I X="" Q
 I X=" ",$D(^DISV(DUZ,"DGPMEX",DFN)) S DGX=^(DFN) I $D(^UTILITY("DGPMVDA",$J,+DGX)) S DGOK=^(+DGX) Q
 I X'=+X!'$D(^UTILITY("DGPMVN",$J,+X)) W !!,*7,"INVALID RESPONSE",! G BREAK
 S DGOK=X Q
W1 W !,$J(I,4),">  " S Y=+DGX X ^DD("DD") W Y,?30,$S('$D(^DG(405.1,+$P(DGX,"^",4),0)):"",$P(^(0),"^",7)]"":$P(^(0),"^",7),1:$E($P(^(0),"^",1),1,20))
 ;IHS/ITSC/WAR 03/11/04 Changed to $$GET1^DIQ
 ;W ?55,"TO:  ",$S($D(^DIC(42,+$P(DGX,"^",6),0)):$E($P(^(0),"^",1),1,18),1:"") I $P(DGX,"^",18)=9 W !?23,"FROM:  ",$S($D(^DIC(4,+$P(DGX,"^",5),0)):$P(^(0),"^",1),1:"")
 W ?55,"TO:  ",$S($D(^DIC(42,+$P(DGX,"^",6),0)):$E($P(^(0),"^",1),1,18),1:"") I $P(DGX,"^",18)=9 W !?23,"FROM:  ",$$GET1^DIQ(405,+$P(^UTILITY("DGPMVN",$J,I),U,1),.05)
