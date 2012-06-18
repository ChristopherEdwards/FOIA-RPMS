ABMMODIT ; IHS/SD/SDR - ENTER/EDIT 3P MODIFIERS ;
 ;;2.6;IHS Third Party Billing System;**2**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*2 - HEAT11578 - can't add modifiers in CE.
 ;
EN ; EP
 N DIC,DIE,DIR,X,Y,DA  ;abm*2.6*2 HEAT11578
 S DIC=$S($$VERSION^XPDUTL("BCSV")>0:"^DIC(81,3,",1:"^AUTTCMOD(")
 S DIC(0)="EMQ"
 D ^DIC
 K DIC
 K:+Y<0 X Q
 S X=$P($$MOD^ABMCVAPI(Y,"",""),U,2)
 Q
