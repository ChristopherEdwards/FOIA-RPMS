AMHLETM ; IHS/CMI/LAB - get time for outpatient visit ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
GETTIME ;
 S Y=$P(^AMHREC(AMHR,0),U) D DD^%DT S AMHTIME=$P(Y,"@",2)
 S AMHPROMP=$S(AMHACTN="1":"Arrival Time.............: ",1:"TIME OF VISIT: ") W !,AMHPROMP,$S(AMHTIME]"":AMHTIME_"// ",1:"12:00// ") R X:$S($D(DTIME):DTIME,1:300) S:'$T X="^" S:X="" X=$S(AMHTIME]"":AMHTIME,1:"12:00")
 S AMHTIME=""
 I X=""!(X="^") W $C(7)_$C(7),"  Time Required!  Enter 1200 or 'D' for a default of 12 if you do not know the time." G GETTIME
 I X["?" W !,"Enter time of visit, or 'D' for default." G GETTIME
 I X="D" S X="12:00" W "  ",X
EDTIME S AMHTIME=X,X=AMHDATE_"@"_AMHTIME
 S %DT="ET" D ^%DT I Y<0 W !!,"Invalid time entry, enter time of visit or 1200 for the default." G GETTIME
 I '$D(X) W $C(7)_$C(7) G GETTIME
 I X="-1" W ! G GETTIME
 S AMHDTIME=Y
 K Y,AMHTIME,X,%DT,AMHPROMP
 Q
