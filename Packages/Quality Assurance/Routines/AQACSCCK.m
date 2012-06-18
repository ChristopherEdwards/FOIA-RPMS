AQACSCCK ;IHS/ASU/RPL ;CHECK AND OFFER TO DELETE SCREENING CODE 0 IF 0 AND ANOTHER CODE PRESENT IN MULTIPLE FIELD ; 11/13/89  11:32 AM
 ;;QA/UR Version 2.04;11/7/89
 ;
 S AQAI=0 F AQAII=1:1 S AQAI=$O(@(DIE_AQAI_")")) Q:AQAI'=+AQAI  S AQA(AQAII)=@(DIE_AQAI_",0)") S:$P(^AQACSC(AQA(AQAII),0),U,1)=0 AQA0=AQAI
 G:'$D(AQA0)!(AQAII=2) QUIT W !!,"This Patient's Admission shows the following Codes:",! S AQAII=AQAII-1,DIWL=5,DIWR=79,DIWF="W" K ^UTILITY($J,"W")
 F AQAJ=1:1:AQAII W !,?4,"CODE "_$P(^AQACSC(AQA(AQAJ),0),U,1) D FRMT
 W *7,!,"Screening Code 0 is not usually appropriate in conjunction with any other Codes!",!,"Do you want to DELETE Screening Code 0 (Y/N)" S %=0 D YN^DICN G:%'=1 QUIT
 S DIK=DIE,DA=+AQA0 D ^DIK W !,"Screening Code 0 is DELETED!",!
QUIT K %,Y,AQAI,AQA,AQA0,AQAX,AQADA,AQAII,AQAJ
 Q
FRMT S X=$P(^AQACSC(AQA(AQAJ),0),U,2) D ^DIWP,^DIWW
 Q
