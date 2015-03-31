ABMINSIT ; IHS/SD/SDR - Budget Activity Input Transform
 ;;2.6;IHS Third Party Billing System;**11**;NOV 12, 2009;Build 133
 ;
EN ; EP
 N DIC,DIE,DIR,DA,Y,DO
 S DIC="^AUTTINTY("
 S DIC(0)="MQX"
 D ^DIC
 K DIC
 I +Y<0 K X Q
 S X=$$GET1^DIQ(9999999.181,+Y,"1")
 W "  "_X
 Q
