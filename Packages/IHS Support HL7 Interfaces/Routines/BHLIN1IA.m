BHLIN1IA ; cmi/sitka/maw - BHL File Inbound IN1 Segment (cont) ;   
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;this routine will file the inbound IN1 segment
 ;
 Q
 ;
UPI ;EP -- update private insurance
 S BHLPIMM=""
 S BHLPIM=0 F  S BHLPIM=$O(^AUPNPRVT(BHLPAT,11,BHLPIM)) Q:BHLPIM=""  D
 . S BHLDATA=$G(^AUPNPRVT(BHLPAT,11,BHLPIM,0))
 . I $P(BHLDATA,U)=BHLICNI,$P(BHLDATA,U,6)=BHLPED,$P(BHLDATA,U,8)=BHLPH S BHLPIMM=BHLPIM Q
 I BHLPIMM="" D  Q
 . S DIC="^AUPNPRVT("_BHLPAT_",11,"
 . S DIC("P")=$P(^DD(9000006,1101,0),U,2),DIC(0)="L",DA(1)=BHLPAT
 . S X="`"_BHLICN,DIC("DR")=".02///"_BHLIID_";.04///"_BHLNOI
 . S DIC("DR")=DIC("DR")_";.06///"_BHLPED_";.07///"_BHLPEXD
 . S DIC("DR")=DIC("DR")_";.08///"_BHLPH
 . D ^DIC
 . I Y<0 S BHLERCD="NOPIEM" X BHLERR Q
 S DIE="^AUPNPRVT("_BHLPAT_",11,"
 S DIC("P")=$P(^DD(9000006,1101,0),U,2),DA=BHLPIMM,DA(1)=BHLPAT
 S DR=".02///"_BHLIID_";.04///"_BHLNOI
 S DR=DR_";.07///"_BHLPEXD
 D ^DIE
 I $D(Y) S BHLERCD="NOUPIEM" X BHLERR Q
 Q
 ;
