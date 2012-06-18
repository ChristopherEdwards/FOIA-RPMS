BSDAL1 ; IHS/ANMC/LJF - IHS APPOINTMENT LIST ; 
 ;;5.3;PIMS;**1011**;APR 26, 2002
 ;Appt List where clinic is already known
 ;
 ;cmi/flag/maw 11/6/2008 added set of BSDD(1) for appointment list
 ;
 ;
LIST(SC,TYPE) ;EP -- list appointments; called by Month-at-a-glance
 NEW A,ALL,DFN,DIC,I,INC,K,M,PCNT,POP,PT,SD,SD1,SDB,SDCC,SDCP,SDD
 NEW SDEM1,SDDIF,SDDIF1,SDEA,SDEC,SDEDT,SDEM,SDEND,SDFL,SDFS,SDIN
 NEW SDNT,SDOI,SDPD,SDREV,SDT,SDTT,SDX,SDXX,SDZ,VADAT,VADATE,VAUTC
 NEW VAUTD,VAQK,X,Y,Y1,Y2,Z
 Q:'$G(SC)  Q:'$G(TYPE)  Q:TYPE<1  Q:TYPE>2
 S VAUTC=0,VAUTD=0,VAUTC($P(^SC(SC,0),U))=SC,M=1
 S X=$P($G(^SC(+SC,0)),U,15),VAUTD(X)=$P(^DG(40.8,+X,0),U)
 K DIC("S") S %DT("A")="List Appointments For Which Date: ",%DT="AEXF"
 D ^%DT K %DT,% I (X["^")!(Y<0) Q
 ;
 I TYPE=1 S BSDD=Y,BSDD(1)=Y D  Q   ;long appt list
 . NEW BSDWI,BSDPCMM,BSDAMB,BSDPH,BSDCR
 . S BSDWI=1,BSDCR=0,BSDPCMM=1,BSDAMB=1,BSDPH=0
 . I $$GET1^DIQ(9009020.2,$$DIV^BSDU,.12)="YES",'$D(^XUSEC("SDZSUP",DUZ)) S BSDAMB=0   ;facility restricts seeing who made appt
 . D EN^BSDALL
 ;
 I TYPE=2 D EN^BSDALS(SC,Y) Q   ;short appt list
