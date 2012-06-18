AQAOPC23 ; IHS/ORDC/LJF - SUBRTN TO PRINT OCC WITH ICD ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the entry point called by ^AQAOPC22.  It collects
 ;all diagnoses and procedures for an occurrence and prints them.
 ;
ICDPRINT ;ENTRY POINT
 ; >>> SUBRTN to collect icd codes then call PRINT to print them
 K AQAOPV,AQAODX,AQAOPC
 ;
 ; >> get all providers listed for occ
 S (X,I)=0 F  S X=$O(^AQAOCC(7,"AB",AQAON,X)) Q:X=""  D
 .Q:'$D(^AQAOCC(7,X,0))  S I=I+1,Y=+^(0)
 .S AQAOPV(I)=$S(Y["VA(200":"I",1:"C")_+Y
 .;  increment count for this provider
 .S ^TMP("AQAO",$J,"V",AQAOSUB,AQAOPV(I))=$G(^TMP("AQAO",$J,"V",AQAOSUB,AQAOPV(I)))+1
 ;
 ;
 ; >> get all dx listed for occ
 S (X,I)=0 F  S X=$O(^AQAOCC(8,"AB",AQAON,X)) Q:X=""  D
 .Q:'$D(^AQAOCC(8,X,0))  S Y=+^(0) ;pointer to icd9 file
 .S I=I+1
 .I $D(AQAODLM) S AQAODX(I)=$P(^ICD9(Y,0),U)_AQAODLM_$E($P(^(0),U,3),1,30)
 .E  S AQAODX(I)=$P(^ICD9(Y,0),U)_": "_$E($P(^(0),U,3),1,30)
 .;  increment count for this dx
 .S ^TMP("AQAO",$J,"D",AQAOSUB,AQAODX(I))=$G(^TMP("AQAO",$J,"D",AQAOSUB,AQAODX(I)))+1
 ;
 ;
 ; >> get all procedures listed for occ
 S (X,I)=0 F  S X=$O(^AQAOCC(9,"AB",AQAON,X)) Q:X=""  D
 .Q:'$D(^AQAOCC(9,X,0))  S Y=+^(0) ;pointer to icd0 file
 .S I=I+1
 .I $D(AQAODLM) S AQAOPC(I)=$P(^ICD0(Y,0),U)_AQAODLM_$E($P(^(0),U,4),1,30)
 .E  S AQAOPC(I)=$P(^ICD0(Y,0),U)_": "_$E($P(^(0),U,4),1,30)
 .;  increment count for this procedure
 .S ^TMP("AQAO",$J,"P",AQAOSUB,AQAOPC(I))=$G(^TMP("AQAO",$J,"P",AQAOSUB,AQAOPC(I)))+1
 ;
 ;
 ; >> print all prov, dx, proc with same subscripts on same line
 Q:AQAOTYPE="S"  ;summary page only, no print
 F I=1:1 Q:'$D(AQAOPV(I))&'$D(AQAODX(I))&'$D(AQAOPC(I))  D
 .I $D(AQAODLM) D
 ..I I=1 W AQAODLM,$G(AQAOPV(I)),AQAODLM,$G(AQAODX(I)),AQAODLM,$G(AQAOPC(I)),!
 ..E  D
 ...F I=1:1:7 W AQAODLM
 ...W $G(AQAOPV(I)),AQAODLM,$G(AQAODX(I)),AQAODLM,$G(AQAOPC(I)),!
 .E  W ?45,$G(AQAOPV(I)),?52,$G(AQAODX(I)),?92,$G(AQAOPC(I)),!
 Q
