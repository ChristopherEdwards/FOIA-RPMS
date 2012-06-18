DGV53PTB ;ALB/SCK - POST INIT CONVERSION ROUTINE FOR DISTANCE FILE; 2/2/93  4/19/93
 ;;5.3;Registration;;Aug 13, 1993
 Q
EN ;
 S (ZCNT,RCNT,MCNT,TOT)=0,U="^"
 K ^TMP("DGBT",$J,"ZIP")
 W !!!,">>> Beginning conversion of BENEFICIARY TRAVEL DISTANCE file, (#392.1)"
 I '$D(^DGBT(392.1,0)) W !!,*7,">>> The BENEFICIARY TRAVEL DISTANCE file, (#392.1), is not properly set-up.",!,"Please re-run the init to set it up." G EXIT
 I '$O(^DGBT(392.1,0)) W !!,">>> There is no data in the BENEFICIARY TRAVEL DISTANCE file (#392.1) to convert",!?4,"Exiting post-init conversion of BENEFICIARY TRAVEL." G EXIT
 L +^DGBT(392.1):3 I '$T W !!,*7,">>> File is not available at the present time!",!?4,"Please try again later." G EXIT
 S PRIDIV=+$P($G(^DG(43,1,"GL")),U,3) I 'PRIDIV D ERR1 G EXIT
 W !! D WAIT^DICD
 W !,">>> Beginning check and conversion",!?4,"of BENEFICIARY TRAVEL DISTANCE file, (#392.1)",!
 S GLREC=0 F  S GLREC=$O(^DGBT(392.1,GLREC)) Q:'GLREC  D LOOP
 L -^DGBT(392.1)
ENDLOOP ;  end of loop to rebuild distance file
 W !!,">>> BENEFICIARY TRAVEL DISTANCE file (#392.1) conversion complete.",!?4,TOT," Cities in the BENEFICIARY TRAVEL DISTANCE file (#392.1) have been converted.",! D WAIT^DICD
 W !,">>> Re-Indexing BENEFICIARY TRAVEL DISTANCE file (#392.1).  This could take awhile."
 S DIK="^DGBT(392.1,",DA(1)=392.1 D IXALL^DIK W !!,">>> Re-Indexing complete."
 D RMK^DGV53PTC,ZIP^DGV53PTC,MILES^DGV53PTC
 I MCNT!(ZCNT)!(RCNT) D
 . W !!!,"INCOMPLETE INFORMATION FOUND DURING THE POST-INIT CONVERSION OF THE",!,"BENEFICIARY TRAVEL DISTANCE FILE, (#392.1)",!!
 .  D:MCNT>0 MSGS D:ZCNT>0 ZIPMSG D:RCNT>0 RMKMSG
EXIT ;
 K ^TMP("DGBT",$J,"ZIP"),^TMP("DGBT",$J,"MILES"),^TMP("DGBT",$J,"ADD")
 K ADDINF,MCNT,MEC,MILES,PRIDIV,RCNT,ZCNT,ZIP,GLREC,TOT,DIK,ZIP,DGBTVAR,STATE
 Q
LOOP ; begin loop for converting distance file
 S TOT=TOT+1,DGBTVAR=^DGBT(392.1,GLREC,0)
CHKMILE ;  check default mileage, if null pass 0 to subnode
 S MILES=+$P(DGBTVAR,U,3) D:MILES'>0 MARRAY
ADDINF ;  check for additional information flag
 S ADDINF=$P(DGBTVAR,U,5) D:ADDINF ADARRAY
MECOST ;
 S MEC=$P($G(^DGBT(392.1,GLREC,0)),U,6)
STUFF ; build subnode from variables set above
 W:'(TOT#10) "."
 I '$D(^DGBT(392.1,GLREC,1,0)) D
 . S ^DGBT(392.1,GLREC,1,0)="^392.1001PA"_"^"_1_"^"_1
 . S ^DGBT(392.1,GLREC,1,1,0)=PRIDIV_"^"_MILES_"^"_$S(MEC'>0:"^"_ADDINF,1:MEC_"^"_ADDINF)
ZIP ;  check for zipcode, make sure there is a number value entered in piece 4.
 D:$P(DGBTVAR,U,4)']"" ZARRAY
 Q
MSGS ;  list out incomplete data found during conversion
 W !!,*7,">>> WARNING! ",!?4,MCNT," CITIES WITH INCOMPLETE MILEAGE INFORMATION",!?4,"WERE FOUND, A LISTING HAS BEEN SENT TO THE MAS ADPAC."
 Q
ZIPMSG ; 
 W !!,*7,">>> WARNING!",!?4,ZCNT," CITIES WITH INCOMPLETE ZIP CODE INFORMATION",!?4,"WERE FOUND, A LISTING HAS BEEN SENT TO THE MAS ADPAC."
 Q
RMKMSG ;
 W !!,*7,">>> WARNING!",!?4,RCNT," CITIES HAD THE ADDITIONAL INFORMATION FIELD SET THAT",!?4,"WILL NEED THE REMARKS COMPLETED.  A LISTING HAS BEEN SENT TO",!?4,"THE MAS ADPAC"
 Q
ERR1 ;
 W !!,*7,">>> The primary division is missing or incorrect.",!,"I'm stopping the Beneficiary Travel portion",!,"of the post-init.  Please check the value of the primary",!,"division in the MAS parameter file DG(43)"
 Q
ZARRAY ;  build array for message on missing zipcodes
 S ZCNT=ZCNT+1,STATE=$$GSTATE,^TMP("DGBT",$J,"ZIP",ZCNT)=$P(DGBTVAR,U,1)_", "_STATE
 Q
MARRAY ;  build array for message on 0 default mileages
 S MCNT=MCNT+1,STATE=$$GSTATE,^TMP("DGBT",$J,"MILES",MCNT)=$P(DGBTVAR,U,1)_", "_STATE
 Q
ADARRAY ;  build array for cities with additional information field set
 S RCNT=RCNT+1,STATE=$$GSTATE,^TMP("DGBT",$J,"ADD",RCNT)=$P(DGBTVAR,U,1)_", "_STATE
 Q
GSTATE() ;
 N STATE
 S STATE=$S($P(DGBTVAR,U,2)]"":$P($G(^DIC(5,$P(DGBTVAR,U,2),0)),U,1),1:"** MISSING STATE **")
 Q STATE
