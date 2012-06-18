AGELA1 ; IHS/ASDS/EFG - Eligibility Display (CONT) ;   
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
MCD S AGEL=""
 F AGEL("I")=1:1 S AGEL=$O(^AUPNMCD("C",AGELP("PH"),AGEL)) Q:'+AGEL  D
 .S AGEL(0)=^AUPNMCD(AGEL,0) Q:'$D(^DPT(+AGEL(0),0))
 .S AGELP("MCD")=AGEL
 .W !,AGEL("I")+12,") ",$P(^DPT(+AGEL(0),0),U)
 .I $D(DUZ(2)),$D(^AUPNPAT(AGEL(0),41,DUZ(2),0)) W ?35,$P(^(0),U,2)
 .S AGELP(+AGEL(0))=(AGEL("I")+12)_U_AGEL
 .W ?44
 .W $S($P(AGEL(0),U,6)]"":$P(^AUTTRLSH($P(AGEL(0),U,6),0),U),1:"SELF")
 .S (AGEL("HIT"),AGEL(1),AGEL("LAST"),AGEL("NUM"))=0
 .F  S AGEL(1)=$O(^AUPNMCD(AGEL,11,AGEL(1))) Q:'+AGEL(1)  S AGEL(10)=^(AGEL(1),0) D  Q:AGEL("HIT")
 ..I $P(AGEL(10),U,2)="" S AGEL("HIT")=1,AGEL("NUM")=AGEL(1) Q
 ..I $P(AGEL(10),U,2)>AGEL("LAST") D
 ...S AGEL("LAST")=$P(AGEL(10),U,2),AGEL("NUM")=AGEL(1)
 .I AGEL("NUM") D
 ..S AGEL("DT")=$P(^AUPNMCD(AGEL,11,AGEL("NUM"),0),U)
 ..S $P(AGELP(+AGEL(0)),U,3)=AGEL("DT")
 ..D DT
 ..W ?62,AGEL("DT")
 ..I $P(^AUPNMCD(AGEL,11,AGEL("NUM"),0),U,2)]"" S AGEL("DT")=$P(^AUPNMCD(AGEL,11,AGEL("NUM"),0),U,2) D DT W ?71,"/",AGEL("DT")
 Q
PRVT S AGEL=""
 F AGEL("I")=1:1 S AGEL=$O(^AUPNPRVT("C",AGELP("PH"),AGEL)) Q:'+AGEL  S AGEL(1)=$O(^(AGEL,"")) D
 .I '$D(^AUPNPRVT(AGEL,0)) K ^AUPNPRVT("C",AGELP("PH"),AGEL) Q
 .S AGEL(0)=$G(^AUPNPRVT(AGEL,0))
 .S AGEL(10)=$G(^AUPNPRVT(AGEL,11,AGEL(1),0))
 .S AGEL(2)=$G(^AUPNPRVT(AGEL,11,AGEL(1),2))
 .S AGELP("PI")=AGEL
 .;# and member name
 .W !,AGEL("I")+12,") "
 .W:$P(AGEL(0),U)'="" $E($P($G(^DPT($P(AGEL(0),U),0)),U),1,17)
 .;new person code
 .W:$P(AGEL(10),U,12)]"" ?22,$P(AGEL(10),U,12)
 .;member #
 .I $P($G(AGEL(2)),U)="",($G(AGEL)=$G(AGELP("PHPAT"))) D
 ..S DIE="^AUPNPRVT("_AGEL_",11,"
 ..S DA=AGEL(1)
 ..S DR="21////"_$P($G(^AUPN3PPH(AGELP("PH"),0)),U,4)
 ..D ^DIE
 ..S AGEL(2)=$G(^AUPNPRVT(AGEL,11,AGEL(1),2))
 .W:$P(AGEL(2),U)]"" ?26,$E($P(AGEL(2),U),1,13)
 .;hrn
 .I $D(DUZ(2)),$D(^AUPNPAT(AGEL(0),41,DUZ(2),0)) D
 ..W ?42,$P(^AUPNPAT(AGEL(0),41,DUZ(2),0),U,2)
 .S AGELP(+AGEL(0))=(AGEL("I")+12)_U_AGEL(1)
 .;relationship
 .W ?50
 .S AGREL=$P(AGEL(10),U,5)
 .I AGREL'=""  D
 ..S AGREL=$S($P($G(^AUTTRLSH(AGREL,0)),U)'="":$P(^AUTTRLSH(AGREL,0),U),1:"SELF")
 .E  S AGREL=""
 .W $E(AGREL,1,9)
 .;from/thru
 .S AGEL("DT")=$P(AGEL(10),U,6)
 .D DT
 .W ?60,AGEL("DT")
 .S AGEL("DT")=$P(AGEL(10),U,7)
 .D DT
 .I AGEL("DT")]"" W "-",AGEL("DT")
 Q
DT ;
 I AGEL("DT")]"" S AGEL("DT")=$$FMTE^XLFDT(AGEL("DT"),5)
 Q
