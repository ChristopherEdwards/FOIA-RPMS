BDMP411 ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**5**;JUN 14, 2007
 ;
 ;
EKG ;need date of last ekg
 S:'$D(BDMCUML(150)) BDMCUML(150)="EKG"
 S $P(BDMCUML(150),U,2)=$P(BDMCUML(150),U,2)+1
 S V=$$EKG^BDMP412(BDMPD,BDMRED,"I")
 I V]"" D
 .S E=$$FMDIFF^XLFDT(BDMADAT,V)
 .I E<(365.25*3) S $P(BDMCUML(150),U,3)=$P(BDMCUML(150),U,3)+1
 .I E<(365.25*5) S $P(BDMCUML(150),U,4)=$P(BDMCUML(150),U,4)+1
 .S $P(BDMCUML(150),U,5)=$P(BDMCUML(150),U,5)+1
TCHOL ;
 S:'$D(BDMCUML(180)) BDMCUML(180)="Total Cholesterol obtained in past 12 months"
 S $P(BDMCUML(180),U,2)=$P(BDMCUML(180),U,2)+1
 S V=$$CHOL^BDMD718(BDMPD,BDMBDAT,BDMADAT,"I")
 I V="" S $P(BDMCUML(180),U,6)=$P(BDMCUML(180),U,6)+1 G LDL
 S V=$P(V,U)
 I $E(V)'=+$E(V) S $P(BDMCUML(180),U,7)=$P(BDMCUML(180),U,7)+1 G LDL ;unable to determine result, not a number or is blank
 I V<200 S $P(BDMCUML(180),U,3)=$P(BDMCUML(180),U,3)+1
 I V<240&(V>199) S $P(BDMCUML(180),U,4)=$P(BDMCUML(180),U,4)+1
 I V>239 S $P(BDMCUML(180),U,5)=$P(BDMCUML(180),U,5)+1
LDL ;
 S:'$D(BDMCUML(190)) BDMCUML(190)="LDL Cholesterol obtained in the past 12 months"
 S $P(BDMCUML(190),U,2)=$P(BDMCUML(190),U,2)+1
 S V=$$LDL^BDMD718(BDMPD,BDMBDAT,BDMADAT,"I")
 I V="" S $P(BDMCUML(190),U,7)=$P(BDMCUML(190),U,7)+1 G HDL
 S V=$P(V,U)
 I $E(V)'=+$E(V) S $P(BDMCUML(190),U,8)=$P(BDMCUML(190),U,8)+1 G HDL ;unable to determine result, not a number or blank
 I V<100 S $P(BDMCUML(190),U,3)=$P(BDMCUML(190),U,3)+1
 I V<130&(V>99) S $P(BDMCUML(190),U,4)=$P(BDMCUML(190),U,4)+1
 I V>129&(V<161) S $P(BDMCUML(190),U,5)=$P(BDMCUML(190),U,5)+1
 I V>160 S $P(BDMCUML(190),U,6)=$P(BDMCUML(190),U,6)+1
HDL ;
 S:'$D(BDMCUML(195)) BDMCUML(195)="HDL Cholesterol obtained in the past 12 months"
 S $P(BDMCUML(195),U,2)=$P(BDMCUML(195),U,2)+1
 S V=$$HDL^BDMD718(BDMPD,BDMBDAT,BDMADAT,"I")
 I V="" S $P(BDMCUML(195),U,7)=$P(BDMCUML(195),U,7)+1 G TRIG
 S V=$P(V,U)
 I $E(V)'=+$E(V) S $P(BDMCUML(195),U,8)=$P(BDMCUML(195),U,8)+1 G TRIG ;unable to determine result, not a number
 S V=$P(V,".")
 I V<35 S $P(BDMCUML(195),U,3)=$P(BDMCUML(195),U,3)+1
 I V<46&(V>34) S $P(BDMCUML(195),U,4)=$P(BDMCUML(195),U,4)+1
 I V>45&(V<56) S $P(BDMCUML(195),U,5)=$P(BDMCUML(195),U,5)+1
 I V>55 S $P(BDMCUML(195),U,6)=$P(BDMCUML(195),U,6)+1
TRIG ;
 S:'$D(BDMCUML(200)) BDMCUML(200)="Triglycerides obtained in past 12 months"
 S $P(BDMCUML(200),U,2)=$P(BDMCUML(200),U,2)+1
 S V=$$TRIG^BDMD718(BDMPD,BDMBDAT,BDMADAT,"I")
 I V="" S $P(BDMCUML(200),U,7)=$P(BDMCUML(200),U,7)+1 G FAST
 S V=$P(V,U)
 I $E(V)'=+$E(V) S $P(BDMCUML(200),U,8)=$P(BDMCUML(200),U,8)+1 G FAST ;unable to determine result, not a number
 I V<150 S $P(BDMCUML(200),U,3)=$P(BDMCUML(200),U,3)+1
 I V<200&(V>149) S $P(BDMCUML(200),U,4)=$P(BDMCUML(200),U,4)+1
 I V>199&(V<401) S $P(BDMCUML(200),U,5)=$P(BDMCUML(200),U,5)+1
 I V>400 S $P(BDMCUML(200),U,6)=$P(BDMCUML(200),U,6)+1
FAST ;
 S:'$D(BDMCUML(600)) BDMCUML(600)="Fasting Glucose obtained ever"
 S $P(BDMCUML(600),U,2)=$P(BDMCUML(600),U,2)+1
 S V=$$FGLUCOSE^BDMD718(BDMPD,$P(^DPT(BDMPD,0),U,3),BDMADAT,"I")
 I V="" S $P(BDMCUML(600),U,7)=$P(BDMCUML(600),U,7)+1 G G75
 S V=$P(V,U)
 I $E(V)'=+$E(V) S $P(BDMCUML(600),U,8)=$P(BDMCUML(600),U,8)+1 G G75 ;unable to determine result, not a number
 S $P(BDMCUML(600),U,3)=$P(BDMCUML(600),U,3)+1
G75 ;
 S:'$D(BDMCUML(610)) BDMCUML(610)="75gm 2 hour glucose obtained ever"
 S $P(BDMCUML(610),U,2)=$P(BDMCUML(610),U,2)+1
 S V=$$G75^BDMD718(BDMPD,$P(^DPT(BDMPD,0),U,3),BDMADAT,"I")
 I V="" S $P(BDMCUML(610),U,7)=$P(BDMCUML(610),U,7)+1 G END
 S V=$P(V,U)
 I $E(V)'=+$E(V) S $P(BDMCUML(610),U,8)=$P(BDMCUML(610),U,8)+1 G END ;unable to determine result, not a number
 S $P(BDMCUML(610),U,3)=$P(BDMCUML(610),U,3)+1
END Q
CESS(P,B,D) ;EP - find any cessation hf in 12 months before E
 I '$G(P) Q ""
 NEW BDM,E,X,G,T
 K BDM
 S X=P_"^LAST HEALTH [DM AUDIT CESSATION HLTH FACTOR;DURING "_B_"-"_D S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) Q "Yes-"_$$FMTE^XLFDT($P(BDM(1),U))
 S X=P_"^EDUC [DM AUDIT SMOKING CESS EDUC;DURING "_B_"-"_D S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) Q "Yes-"_$$FMTE^XLFDT($P(BDM(1),U))
 NEW T S T=$O(^ATXAX("B","DM AUDIT SMOKING CESS EDUC",0))
 I 'T Q "No"
 S (X,G)=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  I $$REFUSAL^BDMP417(P,9999999.09,$P(^ATXAX(T,21,X,0),U),B,D) S G=1
 I G Q "Refused"
 Q "No"
 ;
