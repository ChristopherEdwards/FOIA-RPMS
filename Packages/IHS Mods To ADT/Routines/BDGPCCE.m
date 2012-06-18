BDGPCCE ; IHS/ANMC/LJF - CODE PCC H VISIT ; 
 ;;5.3;PIMS;**1010**;APR 26, 2002
 ;
 ;cmi/anch/maw 10/20/2008 PATCH 1010 changed export date field from .14 to 1106
 ;
ASK ; ask user to select patient and visit
 NEW DFN,VSTN,DATE,END,BDGA,COUNT,ARRAY
 S DFN=+$$READ^BDGF("PO^2:EMZQ","Select Patient") Q:DFN<1
 ;
 ; find all recent hospitalizations (last year)
 S DATE=0,END=9999999-($$FMADD^XLFDT(DT,-731))
 F  S DATE=$O(^AUPNVSIT("AAH",DFN,DATE)) Q:'DATE  Q:(DATE>END)  D
 . S VSTN=0
 . F  S VSTN=$O(^AUPNVSIT("AAH",DFN,DATE,VSTN)) Q:'VSTN  D
 .. Q:$$GET1^DIQ(9000010,VSTN,.11)="DELETED"     ;deleted visit
 .. Q:$$GET1^DIQ(9000010,VSTN,.06,"I")'=DUZ(2)   ;not this facility
 .. ;
 .. ; put into array with visit date and date exported
 .. S COUNT=$G(COUNT)+1
 .. S BDGA(COUNT)=VSTN_U_"Admitted on "_$$PAD($$GET1^DIQ(9000010,VSTN,.01),30)
 .. ;
 .. S X=$O(^AUPNVINP("AD",VSTN,0)) I 'X D   ;current inpatient
 ... S BDGA(COUNT)=BDGA(COUNT)_"Current Inpatient"
 .. ;
 .. ;S X=$$GET1^DIQ(9000010,VSTN,.14)          ;date exported cmi/maw 10/20/2008 PATCH 1010 orig line
 .. S X=$$GET1^DIQ(9000010,VSTN,1106)          ;date exported cmi/maw 10/20/2008 PATCH 1010 new export date
 .. I X]"" S BDGA(COUNT)=BDGA(COUNT)_"Exported on "_X
 ;
 I '$D(BDGA) W !!,"No admissions on file for the past 2 years." D ASK Q
 ;I '$D(BDGA(2)),$P(BDGA(1),U,2)="" S BDGV=+BDGA(1) D BDGPCCEL Q
 ;
 ; else show user list for choosing
 W !!,"Select from these recent admissions:"
 F COUNT=1:1 Q:'$D(BDGA(COUNT))  D
 . S ARRAY(COUNT)=$J(COUNT,3)_". "_$P(BDGA(COUNT),U,2)
 S Y=$$READ^BDGF("N^1:"_(COUNT-1),"Select Hospitalization",1,,,.ARRAY)
 I Y<1 D ASK Q
 S BDGV=+BDGA(Y) D ^BDGPCCEL Q
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
