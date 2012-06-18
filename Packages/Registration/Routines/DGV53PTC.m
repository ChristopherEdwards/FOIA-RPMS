DGV53PTC ;ALB/SCK - POST INIT CONVERSION MESSAGE BUILDER FOR POST INIT ROUTINE;4/19/23
 ;;5.3;Registration;;Aug 13, 1993
START ;
 Q
RMK ;  message builder of cities with add'l information field set
 S XMSUB="BENEFICIARY TRAVEL POST-INIT, ADD'L REMARKS FIELD'S",XMDUZ="BENEFICIARY TRAVEL POST-INIT" D XMZ^XMA2 I XMZ<1 D ERR G EXIT
 I '$D(^TMP("DGBT",$J,"ADD")) S ^XMB(3.9,XMZ,2,1,0)="No problems found with Additional Information fields in BENEFICIARY TRAVEL DISTANCE File (#392.1).",^XMB(3.9,XMZ,2,0)="^3.92A^1^1^"_DT
 I $D(^TMP("DGBT",$J,"ADD")) D
 . S ^XMB(3.9,XMZ,2,1,0)="These cities have their additional information field",^XMB(3.9,XMZ,2,2,0)="set and will need the remarks field completed in the new data file."
 . F L=1:1:RCNT S ^XMB(3.9,XMZ,2,L+2,0)=^TMP("DGBT",$J,"ADD",L),^XMB(3.9,XMZ,2,0)="^3.92A^"_L+2_"^"_L+2_"^"_DT
 D SETUP G EXIT
ZIP ;  message builder for missing zipcodes
 S XMSUB="BENEFICIARY TRAVEL POST-INIT, INCOMPLETE ZIP CODE INFORMATION",XMDUZ="BENEFICIARY TRAVEL POST-INIT" D XMZ^XMA2 I XMZ<1 D ERR G EXIT
 I '$D(^TMP("DGBT",$J,"ZIP")) S ^XMB(3.9,XMZ,2,1,0)="No problems found with missing zip codes in BENEFICIARY TRAVEL DISTANCE File (#392.1).",^XMB(3.9,XMZ,2,0)="^3.92A^1^1^"_DT
 I $D(^TMP("DGBT",$J,"ZIP")) D
 . S ^XMB(3.9,XMZ,2,1,0)="These cities are missing Zip Code information and should be corrected.",^XMB(3.9,XMZ,2,2,0)=""
 . F L=1:1:ZCNT S ^XMB(3.9,XMZ,2,L+2,0)=^TMP("DGBT",$J,"ZIP",L),^XMB(3.9,XMZ,2,0)="^3.92A^"_L+2_"^"_L+2_"^"_DT
 D SETUP G EXIT
MILES ;  message builder for cities with a 0 default mileage
 S XMSUB="BENEFICIARY TRAVEL POST-INIT, CITIES WITH NO DEFAULT MILEAGE",XMDUZ="BENEFICIARY TRAVEL POST-INIT" D XMZ^XMA2 I XMZ<1 D ERR G EXIT
 I '$D(^TMP("DGBT",$J,"MILES")) S ^XMB(3.9,XMZ,2,1,0)="No problems with missing default mileage values in BENEFICIARY TRAVEL DISTANCE File (#392.1).",^XMB(3.9,XMZ,2,0)="^3.92A^1^1^"_DT
 I $D(^TMP("DGBT",$J,"MILES")) D
 . S ^XMB(3.9,XMZ,2,1,0)="These cities are missing their default mileage value and should be corrected.",^XMB(3.9,XMZ,2,2,0)=""
 . F L=1:1:MCNT S ^XMB(3.9,XMZ,2,L+2,0)=^TMP("DGBT",$J,"MILES",L),^XMB(3.9,XMZ,2,0)="^3.92A^"_L+2_"^"_L+2_"^"_DT
 D SETUP G EXIT
EXIT ;
 K L,XMDUN,XMDUZ,XMSUB,XMY,XMZ
 Q
ERR ;  error message for error in creating mail message
 W !!?10,"THERE WAS A PROBLEM IN SETTING UP THE MESSAGE, EXITING..."
 Q
SETUP ;
 S XMDUN="",XMY(DUZ)="" D ENT1^XMD
 Q
