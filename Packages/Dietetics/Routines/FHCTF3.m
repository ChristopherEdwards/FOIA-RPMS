FHCTF3 ; HISC/REL/NCA - Clear File Entries ;4/6/01  09:37
 ;;5.0;Dietetics;**29**;Oct 11, 1995
E0 K DIC S DIC="^VA(200,",DIC(0)="AQEM",DIC("A")="Select CLINICIAN: ",DIC("B")=$P($G(^VA(200,DUZ,0)),"^",1) W ! D ^DIC K DIC G KIL:"^"[X!$D(DTOUT),E0:Y<1 S FHDUZ=+Y
 S CNT=0 D NOW^%DTC S NOW=%,DT=NOW\1 D CLN^FHCTF4 S $P(LN,"-",80)="",QT=""
 F LLL=0:0 S LLL=$O(^FH(119,FHDUZ,"I",LLL)) Q:LLL<1  S FHTF=^(LLL,0) D D2 Q:QT="^"
 I 'CNT W !!,"No Tickler File Entries"
 W ! G KIL
D2 S DTP=$P(FHTF,"^",1),TYP=$P(FHTF,"^",2),X=$P(FHTF,"^",3),DFN=$P(FHTF,"^",4),ADM=$P(FHTF,"^",5),CNT=CNT+1 I DFN,ADM S FHWRD=$P($G(^FHPT(DFN,"A",ADM,0)),"^",8)
 G SF:TYP="S",CN:TYP="C",DI:TYP="D",TF:TYP="T",NS:TYP="N",MO:TYP="M" Q
SF ; Clear Supplemental Feeding
 D HDR,CUR^FHORD7
 W !!,"Current Diet: ",$S(Y'="":Y,1:"No current order")
 S NO=$P(FHTF,"^",6),Y=$S('NO:"",1:$G(^FHPT(DFN,"A",ADM,"SF",NO,0))) D L1^FHNO7
S1 R !!,"Is Order OK? Y// ",YN:DTIME S:'$T!(YN["^") QT="^" Q:QT="^"  S:YN="" YN="Y" S X=YN D TR^FH S YN=X I $P("YES",YN,1)'="",$P("NO",YN,1)'="" W *7," Answer YES or NO" G S1
 S YN=$E(YN,1) Q:YN'="Y"
 S $P(^FHPT(DFN,"A",ADM,"SF",NO,0),"^",30,31)=NOW_"^"_DUZ
 K ^FH(119,FHDUZ,"I",LLL) G DNE
CN ; Clear Consult
 D HDR S FHDR=$P(FHTF,"^",6),Y=^FHPT(DFN,"A",ADM,"DR",FHDR,0),ALL=0 D D1^FHORC2
C1 R !!,"Disposition (C=Complete, X=Cancelled, R=Reassign, RETURN to bypass): ",TYP:DTIME S:'$T!(TYP["^") QT="^" Q:"^"[TYP  S X=TYP D TR^FH S TYP=X I TYP'?1U!("XCR"'[TYP) W *7,!,"Enter C, X or R or Press RETURN to bypass" G C1
 I TYP="R" G C2
 I ORIFN S ORSTS=TYP="C"+1 D ST^ORX
 K ^FHPT("ADRU",FHDUZ,DFN,ADM,FHDR)
 S $P(^FHPT(DFN,"A",ADM,"DR",FHDR,0),"^",8,10)=TYP_"^"_NOW_"^"_DUZ K ^FH(119,FHDUZ,"I",LLL)
 D:TYP="C" EN31^FHASE G DNE
C2 K DIC S DIC="^VA(200,",DIC(0)="AEQM",DIC("A")="REASSIGN to Clinician: " W ! D ^DIC S:$D(DTOUT) QT="^" Q:Y<1  S XMKK=+Y K DIC
 K ^FHPT("ADRU",FHDUZ,DFN,ADM,FHDR) S ^FHPT("ADRU",XMKK,DFN,ADM,FHDR)=""
 S $P(^FHPT(DFN,"A",ADM,"DR",FHDR,0),"^",5)=XMKK
 K ^FH(119,FHDUZ,"I",LLL) S FHSV=FHDUZ,FHDUZ=XMKK D FILE^FHCTF2 S FHDUZ=FHSV
 S REQ=CON,WARD=$P($G(^FH(119.6,+FHWRD,0)),"^",1) D POST^FHORC G DNE
TF ; Tubefeed
 S TF=$P(FHTF,"^",6) D HDR,DIS^FHORT2
T1 R !!,"Is Order OK? Y// ",YN:DTIME S:'$T!(YN["^") QT="^" Q:QT="^"  S:YN="" YN="Y" S X=YN D TR^FH S YN=X I $P("YES",YN,1)'="",$P("NO",YN,1)'="" W *7," Answer YES or NO" G T1
 S YN=$E(YN,1) Q:YN'="Y"
 S $P(^FHPT(DFN,"A",ADM,"TF",TF,0),"^",15,16)=NOW_"^"_DUZ
 K ^FH(119,FHDUZ,"I",LLL) G DNE
 Q
DI ; Diet
 S FHORD=$P(FHTF,"^",6) Q:'FHORD  D HDR,C2^FHORD7 W !!,"Current Diet: ",$S(Y'="":Y,1:"No current order")
 I $D(^FHPT(DFN,"A",ADM,"DI",FHORD,1)) S COM=^(1) W:COM'="" !,"Comment: ",COM
 S TYP=$P(X,"^",8) I TYP'="" W !,"Service: ",$S(TYP="T":"Tray",TYP="D":"Dining Room",1:"Cafeteria")
 S DTP=$P($G(^FHPT(DFN,"A",ADM,0)),"^",3) I DTP D DTP^FH W !,"Expires: ",DTP
D1 R !!,"Is Order OK? Y// ",YN:DTIME S:'$T!(YN["^") QT="^" Q:QT="^"  S:YN="" YN="Y" S X=YN D TR^FH S YN=X I $P("YES",YN,1)'="",$P("NO",YN,1)'="" W *7," Answer YES or NO" G D1
 S YN=$E(YN,1) Q:YN'="Y"
 S $P(^FHPT(DFN,"A",ADM,"DI",FHORD,0),"^",16,17)=NOW_"^"_DUZ
 K ^FH(119,FHDUZ,"I",LLL) G DNE
 Q
NS ; Status
 S F1=$P(FHTF,"^",6),Y=$G(^FHPT(DFN,"S",+F1,0)) Q:Y=""  S S=$P(Y,"^",2)
 D HDR W !!,"Current Status: ",$P($G(^FH(115.4,+S,0)),"^",2)
N1 R !!,"Is Status OK? Y// ",YN:DTIME S:'$T!(YN["^") QT="^" Q:QT="^"  S:YN="" YN="Y" S X=YN D TR^FH S YN=X I $P("YES",YN,1)'="",$P("NO",YN,1)'="" W *7," Answer YES or NO" G N1
 S YN=$E(YN,1) Q:YN'="Y"
 S $P(^FHPT(DFN,"S",F1,0),"^",4,5)=NOW_"^"_DUZ
 K ^FH(119,FHDUZ,"I",LLL) G DNE
MO ; Monitor
 D HDR W !!,$P(FHTF,"^",3)
M1 S MOCOM="" R !!,"Action Taken: ",MOCOM:DTIME S:MOCOM="^^" QT="^" Q:'$T!(MOCOM["^")  I MOCOM'?.ANP W *7," ??" G M1
 I MOCOM=""!($L(MOCOM)>60)!(MOCOM?1"?".E) W *7,!,"Required entry: document action (up to 60 characters) or ^ to bypass." G M1
 S F1=$P(FHTF,"^",6) S $P(^FHPT(DFN,"A",ADM,"MO",F1,0),"^",3,5)=MOCOM_"^"_DUZ_"^"_NOW
 K ^FH(119,FHDUZ,"I",LLL)
 G DNE
DNE W "  ... done" Q
HDR S Y0=$G(^DPT(DFN,0)) W @IOF,!!,$P(Y0,"^",1) D PID^FHDPA W:BID'="" " (",BID,")"
 W ?40,$S($P(Y0,"^",2)="F":"Female",1:"Male")
 S AGE=$P(Y0,"^",3) I AGE'="" S AGE=$E(DT,1,3)-$E(AGE,1,3)-($E(DT,4,7)<$E(AGE,4,7)) W "   Age ",AGE
 S X=$P($G(^FH(119.6,+FHWRD,0)),"^",1)_" "_$P($G(^DPT(DFN,.101)),"^",1) W ?(79-$L(X)),X
 W !,LN S X=$S(TYP="S":"SUPPLEMENTAL FEEDING",TYP="C":"DIETETIC CONSULTATION",TYP="D":"DIET ORDER",TYP="T":"TUBEFEEDING",TYP="N":"NUTRITION STATUS",TYP="M":"MONITOR",1:"")
 W !?(80-$L(X)\2),X,!,LN Q
KIL G KILL^XUSCLEAN
