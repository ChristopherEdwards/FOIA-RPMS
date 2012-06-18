AUCDIC ; CLEAN UP ^DIC AND ^DD [ 06/13/87  9:46 AM ]
 ;
NOTES ; This routine cleans up ^DIC and ^DD by a range of
 ; dictionary numbers.  All files in ^DIC within the range
 ; of dictionary numbers are checked for the following:
 ;   They must have a NAME in ^DIC.
 ;   The NAME in ^DIC must match the NAME in ^DD.
 ;   The NAME must exist in ^DIC("B" with the correct number,
 ;     and that number cannot occur more than once in ^DIC("B".
 ;   They must have a data global specified in ^DIC.
 ;   The data global must be in the correct form.
 ;   The data global must exist.
 ;   The data global must have a 0th node.
 ;   The NAME and NUMBER in the data global must match ^DIC.
 ;   The data globals 0th node must be consistent with
 ;     the data (Exact count not checked).
 ;   They must have valid entries in ^DD as follows:
 ;     The ^DD entry must have a .01 field.
 ;     All "SB" pointers must point to existing sub-files.
 ;     All sub-files must point back to correct parent.
 ;     All "TRB" entries must exist.
 ;     All "PT" entries must exist.
 ;     All "ACOMP" entries must exist.
 ;
 ; When descrepencies are found the entries are corrected
 ; automatically where ever possible.  If this is not possible
 ; operator interaction occurs to make the corrections.  If
 ; the file cannot be corrected, it will be deleted.
 ;
 ; After all dictionaries within the range of dictionary
 ; numbers are checked, all other entries within the range
 ; will be deleted.
 ;
 ; The last step is to set the 0th node of the FILE OF FILES
 ; to the correct high DFN and the correct count of entries.
 ;
BEGIN S U="^"
 W !!,"This routine cleans up ^DIC and ^DD by a range of dictionary numbers."
LO R !!,"Enter low  number of range: ",AUCDLO G:AUCDLO'=+AUCDLO EOJ
HI R !,"Enter high number of range: ",AUCDHI S:AUCDHI="" AUCDHI=AUCDLO G:AUCDHI'=+AUCDHI!(AUCDHI<AUCDLO) EOJ
 I AUCDLO<2 W !!,"*** Don't mess with files less than 2!! ***",*7 G EOJ
 S AUDSLO=AUCDLO,AUDSHI=AUCDHI D EN1^%AUDSET
 I '$D(^UTILITY("AUDSET",$J)) W !!,"No dictionaries were selected!" G EOJ
 D ^AUCDIC2 ; CHECK NAMES AND DATA GLOBALS *****
 D ^AUCDICD ; DELETE BAD FILES FOUND BY ^AUCDIC2 *****
 S AUDSLO=AUCDLO,AUDSHI=AUCDHI D EN1^%AUDSET ; GET LIST AGAIN
 D ^AUCDIC3 ; CHECK ^DD ENTRIES *****
 S AURLO=AUCDLO,AURHI=AUCDHI D EN1^%AURESID ; CHECK DANGLING ^DD ENTRIES
 W !!,"Now confirming ^DIC(""B"")"
 S AUCDX="" F AUCDL=0:0 S AUCDX=$O(^DIC("B",AUCDX)) Q:AUCDX=""  S AUCDFILE="" F AUCDL=0:0 S AUCDFILE=$O(^DIC("B",AUCDX,AUCDFILE)) Q:AUCDFILE=""  I AUCDFILE'<AUCDLO,AUCDFILE'>AUCDHI W "." D BCHK
 S AUCDFILE=AUCDLO-.00000001 F AUCDL=0:0 S AUCDFILE=$O(^DIC(AUCDFILE)) Q:AUCDFILE'=+AUCDFILE  I AUCDFILE'>AUCDHI W "." S AUCDNDIC=$P(^DIC(AUCDFILE,0),U,1) I AUCDNDIC'="",'$D(^DIC("B",AUCDNDIC,AUCDFILE)) S ^(AUCDFILE)="" W "|"
 G EOJ
 ;
BCHK ;
 I '$D(^DIC(AUCDFILE,0))#2 K ^DIC("B",AUCDX,AUCDFILE) W "|" Q
 I AUCDX'=$P(^DIC(AUCDFILE,0),U,1) K ^DIC("B",AUCDX,AUCDFILE) W "|"
 Q
EOJ ;
 K AUCDLO,AUCDHI,AUCDUCI,AUCDL,AUCDFILE,AUCDX,AUCDNDIC
 K ^UTILITY("AUDSET",$J)
 Q
