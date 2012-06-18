PSGSEL ;BIR/CML3-SELECT ORDERS BY WARD, WARD GROUP, OR PATIENT ; 15 May 98 / 9:26 AM
 ;;5.0; INPATIENT MEDICATIONS ;**3**;16 DEC 97
SELECT ; give user choice to select by
 S:'$D(PSGSSH) PSGSSH="GENERIC"
 ;F  R !!,"Select by WARD GROUP (G), WARD (W), or PATIENT (P): ",PSGSS:DTIME W:'$T $C(7) S:'$T PSGSS="^" Q:"^"[PSGSS  D CHK I "GPW"[PSGSS S ^DISV(DUZ,"PSGSEL")=PSGSS Q
 F  R !!,"Select by WARD GROUP (G), WARD (W), or PATIENT (P): ",PSGSS:DTIME W:'$T $C(7) S:'$T PSGSS="^" Q:"^"[PSGSS  D CHK I "GPW"[PSGSS Q
 K PSGSSA Q
 ;
CHK ;
 ;I PSGSS=" ",$D(^DISV(DUZ,"PSGSEL")) S PSGSS=^("PSGSEL") W $S(PSGSS="P":"PATIENT",PSGSS="W":"WARD",PSGSS="G":"GROUP",1:"") Q:PSGSS]""&("GPW"[PSGSS)
 I PSGSS=" " W $S(PSGSS="P":"PATIENT",PSGSS="W":"WARD",PSGSS="G":"GROUP",1:"") Q:PSGSS]""&("GPW"[PSGSS)
 S PSGSSA="" F Q=1:1:$L(PSGSS) S PSGSSA=PSGSSA_$S($E(PSGSS,Q)'?1L:$E(PSGSS,Q),1:$C($A(PSGSS,Q)-32))
 F X="GROUP","WARD","PATIENT" I $P(X,PSGSSA)="" W $P(X,PSGSSA,2) S PSGSS=$E(PSGSSA) Q
 Q:$T  I PSGSS'?1."?" W $C(7),"  ??" S PSGSS="Z" Q
 W ! D @PSGSSH W !!?2,"To leave this option, press the RETURN key or enter an '^'." Q
 ;
HELP ; the following are the help text messages for the various options
 ;
GENERIC W !!,?2,"To run this option for an entire WARD GROUP, enter a 'G'.  To run this option for a single WARD, enter a 'W'.  To run this option for a single PATIENT, enter a 'P'." Q
 ;
VBW W !!?2,"To verify all of the orders in an entire WARD GROUP, enter a 'G'.  To verify  all of the orders in a single WARD, enter a 'W'.  To verify all of the orders   for a single PATIENT, enter a 'P'." Q
 ;
EXP W !?2,"To print STOP ORDER NOTICES for an entire WARD GROUP, enter a 'G'.  To print  notices for a single WARD, enter a 'W'.  To print notices for a single PATIENT, enter a 'P'." Q
 ;
MAR W !?2,"To run a Medication Administration Record (MAR or CMR) for an entire WARD",!,"GROUP, enter a 'G'.  To run an MAR for a single WARD, enter a 'W'.  To run an   MAR for a single PATIENT, enter a 'P'." Q
 ;
LBL W !?2,"To print labels for all of the orders in an entire WARD GROUP, enter a 'G'.   To print labels for all of the orders in a WARD, enter a 'W'.  To print the",!,"labels for a single PATIENT, enter a 'P'." Q
 ;
TCR W !?2,"To run a TOTAL COST REPORT for an entire WARD GROUP, enter a 'G'.  To run the report for a single WARD, enter a 'W'.  To run the report for a single PATIENT,",!,"or a set of PATIENTS, enter a 'P'." Q
 ;
PPR W !?2,"To print PATIENT PROFILES for an entire WARD GROUP, enter a 'G'.  To print    profiles for a single WARD, enter a 'W'.  To print a profile for a single",!,"PATIENT, enter a 'P'." Q
 ;
AP W !?2,"To print ACTION PROFILES for an entire WARD GROUP, enter a 'G'.  To print",!,"ACTION PROFILES for a single WARD, enter a 'W'.  To print an ACTION PROFILE",!,"for a single patient, enter a 'P'.  PLEASE NOTE that only patients"
 W " with active",!,"orders are selectable, and that only patients with active orders will print for",!,"a ward or ward group." Q
ORVC W !?2,"To complete orders for an entire WARD GROUP, enter a 'G'.  To complete orders for a single WARD, enter a 'W'.  To complete orders for a single PATIENT, enter",!,"a 'P'." Q
