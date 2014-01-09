APCM11E7 ;IHS/CMI/LAB - IHS MU; 
 ;;1.0;IHS MU PERFORMANCE REPORTS;**1**;MAR 26, 2012
 ;
ROIH ;EP
 NEW X
 S X=$O(^APCMMUM("B","S1.010.H",0))
 I '$D(APCMIND(X)) Q  ;don't bother as this measure isn't in the report
 NEW APCMD,APCMX,APCMPAT,X,APCMP
 K APCMECHI
 S X=APCMFAC S APCMECHI(X,1)=""
 S X=APCMFAC S APCMECHI(X,2)=""
 ;LOOP THROUGH ROI AND IF I FIND 1 FOR THE HOSPITAL
 S APCMD=$$FMADD^XLFDT(APCMBD,-1)
 S APCM4D=$$FMADD^XLFDT(APCMED,-4)
 F  S APCMD=$O(^BRNREC("B",APCMD)) Q:APCMD'=+APCMD!(APCMD>APCM4D)  D
 .S APCMX=0 F  S APCMX=$O(^BRNREC("B",APCMD,APCMX)) Q:APCMX'=+APCMX  D
 ..Q:$P($G(^BRNREC(APCMX,11)),U,1)'="E"  ;not an electronic request
 ..S APCMPAT=$P($G(^BRNREC(APCMX,0)),U,3)
 ..K APCMVSTS,APCMHVTP
 ..D ALLV^APCLAPIU(APCMPAT,$$FMADD^XLFDT(APCMED,-365),APCMED,"APCMVSTS")
 ..S APCMP=APCMFAC  D
 ...S APCMHV=$$HADVH^APCM11CI(APCMPAT,APCMP,$$FMADD^XLFDT(APCMED,-365),APCMED,.APCMVSTS)
 ...Q:'APCMHV
 ...K APCMECHI(APCMP,1)  ;had a visit with this patient and thus had a request, so no exclusion
 Q:'$G(APCMWPP)
 S APCMD=$$FMADD^XLFDT(APCMPBD,-1)
 S APCM4D=$$FMADD^XLFDT(APCMPED,-4)
 F  S APCMD=$O(^BRNREC("B",APCMD)) Q:APCMD'=+APCMD!(APCMD>APCM4D)  D
 .S APCMX=0 F  S APCMX=$O(^BRNREC("B",APCMD,APCMX)) Q:APCMX'=+APCMX  D
 ..Q:$P($G(^BRNREC(APCMX,11)),U,1)'="E"  ;not an electronic request
 ..S APCMPAT=$P($G(^BRNREC(APCMX,0)),U,3)
 ..K APCMVSTS,APCMHVTP
 ..D ALLV^APCLAPIU(APCMPAT,$$FMADD^XLFDT(APCMPED,-365),APCMPED,"APCMVSTS")
 ..S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  D
 ...S APCMHV=$$HADV^APCM11CI(APCMPAT,APCMP,$$FMADD^XLFDT(APCMPED,-365),APCMPED,.APCMVSTS)
 ...Q:'APCMHV
 ...K APCMECHI(APCMP,2)  ;had a visit with this patient and thus had a request, so no exclusion
 Q
LAB ;EP - CALCULATE LAB
 ;for each provider or for the facility count all labs that meet criteria and if it is not written it meets numerator
 K ^TMP($J,"PATSRX")
 K APCMLABS
 D TOTLAB
 NEW APCMP,N,F
 S (APCMD1,APCMN1)=0
 I APCMRPTT=2 S APCMP=APCMFAC  D
 .;I '$P($G(APCMLABS(APCMP)),U,1) S F=$P(^APCMMUM(APCMIC,0),U,11) D S^APCM11E1(APCMRPT,APCMIC,"Provider is excluded from this measure as he/she did not order any lab tests with results during the time period.",APCMP,APCMRPTT,APCMTIME,F,1) Q
 .;set denominator value into field
 .S F=$P(^APCMMUM(APCMIC,0),U,8)  ;denom field for this measure
 .S N=$P($G(APCMLABS(APCMP)),U,1)  ;returns # of LABS^# not Structured data
 .D S^APCM11E1(APCMRPT,APCMIC,+N,APCMP,APCMRPTT,APCMTIME,F)
 .;now set patient list for this provider
 .S P=0 F  S P=$O(^TMP($J,"PATSRX",APCMP,P)) Q:P'=+P  D
 ..;Q:'$P(^TMP($J,"PATSRX",APCMP,P),U,1)
 ..I $P(^TMP($J,"PATSRX",APCMP,P),U,1)=$P(^TMP($J,"PATSRX",APCMP,P),U,2) S APCMVALU="# Labs: "_$P(^TMP($J,"PATSRX",APCMP,P),U,1)_"|||"_" # w/structured result: "_+$P(^TMP($J,"PATSRX",APCMP,P),U,2)_"|||1" D  Q
 ...S DFN=P D SETLIST^APCM11E1 Q
 ..S S="",APCMVALU="No Structured Result: "
 ..F  S S=$O(^TMP($J,"PATSRX",APCMP,P,"SCRIPTS",S)) Q:S=""  D
 ...I '$D(^TMP($J,"PATSRX",APCMP,P,"ELEC",S)) D
 ....S APCMVALU=APCMVALU_S_";"
 ..S DFN=P,APCMVALU="# of Labs: "_$P(^TMP($J,"PATSRX",APCMP,P),U,1)_" # w/structured results: "_+$P(^TMP($J,"PATSRX",APCMP,P),U,2)_"|||"_APCMVALU,$P(APCMVALU,"|||",3)=0 D SETLIST^APCM11E1
 .;numerator?
 .S F=$P(^APCMMUM(APCMIC,0),U,9)
 .S N=$P($G(APCMLABS(APCMP)),U,2)
 .D S^APCM11E1(APCMRPT,APCMIC,+N,APCMP,APCMRPTT,APCMTIME,F)
 K ^TMP($J,"PATSRX")
 Q
TOTLAB ;EP - 
 ;SET ARRAY APCMLABS to APCMLABS(prov ien)=denom^numer
 ;IF DENOM =0 THEN PROVIDER EXCLUSION
 NEW ID,C,Y,X,D,S,N,A,B,R,PAT,D,APCMLAB1,PAT
 K APCMLAB1
 S C=0,N=0
 S LABSNO=""
 S T=$O(^ATXLAB("B","BGP PAP SMEAR TAX",0))
 S (ID,SD)=$$FMADD^XLFDT(APCMBDAT,-365),ID=ID_".99999"
 F  S ID=$O(^AUPNVSIT("B",ID)) Q:ID'=+ID  D
 .S X=0 F  S X=$O(^AUPNVSIT("B",ID,X)) Q:X'=+X  D
 ..K APCMLAB1
 ..S PAT=$P(^AUPNVSIT(X,0),U,5)
 ..Q:'$D(^AUPNVLAB("AD",X))  ;no labs
 ..Q:$P(^AUPNVSIT(X,0),U,6)'=APCMFAC
 ..I '$$HOSER^APCM11E6(X,APCMFAC),$P(^AUPNVSIT(X,0),U,7)'="I" Q  ;not a H or 30 or I
 ..S D=$$VD^APCLV(X)
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AD",X,Y)) Q:Y'=+Y  D
 ...Q:$P($P($G(^AUPNVLAB(Y,12)),U,1),".")>APCMEDAT  ;ordered after end date
 ...I $P($G(^AUPNVLAB(Y,12)),U,1)]"" Q:$P($P($G(^AUPNVLAB(Y,12)),U,1),".")<APCMBDAT  ;ordered before beg date
 ...S A=$P(^AUPNVLAB(Y,0),U,1)
 ...I T,$D(^ATXLAB(T,21,"B",A)) Q   ;it's a pap smear
 ...I $$UP^XLFSTR($P(^AUPNVLAB(Y,0),U,4))="CANC" Q  ;it's cancelled
 ...S APCMLAB1(Y)=D_"^"_$$VAL^XBDIQ1(9000010.09,Y,.01)_"^"_$$VAL^XBDIQ1(9000010.09,Y,.04)_"^"_Y_"^"_$P(^AUPNVLAB(Y,0),U,3)
 ..;now go back through the labs and count or not count them
 ..S Y=0 F  S Y=$O(APCMLAB1(Y)) Q:Y'=+Y  D
 ...Q:$P(APCMLAB1(Y),U,10)]""  ;already processed this one
 ...;is this a panel and if so do panel check
 ...S PAR=$P($G(^AUPNVLAB(Y,12)),U,8)
 ...I PAR S $P(APCMLAB1(Y),U,10)="HAS PARENT SKIP/EXCL" Q  ;has a parent, will deal with parent
 ...D SETDENL
 ...;now check numerator
 ...;if panel do panel check for 1 test that is resulted
 ...I $O(^LAB(60,A,2,0)) D PANEL Q
 ...Q:$P($G(^AUPNVLAB(Y,11)),U,9)'="R"  ;if status not resulted it doesn't make the numerator
 ...I $$UP^XLFSTR($P(^AUPNVLAB(Y,0),U,4))="COMMENT",'$$HASCOM(Y) Q
 ...S $P(APCMLABS(APCMFAC),U,2)=$P(APCMLABS(APCMFAC),U,2)+1
 ...S $P(^TMP($J,"PATSRX",APCMFAC,PAT),U,2)=$P($G(^TMP($J,"PATSRX",APCMFAC,PAT)),U,2)+1 S ^TMP($J,"PATSRX",APCMFAC,PAT,"ELEC",$$VAL^XBDIQ1(9000010.09,Y,1201)_" "_$$VAL^XBDIQ1(9000010.09,Y,.01))=""  ;S N=N+G Q  ;S N=N+G
 Q
PANEL ;
 ;find all children and find at least one with a result, if one found set numerator
 NEW X,Z,G,P
 S G=0
 S X=0 F  S X=$O(APCMLAB1(X)) Q:X'=+X!(G)  D
 .S P=$P($G(^AUPNVLAB(X,12)),U,8)
 .I P'=Y Q  ;not a member of this panel
 .I $P($G(^AUPNVLAB(Y,11)),U,9)'="R" S $P(APCMLAB1(X),U,10)="NOT RESULTED" Q
 .I $$UP^XLFSTR($P(^AUPNVLAB(X,0),U,4))="COMMENT",'$$HASCOM(X) S $P(APCMLAB1(X),U,10)="comment/no comments" Q
 .S G=1
 Q:'G
 S $P(APCMLABS(APCMFAC),U,2)=$P(APCMLABS(APCMFAC),U,2)+1
 S $P(^TMP($J,"PATSRX",APCMFAC,PAT),U,2)=$P($G(^TMP($J,"PATSRX",APCMFAC,PAT)),U,2)+1 S ^TMP($J,"PATSRX",APCMFAC,PAT,"ELEC",$$VAL^XBDIQ1(9000010.09,Y,1201)_" "_$$VAL^XBDIQ1(9000010.09,Y,.01))=""  ;S N=N+G Q  ;S N=N+G
 Q
 ;
HASCOM(L) ;ARE THERE ANY COMMENTS
 I '$D(^AUPNVLAB(L,21)) Q 0  ;no comment multiple
 NEW B,G
 S G=0
 S B=0 F  S B=$O(^AUPNVLAB(L,21,B)) Q:B'=+B  I ^AUPNVLAB(L,21,B,0)]"" S G=1  ;has comment
 Q G
 ;
SETDENL ;
 S $P(APCMLAB1(Y),U,10)=1  ;processed this test
 I '$D(APCMLABS(APCMFAC)) S APCMLABS(APCMFAC)=""
 S $P(APCMLABS(APCMFAC),U,1)=$P(APCMLABS(APCMFAC),U,1)+1
 S $P(^TMP($J,"PATSRX",APCMFAC,PAT),U,1)=$P($G(^TMP($J,"PATSRX",APCMFAC,PAT)),U,1)+1,^TMP($J,"PATSRX",APCMFAC,PAT,"SCRIPTS",$$VAL^XBDIQ1(9000010.09,Y,1201)_" "_$$VAL^XBDIQ1(9000010.09,Y,.01))=""
 Q
