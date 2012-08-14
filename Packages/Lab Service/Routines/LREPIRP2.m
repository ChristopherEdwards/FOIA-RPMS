LREPIRP2 ;VA/DALOI/CKA-EMERGING PATHOGENS HL7 REPORT CONVERSION ;5/14/2003
 ;;5.2;LAB SERVICE;**1030**;NOV 01, 1997
 ;;5.2;LAB SERVICE;**281**;Sep 27, 1994
 ; Reference to ^DIC(21 supported by IA #913
 Q
 ;NTE findings of 1,3,4,5,6,8, or 10
 ;Read through the TMP($,"RPT"
 ;Save in ^XTMP("LREPIREP"_date,path,dfn,"PID")
 ;        ^XTMP("LREPIREP"_date,path,dfn,"PV1",#)
 ;        ^XTMP("LREPIREP"_date,path,dfn,"PV1",#,"OBR",#)
 ;        ^XTMP("LREPIREP"_date,path,dfn,"PV1",#,"OBR",#,"OBX",#)
 ;save PID, PV1, OBR, and OBX data in ^XTMP.
 Q
PID ;PATIENT INFO
 S NM=$P(LRTMP,HLFS,6),SSN=$P(LRTMP,HLFS,20)
 S SSN=$E(SSN,6,9)
 S DOB=$$CDT($P(LRTMP,HLFS,8)),NM=$P(NM,LRCS,2)_" "_$P(NM,LRCS,1)
 S SX=$P(LRTMP,HLFS,9),AD=$P($P(LRTMP,HLFS,12),LRCS,1)
 S ZP=$P($P(LRTMP,HLFS,12),LRCS,2),POS=$P(LRTMP,HLFS,28),POSN=""
 I POS'="",$D(^DIC(21,"D",POS)) S POS=$O(^DIC(21,"D",POS,""))
 S:POS'="" POSN=$P($G(^DIC(21,POS,0)),U,1)
 S MSG=NM_$E(LRSP,1,30-$L(NM))_SSN_$E(LRSP,1,7-$L(SSN))_DOB_$E(LRSP,1,11-$L(DOB))_SX_$E(LRSP,1,3-$L(SX))
 S:POSN'="" MSG=MSG_"   "_POSN
 S MSG=MSG_"   "_AD_"   "_ZP
 S ^XTMP("LREPIREP"_LRDATE,LRTYPE,DFN,"PID")=MSG
 K NM,DOB,SX,POS,AD,ZP,POSN
 Q
PV1 ;PATIENT VISIT ENCOUNTER
 S TYPE=$P(LRTMP,HLFS,3)
 S ENC=$S(TYPE="O":"Accession ",1:"Admission ")_"Date:  "
 S TYPE=$S(TYPE="U":"Update",TYPE="I":"Inpatient",1:"Outpatient")
 S MSG=TYPE_"  "_ENC_$$CDT($P(LRTMP,HLFS,45))
 I TYPE="Inpatient" D
 .S MSG=MSG_"            Discharge Date:  "_$S($P(LRTMP,HLFS,46)="":"",1:$$CDT($P(LRTMP,HLFS,46)))
 .S MSG=MSG_"  Discharge Disposition:  "_$P($P(LRTMP,HLFS,37),LRCS,2)
 S ^XTMP("LREPIREP"_LRDATE,LRTYPE,DFN,"PV1",LRPV1)=MSG
 K TYPE
 Q
CDT(DATE) ;CONVERTS THE DATE AND TIME
 S X=$E(DATE,5,6)_"-"_$E(DATE,7,8)_"-"_$E(DATE,1,4)
 S:$E(DATE,9,12)'="" X=X_"@"_$E(DATE,9,12)
 S:X="--" X=""
 Q X
OBR ;OBSERVATION REPORTING
 S TST=$P(LRTMP,HLFS,5),TSTNM=$P(TST,LRCS,2),MSG=""
 S:TSTNM="" TSTNM=$P(TST,LRCS,5)
 S TOP=$P($P(LRTMP,HLFS,16),LRCS,3)
 S ENTRY=$P($P(LRTMP,HLFS,27),LRCS,2)
 S:+ENTRY MSG="ORG # "_ENTRY_"  "
 S MSG=MSG_$$CDT($P(LRTMP,HLFS,8))_"  "
 S LRACCDT=$$CDT($P(LRTMP,HLFS,8))
 S:$P(LRTMP,HLFS,19)'="" MSG=MSG_$P(LRTMP,HLFS,19)_"  "
 S MSG=MSG_TSTNM_"  "_TOP
 S ^XTMP("LREPIREP"_LRDATE,LRTYPE,DFN,"PV1",LRPV1,"OBR",LROBR)=MSG
 K TST,TSTNM,TOP,ENTRY
 Q
OBX ;RESULTS
 I $P(LRTMP,HLFS,3)="ST" D
 .S TST=$P(LRTMP,HLFS,4),TSTNM=$P(TST,LRCS,2)
 .S:TSTNM="" TSTNM=$P(TST,LRCS,5)
 .S OV=$P(LRTMP,HLFS,6)
 I $P(LRTMP,HLFS,3)="CE" D
 .S TSTNM=""
 .S OV=$P($P(LRTMP,HLFS,6),LRCS,2)
 S MSG="",ENTRY=$P(LRTMP,HLFS,5) S:+ENTRY MSG=ENTRY_"  "
 S MSG=MSG_TSTNM_$E(LRSP,1,30-$L(TSTNM))
 S FD=$$CDT($P(LRTMP,HLFS,15)),RR=$P(LRTMP,HLFS,8)
 S UN=$P(LRTMP,HLFS,7),AF=""
 S MSG="     "_MSG_FD_"   "_OV_$E(LRSP,1,10-$L(OV))_UN_$E(LRSP,1,10-$L(UN))_RR
 S MSG=MSG_$E(LRSP,1,(40-$L(MSG)))_$P(LRTMP,HLFS,9)
 S ^XTMP("LREPIREP"_LRDATE,LRTYPE,DFN,"PV1",LRPV1,"OBR",LROBR,"OBX",LROBX)=MSG
 Q