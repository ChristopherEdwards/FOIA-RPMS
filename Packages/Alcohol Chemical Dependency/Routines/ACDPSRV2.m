ACDPSRV2 ;IHS/ADC/EDE/KML - BUILD ENTRIES FROM IMPORTED GLOBAL ACDPTMP; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
 ;******************************************************************
 ;Build CDMIS data files on area/HQ machine from the ^ACDPTMP global
 ;that has just been imported to the area/HQ machine
 ;****************************************************************
EN ;EP
 ;//^ACDPSRV1
 ;Check for existence of data
 I '$D(^ACDPTMP) Q
 ;
 ;Validate incomming ASUFAC's are in the area location file
 ;ACDUSER is in the form 'DUZ(2)^PROGRAM ASSOCIATED WITH VISIT'
 K ACDQUIT S ACDUSER="" F  S ACDUSER=$O(^ACDPTMP(ACDUSER)) Q:ACDUSER=""  I $P(ACDUSER,"*")=ACDHEAD(3),'$O(^AUTTLOC("C",$P(ACDUSER,"*",2),0)) S ACDQUIT=1 Q
 ;
 I $D(ACDQUIT) S ^ACDP1TMP=1 Q
 ;
 ;
RBL ;
 ;Rebuild program data here.
 S ACDUSER="" F  S ACDUSER=$O(^ACDPTMP(ACDUSER)) Q:ACDUSER=""  I $P(ACDUSER,"*")=ACDHEAD(3) D
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
 .K ^ACDPTMP(ACDUSER)
 .L -^ACDQAN(ACDA)
 .Q
 ;
RDX ;
 ;Re-index all entries for B index
 K ^ACDQAN("B")
 S DIK(1)=".01^B"
 S DIK="^ACDQAN("
 D ENALL^DIK
 ;
 I $D(^ACDP1TMP) W !!,"Since this import is finished, now killing the ^ACDP1TMP global flag." K ^ACDP1TMP ;    kill of scratch global  SAC EXEMPTION (2.3.2.3  KILLING of unsubscripted globals is prohibited)
K ;
