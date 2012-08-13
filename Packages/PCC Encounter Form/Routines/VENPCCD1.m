VENPCCD1 ; IHS/OIT/GIS - PATIENT DEMOG UPDATE - CONTINUATION ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ;
 ;
PI ; EP-PVT INSURANCE
 W !,?5,IOUON,IOINHI,"Private Ins.: "
 I $O(^AUPNPRVT(DFN,11,0))="" W "NONE ON FILE" Q
 W IOUOFF,IOINLOW
 S VEN("PI")=0
 F  S VEN("PI")=$O(^AUPNPRVT(DFN,11,VEN("PI"))) Q:+VEN("PI")=0  D
 .S VENPI=^AUPNPRVT(DFN,11,VEN("PI"),0)
 .S VEN("PIN")=$P(^AUTNINS(($P(VENPI,"^",1)),0),"^",1)
 .S (VEN("ST"),Y)=$P(VENPI,"^",6) I Y'="" D DD^%DT S VEN("ST")=Y
 .S (VEN("EN"),Y)=$P(VENPI,"^",7) I Y'="" D DD^%DT S VEN("EN")=Y
 .S VEN("HO")=$P($G(^AUPN3PPH((+$P(VENPI,"^",8)),0)),U)
 .W !,?10,VEN("PIN"),!," (Policy Holder: ",VEN("HO")," )  ",VEN("ST"),"  to  ",VEN("EN")
 Q
MDCD ; EP-MEDICAID
 N MDIEN,START,FIN,TOT,Y
 S TOT=0
 S MDIEN=$O(^AUPNMCD("B",$G(DFN),0)) I 'MDIEN Q
 W !,?5,IOUON,IOINHI,"Medicaid: (last 4 times eligible)"
 I '$D(^AUPNMCD("B",DFN)) W "NONE ON FILE" Q
 W IOUOFF,IOINLOW
 S START=9999999
 F  S START=$O(^AUPNMCD(MDIEN,11,START),-1) Q:'START  D  I TOT>3 Q
 . S TOT=TOT+1
 . S FIN=$P($G(^AUPNMCD(MDIEN,11,START,0)),U,2)
 . W !,?10
 . S Y=$E(START,1,5) X ^DD("DD") W Y
 . I 'FIN W " to ???" Q
 . S Y=$E(FIN,1,5) X ^DD("DD") W " to ",Y
 . I TOT=1 W "  (currently eligible)" Q
 Q
MCR ; EP-MEDICARE
 W !,?5,IOUON,IOINHI,"Medicare: "
 I (VEN("AGE")>64)&('$D(^AUPNMCR(DFN))) D MCRFL Q
 I '$D(^AUPNMCR(DFN)) W "NONE ON FILE" Q
 W IOUOFF,IOINLOW
 S VEN("MRTY")=""
 S N=0
 F  S N=$O(^AUPNMCR(DFN,11,N)) Q:+N=0  D
 .S VEN("R")=^AUPNMCR(DFN,11,N,0)
 .S (VEN("S"),Y)=$P(VEN("R"),"^",1) I Y'="" D DD^%DT S VEN("S")=Y
 .S (VEN("E"),Y)=$P(VEN("R"),"^",2) I Y'="" D DD^%DT S VEN("E")=Y
 .S VEN("P")=$P(VEN("R"),"^",3)
 .W !,?10,"START: ",VEN("S")," to ",VEN("E"),"  Plan: ",VEN("P")
 Q
PICK ;   
 S N=0
 K VEN("PI")
 F  S N=$O(^AUPNPRVT(DFN,11,N)) Q:+N=0  D
 .S VEN("R")=^AUPNPRVT(DFN,11,N,0)
 .S VEN("END")=$P(VEN("R"),"^",7)
 .S VEN("ST")=$P(VEN("R"),"^",6)
 .S VEN("IN")=$P(VEN("R"),"^"),VEN("IN")=$P($G(^AUTNINS(VEN("IN"),0)),"^",1)
 .I (VEN("END")="")&(DT'<VEN("ST")) S VEN("PI",N)=VEN("IN") Q
 .I (DT'<VEN("ST"))&(DT'>VEN("END")) S VEN("PI",N)=VEN("IN") Q
 Q
ELIG ; EP-edit the elig. information from pat. reg
 Q:'DFN
 S AGXTERN=""
 K DIC
 D ^AGVAR
 D DFN^AGEDIT
 I $$VERSION^XPDUTL("AG")["7." D VAR^AGED4A G KILL
 D ^AGED4,^AGED5,^AGED6,^AGED7
KILL ;
 K ^UTILITY("DIQ1",$J)
 K AG,AGCHRT,AGI,AGLINE,AGOPT,AGPAT,AGSITE,AGUPDT
 K AG("DENT"),DFOUT,DIC,DIE,DLOUT,DTOUT,DQOUT,DUOUT,G,AGL,I,L,AGNEW,AGPCC,AGSCRN,AGTEMP,AG("TRBCODE")
 K AGXTERN
 Q
EMPL ; EP-changes to employer, employment status or spouses employer
 N GBL,%,DIE,DIC,DR,DA,X,Y
 S GBL=$NA(AGPATCH)
 Q:'DFN
 S DIE="^AUPNPAT(",DA=DFN,DR=".19;.21;.22;.03////DT;.16////DT;.12////DUZ"
 L +^AUPNPAT(DA):0 I $T D ^DIE L -^AUPNPAT(DA)
 D NOW^%DTC
 S @GBL@(%,DUZ(2),DFN)=""
 Q
MCRFL ; EP-medicare alert--person over 64 and not on file with medicare
 U 0 W *7,IOINHI,IOBON,"PERSON OVER 64--NO MEDICARE ON FILE!!!",IOINLOW,IOBOFF
 Q
