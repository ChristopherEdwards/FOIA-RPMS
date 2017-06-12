APCDBMI ; IHS/CMI/LAB -BMI ;
 ;;2.0;IHS PCC SUITE;**10,11**;MAY 14, 2009;Build 58
BMICALC(APCDX) ;EP - called from input templates to calculate and store BMI
 I '$G(APCDX) Q
 D EN^XBNEW("CALCBMI1^APCDBMI","APCDX")
 K APCDX
 Q
CALCBMI1 ;
 ;NEW A,B,C,D,E,P,V,VD,W,H,BMI,HD,ERR,APCLFDA,BIEN,X,Y,DA
 S A=$$GET1^DIQ(9000010.01,APCDX,.01)
 I A'="HT",A'="WT" Q  ;only ht/wt
 I A="WT" D CALCBMIW Q
 I A="HT" D CALCBMIH Q
 Q
CALCBMIW ;
 S BMI=""
 ;weight was just entered so calculate and store a bmi and bmip
 S W=$$GET1^DIQ(9000010.01,APCDX,.04)  ;wt value is in W
 Q:W=""
 S DFN=$$GET1^DIQ(9000010.01,APCDX,.02,"I")  ;patient dfn
 Q:DFN=""
 S V=$$GET1^DIQ(9000010.01,APCDX,.03,"I")  ;visit ien is in V
 Q:V=""
 S VD=$$VD^APCLV(V)  ;visit date
 S AGE=$$AGE^AUPNPAT(DFN,VD)  ;age of patient on visit date
 S H=$$LASTHT(DFN,VD)  ;get last height entered that is allowable for age (same day for <18, last 5 YRS for 19-49, last 2 years for 50 AND OVER)
 I H="" Q  ;no ht so don't calculate anything
 S HD=$P(H,U,2)
 S H=$P(H,U)
 ;calc bmi
 S W=W*.45359,H=(H*.0254),H=(H*H),BMI=(W/H)
 ;
 I $$HASVM(V,"BMI",BMI) G BMIP  ;already has this bmi value on this visit so don't store it again, go do BMIP
 D STORE(V,DFN,"BMI",BMI,APCDX,HD)
 ;NOW STORE BMIP
 D BMIP
 Q
STORE(V,DFN,TYPE,VALUE,APCDX,HD) ;
 ;store BMI as v meas
 K APCDALVR
 S APCDALVR("APCDVSIT")=V
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.01 (ADD)]"
 S APCDALVR("APCDTTYP")="`"_$O(^AUTTMSR("B",TYPE,0))
 S APCDALVR("APCDPAT")=DFN
 S APCDALVR("APCDTVAL")=VALUE
 S APCDALVR("APCDTEPR")="`"_DUZ
 S APCDALVR("APCDTCDT")=$$GET1^DIQ(9000010.01,APCDX,1201)
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) D EN^DDIOL("UNABLE TO STORE "_TYPE_" VALUE OF "_VALUE_" HT DATE "_$$FMTE^XLFDT(HD))
 Q
CALCBMIH ;
 ;ht added, calculate bmi for this date and forward till find another ht
 ;first delete all bmis and bmips from this date/time forward
 ;table all visits from this date/time forward that have a WT or BMI or BMIP
 ;Quit when another HT is found
 S BMI=""
 ;HEIGHT was just entered so RE-calculate and store a bmi and bmip FROM THIS VISIT
 ;FORWARD UNTIL WE FIND ANOTHER HT
 S HT=$$GET1^DIQ(9000010.01,APCDX,.04)  ;wt value is in B
 Q:HT=""
 S DFN=$$GET1^DIQ(9000010.01,APCDX,.02,"I")  ;patient dfn is in P
 Q:DFN=""
 S V=$$GET1^DIQ(9000010.01,APCDX,.03,"I")  ;visit ien is in V
 Q:V=""
 S HD=$$VD^APCLV(V)
 S AGE=$$AGE^AUPNPAT(DFN,$$VD^APCLV(V))
 K APCDVAR
 I AGE>18,AGE<50 S E=$$FMADD^XLFDT($$VD^APCLV(V),(5*365))
 I AGE>49 S E=$$FMADD^XLFDT($$VD^APCLV(V),(2*365))
 I AGE<19 S E=$$VD^APCLV(V)
 D ALLV^APCLAPIU(DFN,$$VD^APCLV(V),E,"APCDVAR")
 ;REORDER BY DATE LOWEST TO HIGHEST
 S APCDSTOP=""
 S X=0 F  S X=$O(APCDVAR(X)) Q:X'=+X  D
 .S N=$P(APCDVAR(X),U,5)
 .S APCDVAR("LH",$$VDTM^APCLV(N),X)=APCDVAR(X)
 S D=0 F  S D=$O(APCDVAR("LH",D)) Q:D'=+D  D
 .S X=0 F  S X=$O(APCDVAR("LH",D,X)) Q:X'=+X  D
 ..S N=$P(APCDVAR("LH",D,X),U,5)
 ..I $$VDTM^APCLV(N)<$$VDTM^APCLV(V) K APCDVAR("LH",D,X)  ;BEFORE MY VISIT, DON'T DEAL WITH IT
 ..I '$$HASAVM(N,"WT") K APCDVAR("LH",D,X)  ;no wts so don't bother, can't calculate bmi
 ..I $$HASAVM(N,"HT"),N'=V S A=D,B=X D  ;KILL OFF ALL REMAINING
 ...F  S A=$O(APCDVAR("LH",A)) Q:A'=+A  F  S B=$O(APCDVAR("LH",A,B)) Q:B'=+B  K APCDVAR("LH",A,B)
 ;now calculate bmi on this array of visits
 S D=0 F  S D=$O(APCDVAR("LH",D)) Q:D=""  D
 .S X=0 F  S X=$O(APCDVAR("LH",D,X)) Q:X=""  D
 ..S N=$P(APCDVAR(X),U,5)  ;visit ien
 ..S APCDAGE=$$AGE^AUPNPAT(DFN,$$VD^APCLV(N))
 ..;delete all bmis and bmips
 ..F  S APCDZ=$$HASVM(N,"BMI",BMI) Q:'APCDZ  D FILEEIE(APCDZ)
 ..F  S APCDZ=$$HASVM(N,"BMIP",BMI) Q:'APCDZ  D FILEEIE(APCDZ)
 ..;NOW ADD NEW BMI/BMIP
 ..S APCDA=0 F  S APCDA=$O(^AUPNVMSR("AD",N,APCDA)) Q:APCDA'=+APCDA  D
 ...Q:$P($G(^AUPNVMSR(APCDA,2)),U,1)
 ...Q:$$VAL^XBDIQ1(9000010.01,APCDA,.01)'="WT"
 ...S W=$$VAL^XBDIQ1(9000010.01,APCDA,.04)
 ...S H=$$LASTHT(DFN,$$VD^APCLV(N))  ;get last height entered that is allowable for age (same day for <18, last 5 YRS for 19-49, last 2 years for 50 AND OVER)
 ...I H="" Q  ;no ht so don't calculate anything
 ...S HD=$P(H,U,2)
 ...S H=$P(H,U)
 ...;calc bmi
 ...S W=W*.45359,H=(HT*.0254),H=(H*H),BMI=(W/H)
 ...I '$$HASVM(V,"BMI",BMI) D STORE(N,DFN,"BMI",BMI,APCDX,HD)
 ...Q:$T(BMIPCT^BEHOVM2)=""   ;no routine to calculate
 ...Q:APCDAGE<2
 ...Q:APCDAGE>18
 ...S BMIPCT=$$BMIPCT^BEHOVM2(BMI,DFN,$$VD^APCLV(N))
 ...I BMIPCT'>0 Q
 ...;store bmip
 ...I $$HASVM(N,"BMIP",BMIPCT) Q  ;already has this bmiP value on this visit so don't store it again, Q
 ...;store BMIP as v meas
 ...D STORE(N,DFN,"BMIP",BMIPCT,APCDX,HD)
 Q
LASTHT(P,VD) ;get last allowable ht for patient's age to calculate BMI
 I '$G(P) Q ""
 I '$G(VD) Q ""
 NEW A,CD,VALUE,%
 S VALUE=""
 S A=$$AGE^AUPNPAT(P,VD)  ;age of patient on visit date
 I A<2 Q VALUE
 I A>18,A<50 D  Q VALUE  ;get last ht in past 5 years
 .S CD=$$FMADD^XLFDT(VD,-(5*365))  ;5 yrs
 .S %=$$LASTITEM^APCLAPIU(P,"HT","MEASUREMENT",CD,VD,"A")
 .Q:%=""
 .S VALUE=$P(%,U,3)_U_$P(%,U,1)  ;send back ht value^ht date
 ;NOW DO OVER 49
 I A>49 D  Q VALUE
 .S CD=$$FMADD^XLFDT(VD,-(2*365))
 .S %=$$LASTITEM^APCLAPIU(P,"HT","MEASUREMENT",CD,VD,"A")
 .Q:%=""
 .S VALUE=$P(%,U,3)_U_$P(%,U,1)  ;send back ht value^ht date
 ;UNDER 19 MUST BE ON SAME DATE AS WT
 S %=$$LASTITEM^APCLAPIU(P,"HT","MEASUREMENT",VD,VD,"A")
 I %="" Q ""
 S VALUE=$P(%,U,3)_U_$P(%,U,1)  ;send back ht value^ht date
 Q VALUE
 ;
HASVM(V,T,B) ;
 NEW Y,G
 S Y=0,G=0 F  S Y=$O(^AUPNVMSR("AD",V,Y)) Q:Y'=+Y!(G)  D
 .Q:$$GET1^DIQ(9000010.01,Y,.01)'=T
 .Q:$$GET1^DIQ(9000010.01,Y,.04)'=B
 .Q:$P($G(^AUPNVMSR(Y,2)),U,1)  ;EIE
 .S G=Y
 Q G
BMIP ;
 Q:$T(BMIPCT^BEHOVM2)=""   ;no routine to calculate
 Q:AGE<2
 Q:AGE>18
 S BMIPCT=$$BMIPCT^BEHOVM2(BMI,DFN,VD)
 I BMIPCT'>0 Q
 ;store bmip
 I $$HASVM(V,"BMIP",BMIPCT) Q  ;already has this bmiP value on this visit so don't store it again, Q
 ;store BMIP as v meas
 D STORE(V,DFN,"BMIP",BMIPCT,APCDX,HD)
 Q
EIE(APCDX) ;EP - wt or ht entered in error, bmi eie
 I '$G(APCDX) Q
 D EN^XBNEW("EIE1^APCDBMI","APCDX")
 K APCDX
 Q
EIE1 ;
 ;NEW A,B,C,D,E,P,V,VD,W,H,BMI,HD,ERR,APCLFDA,BIEN,X,Y,DA
 S A=$$GET1^DIQ(9000010.01,APCDX,.01)
 I A'="HT",A'="WT" Q  ;only ht/wt
 I A="WT" D EIEW Q
 I A="HT" D EIEH Q
 Q
EIEW ;WT ENTERED IN ERROR
 ;if no other wts deleted all bmi, bmip on this visit
 ;
 S V=$$GET1^DIQ(9000010.01,APCDX,.03,"I")  ;visit ien is in V
 Q:V=""
 I '$$HASAVM(V,"WT") D  Q
 .;find all bmi's and bmip's and mark them EIE
 .S APCDY=0 F  S APCDY=$O(^AUPNVMSR("AD",V,APCDY)) Q:APCDY'=+APCDY  D
 ..Q:$P($G(^AUPNVMSR(APCDY,2)),U,1)  ;ALREADY EIE
 ..S T=$$GET1^DIQ(9000010.01,APCDY,.01)
 ..I T'="BMI",T'="BMIP" Q
 ..;mark as EIE
 ..D FILEEIE(APCDY)
 ;WHAT IF THERE IS ALREADY A WT SO NEED TO DELETE THE CORRECT BMI SO FIND BMI/BMIP AND DELETE
 S W=$$GET1^DIQ(9000010.01,APCDX,.04)  ;wt value is in B
 Q:W=""
 S DFN=$$GET1^DIQ(9000010.01,APCDX,.02,"I")  ;patient dfn is in P
 Q:DFN=""
 S V=$$GET1^DIQ(9000010.01,APCDX,.03,"I")  ;visit ien is in V
 Q:V=""
 S VD=$$VD^APCLV(V)  ;visit date
 S AGE=$$AGE^AUPNPAT(DFN,VD)  ;age of patient on visit date
 S H=$$LASTHT(DFN,VD)  ;get last height entered that is allowable for age (same day for <18, last 5 YRS for 19-49, last 2 years for 50 AND OVER)
 I H="" Q  ;no ht so don't calculate anything
 S HD=$P(H,U,2)
 S H=$P(H,U)
 ;calc bmi
 S W=W*.45359,H=(H*.0254),H=(H*H),BMI=(W/H)
 ;find bmi with this value and mark as EIE
 F  S APCDZ=$$HASVM(V,"BMI",BMI) Q:'APCDZ  D FILEEIE(APCDZ)
 ;now find bmip
 Q:$T(BMIPCT^BEHOVM2)=""   ;no routine to calculate
 Q:AGE<2
 Q:AGE>18
 S BMIPCT=$$BMIPCT^BEHOVM2(BMI,DFN,VD)
 I BMIPCT'>0 Q
 F  S APCDZ=$$HASVM(V,"BMIP",BMIPCT) Q:'APCDZ  D FILEEIE(APCDZ)
 Q
EIEH ;
 ;IF HT ENTERED IN ERROR, DELETE ALL BMIS AND BMIPS UNTIL FIND ANOTHER HT, MARK THEM ALL EIE
 S DFN=$$GET1^DIQ(9000010.01,APCDX,.02,"I")  ;patient dfn is in P
 Q:DFN=""
 S V=$$GET1^DIQ(9000010.01,APCDX,.03,"I")  ;visit ien is in V
 Q:V=""
 S HD=$$VD^APCLV(V)
 S AGE=$$AGE^AUPNPAT(DFN,$$VD^APCLV(V))
 K APCDVAR
 I AGE>18,AGE<50 S E=$$FMADD^XLFDT($$VD^APCLV(V),(5*365))
 I AGE>49 S E=$$FMADD^XLFDT($$VD^APCLV(V),(2*365))
 I AGE<19 S E=$$VD^APCLV(V)
 D ALLV^APCLAPIU(DFN,$$VD^APCLV(V),E,"APCDVAR")
 ;REORDER BY DATE LOWEST TO HIGHEST
 S APCDSTOP=""
 S X=0 F  S X=$O(APCDVAR(X)) Q:X'=+X  D
 .S N=$P(APCDVAR(X),U,5)
 .S APCDVAR("LH",$$VDTM^APCLV(N),X)=APCDVAR(X)
 S D=0 F  S D=$O(APCDVAR("LH",D)) Q:D'=+D  D
 .S X=0 F  S X=$O(APCDVAR("LH",D,X)) Q:X'=+X  D
 ..S N=$P(APCDVAR("LH",D,X),U,5)
 ..I $$VDTM^APCLV(N)<$$VDTM^APCLV(V) K APCDVAR("LH",D,X)  ;BEFORE MY VISIT, DON'T DEAL WITH IT
 ..I '$$HASAVM(N,"WT") K APCDVAR("LH",D,X)  ;no wts so don't bother, can't calculate bmi
 ..I $$HASAVM(N,"HT"),N'=V S A=D,B=X D  ;KILL OFF ALL REMAINING
 ...F  S A=$O(APCDVAR("LH",A)) Q:A'=+A  F  S B=$O(APCDVAR("LH",A,B)) Q:B'=+B  K APCDVAR("LH",A,B)
 ;nowDELETE bmi/BMIP on this array of visits
 S D=0 F  S D=$O(APCDVAR("LH",D)) Q:D=""  D
 .S X=0 F  S X=$O(APCDVAR("LH",D,X)) Q:X=""  D
 ..S N=$P(APCDVAR(X),U,5)  ;visit ien
 ..S APCDAGE=$$AGE^AUPNPAT(DFN,$$VD^APCLV(N))
 ..;delete all bmis and bmips
 ..F  S APCDZ=$$HASAVM(N,"BMI") Q:'APCDZ  D FILEEIE(APCDZ)
 ..F  S APCDZ=$$HASAVM(N,"BMIP") Q:'APCDZ  D FILEEIE(APCDZ)
 ..;NOW ADD NEW BMI/BMIP WITH HT PREVIOUS TO THE ONE DELETED, IF WE CAN
 ..S APCDA=0 F  S APCDA=$O(^AUPNVMSR("AD",N,APCDA)) Q:APCDA'=+APCDA  D
 ...Q:$P($G(^AUPNVMSR(APCDA,2)),U,1)
 ...Q:$$VAL^XBDIQ1(9000010.01,APCDA,.01)'="WT"
 ...S W=$$VAL^XBDIQ1(9000010.01,APCDA,.04)
 ...;calc bmi
 ...S H=$$LASTHT(DFN,$$VD^APCLV(N))  ;get last height entered that is allowable for age (same day for <18, last 5 YRS for 19-49, last 2 years for 50 AND OVER)
 ...I H="" Q  ;no ht so don't calculate anything
 ...S HD=$P(H,U,2)
 ...S H=$P(H,U)
 ...;calc bmi
 ...S W=W*.45359,H=(H*.0254),H=(H*H),BMI=(W/H)
 ...I '$$HASVM(V,"BMI",BMI) D STORE(N,DFN,"BMI",BMI,APCDA,HD)
 ...Q:$T(BMIPCT^BEHOVM2)=""   ;no routine to calculate
 ...Q:APCDAGE<2
 ...Q:APCDAGE>18
 ...S BMIPCT=$$BMIPCT^BEHOVM2(BMI,DFN,$$VD^APCLV(N))
 ...I BMIPCT'>0 Q
 ...;store bmip
 ...I $$HASVM(N,"BMIP",BMIPCT) Q  ;already has this bmiP value on this visit so don't store it again, Q
 ...;store BMIP as v meas
 ...D STORE(N,DFN,"BMIP",BMIPCT,APCDA,HD)
 Q
FILEEIE(APCDY) ;
 I '$G(APCDY) Q
 I '$D(^AUPNVMSR(APCDY)) Q
 NEW APCDIENS,APCDFDA,APCDERR,DA,DIK
 S APCDIENS=APCDY_","
 S APCDFDA(9000010.01,APCDIENS,2)=1
 S APCDFDA(9000010.01,APCDIENS,3)=DUZ
 ;S APCDFDA(9000010.014,"+1,"_APCDIENS,.01)=$P(BEHDATA,"^",3)
 D UPDATE^DIE("","APCDFDA","APCDIEN","APCDERR")
 ;NOW MERGE OVER THE RESONS FROM THE OTHER ENTRY
 M ^AUPNVMSR(APCDY,2.1)=^AUPNVMSR(APCDX,2.1)
 ;REINDEX
 S DA=APCDY,DIK="^AUPNVMSR(" D IX^DIK K DA,DIK
 Q
 ;
HASAVM(V,T) ;
 NEW Y,G
 S Y=0,G=0 F  S Y=$O(^AUPNVMSR("AD",V,Y)) Q:Y'=+Y!(G)  D
 .Q:$$GET1^DIQ(9000010.01,Y,.01)'=T
 .Q:$P($G(^AUPNVMSR(Y,2)),U,1)  ;EIE
 .S G=Y
 Q G
