BRNPOST3 ; IHS/PHXAO/TMJ - Post Init Routine ;  
 ;;2.0T1;RELEASE OF INFO SYSTEM;;JAN 21, 2003
 ;Installs Package Protocols and List Templates
 ;
 ;
 D CONV
 ;
 D POST1 ;Populates the Site Parameter as Conversion Done
 ;
 D XREF
 ;
 D OPTION
 ;
 D DONE
 Q
 ;
PROT ;Protocol Install
 ;W !!,"I WILL NOW DO THE PROTOCOL INSTALLATION...",!!
 ;D ^BRNONIT
 ;W !,"FINISHED INSTALLING ONITS",!!
 ;
ONIT ;List Template Install
 ;W !,"I WILL NOW DO THE LIST TEMPLATE INSTALL...",!!
 ;D ^BRNL
 ;W !,"DON WITH TEMPLATE INSTALL",!
 ;
 ;
CONV ;Conversion of old Data to new BRN Globals
 ;
 Q:'$D(^AZXAREC(0))  ;Quit if Virgin Install-No Conversion Needed
 ;
 ;
 Q:'$D(^AZXAPARM)  ;Quit if no previous ROI vs. 1.0
 Q:'$D(^AZXAREQ)  ;Quit if no previous ROI vs. 1.0
 Q:'$D(^AZXAREC)  ;Quit if no previous ROI vs. 1.0
 ;
 ;
 S BRNIEN=$O(^BRNPARM("B",0))
 I BRNIEN="" D CONV1 Q  ;New Previous Site entry
 ;
 Q  ;Conversion ran already - just quit
 ;
 ;
 ;
CONV1 ;Run Conversion - Never completed
 ;
 ;Site Parameter Conversion from AZXAPARM to BRNPARM
 S BRNOGBL=^AZXAPARM(0) ;Old Global
 S BRNNGBL=^BRNPARM(0) ; New Global
 S BRNOREC=$P($G(BRNOGBL),"^",3) ;Last IEN
 I BRNOREC="" S BRNOREC=0
 S BRNOCT=$P($G(BRNOGBL),"^",4) ;Number of Records
 I BRNOCT="" S BRNOCT=0
 ;
 ;Run Conversion of Site Parameter
 S %X="^AZXAPARM(" S %Y="^BRNPARM(" D %XY^%RCR
 ;
 S ^BRNPARM(0)=BRNNGBL ;Set Zero Node Back to correct Name and Number
 S $P(^BRNPARM(0),"^",3)=BRNOREC ;Old Last IEN Number
 S $P(^BRNPARM(0),"^",4)=BRNOCT ;Old Count of Records
 W !,"Conversion of Site Parameters Completed!",!
 ;
 ;Requesting and Receiving Conversion AZXAREQ TO BRNTREQ
 S ^BRNPARM(0)=""""_BRNNAME_"^"_BRNFILE_"^"_BRNOREC_"^"_BRNOCT_""""
 S %X="^AZXAREQ(" S %Y="^BRNTREQ(" D %XY^%RCR
 W !,"Conversion of Table File Completed!",!
 ;
 S %X="^AZXAREC(" S %Y="^BRNREC(" D %XY^%RCR
 W !,"Conversion of Disclosure Data Completed!",!
 ;
 ;K ^AZXAPARM ;Kill Old Global ;Don't kill old Global yet
 ;K ^AZXAREQ ;Kill Old Global
 ;K ^AZXAREC ;Kill Old Global
 ;
 W !,"Conversion successfully Completed",!
 Q
POST1 ;Run BRNPOST1 to Populate the File Conversion Field
 ;
 D ^BRNPOST1
 Q
XREF ;REINDEX AP XREF
 W !,"I WILL NOW REINDEX THE AP CROSS REFERENCE",!
 K ^BRNREC("AP")
 S DIK="^BRNREC(",DIK(1)=".06^AP" D ENALL^DIK K DA,DIK
 W !,"FINSIHED WITH CROSS REFERENCE!",!!
 Q
 ;
OPTION ;Delete old AZXA Namespace Menu Options
 ;
 S BRNOPT=$O(^DIC(19,"B","AZXAMENU",0))
 Q:BRNOPT=""  ;Quit if AZXA Options non existent
 ;
 S XBPKNSP="AZXA" D ^XBPKDEL
 Q
DONE ;
 W !,"INSTALLATION OF THE ROI PROGRAM IS SUCCESSFULL",!
 W "IF FIRST TIME INSTALL THE SITE PARAMETERS MUST BE COMPLETED PRIOR TO RUNNING PROGRAM",!
 K BRNIEN,BRNDFN,BRNOPT
 Q
