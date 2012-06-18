BLRAPPH ;DAOU/ALA-Find Primary Menus for Providers [ 11/18/2002  1:39 PM ]
 ;;5.2;LR;**1013,1015**;NOV 18, 2002
 ;
 ;**Program Description**
 ;  This program can be run to find the primary menu
 ;  options for potential participating providers
 ;
EN ;  Starting point
 S PNM="" D ^%ZIS Q:POP
 ;
 ;  Go through the provider cross-reference
PNAM S PNM=$O(^VA(200,"AK.PROVIDER",PNM)) G EXIT:PNM=""
 S IEN=""
IEN S IEN=$O(^VA(200,"AK.PROVIDER",PNM,IEN)) G PNAM:IEN=""
 ;
 ;  Check for termination date
 I $P($G(^VA(200,IEN,0)),U,11)'="" G IEN
 ;
 ;  Get the primary menu pointer
 S PMEN=$G(^VA(200,IEN,201)) G IEN:PMEN=""
 S PMENU=$S($G(^DIC(19,PMEN,0))="":PMEN,1:$P($G(^DIC(19,PMEN,0)),U,1)) W !,IEN,?6,PNM,?40,PMENU,?60,$P($G(^(0)),U,2)
 G IEN
EXIT D ^%ZISC
 Q
