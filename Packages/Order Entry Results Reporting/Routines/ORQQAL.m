ORQQAL ; slc/CLA,JFR - Functions which return patient allergy data ;06-Feb-2013 11:37;PLS
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**9,85,162,190,1007,216,232,243,1010**;Dec 17, 1997;Build 47
 ;Modified - IHS/MSC/MGH Modified to remove inactive allergies
 ;              IHS/MSC/MGH - 04/06/2012 -  Patch 10 added data for reactions
 ;              IHS/MSC/MGH - 12/21/2012 -  Patch 10 for compound medications
LIST(ORAY,ORPT) ; RETURN PATIENT'S ALLERGY/ADVERSE REACTION INFO:
 ; null:no allergy assessment, 0:no known allergies, 1:pt has allergies
 ; if 1 also get: allergen/reactant^reaction/symptom^severity^allergy ien
 N I,J,K
 S I=1,J=0,K=0
 D EN1^GMRAOR1(ORPT,"GMRARXN")
 I $G(GMRARXN)="" S ORAY(I)="^No Allergy Assessment"
 I $G(GMRARXN)=0 S ORAY(I)="^No Known Allergies"
 I $G(GMRARXN)=1 F  S J=$O(GMRARXN(J)) Q:J=""  S ORAY(I)=$P(GMRARXN(J),"^",3)_"^"_$P(GMRARXN(J),"^")_"^"_$P(GMRARXN(J),"^",2) D SIGNS S I=I+1
 S:'$D(ORAY(1)) ORAY(1)="^No allergies found."
 K GMRARXN
 Q
SIGNS S K=0,N=0 F  S K=$O(GMRARXN(J,"S",K)) Q:K'>0  D
 .I N=0 S ORAY(I)=ORAY(I)_"^"_$P(GMRARXN(J,"S",K),";")
 .E  S ORAY(I)=ORAY(I)_";"_$P(GMRARXN(J,"S",K),";")
 .S N=N+1
 Q
LRPT(ORAY,ORPT) ; RETURN PT'S ALLERGY/ADVERSE REACTION INFO IN REPORT FORMAT:
 ; null:no allergy assessment, 0:no known allergies, 1:pt has allergies
 ; if 1 also get: allergen/reactant^reaction/symptom^severity^allergy ien
 N I,J,K,SEVER,CR,GMRAIDT ;216
 S CR=$CHAR(13)
 S I=1,J=0,K=0,SEVER="",GMRAIDT=1 ;216
 D EN1^GMRAOR1(ORPT,"GMRARXN")
 I $G(GMRARXN)="" S ORAY(I)="No Allergy Assessment"
 I $G(GMRARXN)=0 S ORAY(I)="No Known Allergies"
 I $G(GMRARXN)=1 F  S J=$O(GMRARXN(J)) Q:J=""  D
 .S SEVER=$P(GMRARXN(J),U,2)
 .S ORAY(I)=$P(GMRARXN(J),U)_"     "_$S($L($G(SEVER)):"[Severity: "_SEVER_"]",1:""),I=I+1
 .S K=0,N=0 F  S K=$O(GMRARXN(J,"S",K)) Q:K'>0  D
 ..I N=0 S ORAY(I)="    Signs/symptoms: "_$P(GMRARXN(J,"S",K),";")
 ..E     S ORAY(I)="                    "_$P(GMRARXN(J,"S",K),";")
 ..I $P(GMRARXN(J,"S",K),";",2) S ORAY(I)=ORAY(I)_" ("_$$FMTE^XLFDT($P(GMRARXN(J,"S",K),";",2),2)_")" ;216
 ..S N=N+1,I=I+1
 .S ORAY(I)=" ",I=I+1
 S:'$D(ORAY(1)) ORAY(1)="No allergies found."
 K GMRARXN
 Q
RXN(ORAY,ORPT,SRC,NDF,PSDRUG) ; RETURN TRUE OR FALSE IF PATIENT IS ALLERGIC TO AGENT
 ; SRC: ALLERGEN SOURCE (CM=CONTRAST MEDIA, DR=DRUG)
 ; NDF: IF SRC=DR, NDF=Nat'l Drug File ien ELSE NDF=""
 ; PSDRUG:IF SRC=DR, PSDRUG=(local) Drug file ien ELSE PSDRUG=""
 N CMP,CMPDR,SAVE,TEMP,TEMP2,CDRG,CNT,NDF2
 I +PSDRUG D
 .S SAVE=0,TEMP2=""
 .;IHS/MSC/MGH Mod for compound meds patch 1010
 .S CMP=$P($G(^PSDRUG(PSDRUG,999999935)),U,1)
 .I CMP=1 D
 ..S CMPDR=0
 ..F  S CMPDR=$O(^PSDRUG(PSDRUG,999999936,CMPDR)) Q:'+CMPDR  D
 ...S CDRG=$P($G(^PSDRUG(PSDRUG,999999936,CMPDR,0)),U,1)
 ...S NDF2=$$GET1^DIQ(50,CDRG,20,"I")_"."_$$GET1^DIQ(50,CDRG,22,"I")
 ...S ORAY=$$ORCHK^GMRAOR(ORPT,SRC,NDF2,"",1)
 ...I ORAY=1 S SAVE=1
 ...D SETARRY
 ...I $P(ORAY,U,2)'="" S TEMP($P(ORAY,U,2))=""
 ...K ORAY
 ..;end MOD for compound meds
 .S (X,TEMP2)="",CNT=0
 .F  S X=$O(TEMP(X)) Q:X=""  D
 ..S CNT=CNT+1
 ..S TEMP2=TEMP2_" "_CNT_") "_X
 .S ORAY=SAVE_U_TEMP2
 I +NDF D
 .S ORAY=$$ORCHK^GMRAOR(ORPT,SRC,NDF,"",1)
 .D SETARRY
 Q
SETARRY ; Get the data
 I SRC="DR",ORAY=1 D  ;drug ingredient allergy found
 .S I=1,J=0 F  S J=$O(GMRAING(J)) Q:J=""  D
 ..I I=1 S ORAY=ORAY_U_GMRAING(J)
 ..E  S ORAY=ORAY_";"_GMRAING(J)
 ..S I=I+1
 .N K
 .;IHS/MSC/MGH added reaction data patch 1010
 .I $D(GMRAREAC) D
 ..S K=0 F  S K=$O(GMRAREAC(K)) Q:K=""  D
 ...I K=1 S ORAY=ORAY_" Reac: "_GMRAREAC(K)
 ...E  S ORAY=ORAY_";"_GMRAREAC(K)
 .;END MOD
 I SRC="DR",ORAY=2 D  ;drug class allergy found
 .S CL="",I=1,J=0 F  S J=$O(GMRADRCL(J)) Q:J=""  D
 ..; per test sites 3/17/04 - no oc for pt allergy to entire HERBS class:
 ..Q:$P(GMRADRCL(J),U)="HA000"
 ..I I=1 S ORAY=ORAY_U_$P(GMRADRCL(J),U,2)
 ..E  S CL=$P(GMRADRCL(J),U,2) I ORAY'[CL S ORAY=ORAY_";"_CL
 ..;IHS/MSC/MGH added reaction data patch 1010
 ..I $D(GMRAREAC) D
 ...S K=0 F  S K=$O(GMRAREAC(K)) Q:K=""  D
 ....I K=1 S ORAY=ORAY_" Reac: "_GMRAREAC(K)
 ....E  S ORAY=ORAY_";"_GMRAREAC(K)
 ..;END MOD
 ..S I=I+1
 I SRC="DR",(+$G(ORAY)<1) D MEDCLASS(.ORAY,ORPT,PSDRUG)
 K I,J,GMRADRCL,GMRAING,CL,GMRAREAC
 Q
MEDCLASS(ORAY,DFN,PSDRUG) ;check for allergens with medications in same VA drug class
 N ORVACLS,CL,X,I,RET,TYP
 S TYP="DR"
 Q:+$G(PSDRUG)<1
 ;S ORVACLS=$P(^PSDRUG(PSDRUG,0),U,2)
 S ORVACLS=$$CLASS50^ORPEAPI(PSDRUG)
 Q:$L(ORVACLS)<4
 Q:$G(ORVACLS)="HA000"  ;don't process herbal drug class for order checks
 S CL=$S($E(ORVACLS,1,4)="CN10":5,1:4) ;look at 5 chars if ANALGESICS
 D GETDATA^GMRAOR(DFN)
 Q:'$D(^TMP("GMRAOC",$J,"APC"))
 S I="" F  S I=$O(^TMP("GMRAOC",$J,"APC",I)) Q:'$L(I)  D
 .I $E(I,1,CL)=$E(ORVACLS,1,CL) S X=I
 I $L($G(X)) D
 .N IEN,NAME
 .D IEN^PSN50P65(,X,"ORQQAL")
 .S IEN=$O(^TMP($J,"ORQQAL","B",X,0))
 .I 'IEN S ORAY="2"_U_X Q
 .S NAME=$G(^TMP($J,"ORQQAL",IEN,1))
 .I '$L(NAME) S ORAY="2"_U_X Q
 .S ORAY="2"_U_NAME_": ("_$G(^TMP("GMRAOC",$J,"APC",X))_")"
 .N K S K=0 S K=$O(^TMP("GMRAOC",$J,"APC",X,"REAC",K)) Q:'+K  D
 ..I K=1 S ORAY=ORAY_"Reac: "_$G(^TMP("GMRAOC",$J,"APC",X,"REAC",K))
 ..E  S ORAY=ORAY_";"_$G(^TMP("GMRAOC",$J,"APC",X,"REAC",K))
 K ^TMP("GMRAOC",$J)
 Q
DETAIL(ORAY,DFN,ALLR,ID) ; RETURN DETAILED ALLERGY INFO FOR SPECIFIED ALLERGIC REACTION:
 D EN1^GMRAOR2(ALLR,"GMRACT")
 N CR,OX,OH S CR=$CHAR(13),I=1
 S ORAY(I)="    Causative agent: "_$P(GMRACT,U),I=I+1
 S ORAY(I)=" Nature of Reaction: "_$S($P(GMRACT,U,6)="ALLERGY":"Allergy",$P(GMRACT,U,6)="PHARMACOLOGIC":"Adverse Reaction",$P(GMRACT,U,6)="UNKNOWN":"Unknown",1:""),I=I+1 ;216
 S ORAY(I)=" ",I=I+1
 I $D(GMRACT("S",1)) D SYMP
 I $D(GMRACT("V",1)) D CLAS
 S ORAY(I)="         Originator: "_$P(GMRACT,U,2)_$S($L($P(GMRACT,U,3)):" ("_$P(GMRACT,U,3)_")",1:""),I=I+1 ;216
 S ORAY(I)="         Originated: "_$P(GMRACT,U,10),I=I+1 ;216
 I $D(GMRACT("O",1)) D OBS
 S ORAY(I)="           Verified: "_$S($P(GMRACT,U,4)="VERIFIED":$P(GMRACT,U,8),1:"No"),I=I+1 ;216
 S ORAY(I)="Observed/Historical: "_$S($P(GMRACT,U,5)="OBSERVED":"Observed",$P(GMRACT,U,5)="HISTORICAL":"Historical",1:""),I=I+1
 I $D(GMRACT("C",1)) D COM
 K GMRACT
 Q
SYMP S K=0,N=0 F  S K=$O(GMRACT("S",K)) Q:K'>0  D
 .I N=0 S ORAY(I)="     Signs/symptoms: "_GMRACT("S",K),I=I+1
 .E  S ORAY(I)="                     "_GMRACT("S",K),I=I+1
 .S N=N+1
 S ORAY(I)=" ",I=I+1
 K N,K
 Q
CLAS S K=0,N=0 F  S K=$O(GMRACT("V",K)) Q:K'>0  D
 .I N=0 S ORAY(I)="       Drug Classes: "_$P(GMRACT("V",K),U,2),I=I+1
 .E  S ORAY(I)="                     "_$P(GMRACT("V",K),U,2),I=I+1
 .S N=N+1
 S ORAY(I)=" ",I=I+1
 K N,K
 Q
OBS S K=0,N=0 F  S K=$O(GMRACT("O",K)) Q:K'>0  D
 .I N=0 D
 ..S Y=$P(GMRACT("O",K),U) D DD^%DT
 ..S ORAY(I)=" Obs dates/severity: "_Y_" "_$P(GMRACT("O",K),U,2),I=I+1
 .E  D
 ..S Y=$P(GMRACT("O",K),U) D DD^%DT
 ..S ORAY(I)="                     "_Y_" "_$P(GMRACT("O",K),U,2),I=I+1
 .S N=N+1
 S ORAY(I)=" ",I=I+1
 K N,K,Y
 Q
COM S K=0,N=0,ORAY(I)=" ",I=I+1
 F  S K=$O(GMRACT("C",K)) Q:K'>0  D
 .I N=0 S ORAY(I)="Comments:",I=I+1
 .S Y=$P(GMRACT("C",K),U) D DD^%DT
 .S ORAY(I)="   "_Y_" by "_$P(GMRACT("C",K),U,2),I=I+1
 .I $D(GMRACT("C",K,1,0)) S L=0 F  S L=$O(GMRACT("C",K,L)) Q:L'>0  D
 ..S ORAY(I)=GMRACT("C",K,L,0),I=I+1
 .S N=N+1
 S ORAY(I)=" ",I=I+1
 K N,K,L,Y
 Q
