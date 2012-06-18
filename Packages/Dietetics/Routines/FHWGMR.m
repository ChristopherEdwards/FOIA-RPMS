FHWGMR ; HISC/NCA - Signed Reaction Event Filer ;2/16/96  11:37
 ;;5.0;Dietetics;**3**;Apr 21, 1996
EN1 ; File Entered Signed Reaction
 Q:+$$VERSION^XPDUTL("GMRA")'=4
 S FLG=1 D CHK G:'FLG KIL
 S EVT="M^O^^"_"Allergy - "_ALG D FIL
 G KIL
CAN ; File Cancelled/Entered in Error Allergy
 S FLG=1 D CHK G:'FLG KIL
 S EVT="M^O^^"_"Allergy - "_ALG_" Cancelled" D FIL
 G KIL
FIL ; File Event
 D ^FHORX Q
KIL K %,%H,%I,ADM,ALG,DFN,FHSTR,FHTYP,FHWRD,FLG,X Q
CHK ; Check Validity of Data Passed
 I 'GMRAPA!($G(GMRAPA(0))="") G ERR
 S FHSTR=$G(GMRAPA(0)),DFN=+FHSTR G:'DFN ERR
 S ALG=$P(FHSTR,"^",2) G:ALG="" ERR
 G:'$D(^FHPT(DFN)) ERR S FHWRD=$G(^DPT(DFN,.1)) G:FHWRD="" ERR
 S ADM=$G(^DPT("CN",FHWRD,DFN)) G:ADM<1 ERR
 G:'$P(FHSTR,"^",12) ERR
 S FHTYP=$P(FHSTR,"^",20) G:FHTYP'["F" ERR
 Q
ERR S FLG=0 Q
