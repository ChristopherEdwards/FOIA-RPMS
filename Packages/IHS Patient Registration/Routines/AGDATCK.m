AGDATCK ; IHS/ASDS/EFG - CHECK DATA ;
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;****************************************************************
 ;Please notify the Patient Care Component (PCC) maintenance
 ;programmer of any changes affecting validation of data.
 ;
 ;****************************************************************
 ;
 D:'$D(AGOPT) ^AGVAR
 S AG("DTOT")=0
 K AG("ER")
 Q:'$D(DFN)
 I '$D(^DPT(DFN,0)) D
 . S AG("DTOT")=AG("DTOT")+3
 . F AGI=1,3,4 S AG("ER",AGI)=""
 I '$D(^AUPNPAT(DFN,11)) D
 . S AG("DTOT")=AG("DTOT")+4
 . F AGI=5,6,8,9 S AG("ER",AGI)=""
 I $D(^AUPNPAT(DFN,51))<10 D
 . S AG("DTOT")=AG("DTOT")+1
 . S AG("ER",7)=""
 I '+$O(^AUPNPAT(DFN,41,0)) D
 . S AG("DTOT")=AG("DTOT")+2
 . S AG("ER",2)=""
 . S AG("ER","NOHRN")=""
 . S AG("ER",13)=""
NAME ;
 G CHART:$D(AG("ER",1))
 S X=$P(^DPT(DFN,0),U)
 S (DA,D0)=DFN
 X $P(^DD(2,.01,0),U,5,99)
 K DA,D0
 I '$D(X) D  G END:AG("DTOT")=9
 . S AG("DTOT")=AG("DTOT")+1
 . S AG("ER",1)=""
CHART ;
 G HRNPFAC ;eliminate fac:hrn check as Parent Fac:HRN is inclusive
HRNPFAC ;
 G INACT:$D(AG("ER",13))
 K AGRSITE
 D ^AGTXRHRN
 I $G(AGRHRN) D  G INACT
 . K AGRSITE,AGRHRN
 S AG("ER",13)=""
 S AG("DTOT")=AG("DTOT")+1
 K AGRSITE,AGRHRN
INACT ;
 G DOB
DOB ;
 G SEX:$D(AG("ER",3))
 I $P(^DPT(DFN,0),U,3)="" D
 . S AG("ER",3)=""
 . S AG("DTOT")=AG("DTOT")+1
SEX ;
 G TRIBE:$D(AG("ER",4))
 I $P(^DPT(DFN,0),U,2)=""!("MF"'[$P(^DPT(DFN,0),U,2)) D
 . S AG("ER",4)=""
 . S AG("DTOT")=AG("DTOT")+1
TRIBE ;
 G QUANT:$D(AG("ER",5))
 I $P(^AUPNPAT(DFN,11),U,8)="" D
 . S AG("ER",5)=""
 . S AG("DTOT")=AG("DTOT")+1
OLDTRIBE ;
 G QUANT:$D(AG("ER",5))
 I $P(^AUTTTRI($P(^AUPNPAT(DFN,11),U,8),0),U,4)="Y" D
 . S AG("ER",12)=""
 . S AG("DTOT")=AG("DTOT")+1
UNSTRIBE ;
 G QUANT:$D(AG("ER",5))
 I $P(^AUTTTRI($P(^AUPNPAT(DFN,11),U,8),0),U,2)=999 D
 . S AG("ER",5)=""
 . S AG("DTOT")=AG("DTOT")+1
QUANT ;
 G COMM:$D(AG("ER",6))
 I $P(^AUPNPAT(DFN,11),U,10)="" D
 . S AG("ER",6)=""
 . S AG("DTOT")=AG("DTOT")+1
COMM ;
 G BEN:$D(AG("ER",7))
 K AG("DATE")
 S AG("I")=0
 F AGI=1:1 S AG("I")=$O(^AUPNPAT(DFN,51,AG("I"))) G COMM1:AG("I")="" S AG("DATE")=AG("I")
COMM1 ;
 G COMM2:'$D(AG("DATE"))
 G COMM2:$P(^AUPNPAT(DFN,51,AG("DATE"),0),U,3)=""
 G BEN
COMM2 ;
 S AG("ER",7)=""
 S AG("DTOT")=AG("DTOT")+1
BEN ;
 G ELIG:$D(AG("ER",8))
 I $P(^AUPNPAT(DFN,11),U,11)="" D  G ELIG
 . S AG("ER",8)=""
 . S AG("DTOT")=AG("DTOT")+1
 I '$D(^AUTTBEN($P(^AUPNPAT(DFN,11),U,11),0)) D
 . S AG("ER",8)=""
 . S AG("DTOT")=AG("DTOT")+1
ELIG ;
 I AGOPT(14)'="Y" G END:$D(AG("ER",9)) D
 . D ^AGELCHK
 . S:$D(AG("ER",9)) AG("DTOT")=AG("DTOT")+1
END ;
 K AG("I"),AGI,I,X
 Q
