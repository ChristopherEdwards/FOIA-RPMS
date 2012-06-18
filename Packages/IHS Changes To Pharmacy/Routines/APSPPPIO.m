APSPPPIO ;IHS/CIA/PLS - Return PMI information ;03-Nov-2004 21:32;PLS
 ;;7.0; IHS PHARMACY MODIFICATIONS;**1001**;MAR 2, 2004
 ; This is a modified version of PSNPPIO
 ; Modified - IHS/CIA/PLS - 11/03/04 - EN+19
EN(PSNDRUG,PSNMSG) ; EP
 ;
 ; entry point from Outpatient Pharmacy Labels
 ; Calling method: S PSNFLAG=$$EN^APSPPPIO(PSNDRUG)
 ;
 ; Input: PSNDRUG = IFN from the DRUG file (50)  ** REQUIRED **
 ;
 ; Output: PSNFLAG = 0 if no PMI returned
 ;                   1 if PMI returned in ^TMP($J,"PSNPMI"
 ;         PSNMSG  = message text for no PMI information
 ;
 N PSNFLAG,PSNPN,PSNGCN,A1,PSNFILE1,PSNFILE2,PSNEMAP,PMID,PSNPL,I
 N MAP,LP,TXT,MTBL,XX,PMAP
 K ^TMP($J,"PSNPMI")
 S PSNFLAG=1,(MAP,PMAP,XX)=""
 S PSNPN=$TR($P($G(^PSDRUG(PSNDRUG,2)),U,4),"-")   ; NDC
 I 'PSNPN S PSNMSG="This drug is not matched to the National Drug File; therefore, a Medication Information Sheet cannot be printed." Q 0
 S PSNGCN=$O(^APSAMDF("B",PSNPN,0))
 I 'PSNGCN S PSNMSG="This drug is not linked to a Medication Information Sheet." Q 0
 ;S PSNGCN=+$G(^APSAMDF(PSNGCN,3)) ; IHS/CIA/PLS - 11/03/04
 S PSNGCN=$G(^APSAMDF(PSNGCN,3))   ; '+' removed
 I 'PSNGCN!'$D(^APSAPPI(PSNGCN)) S PSNMSG="This drug is not linked to a Medication Information Sheet." Q 0
 D SETMTBL(.MTBL)
 S ^TMP($J,"PSNPMI",0)=$G(^APSAPPI(PSNGCN,0))
 S LP=0 F  S LP=$O(^APSAPPI(PSNGCN,1,LP)) Q:'LP  D
 .S TXT=$G(^APSAPPI(PSNGCN,1,LP,0)),XX=""
 .I $$GETMAP(TXT,.MAP,.XX) D
 ..I $L(XX) D
 ...D SETTXT(XX,PMAP)
 ...D SETTXT($P(TXT,XX,2),MAP)
 ...S XX=""
 ..E  D SETTXT(TXT,MAP)
 ..S PMAP=MAP
 .E  D
 ..D SETTXT(TXT,MAP)
 D ADDDISC  ; Add disclaimer text
 Q 1
 ; Set text into global
SETTXT(TEXT,SUB) ;
 Q:SUB=""
 S ^TMP($J,"PSNPMI",SUB,+$G(MTBL(SUB)),0)=$$TRIM^XLFSTR(TEXT,"R")
 S MTBL(SUB)=MTBL(SUB)+1
 Q
 ; Return mapping type
GETMAP(TEXT,MAP,XX) ;
 N L,LBL,FLG
 S FLG=0
 F L=1:1 S LBL=$P($T(MAP+L),";;",2,3) Q:LBL=""  D  Q:FLG
 .I TEXT[$P(LBL,";;")_":" D
 ..S MAP=$P(LBL,";;",2),FLG=1
 ..S XX=$P(TEXT,$P(LBL,";;")_":")
 Q FLG
 ; Setup Map Table Counts
SETMTBL(DAT) ;
 N L,KEY
 F L=1:1 S LBL=$P($T(MAP+L),";;",2,3) Q:LBL=""  D
 .S DAT($P(LBL,";;",2))=1
 Q
 ; Add Disclaimer Text to "T" subscript of global
ADDDISC ;
 N LP,TXT
 S LP=0
 S TXT=$$TRIM^XLFSTR($P(^APSAPPI(.5,0),U,1),"R")
 S TXT="DISCLAIMER: "_TXT_"  Expires "_$$FMTE^XLFDT($$HL7TFM^XLFDT($P(^APSAPPI(.5,0),U,5))\100*100,"1D")_"."
 D SETTXT(TXT,"T")
 F  S LP=$O(^APSAPPI(.5,2,LP)) Q:'LP  D
 .D SETTXT(^APSAPPI(.5,2,LP,0),"T")
 S LP=0 F  S LP=$O(^APSAPPI(.5,3,LP)) Q:'LP  D
 .D SETTXT(^APSAPPI(.5,3,LP,0),"T")
 Q
 ; Key words
MAP ;;
 ;;GENERIC NAME;;G;;
 ;;COMMON USES;;U;;
 ;;HOW TO USE THIS MEDICINE;;H;;
 ;;CAUTIONS;;C;;
 ;;POSSIBLE SIDE EFFECTS;;S;;
 ;;BEFORE USING THIS MEDICINE;;B;;
 ;;OVERDOSE;;O;;
 ;;ADDITIONAL INFORMATION;;I;;
 ;;DISCLAIMER;;T;;
