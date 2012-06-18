AUTTFIPS ;IHS/SET/GTH - FIPS CODES EXTRINSICS ; [ 01/03/2003  10:48 AM ]
 ;;98.1;IHS DICTIONARIES (POINTERS);**12**;MAR 04, 1998
 ;IHS/SET/GTH AUT*98.1*12 01/02/2003 - New routine.
 ;
ST(X) ;PEP;Return FIPS code for X=2-letter-State-designator.
 ; e.g.:  S State_FIPS=$$ST^AUTTFIPS("AZ")
 ; The lookup failed if +State_FIPS = 0
 ; 
 NEW DIC,Y
 S DIC=5,DIC(0)="",D="C"
 D IX^DIC
 I Y<1 Q "00"
 S Y="00"_$$GET1^DIQ(5,+Y,2)
 Q $E(Y,$L(Y)-1,$L(Y))
 ;
CT(AUT) ;PEP;AUT=IEN of ^AUTTCTY(.  Return 3-digit FIPS for County.
 ; IEN is used assuming RPMS applications will have IEN.
 ; e.g.:  S County_FIPS=$$CT^AUTTFIPS(4)
 ; The lookup failed if +County_FIPS = 0
 ;  
 NEW DIC,X,Y
 S AUT=$P(^AUTTCTY(AUT,0),"^",2),X=$P(^(0),"^",1)
 I 'AUT Q "000"
 S DIC="^DIC(5,"_AUT_",1,",DIC(0)=""
 D ^DIC
 I Y<1 Q "000"
 S Y="000"_$$GET1^DIQ(DIC,+Y,2)
 Q $E(Y,$L(Y)-2,$L(Y))
 ;
