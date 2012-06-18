BDGICR21 ; IHS/OIT/LJF - PROVIDER'S OWN INCOMPLETE CHART LISTING;
 ;;5.3;PIMS;**1005**;MAY 28, 2004
 ;IHS/OIT/LJF 02/15/2006 PATCH 1005 new routine
 ;
 NEW BDGTYP,X,DEFAULT,BDGPRV,BDGRPT,BDGCOP
 ;
 ; preset variables
 S BDGTYP=3                                            ;both inpatient and observation/day surgery charts
 S BDGPRV="NAME",BDGPRV(DUZ)=$$GET1^DIQ(200,DUZ,.01)   ;user's name
 S BDGRPT=1                                            ;individual provider listing
 S BDGCOP=1                                            ;one copy
 I $$BROWSE^BDGF="B" D EN^BDGICR2 Q
 D ZIS^BDGF("PQ","EN^BDGICR2","PROVIDER'S IC LIST","BDGTYP;BDGPRV*;BDGRPT;BDGCOP")
 Q
