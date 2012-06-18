ACDPIMP1 ;IHS/ADC/EDE/KML - build entries from imported global; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
 ;******************************************************************
 ;Build CDMIS data files on area/HQ machine from the ^ACDPTMP global
 ;that has just been imported to the area/HQ machine
 ;****************************************************************
EN ;EP
 ;//ACDPIMP
 ;Check for existence of data
 I '$D(^ACDPTMP) W !,"No data to import..." Q
 ;
 ;Validate incomming ASUFAC's are in the area location file
 ;ACDUSER is in the form 'DUZ(2)^PROGRAM ASSOCIATED WITH VISIT'
 ;
 W !! K ACDQUIT S ACDUSER="" F  S ACDUSER=$O(^ACDPTMP(ACDUSER)) Q:ACDUSER=""  W !,"Checking for the existence of ASUFAC: ",$P(ACDUSER,"*",2)," in your location file." I '$O(^AUTTLOC("C",$P(ACDUSER,"*",2),0)) S ACDQUIT=1 W *7," Missing.",!
 I $D(ACDQUIT) W !!,"Aborted...Contact your site manager immediately.." S ^ACDP1TMP=1 Q
 E  W !!,"All facility codes exist. Proceeding with rebuild...",!
 ;
 ;
RBL ;
 ;Rebuild program data here.
 S ACDUSER=""  F  S ACDUSER=$O(^ACDPTMP(ACDUSER)) Q:ACDUSER=""  D
 .S ACDA=$O(^AUTTLOC("C",$P(ACDUSER,"*",2),0))
 .;
 .;Delete original entry if it exists
 .S DA=ACDA,DIK="^ACDQAN(" D ^DIK
 .L +^ACDQAN(ACDA):0 ;    lock not needed/done for verification only
 .; locking non-existent entry, users locked out
 .;
 .S %Y="^ACDQAN("_ACDA_","
 .S %X="^ACDPTMP("""_ACDUSER_""","
 .D %XY^%RCR
 .;
 .;Reset .01 because it is dinumed
 .S $P(^ACDQAN(ACDA,0),U)=ACDA
 .L -^ACDQAN(ACDA)
 ;
RDX ;
 ;Re-index all entries for B index
 K ^ACDQAN("B")
 S DIK(1)=".01^B"
 S DIK="^ACDQAN("
 D ENALL^DIK
 ;
 I $D(^ACDP1TMP) W !!,"Since this import is finished, now killing the ^ACDP1TMP global flag." K ^ACDP1TMP ;    kill of scratch global  SAC EXEMPTION (2.3.2.3  killing of unsubscripted globals is prohibited)
K ;
 K ^ACDPTMP ;       kill of scratch global
 Q
