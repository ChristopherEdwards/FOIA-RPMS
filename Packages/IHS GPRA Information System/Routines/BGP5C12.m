BGP5C12 ; IHS/CMI/LAB - calc CMS indicators 26 Sep 2004 11:28 AM ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
EN ;EP
 K BGPDATA
ALLALG ;
 I BGPIND=3 G ALLRX
 S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT,15,"ALL Allergies from Problem List:")=""
 K BGPDATA
 D ALLALG1(DFN,$$DSCH(BGPVINP),.BGPDATA)
 S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  D
 .S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT,15,"ALL Allergies from Problem List:",X)=BGPDATA(X)
ALLALGA ;
 S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT,16,"ALL Allergies from Allergy Tracking:")=""
 K BGPDATA
 D ALLALGA1(DFN,$$DSCH(BGPVINP),.BGPDATA)
 S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  D
 .S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT,16,"ALL Allergies from Allergy Tracking:",X)=BGPDATA(X)
ALLRX ;
 S V=$P($P(BGPVSIT0,U),"."),Z="Last of each drug dispensed "_$$DATE^BGP5UTL($$FMADD^XLFDT(V,-365))_"-"_$$DATE^BGP5UTL($$FMADD^XLFDT($$DSCH(BGPVINP),30))_":"
 S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT,17,Z)=""
 K BGPDATA
 D ALLRX1(DFN,$P($P(BGPVSIT0,U),"."),$$DSCH(BGPVINP),.BGPDATA)
 S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  D
 .S V=$P($P(BGPVSIT0,U),"."),Z="Last of each drug dispensed "_$$DATE^BGP5UTL($$FMADD^XLFDT(V,-365))_"-"_$$DATE^BGP5UTL($$FMADD^XLFDT($$DSCH(BGPVINP),30))_":"
 .S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT,17,Z,X)=BGPDATA(X)
ALLINPM ;
 K BGPY,BGPDATA
 S V=$P($P(BGPVSIT0,U),"."),Z="ALL Unit Dose/IV Meds during Hospital Stay: "_$$DATE^BGP5UTL($P($P(BGPVSIT0,U),"."))_"-"_$$DATE^BGP5UTL($$DSCH(BGPVINP))_":"
 S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT,17,Z)=""
 K BGPDATA
 D IVUD(DFN,$P($P(BGPVSIT0,U),"."),$$DSCH(BGPVINP),,.BGPDATA)
 S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  D
 .S V=$P($P(BGPVSIT0,U),"."),Z="ALL Unit Dose/IV Meds during Hospital Stay: "_$$DATE^BGP5UTL($P($P(BGPVSIT0,U),"."))_"-"_$$DATE^BGP5UTL($$DSCH(BGPVINP))_":"
 .S ^XTMP("BGP5C1",BGPJ,BGPH,BGPORDER,BGPIND,"LIST 2",$P(^DPT(DFN,0),U),DFN,BGPVSIT,17,Z,X)=BGPDATA(X)
 Q
DSCH(H) ;
 Q $P($P(^AUPNVINP(H,0),U),".")
ALLALG1(P,BGPD,BGPY) ;
 ;get all ALLERGIES FROM PROBLEM LIST UP THROUGH DATE OF DISCHARGE ADDED
 NEW ED,BD,BGPG,BGPC,X,Y,Z,N
 ;BGPD is discharge date
 S BGPC=0
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:'X  D
 .S I=$P($$ICDDX^ICDCODE(+^AUPNPROB(X,0)),U,2) ;$P(^ICD9(+^AUPNPROB(X,0),0),U,1)
 .S Z=$$PROBACHK(I,X)
 .Q:Z=0
 .S D=$P(^AUPNPROB(X,0),U,8)
 .Q:D>BGPD
 .I Z=2 D  Q
 ..S BGPC=BGPC+1,BGPY(BGPC)="NO ALLERGY NOTED ON "_$$DATE^BGP5UTL(D)
 .S N=$P(^AUTNPOV(+$P(^AUPNPROB(X,0),U,5),0),U,1)
 .I N="" S N="???"
 .S BGPC=BGPC+1,BGPY(BGPC)="["_I_"]  "_N_"  "_$$DATE^BGP5UTL(D)
 .Q
 Q
ALLALGA1(P,BGPD,BGPY) ;all allergies from the allergy tracking system
 ;
 ;now check allergy tracking
 S BGPC=0
 S X=0 F  S X=$O(^GMR(120.8,"B",P,X)) Q:X'=+X  D
 .Q:$P($G(^GMR(120.8,X,0)),U,26)>BGPD  ;entered after discharge date
 .S N=$P($G(^GMR(120.8,X,0)),U,2),N=$$UP^XLFSTR(N)
 .S BGPC=BGPC+1,BGPY(BGPC)=N_"  "_$$DATE^BGP5UTL($P(^GMR(120.8,X,0),U,4))
 Q
PROBACHK(I,X) ;checking for allergy codes
 I I="692.3" Q 1
 I I="693.0" Q 1
 I I="995.0" Q 1
 I I=995.2 Q 1
 I (+I'<999.4),(+I'>999.8) Q 1
 I I?1"V14."1E Q 1
 I I="692.5" Q 1
 I I="693.1" Q 1
 I I["V15.0" Q 1
 I $E(I,1,3)=692,I'="692.9" Q 1
 I I="693.8" Q 1
 I I="693.9" Q 1
 I I="989.5" Q 1
 I I="989.82" Q 1
 I I="995.3" Q 1
 I $P(^AUPNPROB(X,0),U,5)="" Q 0
 S N=$P(^AUTNPOV($P(^AUPNPROB(X,0),U,5),0),U)
 I I="799.9"!(I="V82.9"),N["NO KNOWN ALLERG"!(N["NKA")!(N["NKDA")!(N["NO KNOWN DRUG ALLERG") Q 2
 Q 0
ALLRX1(P,BGPA,BGPD,BGPY) ;
 NEW BGPG,BGPC,X,Y,Z,E,BD,ED
 S BGPC=0
 K ^TMP($J,"A")
 S ED=$$FMADD^XLFDT(BGPD,30),ED=9999999-ED,ED=ED-1
 S BD=$$FMADD^XLFDT(BGPD,-365),BD=9999999-BD
 S D=ED F  S D=$O(^AUPNVMED("AA",P,D)) Q:D'=+D!(D>BD)  D
 .S N=0 F  S N=$O(^AUPNVMED("AA",P,D,N)) Q:N'=+N  D
 ..S C=$P($G(^AUPNVMED(N,0)),U)
 ..Q:C=""
 ..Q:'$D(^PSDRUG(C,0))
 ..S C=$P(^PSDRUG(C,0),U)
 ..S ^TMP($J,"A",C,D)=N
 ..Q
 S D="" F  S D=$O(^TMP($J,"A",D)) Q:D=""  D
 .S A=$O(^TMP($J,"A",D,0))
 .S B=9999999-A
 .S Y=^TMP($J,"A",D,A)
 .S BGPC=BGPC+1,BGPY(BGPC)=D_"   "_$P(^AUPNVMED(Y,0),U,5)_"  qty: "_$P(^AUPNVMED(Y,0),U,6)_" days: "_$P(^AUPNVMED(Y,0),U,7)_" "_$$DATE^BGP5UTL(B)
 .Q
 K ^TMP($J,"A")
 K BGPG
 Q
 ;
IVUD(P,BD,ED,TAX,BGPY) ;EP
 ;p - patient
 ;bd - beg date
 ;ed - ending date
 ;BGPY - return array
 ;tax - taxonomy ien
 NEW C,X,E,D
 S TAX=$G(TAX)
 S C=0
 S X=0 F  S X=$O(^PS(55,P,5,X)) Q:X'=+X  D
 .S D=$P($G(^PS(55,P,5,X,.1)),U)
 .Q:D=""
 .I TAX Q:'$D(^ATXAX(TAX,21,"B",D))
 .S E=$P($P($G(^PS(55,P,5,X,2)),U,2),".",1)
 .Q:E>ED
 .Q:E<BD
 .S C=C+1,BGPY(C)="Unit Dose:  "_$P(^PS(50.3,D,0),U)_"  Date: "_$$DATE^BGP5UTL(E)
 .Q
 S X=0 F  S X=$O(^PS(55,P,"IV",X)) Q:X'=+X  D
 .S E=$P(^PS(55,P,"IV",X,0),U,2),E=$P(E,".")
 .Q:E>ED
 .Q:E<BD
 .S D=$P($G(^PS(55,P,"IV",X,6)),U)
 .Q:D=""
 .I TAX Q:'$D(^ATXAX(TAX,21,"B",D))
 .S C=C+1,BGPY(C)="IV:  "_$P(^PS(50.3,D,0),U)_"  Date: "_$$DATE^BGP5UTL(E)
 .Q
 Q
