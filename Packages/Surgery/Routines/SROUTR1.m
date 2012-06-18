SROUTR1 ;B'HAM ISC/MAM - UNTRANSCRIBED DICTATIONS;5 Oct 1988  9:03 AM
 ;;3.0; Surgery ;;24 Jun 93
EN ; entry point
 W @IOF,!,"List of Untranscribed Surgeon's Dictations",!!!,"Sort Cases by: ",!!,"1. Surgeon",!,"2. Service",!,"3. Date of Operation",!!,"Enter number: " R SRT:DTIME I '$T!("^"[SRT) G END
 I SRT'?1N!(SRT<1)!(SRT>3) D QUES1 G EN
 G ASK^SROUTRN
QUES1 W !!,"If you would like the cases sorted by the surgeon, enter '1'.  If you would",!,"the list sorted by surgical specialty, enter '2'.  Enter '3' to sort the cases",!,"by the date of the operation."
 W !!,"Press RETURN to continue  " R X:DTIME
 Q
END W ! D ^SRSKILL K SRTN D ^%ZISC W @IOF
 Q
