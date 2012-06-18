BARBLLK ; IHS/SD/LSL - LOOKUPS INTO THE BILL FILE ;07/10/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ;;
 ; IHS/SD/TMM 06/18/2010 1.8*Patch 19 (M819_5), Add Prepayment functionality.
 ;                       See work order 3PMS10001
 ;                       New tags EN1 and PAT1
 ;                       to pass default values (DIC("B")) during lookup
 ;                       (^BARCLU,^BARCLU01,^BARPUTL,^BARPST1,^BARBLLK)
 ; ********************************************************************* ;
 ;
 ;asks PATIENT and returns BARBL = IEN if found
 ;bill=open & A/R service/section matches users
 K BARBL
 S BARBLDA=0
 D ^XBNEW("PAT^BARBLLK:BARBLDA") ;new environment
 I $G(BARBLDA)>0 S BARBL(.01)=$$VAL^XBDIQ1(90050.01,BARBLDA,.01)
 E  K BARBL
 Q
 ; *********************************************************************
 ;
PAT ;EP lookup bill by patient with open accounts
 S BARPASS=$$EN^BARPST1()
 I BARPASS'["" Q
 S BARCNT=$$EN^BARPNP2(BARPASS)
 I 'BARCNT W !,?10," NO SELECTION ",! Q
 D HIT^BARPNP2(BARPASS)
 K DIR
 S DIR(0)="N^0:"_BARCNT
 S DIR("A")="LINE # or 0 to quit"
 D ^DIR
 I Y'>0 Q
 S BARBLDA=$O(^BARTMP($J,"B",Y,0))
 Q
 ;
 ;--->NEW TAG EN1--->  ;M819*ADD*TMM*20100711 (819_4)
 ; (copied entry to ^BARBLLK but calls PAT1^BARBLLK instead of PAT^BARBLLK
EN1(DICB,DICB2,DICB3) ;
 ;asks PATIENT and returns BARBL = IEN if found
 ;bill=open & A/R service/section matches users
 K BARBL
 S BARBLDA=0
 D ^XBNEW("PAT1^BARBLLK:BARBLDA;DICB;DICB2;DICB3") ;new environment    ;M819*ADD*TMM*20100711 ;use default for looup
 I $G(BARBLDA)>0 S BARBL(.01)=$$VAL^XBDIQ1(90050.01,BARBLDA,.01)
 E  K BARBL
 Q
 ;
PAT1 ;EP lookup bill by patient with open accounts
 ;--->NEW TAG PAT1--->  ;M819*ADD*TMM*20100711 (819_4)
 ; (copied from PAT^BARBLLK passes default DIC("B") values to ^BARPUTL
 ;
 ;M819*DEL*TMM*20100711***  S BARPASS=$$EN^BARPST1()
 S DICB=$G(DICB)
 S DICB2=$G(DICB2)
 S DICB3=$G(DICB3)
 S BARPASS=$$EN1^BARPST1(DICB,DICB2,DICB3)
 I BARPASS'["" Q
 S BARCNT=$$EN^BARPNP2(BARPASS)
 I 'BARCNT W !,?10," NO SELECTION ",! Q
 D HIT^BARPNP2(BARPASS)
 K DIR
 S DIR(0)="N^0:"_BARCNT
 S DIR("A")="LINE # or 0 to quit"
 D ^DIR
 I Y'>0 Q
 S BARBLDA=$O(^BARTMP($J,"B",Y,0))
 Q
