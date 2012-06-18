SDSCP ;ALB/MLI - STOP CODE PRINT ROUTINE ; 2 NOV 87 14:00 [ 08/20/2004  4:10 PM ]
 ;;5.3;Scheduling;**14,34,132,1001**;Aug 13, 1993
 ;
CL ; -- called from CL^SDCWL
 W ! S DIC="^DIC(40.7,",DIC(0)="EFQZM" D ^DIC K DIC("S") Q:X["?"  I Y'>0 W *7," No such stop code" Q
 I $P(Y(0),U,2)=900 W *7," is not a stop code??" Q
 I $D(SDCL($P(Y(0),"^",2))) W *7,"??    This stop code has already been selected" Q
 ;IHS/ITSC/WAR 5/3/2004 P #1001 REM'd next line - IHS does not use 3 digit codes
 ;I $P(Y(0),"^",2)'?3N W *7,"??   Must be a three digit stop code" Q
 S SDCL($P(Y(0),"^",2))=+Y,SDI=SDI+1
 Q
 ;
