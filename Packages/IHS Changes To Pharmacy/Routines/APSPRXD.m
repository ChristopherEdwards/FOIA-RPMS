APSPRXD ; IHS/DSD/ENM - DELETE PRESCRIPTIONS UP TO CERTAIN DATE ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;
 ; This routine deletes prescriptions up to a user specified number
 ; of months from the day it is run.  It it meant to be run from
 ; the background but could be called at ENQUE if APSPRXD("ED") was
 ; defined with a Fileman formatted date.  This deletes entries
 ; from the PSRX,PS(55,PS(52.5, globals which correspond to the
 ; Prescription, Pharmacy Patient, RX Suspense files.
 ; When checking the prescriptions for deletion it checks for
 ; refills that were done for the prescription and if any of the
 ; refills were filled after the APSPRXD("ED") date, the prescription
 ; entry is not deleted.
 ;--------------------------------------------------------------------
START ;
 S MWR=0
 D ASK G ENQUE ;IHS/ANMC/MWR 03/17/92
 Q
 D QUE G END
ENQUE ; EP
 D PROCESS
END D EOJ
 Q
 ;---------------------------------------------------------------------
ASK ;
 S DIR(0)="NO^6:24",DIR("B")=15
 S DIR("A")="Number of months of prescriptions to keep"
 S DIR("?")="If you enter a 15, all prescriptions older than 15 months will be deleted."
 D ^DIR
 I $D(DTOUT)!($D(DUOUT)) S APSPRXD("QFLG")=1 G ASKX
 S X="T-"_Y_"M" D ^%DT S APSPRXD("ED")=Y
ASKX K DIR,X,Y
 Q
 ;
QUE ;
 S ZTRTN="ENQUE^APSPRXD",ZTIO="",ZTSAVE("APSPRXD(""ED"")")=""
 S ZTDESC="PRESCRIPTION DELETION"
 D ^%ZTLOAD
 Q
 ;
PROCESS ;
 F APSPRXD("DATE")=0:0 S APSPRXD("DATE")=$O(^PSRX("AD",APSPRXD("DATE"))) Q:APSPRXD("DATE")'<APSPRXD("ED")  D RX
 Q
RX ;
 ;APSPRXD("IRXN") IS THE SUBSCRIPT PRESCRIPTION NUMBER
 F APSPRXD("IRXN")=0:0 S APSPRXD("IRXN")=$O(^PSRX("AD",APSPRXD("DATE"),APSPRXD("IRXN"))) Q:APSPRXD("IRXN")=""  D CHECK
 Q
 ;
CHECK ;
 ; IF THE ENTRY DOES NOT EXIST, KILL THE XREF.    ;IHS/ANMC/MWR 03/19/92
 I '$D(^PSRX(APSPRXD("IRXN"))) K ^PSRX("AD",APSPRXD("DATE"),APSPRXD("IRXN")) Q  ;IHS/ANMC/MWR 03/19/92
 ;
 ;
 S APSPRXD("CHECK QFLG")=0
 I $O(^PSRX(APSPRXD("IRXN"),1,0)) F %=0:0 S %=$O(^PSRX(APSPRXD("IRXN"),1,%)) Q:'%!(APSPRXD("CHECK QFLG"))  S:+^(%,0)'<APSPRXD("ED") APSPRXD("CHECK QFLG")=1
 D:'APSPRXD("CHECK QFLG") DELETE
 Q
 ;
DELETE ;
 K APSPRXDI S APSPRXD("PAT")=$P(^PSRX(APSPRXD("IRXN"),0),U,2)
 I APSPRXD("PAT") F APSPRXDI=0:0 S APSPRXDI=$O(^PS(55,APSPRXD("PAT"),"P",APSPRXDI)) Q:'APSPRXDI  I +^(APSPRXDI,0)=APSPRXD("IRXN") D
 . S ^PS(55,APSPRXD("PAT"),"P",0)=$P(^PS(55,APSPRXD("PAT"),"P",0),U,1,3)_U_($P(^(0),U,4)-1)
 . K ^PS(55,APSPRXD("PAT"),"P",APSPRXDI)
 . F %=0:0 S %=$O(^PS(55,APSPRXD("PAT"),"P","A",%)) Q:'%  I $D(^(%,APSPRXD("IRXN"))) K ^(APSPRXD("IRXN"))
 . K:$D(^PS(55,APSPRXD("PAT"),"P","CP",APSPRXD("IRXN"))) ^(APSPRXD("IRXN"))
 . Q
 ;
 I $D(^PS(52.5,"B",APSPRXD("IRXN"))) S DA=$O(^PS(52.5,"B",APSPRXD("IRXN"),0)),DIK="^PS(52.5," D ^DIK K DIK,DA
 S DIK="^PSRX(",DA=APSPRXD("IRXN") D ^DIK K DIK,DA
 S MWR=MWR+1
 Q
 ;
EOJ ;
 K APSPRXD,ZTSK
 S:$D(ZTQUEUED) ZTREQ="@"
 Q
