ABMDVST3 ; IHS/ASDST/DMJ - PCC VISIT STUFF - PART 4 (ICD PROCEDURE) ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;;Y2K/OK - IHS/ADC/JLG 12-18-97
 ;Original;TMD;03/26/96 12:26 PM
 ;
 Q:ABMIDONE
 ; undinumed
PRC S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",19,",DIC(0)="LE"
 S ABMR("P")=2
 S ABMI=""
 F  S ABMI=$O(^AUPNVPRC("AD",ABMVDFN,ABMI)) Q:'ABMI  D
 .K DIC("DR"),DD,DO
 .D PRCCHK
 K ABMR,ABMI,ABMSRC,DIC
 Q
 ;
PRCCHK Q:'$D(^AUPNVPRC(ABMI,0))
 N ABMOKNEW,ABMEDIT
 S ABMEDIT=0
 ;Set to 1 or 2, 7th piece is principle proc
 S ABMR("PX")=$S($P(^AUPNVPRC(ABMI,0),U,7)="Y":1,1:ABMR("P"))
 ;Sets the 2 vars to the last value of the subscript+1
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,"C",ABMR("PX")))=10 S ABMR="" F  S ABMR=$O(^(ABMR)) Q:ABMR=""  S (ABMR("PX"),ABMR("P"))=ABMR+1
 ;Sets var to procedure date if it exists or to visit date
 S ABMR("VDT")=$S($P(^AUPNVPRC(ABMI,0),U,6)]"":$P(^(0),U,6),1:ABMCHVDT)
 ;Diagnosis
 ;S ABMR("CDX")=$S($P(^AUPNVPRC(X,0),U,5)]"":$P(^(0),U,5),1:"")
 S ABMSRC="08|"_ABMI_"|ICD"
 ; setting prov narrative
 S X=$P(^AUPNVPRC(ABMI,0),U),ABMR("NAR")=$P(^(0),U,4)
 I '$D(@(DIC_"0)")) S @(DIC_"0)")="^9002274.3019P",ABMOKNEW=1
 E  D
 .S ABMOKNEW=1
 .S ABM=0
 .F  S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,ABM)) Q:'ABM  D  Q:'ABMOKNEW
 ..S Y=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,ABM,0))
 ..Q:($P(Y,U,17)]"")&(ABMSRC'=$P(Y,U,17))
 ..I $P(Y,U,17)="",X'=$P(Y,U) Q
 ..S ABMOKNEW=0
 ..I (X'=$P(Y,U))!(ABMR("VDT")'=$P(Y,U,3))!(ABMR("NAR")'=$P(Y,U,4)) S ABMEDIT=1 Q
 ..I $P(Y,U,17)="",X=$P(Y,U) S ABMEDIT=1
 I ABMOKNEW D  Q
 .S DIC("DR")=".02////"_ABMR("PX")_";.03////"_ABMR("VDT")_";.04////"_ABMR("NAR")
 .;S:ABMR("CDX")]"" DIC("DR")=DIC("DR")_";.05////"_ABMR("CDX")
 .S DIC("DR")=DIC("DR")_";.17////"_ABMSRC
 .S:ABMR("PX")>1 ABMR("P")=ABMR("P")+1
 .K DD,DO D FILE^DICN
 I ABMEDIT D
 .N FILE,IENS,ABMFDA
 .S FILE=9002274.3019
 .S IENS=ABM_","_ABMP("CDFN")_","
 .S ABMFDA(FILE,IENS,.01)=X
 .S ABMFDA(FILE,IENS,.03)=ABMR("VDT")
 .S ABMFDA(FILE,IENS,.04)=ABMR("NAR")
 .S ABMFDA(FILE,IENS,.17)=ABMSRC
 .D FILE^DIE("K","ABMFDA")
 Q
