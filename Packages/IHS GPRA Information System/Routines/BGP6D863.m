BGP6D863 ; IHS/CMI/LAB - measure C ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
MEDSPRE(P,BDATE,EDATE) ;EP
 I $G(P)="" Q ""
 K BGPZ
 ;A-RA OS NSAID
 ;B-GOLD IM
 ;C-AZS
 ;D-LEF
 ;E-METHO
 ;F-CYCLO
 ;G=GOLD ORAL
 ;H=MYCO
 ;I=PENI
 ;J=SULFA
 F X="A","B","C","D","E","F","G","H","I","J" S BGPZ(X)=""
 K ^TMP($J,"A")
 S S="^TMP($J,""A"",",R=P_"^ALL MEDS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),F=$$START1^APCLDF(R,S)
 I '$D(^TMP($J,"A")) Q ""
 S T1=$O(^ATXAX("B","BGP RA OA NSAID MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA OA NSAID NDC",0))
 S T2=$O(^ATXAX("B","DM AUDIT ASPIRIN DRUGS",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) S BGPZ("A")=1 Q
 .I $D(^ATXAX(T2,21,"B",Z)) S BGPZ("A")=1
 ;now check for B
 S T1=$O(^ATXAX("B","BGP RA IM GOLD MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA IM GOLD NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) S BGPZ("B")=1
 ;now check for C
 S T1=$O(^ATXAX("B","BGP RA AZATHIOPRINE MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA AZATHIOPRINE NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) D
 ..S BGPZ("C")=1
 ;now check for D
 S T1=$O(^ATXAX("B","BGP RA LEFLUNOMIDE MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA LEFLUNOMIDE NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) S BGPZ("D")=1
 ;now check for E
 S T1=$O(^ATXAX("B","BGP RA METHOTREXATE MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA METHOTREXATE NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U)
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) D
 ..S BGPZ("E")=1
 ;now check for F
 S T1=$O(^ATXAX("B","BGP RA CYCLOSPORINE MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA CYCLOSPORINE NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U)
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) S BGPZ("F")=1
 ;now check for G
 S T1=$O(^ATXAX("B","BGP RA ORAL GOLD MEDS",0))
 ;S T4=$O(^ATXAX("B","BGP RA ORAL GOLD NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U)
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) S BGPZ("G")=1
 ;now check for H
 S T1=$O(^ATXAX("B","BGP RA MYCOPHENOLATE MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA MYCOPHENOLATE NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) S BGPZ("H")=1
 ;now check for I
 S T1=$O(^ATXAX("B","BGP RA PENICILLAMINE MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA PENICILLAMINE NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) S BGPZ("I")=1
 ;now check for J
 S T1=$O(^ATXAX("B","BGP RA SULFASALAZINE MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA SULFASALAZINE NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) S BGPZ("J")=1
 S C=0 F X="A","B","C","D","E","F","G","H","I","J" I BGPZ(X) S C=C+1
 I C=0 Q ""  ;none within time frame
 S BDATE=$$FMADD^XLFDT(EDATE,-465)
 K ^TMP($J,"A")
 S (A,B)=0
 S E="^TMP($J,""A"",",H=P_"^ALL MEDS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),F=$$START1^APCLDF(H,E)
 I '$D(^TMP($J,"A")) Q ""  ;no meds in time window so quit
COUNTD ;count # days except for im gold and count hits
 S T1=$O(^ATXAX("B","BGP RA OA NSAID MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA OA NSAID NDC",0))
 S T2=$O(^ATXAX("B","DM AUDIT ASPIRIN DRUGS",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) D  Q
 ..S $P(BGPZ("A"),U,2)=$P(BGPZ("A"),U,2)+$$DAYS(Y,V)
 .I $D(^ATXAX(T2,21,"B",Z)) D
 ..S $P(BGPZ("A"),U,2)=$P(BGPZ("A"),U,2)+$$DAYS(Y,V)
 ;now check for B
 S T1=$O(^ATXAX("B","BGP RA IM GOLD MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA IM GOLD NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) D
 ..S $P(BGPZ("B"),U,2)=$P(BGPZ("B"),U,2)+1
 ;now check for C
 S T1=$O(^ATXAX("B","BGP RA AZATHIOPRINE MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA AZATHIOPRINE NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) D
 ..S $P(BGPZ("C"),U,2)=$P(BGPZ("C"),U,2)+$$DAYS(Y,V)
 ;now check for D
 S T1=$O(^ATXAX("B","BGP RA LEFLUNOMIDE MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA LEFLUNOMIDE NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) S $P(BGPZ("D"),U,2)=$P(BGPZ("D"),U,2)+$$DAYS(Y,V)
 ;now check for E
 S T1=$O(^ATXAX("B","BGP RA METHOTREXATE MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA METHOTREXATE NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) D
 ..S $P(BGPZ("E"),U,2)=$P(BGPZ("E"),U,2)+$$DAYS(Y,V)
 ;now check for F
 S T1=$O(^ATXAX("B","BGP RA CYCLOSPORINE MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA CYCLOSPORINE NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) S $P(BGPZ("F"),U,2)=$P(BGPZ("F"),U,2)+$$DAYS(Y,V)
 ;now check for G
 S T1=$O(^ATXAX("B","BGP RA ORAL GOLD MEDS",0))
 ;S T4=$O(^ATXAX("B","BGP RA ORAL GOLD NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) S $P(BGPZ("G"),U,2)=$P(BGPZ("G"),U,2)+$$DAYS(Y,V)
 ;now check for H
 S T1=$O(^ATXAX("B","BGP RA MYCOPHENOLATE MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA MYCOPHENOLATE NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) S $P(BGPZ("H"),U,2)=$P(BGPZ("H"),U,2)+$$DAYS(Y,V)
 ;now check for I
 S T1=$O(^ATXAX("B","BGP RA PENICILLAMINE MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA PENICILLAMINE NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) S $P(BGPZ("I"),U,2)=$P(BGPZ("I"),U,2)+$$DAYS(Y,V)
 ;now check for J
 S T1=$O(^ATXAX("B","BGP RA SULFASALAZINE MEDS",0))
 S T4=$O(^ATXAX("B","BGP RA SULFASALAZINE NDC",0))
 S X=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5),Y=+$P(^TMP($J,"A",X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:Z=""  ;BAD POINTER
 .I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)) S $P(BGPZ("J"),U,2)=$P(BGPZ("J"),U,2)+$$DAYS(Y,V)
 S D=.75*($$FMDIFF^XLFDT(EDATE,BDATE)),D=D\1
 S J=1,V="" F X="A","B","C","D","E","F","G","H","I","J" D
 .S J=J+1
 .I X="B" D  Q
 ..I $P(BGPZ(X),U),$P(BGPZ(X),U,2)>11 S $P(V,U,1)=1,$P(V,U,J)=1,$P(V,U,15)=$P(V,U,15)_" "_BGPZ(X)_" IM Injections of "_$P($T(@X),";;",2) Q
 .I $P(BGPZ(X),U),D'>$P(BGPZ(X),U,2) S $P(V,U,1)=1,$P(V,U,J)=1,$P(V,U,15)=$P(V,U,15)_" "_BGPZ(X)_" days of "_$P($T(@X),";;",2)
 Q V
DAYS(I,V) ;
 NEW %,N,S,D
 S N=$P(^AUPNVMED(Y,0),U,7)  ;DAYS SUPPLY
 S %=$P(^AUPNVMED(Y,0),U,8)  ;DATE DISCONTINUED
 I %="" Q N
 S D=$P($P($G(^AUPNVSIT(V,0)),U),".")
 I D="" Q N
 S S=$$FMDIFF^XLFDT(%,D)
 I S>0,S<N Q S
 Q N
NDC(A,B) ;
 ;a is drug ien
 ;b is taxonomy ien
 S BGPNDC=$P($G(^PSDRUG(A,2)),U,4)
 I BGPNDC]"",B,$D(^ATXAX(B,21,"B",BGPNDC)) Q 1
 Q 0
A ;;NSAID
B ;;IM GOLD
C ;;AZATHRIOPRINE
D ;;LEFLUNOMIDE
E ;;METHOTREXATE
F ;;CYCLOSPORINE
G ;;ORAL GOLD
H ;;MYCOPHENOLATE
I ;;PENICILLAMINE
J ;;SULFASALAZINE
