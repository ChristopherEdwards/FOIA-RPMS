XBHEDD8 ;402,DJB,10/23/91,EDD - Trace a Field
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;;David Bolduc - Togus, ME
EN ;
 I FLAGP D PRINT^XBHEDD7 ;Turn off printing
 D GETFLD G:FLAGQ EX D LIST G:FLAGG!(FLAGE) EX
 D TRACE G:FLAGQ EX D PRINT,ASK
EX K CNT,DATA,FLD,FLD1,FLDCNT,I,LEVEL,MAR,MAR1,ZDD,ZNAME,ZNUMBER,^UTILITY($J,"FLD")
 S FLAGQ=1 Q
GETFLD ;
 R !?8,"Enter Field Name: ALL FIELDS//",FLD:DTIME S:'$T FLD="^^" I FLD["^" S FLAGQ=1 S:FLD="^^" FLAGE=1 Q
 I FLD="?" W !?2,"Enter field name or any portion of name. I will display the field's path.",!?2,"Use this option if you get ""beeped"" in the INDIVIDUAL FIELD SUMMARY because",!?2,"the field is decendent from a multiple." G GETFLD
 Q
LIST ;
 S ZDD="",FLDCNT=1
 F  S ZDD=$O(^UTILITY($J,"TMP",ZDD)) Q:ZDD=""!(FLAGQ)  S LEVEL=$P(^(ZDD),U,2),ZNAME="" F  S ZNAME=$O(^DD(ZDD,"B",ZNAME)) Q:ZNAME=""  I $E(ZNAME,1,$L(FLD))=FLD D LIST1 Q:FLAGQ
 I '$D(^UTILITY($J,"FLD")) W ?50,"No such field." S FLAGG=1
 S FLAGQ=0 Q
LIST1 ;
 S ZNUMBER=$O(^DD(ZDD,"B",ZNAME,"")) Q:^DD(ZDD,"B",ZNAME,ZNUMBER)=1
 D:FLDCNT=1 HD
 W ! W:$P(^DD(ZDD,ZNUMBER,0),U,2)>0 "Mult->" W ?6,$J(FLDCNT,3),".",?LEVEL*5+6,"  ",ZNAME,"  (",ZNUMBER,")"
 S ^UTILITY($J,"FLD",FLDCNT)=ZNAME_"^"_ZDD_"^"_ZNUMBER_"^"_LEVEL
 D:$Y>SIZE PAGE Q:FLAGQ
 S FLDCNT=FLDCNT+1
 Q
TRACE ;If more than one match do NUM
 R !!?8,"Select Number: ",FLD1:DTIME S:'$T FLD1="^^" S:FLD1="" FLD1="^" I FLD1["^" S FLAGQ=1 S:FLD1="^^" FLAGE=1 Q
 I FLD1<1!(FLD1>(FLDCNT)) W *7,!?2,"Enter a number from the left hand column." G TRACE
 S CNT=1,ZNAME(CNT)=$P(^UTILITY($J,"FLD",FLD1),U),ZNUMBER(CNT)=$P(^(FLD1),U,3),ZDD=$P(^(FLD1),U,2)
 Q:ZDD=ZNUM
 F  S CNT=CNT+1,ZNUMBER(CNT)=$P(^UTILITY($J,"TMP",ZDD),U,3),ZDD=^DD(ZDD,0,"UP"),ZNAME(CNT)=$P(^DD(ZDD,ZNUMBER(CNT),0),U) Q:ZDD=ZNUM
 Q
PRINT ;Print data.
 W @IOF,!!!,?IOM\2-11,"F I E L D    T R A C E",!,$E(ZLINE1,1,IOM)
 S MAR=5,MAR1=15
 F  W !!?MAR,ZNUMBER(CNT),?MAR1,ZNAME(CNT) S CNT=CNT-1 Q:CNT=0  S MAR=MAR+5,MAR1=MAR1+5
 Q
ASK ;
 I $Y'>SIZE F I=$Y:1:SIZE W !
 W !,$E(ZLINE1,1,IOM)
 W !?2,"(<RETURN>=Main Menu)  ('I'=Individual Field Summary)"
ASK1 R !?2,"Select: ",Z1:DTIME S:'$T Z1="^^" I Z1="^^" S FLAGE=1
 I Z1="?" W *7,!?2,"See menu on line above." G ASK1
 S:Z1="i" Z1="I" I Z1="I" D ^XBHEDD3
 Q
PAGE ;
 R !!?2,"<RETURN> to continue, '^' to quit, '^^' to exit: ",Z1:DTIME S:'$T Z1="^" I Z1["^" S FLAGQ=1 S:Z1="^^" FLAGE=1 Q
 D HD Q
HD ;Trace a field
 W @IOF,!!,"MULTIPLE",?13,"1    2    3    4    5    6    7",!,"LEVELS",?13,"|    |    |    |    |    |    |",!,$E(ZLINE,1,IOM),!
 Q
