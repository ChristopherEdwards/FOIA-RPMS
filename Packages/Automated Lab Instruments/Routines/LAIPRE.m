LAIPRE ;DALISC/JRR - AUTO INSTRUMENTS PRE INIT ENVIRONMENT CHECK
 ;;5.2;LA;;NOV 01, 1997
 ;This routine checks to make sure that the programmer running
 ;the inits has the proper variables defined, otherwise, it
 ;signals the init to quit by killing the variable DIFQ.
 ;It is called from LAINIT only.
EN ;
 I $S('$D(DUZ):1,'$D(^VA(200,+DUZ)):1,'$D(IO):1,1:0) D
 .  W !!?10,"Your DUZ is undefined, you should log in through"
 .  W !?10,"Kernel, or DO ^XUP before continuing!"
 .  K DIFQ
 I $S('$D(DUZ(0)):1,DUZ(0)'="@":1,1:0) D
 .  W !!?10,"Your programmer access code is not equal to"
 .  W !?10,"the '@' character.  Please set it or log in"
 .  W !?10,"through Kernel, or DO ^XUP to set it correctly."
 .  K DIFQ
 I '$D(DIFQ) W !!?10,"Init will not proceed.",!!
 E  W !!?10,"Pre-Init Environment Check Completed...",!!
 QUIT
