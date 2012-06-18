AICDPOST ;IHS/OHPRD/ACC - Keyword Lookup Control File Postinit ; 
 ;;3.51;IHS ICD/CPT lookup & grouper;;MAY 30, 1991
 ;
 S U="^"
 W !!,"Keyword Lookup Control File postinit.",!
 W "Creating New Entries in Keyword Lookup Control File...",!
 ;
 I '$D(^DD(9001010)) W *7,!,"KEYWORD LOOKUP CONTROL FILE is Missing",! G XIT
 ;
MAIN S AICDENT="DIAGNOSES^PROCEDURES^CPT PROCEDURES"
 F AICD=1:1:$L(AICDENT,U) S AICDX=$P(AICDENT,U,AICD) W AICDX D:'$D(^AICDKWLC("B",AICDX)) NEW W !
 G END
 ;
NEW K DD,DO,DIC
 S DIC="^AICDKWLC(",X=AICDX,DIC(0)="L"
 D FILE^DICN
 I +Y<1 W *7," -- ERROR: ENTRY NOT CREATED"
 E  W " -- OK"
 Q
 ;
END W !,"CONTROL FILE UPDATE COMPLETE!",!
XIT K AICDENT,AICDX
 Q
