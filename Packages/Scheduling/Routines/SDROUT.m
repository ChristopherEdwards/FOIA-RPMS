SDROUT ;BSN/GRR - ROUTING SLIPS ; [ 11/03/2001  9:04 AM ]
 ;;5.3;Scheduling;**3,39,1013**;Aug 13, 1993
 ;IHS/ANMC/LJF 11/15/2000 added IHS call for sorts & reprint questions
 ;                        added kill of ^TMP (used instead of ^UTILITY)
 ;                        changed $N to $O
 ;                        checked for "include on file room list=no"
 ;             11/17/2000 added IHS call for single patient rs
 ;             11/22/2000 added call to find chart requests to print
 ;             12/06/2000 made all vs. add-on question clearer
 ;             11/02/2001 added code to print range for ALL
 ;
 ;ihs/cmi/maw 04/11/2011 PATCH 1013 RQMT151
 ;
 N VAUTC
 S SDSTOP=""   ;IHS/ANMC/LJF 11/02/2001
 S (SDIQ,SDX,DIV,SDREP,SDSTART)="" D DIV^SDUTL I $T D ROUT^SDDIV G:Y<0 END
R1 S %=2 W !,"DO YOU WANT ROUTING SHEET FOR A SINGLE PATIENT" D YN^DICN I '% D QQ G R1
 ;G:%<0 END S SDSP=$S(%=2:"N",1:"Y") G:SDSP["Y" SIN1^SDROUT1
 G:%<0 END S SDSP=$S(%=2:"N",1:"Y") G:SDSP["Y" ONE^BSDROUT  ;IHS/ANMC/LJF 11/17/2000
R2 ;R !,"WANT (A)LL ROUTING SHEETS OR (O)NLY ADD-ONS: ONLY ADD-ONS// ",X:DTIME G:X["^"!('$T) END I X="" S X="O" W X  ;IHS/ANMC/LJF 12/06/2000
 ;ihs/cmi/maw 04/11/2011 Patch 1013 RQMT151 for routing slip default
 N BSDRSDF,BSDPROM
 S BSDRSDF=$S($G(DIV):$$GET1^DIQ(9009020.2,DIV,.27,"I"),1:"O")
 ;R !,"Select All Routing Slips (A) or Only Add-ons (O): O// ",X:DTIME G:X["^"!('$T) END I X="" S X="O" W X  ;IHS/ANMC/LJF 12/06/2000
 S DIR(0)="S^A:All Routing Slips;O:Only Add-Ons",DIR("A")="Select All Routing Slips (A) or Only Add-ons (O): "
 S DIR("B")=BSDRSDF
 D ^DIR
 G END:$D(DIRUT)
 S Z="^ALL ROUTING SHEETS^ONLY ADD-ONS" D IN^DGHELP I %=-1 W !?12,"CHOOSE FROM:",!?12,"O - To only see add-ons",!?9,"or A - To see all routing sheets" G R2
 S SDX=$S(X="O":"ADD-ONS",1:"ALL")
 ;
 D ASK^BSDROUT Q  ;IHS/ANMC/LJF 11/15/2000
 ;
R3 S ORDER=0 R !,"PRINT IN (T)ERMINAL DIGIT, (N)AME, OR (C)LINIC ORDER: T// ",X:DTIME G:X="^"!'$T END S Z="^TERMINAL DIGIT^NAME^CLINIC" I X="" S X="T" W X
 D IN^DGHELP I %=-1 W !?12,"CHOOSE FROM:",!?12,"T - To see routing slips sorted in terminal digit order",!?12,"N - To see routing slips sorted in alphabetical order by name",!?9,"or C - To see routing slips printed by clinic" G R3
R4 S ORDER=$S(X="T":1,X="N":"",1:2)
 D:'$D(DT) DT^SDUTL S %DT="AEXF",%DT("A")="PRINT ROUTING SLIPS FOR WHAT DATE: " D ^%DT K %DT("A") G:Y<1 END S SDATE=Y
A5 S %=2 W !,"IS THIS A REPRINT OF A PREVIOUS RUN" D YN^DICN I '% D QQ G A5
 Q:%<0  I '(%-1) S POP=0 D REP^SDROUT1 Q:POP
 I ORDER=2,SDREP="" G END:'$$CLINIC(DIV,.VAUTC)
 S VAR="DIV^VAUTC^VAUTC(^SDX^ORDER^SDATE^SDIQ^SDREP^SDSTART",DGPGM="START^SDROUT"
 D ZIS^DGUTQ G:POP END^SDROUT1
 G START
 ;
START ;EP; IHS/ANMC/LJF 11/15/2000 called by BSDROUT to return to VA code
 K ^TMP("SDRS",$J)  ;IHS/ANMC/LJF 11/15/2000 IHS code uses ^TMP
 K ^UTILITY($J) U IO
 S Y=SDATE D DTS^SDUTL S APDATE=Y,Y=DT D DTS^SDUTL S PRDATE=Y
 ;
 ;
 ;IHS/ANMC/LJF 11/15/2000 11/02/2001 changed $N to $O, added IHS call
 ;F SC=0:0 S SC=$N(^SC(SC)) Q:SC'>0  D CHECK I $T S GDATE=SDATE F K=0:0 S GDATE=$N(^SC(SC,"S",GDATE)) ;split line - too ling with semi-colon added
 ;Q:GDATE<0!(GDATE>(SDATE+1))  I $D(^SC(SC,"S",GDATE,1)) F L=0:0 S L=$N(^SC(SC,"S",GDATE,1,L)) Q:L<0  I $D(^(L,0)),$P(^(0),U,9)'="C" D GOT^SDROUT0
 S SC=0 F  S SC=$O(^SC(SC)) Q:'SC  D CHECK I $T D
 . S GDATE=SDATE
 . F  S GDATE=$O(^SC(SC,"S",GDATE)) Q:('GDATE)!(GDATE>(SDATE+1))  D
 .. I $D(^SC(SC,"S",GDATE,1)) F L=0:0 S L=$O(^SC(SC,"S",GDATE,1,L)) Q:'L  I $D(^(L,0)),$P(^(0),U,9)'="C" D FIND^BSDROUT0(SC,GDATE,L,ORDER,"")
 D CRLOOP^BSDROUT2
 D PRINT^BSDROUT1(ORDER,SDATE) Q
 ;IHS/ANMC/LJF 11/15/2000 11/02/2001
 ;
 ;
 G GO^SDROUT0
 ;
 ;IHS/ANMC/LJF 11/15/2000 file room list check added
CHECK ;I $P(^SC(SC,0),"^",3)="C",$S(DIV="":1,$P(^SC(SC,0),"^",15)=DIV:1,1:0),$S('$D(^SC(SC,"I")):1,+^("I")=0:1,+^("I")>SDATE:1,+$P(^("I"),"^",2)'>SDATE&(+$P(^("I"),"^",2)):1,1:0)
 I $P(^SC(SC,0),U,21)'=0,$P(^SC(SC,0),"^",3)="C",$S(DIV="":1,$P(^SC(SC,0),"^",15)=DIV:1,1:0),$S('$D(^SC(SC,"I")):1,+^("I")=0:1,+^("I")>SDATE:1,+$P(^("I"),"^",2)'>SDATE&(+$P(^("I"),"^",2)):1,1:0)
 ;
 I $T,$S(ORDER'=2:1,SDREP:1,VAUTC=1:1,1:$D(VAUTC(SC)))
 Q
QQ W !,"RESPOND YES OR NO" Q
END K VAUTC,ALL,DIV,ORD,ORDER,RMSEL,SDIQ,SDREP,SDSP,SDSTART,SDX,X,Y,C,V,I,SDEF,%I Q
 ;
CLINIC(SDIV,VAUTC) ;
 N DIV,SDX,ORDER,SDATE,SDIQ,SDREP,SDSTART,VAUTD
 I 'SDIV S VAUTD=1
 I SDIV S VAUTD=0,VAUTD(SDIV)=$P($G(^DG(40.8,SDIV,0)),U)
 Q $$CLINIC1()
 ;
CLINIC1() ; -- get clinic data
 ;  input: VAUTD  := divisions selected
 ; output: VAUTC := clinic selected (VAUTC=1 for all)
 ; return: was selection made [ 1|yes   0|no]
 ;
 W !!,$$LINE^SDAMO("Clinic Selection")
 ;
 ; -- select clinics
 ; -- call generic clinic screen, correct division
 ;
 S DIC("S")="I $$CLINIC2^SDROUT(Y),$S(VAUTD:1,$D(VAUTD(+$P(^SC(Y,0),U,15))):1,'+$P(^(0),U,15)&$D(VAUTD(+$O(^DG(40.8,0)))):1,1:0)"
 S DIC="^SC(",VAUTSTR="clinic",VAUTVB="VAUTC",VAUTNI=2
 D FIRST^VAUTOMA
 ;
 I Y<0 K VAUTC
CLINICQ Q $D(VAUTC)>0
 ;
CLINIC2(SDCL) ; -- generic screen for hos. loc. entries
 ; input:   SDCL := ifn of HOSPITAL LOCATION file
 ;      returned := [ 0 | do not use entry ; 1 | use entry ]
 ;
 ; -- must be a clinic
 N X S X=$G(^SC(SDCL,0))
 Q $P(X,"^",3)="C"
 ;
