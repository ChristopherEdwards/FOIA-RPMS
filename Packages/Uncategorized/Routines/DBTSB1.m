DBTSB1 ;IHS/BAO/DMH  ROUTINE CALLED FROM DBTSBEG [ 11/02/1999  5:16 PM ]
 ;BAO 2/8/99
 ;    copy of dbtsb1 for test on to pull visit info too...9/30/99
ST ;
 D @ENT
 Q
1 ;    chk for demographic chgs or adds
 I $P($G(^DBTSPAT(DBTSP,0)),"^",2)="" S DBTSAU=1 D VISITCK Q
 S DBTS("LM")=$P(^AUPNPAT(DBTSP,0),U,3)
 S DBTS("LDT")=$P($G(^DBTSPAT(DBTSP,0)),U,2)
 I (DBTS("LDT")>(DBTS("LM"))) S DBTSAU=0
 E  S DBTSAU=1 
 D VISITCK   ;dmh added this visit check to see if any new or mod visits
 D PROBCK   ;dmh added this 11-2-99
 Q
VISITCK ;   chk for patient chgs or adds
 ;
 S SETFL=0
 I ($P($G(^DBTSPAT(DBTSP,"V")),"^",1)="") D  Q
 .I '$D(^AUPNVSIT("AC",DBTSP)) S DBTSAU=DBTSAU_U_0 Q
 .S DBTSAU=DBTSAU_U_1 Q
 S REC=^DBTSPAT(DBTSP,"V")
 S DBTS("LDFN")=$P(REC,U,1),DBTS("LDT")=$P(REC,U,2)
 S N=0
 F  S N=$O(^AUPNVSIT("AC",DBTSP,N)) Q:+N=0  D  I SETFL=1 Q
 .I N>(DBTS("LDFN")) S DBTSAU=DBTSAU_U_1 S SETFL=1 Q
 .S DBTS("MODDT")=$P($G(^AUPNVSIT(N,0)),U,13)
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=DBTSAU_U_1 S SETFL=1
 .Q
 I SETFL=0 S DBTSAU=DBTSAU_U_0
 Q
PROBCK ;
 S SETFL=0
 I ($P($G(^DBTSPAT(DBTSP,"PROB")),"^",1)="") D  Q
 .I '$D(^AUPNPROB("AC",DBTSP)) S DBTSAU=DBTSAU_U_0 Q
 .S DBTSAU=DBTSAU_U_1 Q
 S REC=^DBTSPAT(DBTSP,"PROB")
 S DBTS("LDFN")=$P(REC,U,1),DBTS("LDT")=$P(REC,U,2)
 S N=0
 F  S N=$O(^AUPNPROB("AC",DBTSP,N)) Q:+N=0  D  I SETFL=1 Q
 .I N>(DBTS("LDFN")) S DBTSAU=DBTSAU_U_1 S SETFL=1 Q
 .S DBTS("MODDT")=$P($G(^AUPNPROB(N,0)),U,3)
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=DBTSAU_U_1 S SETFL=1
 .Q
 I SETFL=0 S DBTSAU=DBTSAU_U_0
 Q
2 ;    chk for meas. chgs. or adds
 F X="BP","HT","WT" D 
 .S REC=$G(^DBTSPAT(DBTSP,X))
 .S LDFN=$P(REC,U,1),LDT=$P(REC,U,2)
 .I '$D(DBTS("LDFN")) S DBTS("LDFN")=LDFN
 .I '$D(DBTS("LDT")) S DBTS("LDT")=LDT
 .I LDT>(DBTS("LDT")) S DBTS("LDT")=LDT
 .I LDFN>(DBTS("LDFN")) S DBTS("LDFN")=LDFN
 S DBTSAU=0
 S N=0
 F  S N=$O(^AUPNVMSR("AC",DBTSP,N)) Q:+N=0  D  I DBTSAU=1 Q
 .S MSR=$G(^AUPNVMSR(N,0))
 .S VD=$P(MSR,U,3)
 .S DBTS("TY")=$P(MSR,U,1)
 .I DBTS("TY")="" Q
 .S DBTS("TY")=$P($G(^AUTTMSR(DBTS("TY"),0)),U,1)
 .I (DBTS("TY")'="BP"),(DBTS("TY")'="HT"),(DBTS("TY")'="WT") Q
 .I N>(DBTS("LDFN")) S DBTSAU=1 Q
 .I VD'="" S DBTS("MODDT")=$P($G(^AUPNVSIT(VD,0)),U,13)
 .E  S DBTS("MODDT")=""
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=1
 .Q
 Q
3 ;    chk for immunizations chgs or adds
 S REC=$G(^DBTSPAT(DBTSP,"IMM"))
 S DBTS("LDFN")=$P(REC,U,1),DBTS("LDT")=$P(REC,U,2)
 S DBTSAU=0
 S N=0
 F  S N=$O(^AUPNVIMM("AC",DBTSP,N)) Q:+N=0  D  I DBTSAU=1 Q
 .I N>(DBTS("LDFN")) S DBTSAU=1 Q
 .S VD=$P($G(^AUPNVIMM(N,0)),U,3)
 .I VD'="" S DBTS("MODDT")=$P($G(^AUPNVSIT(VD,0)),U,13)
 .E  S DBTS("MODDT")=""
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=1
 .Q
 Q
4 ;    chk for ppd chgs or adds
 S DBTSAU=0
 S PPD=$O(^AUTTSK("B","PPD",0))
 I PPD="" D APPEND Q
 S REC=$G(^DBTSPAT(DBTSP,"PPD"))
 S DBTS("LDFN")=$P(REC,U,1),DBTS("LDT")=$P(REC,U,2)
 S N=0
 F  S N=$O(^AUPNVSK("AC",DBTSP,N)) Q:+N=0  D  I DBTSAU=1 Q
 .S SKIN=$G(^AUPNVSK(N,0))
 .S DBTS("PPD")=$P(SKIN,U,1)
 .Q:DBTS("PPD")'=PPD
 .I N>(DBTS("LDFN")) S DBTSAU=1 Q
 .S VD=$P(SKIN,U,3)
 .I VD'="" S DBTS("MODDT")=$P($G(^AUPNVSIT(VD,0)),U,13)
 .E  S DBTS("MODDT")=""
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=1
 .Q
 Q
5 ;    chk for breast exam chgs or adds
 S REC=$G(^DBTSPAT(DBTSP,"BRE"))
 S DBTS("LDFN")=$P(REC,U,1),DBTS("LDT")=$P(REC,U,2)
 S DBTSAU=0
 S N=0
 F  S N=$O(^AUPNVXAM("AC",DBTSP,N)) Q:+N=0  D  I DBTSAU=1 Q
 .S EXAM=$G(^AUPNVXAM(N,0))
 .S CODE=$P(EXAM,U,1)
 .I CODE="" Q
 .S CODE=$P($G(^AUTTEXAM(CODE,0)),U,2)
 .Q:CODE'="06"
 .I N>(DBTS("LDFN")) S DBTSAU=1 Q
 .S VD=$P(EXAM,U,3)
 .I VD'="" S DBTS("MODDT")=$P($G(^AUPNVSIT(VD,0)),U,13)
 .E  S DBTS("MODDT")=""
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=1
 .Q
 Q
6 ;    chk for dental chgs or adds
 S REC=$G(^DBTSPAT(DBTSP,"DEN"))
 S DBTS("LDFN")=$P(REC,U,1),DBTS("LDT")=$P(REC,U,2)
 S DBTSAU=0
 S N=0
 F  S N=$O(^ADEPCD("B",DBTSP,N)) Q:+N=0  D  I DBTSAU=1 Q
 .S DEN=$G(^ADEPCD(N,0))
 .Q:DEN=""
 .I N>(DBTS("LDFN")) S DBTSAU=1 Q
 .S VD=$P($G(^ADEPCD(N,"PCC")),U,1)
 .I VD'="" S DBTS("MODDT")=$P($G(^AUPNVSIT(VD,0)),U,13)
 .E  S DBTS("MODDT")=""
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=1
 .Q
 Q
