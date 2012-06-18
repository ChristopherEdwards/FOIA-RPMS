AUMUP102 ;IHS/OIT/ABK - AUM 11 patch 1 AUTTEDT LOAD [ 10/09/2010  4:11 PM ]
 ;;11.0;TABLE MAINTENANCE;**5**;Oct 15,2010
 ;
QUIT ; This routine should not be called at the top.  It is only to be called
 ; at START and POST by KIDS as the pre and post inits for AUM*10.2.
 ;
START ;IHS/OIT/ABK
 D UPD
 Q
UPD ;read ^AUMPCLN and update ^AUTTEDT
 ; Development Notes - 2/17/2010 - abk
 ;    1.  Had a lot of trouble setting the sub fields until I called ^XBFMK after every
 ;    fileman call.  Once I did that and reset all the fileman variables before fileman
 ;    call, it worked flawlessly.
 ;    2.  We are updating existing Patient Education topics.  We are setting all
 ;    existing topics to inactive before we load the next set updating where we find a
 ;    match.
 ;    3.  When updating and deleting the Outcome and Standard sub fields, I had
 ;    to kill off those entries explicitly because the data contains punctuation
 ;    at these levels and I get a subscript error from ^DIK trying to parse the data for 
 ;    punctuation because it thinks this is a file specification and not data...
 ;    
 N AUMX,AUMICD,XICD,XNAM,AUMXS,AUMCNAM,AUMMNE,AUMMJT,AUMOUTC,AUMPCLN,AUMSTD,AUMDINUM,AUMDA,AUMDA1,XABK,DINUM,TOTCNT,TOTUPD,TOTNEW,AUMSKIP,SKIPIT
 K DO,DIC,DIE
 D ^XBFMK
 S ADT=$$DT^XLFDT
 ;
 S ^XTMP("AUM11P1",0)="3120101^3101101^AUM*11.0*2"
 S:$G(APART)=1 ^XTMP("AUM11P1",ADT)="PARTIAL"
 S:$G(APART)'=1 ^XTMP("AUM11P1",ADT)="FULL"
 S AUMPCLN="",TOTUPD=0,TOTNEW=0,TOTCNT=0,AUMSKIP=0,AUMERR=0,TOTINACT=0
 F  S AUMPCLN=$O(^AUMPCLN(AUMPCLN)) Q:AUMPCLN=""  S AUMXS=^(AUMPCLN) D
  .S TOTCNT=TOTCNT+1
  .S AUMACT=$P(AUMXS,U,1)
  .I AUMACT="I" D INACT^AUMP1012 Q
  .S AUMCNAM=$P(AUMXS,U,2),AUMMNE=$P(AUMXS,U,3),AUMMJT=$P($P(AUMXS,U,4),"-",1),AUMOUTC=$P(AUMXS,U,5),AUMSTD=$P(AUMXS,U,6)
  .;
  .; Do error checking
  .I AUMCNAM="" D BMES^XPDUTL("Name field is null "_AUMCNAM_" not inserted - error"),BMES^XPDUTL("Record: "_AUMXS) S AUMERR=AUMERR+1 Q
  .I AUMMNE="" D BMES^XPDUTL("Mnemonic field is null "_AUMMNE_" not inserted - error"),BMES^XPDUTL("Record: "_AUMXS) S AUMERR=AUMERR+1 Q
  .;
  .; Ok - past that
  .S AUMFND=0
  .S AUMDA1=0,AUMDA1=$O(^AUTTEDT("B",AUMCNAM,AUMDA1)) I AUMDA1'="" S AUMFND=1
  .I 'AUMFND S AUMDA1=-1,AUMDA1=$O(^AUTTEDT("C",AUMMNE,AUMDA1)) I AUMDA1'="" S AUMFND=1
  .I 'AUMFND D
  ..S X=AUMCNAM,DIC="^AUTTEDT("
  ..S DIC("DR")="1////"_AUMMNE_";.06////"_AUMMJT
  ..D ^DIC
  ..I $P(Y,U,1)'=-1 D
  ...S (AUMDA,AUMDA1,DA)=$P(Y,U,1),AUMFND=1
  ...Q
  ..Q
  .I 'AUMFND D
  ..S X=AUMCNAM,DIC="^AUTTEDT("
  ..S DIC("DR")="1////"_AUMMNE_";.06////"_AUMMJT,DIC(0)="L"
  ..D ^DIC
  ..I $P(Y,U,3)=1 D
  ...S TOTNEW=TOTNEW+1
  ...S ^XTMP("AUM11P1",ADT,"NEW",TOTNEW)=AUMCNAM_"^"_AUMMNE
  ...S (AUMDA,AUMDA1,DA)=$P(Y,U,1)
  ...D BMES^XPDUTL("New - Name = "_AUMCNAM_"    Mnemonic = "_AUMMNE)
  ...Q
  ..E  D
  ...I $P(Y,U,1)=-1 D
  ....S AUMERR=AUMERR+1
  ....K AUMDA
  ....S ^XTMP("AUM11P1",ADT,"ERROR","INSERT FAILED",AUMERR)=AUMCNAM_"^"_AUMMNE
  ....D BMES^XPDUTL("Record:  "_AUMPCLN_" not inserted - error"),BMES^XPDUTL("AUMCNAM= "_AUMCNAM),BMES^XPDUTL("AUMMNE=  "_AUMMNE),BMES^XPDUTL("Record:  "_AUMXS),BMES^XPDUTL("Y:  "_Y)
  ....Q
  ...E  D
  ....S (AUMDA,AUMDA1,DA)=$P(Y,U,1),AUMFND=1
  ....Q
  ..Q
  .D ^XBFMK
  .;Done with new; so,we are updating
  .I AUMFND D
  ..S SKIPIT=0
  ..S AUMX=$G(^AUTTEDT(AUMDA1,0)),AUMICD=$P(AUMX,U,4),XICD=$P(AUMX,U,6),XNAM=$P(AUMX,U,1)
  ..;if this is a local topic, quit
  ..I AUMICD?1N.N S SKIPIT=1
  ..I XICD?1A.N1P.N S SKIPIT=1
  ..I XICD?.N1P.N S SKIPIT=1
  ..I XICD?1P.N S SKIPIT=1
  ..; OK CHECK TO SEE IF WE'RE SKIIPING, QUIT IF SO
  ..I SKIPIT=1 D
  ...D BMES^XPDUTL("Local Topic "_XNAM_" not changed - Skipped"),BMES^XPDUTL("Record: "_AUMX)
  ...S AUMSKIP=AUMSKIP+1
  ...S ^XTMP("AUM11P1",ADT,"SKIPPED",AUMDA1)=AUMCNAM_"^"_AUMMNE
  ...Q
  ..Q:SKIPIT=1
  ..; OK, we're ok to update
  ..S TOTUPD=TOTUPD+1
  ..S DIE="^AUTTEDT(",DA=AUMDA1 ;,DIC(0)="L"
  ..S DR=".01////"_AUMCNAM_";1////"_AUMMNE_";.06////"_AUMMJT_";.03////@"
  ..S ^XTMP("AUM11P1",ADT,"UPDATE",AUMDA1)=AUMCNAM_"^"_AUMMNE
  ..D ^DIE D BMES^XPDUTL("Updated - Name = "_AUMCNAM_"    Mnemonic = "_AUMMNE) D ^XBFMK
  ..; abk - hit subscript error due to data on next 2 lines trying to
  ..;       delete outcome and standard data
  ..;S DA(1)=AUMDA1,DIK="^AUTTEDT("_DA(1)_",",DA=2 D ^DIK D ^XBFMK
  ..;S DA(1)=AUMDA1,DIK="^AUTTEDT("_DA(1)_",",DA=1 D ^DIK D ^XBFMK
  ..; so, I am killing them outright - they are not cross-referenced
  ..K ^AUTTEDT(AUMDA1,1),^AUTTEDT(AUMDA1,2)
  ..S AUMDA=AUMDA1
  ..Q
  .I $D(AUMDA),AUMOUTC'="" D
  ..S DIC("P")=$P(^DD(9999999.09,1101,0),U,2),DA=AUMDA,DIC="^AUTTEDT("_AUMDA_",1,",DINUM=0,X="",DIC(0)="L" D FILE^DICN S DIC("P")="" D ^XBFMK
  ..I AUMOUTC["|" F AUMDINUM=1:1 S XABK=$P(AUMOUTC,"|",AUMDINUM) S:XABK="" AUMDINUM=AUMDINUM+1,XABK=$P(AUMOUTC,"|",AUMDINUM) S DIC="^AUTTEDT("_AUMDA_",1,",DIC(0)="L" Q:XABK=""  S DA=AUMDA,DINUM=AUMDINUM,X=XABK D FILE^DICN D ^XBFMK
  ..I AUMOUTC'["|" S XABK=AUMOUTC,DIC="^AUTTEDT("_AUMDA_",1," I XABK'="" S DA=AUMDA,DINUM=1,X=XABK,DIC(0)="L" D FILE^DICN D ^XBFMK
  ..Q
  ..;
  .I $D(AUMDA),AUMSTD'="" D
  ..S DIC("P")=$P(^DD(9999999.09,1102,0),U,2),DA=AUMDA,DIC="^AUTTEDT("_AUMDA_",2,",X="",DINUM=0,DIC(0)="L" D FILE^DICN S DIC("P")="" D ^XBFMK
  ..I AUMSTD["|" F AUMDINUM=1:1 S XABK=$P(AUMSTD,"|",AUMDINUM) S:XABK="" AUMDINUM=AUMDINUM+1,XABK=$P(AUMSTD,"|",AUMDINUM) S DIC="^AUTTEDT("_AUMDA_",2,",DIC(0)="L" Q:XABK=""  S DA=AUMDA,DINUM=AUMDINUM,X=XABK D FILE^DICN D ^XBFMK
  ..I AUMSTD'["|" S XABK=AUMSTD,DIC="^AUTTEDT("_AUMDA_",2," I XABK'=""  S DA=AUMDA,DINUM=1,X=XABK,DIC(0)="L" D FILE^DICN D ^XBFMK
  ..Q
  .Q
  ;now check ^AUTTEDT for inactive records
  D:$G(APART)'=1 INACT
  ;and, check EHR for potential picklist changes, quit if not there
  D:$D(^BGOEDTPR) PKLST
  D FBADNAM
  D FBADMN
  ;
  S AUMX=^XTMP("AUM11P1",ADT)_"^Total Records:^"_TOTCNT_"^Errors:^"_AUMERR_"^New:^"_TOTNEW_"^Updated:^"_TOTUPD_"^Inactive:^"_TOTINACT_"^Not Updated:^"_TMNMISS_"^Skipped:^"_AUMSKIP
  S ^XTMP("AUM11P1",ADT)=AUMX
  D BMES^XPDUTL("Total records   processed:   "_TOTCNT)
  D BMES^XPDUTL("Total records     updated:   "_TOTUPD)
  D BMES^XPDUTL("Total records inactivated:   "_TOTINACT)
  D BMES^XPDUTL("Total records    inserted:   "_TOTNEW)
  D BMES^XPDUTL("Total records    in error:   "_AUMERR)
  D BMES^XPDUTL("Local records     skipped:   "_AUMSKIP)
 Q
KILL ;kill "B" and "C" cross-references
 K ^AUTTEDT("B")
 K ^AUTTEDT("C")
 Q
 ;
POST ;call to ENALL^DIK for .01 and 1
 W !,"Rebuilding Indexes",!
 S DIK="^AUTTEDT("
 S DIK(1)=".01^B"
 D ENALL^DIK
 S DIK(1)="1^C"
 D ENALL^DIK
 Q
INACT ;Check for new inactive records 
 N A,AUMX,AUMDT
 S A=0,TOTINACT=0,AUMDT=$$DT^XLFDT
 F  S A=$O(^AUTTEDT(A)) Q:A'?1N.N  S AUMX=$G(^AUTTEDT(A,0)) D
 .Q:$P(AUMX,U,5)'=AUMDT
 .Q:'$D(TMP("AUM11P1",ADT,"UPDATE",A))
 .S ^XTMP("AUM11P1",ADT,"INACTIVE",A)=$P(^AUTTEDT(A,0),U,1,2)
 .S TOTINACT=TOTINACT+1
 .Q
 Q
PKLST ;Check to see what EHR pick lists might be affected
 S PKNAM="",PK1=0
 F  S PK1=$O(^BGOEDTPR(PK1)) Q:PK1'?1N.N  D
 .S PK2="" F  S PK2=$O(^BGOEDTPR(PK1,PK2)) Q:PK2'?1N.N  D
 ..S:PK2=0 PKNAM=$P(^BGOEDTPR(PK1,PK2),U,1)
 ..S PK3=0 F  S PK3=$O(^BGOEDTPR(PK1,PK2,PK3)) Q:PK3'?1N.N  D
 ...S PXEDT=$P($G(^BGOEDTPR(PK1,PK2,PK3,0)),U,1)
 ...S:PXEDT'="" ^XTMP("AUM11P1",ADT,"PKLST",PKNAM,PXEDT)=""
 ...Q
 ..Q
 .Q
 Q
RPT ;Actually print the report
 ;
 N A,ADT,L,X,DATAX
 S AUMHDR=""
 D EN^AUMDODEV
 S A=0 F J=1:1  S A=$O(^XTMP("AUM11P1",A)) Q:A=""  S DATAX(J)=A
 S JNDX=J-1
OPT ;Select which install to report on
 I JNDX>1 D
 .S DIR(0)="SO^"
 .S DIR("L",1)="Which Date Do You Want To Report On:"
 .S DIR("L",2)=""
 .S A="" F K=1:1 S A=$O(DATAX(A)) Q:A=""  S DIR("L",K+2)=K_"     "_DATAX(A),DIR(0)=DIR(0)_K_":"_DATAX(A)_";"
 .S L=$L(DIR(0)),L=L-1
 .S DIR(0)=$E(DIR(0),1,L)
 .D ^DIR Q:X="^"
 .S ADT=DATAX(X)
 .Q
 E  S ADT=DATAX(1)
 Q:'$D(ADT)
 U IO
 S AUMBM=IOSL-10
 I '$D(IO("S")),'$D(ZTQUEUED),IO=IO(0) S AUMBM=IOSL-4
 S AUMPG=1,DIWL=5,DIWR=75,DIWF="W"
 W !!,"****          Patient Education Topic Report for "_ADT_"          ****",!!!
 W !,"Records that were not loaded due to errors:",!
 I $D(^XTMP("AUM11P1",ADT,"ERROR")) D RERR
 E  W ?15,"No Errors to Report",!
 W !!
 W !,"Records that were set as Inactive:",!
 I $D(^XTMP("AUM11P1",ADT,"INACTIVE")) D RINA
 E  W ?15,"No Records were made Inactive",!
 W !!
 W !,"Records that are New:",!
 I $D(^XTMP("AUM11P1",ADT,"NEW")) D RNEW
 E  W ?15,"No New Records were Added",!
 W !!
 W !,"Local (ICD9) Records that were Skipped:",!
 I $D(^XTMP("AUM11P1",ADT,"SKIPPED")) D RSKP
 E  W ?15,"No Local Records were Skipped",!
 W !!
 W !,"Records that were Updated:",!
 I $D(^XTMP("AUM11P1",ADT,"UPDATE")) D RUPD
 E  W ?15,"No Records were Updated",!
 W !!
 I $D(^XTMP("AUM11P1",ADT,"PKLST")) D RPKL
 E  W ?15,"EHR Not installed or no Pick Lists were Added",!
 W !!
 ;I $D(^XTMP("AUM11P1",ADT,"MISSING NM")) D RNAM W !!
 I $D(^XTMP("AUM11P1",ADT,"MISSING MNE")) D RMNE W !!
 ;
 S AUMX=^XTMP("AUM11P1",ADT) F J=2:2:15 W ?15,$P(AUMX,U,J),?30,$P(AUMX,U,J+1),!
 W !,"****   End of Patient Education Topic Report for "_ADT_"    ****",!
 D END
 Q
RUPD ;Report on records that were Updated
 S AUMHDR="  EIN       Name                                                 Mnemonic"
 W !,?2,"EIN",?12,"Name",?65,"Mnemonic",!
 S A="" F  S A=$O(^XTMP("AUM11P1",ADT,"UPDATE",A)) Q:A'?1N.N  D
 .W ?2,A,?12,$E($P(^XTMP("AUM11P1",ADT,"UPDATE",A),U,1),1,50),?65,$E($P(^XTMP("AUM11P1",ADT,"UPDATE",A),U,2),1,14)
 .D ^DIWW,PG:$Y>AUMBM
 .Q
 Q
RNEW ;Report on New Records
 S AUMHDR="     Name                                                        Mnemonic"
 W !,?5,"Name",?65,"Mnemonic",!
 S A="" F  S A=$O(^XTMP("AUM11P1",ADT,"NEW",A)) Q:A=""  D
 .W ?5,$E($P(^XTMP("AUM11P1",ADT,"NEW",A),U,1),1,55),?65,$E($P(^XTMP("AUM11P1",ADT,"NEW",A),U,2),1,14)
 .D ^DIWW,PG:$Y>AUMBM
 .Q
 Q
RSKP ;Report on Skipped Records
 S AUMHDR="     Name                                                        Mnemonic"
 W !,?5,"Name",?65,"Mnemonic",!
 S A="" F  S A=$O(^XTMP("AUM11P1",ADT,"SKIPPED",A)) Q:A=""  D
 .W ?5,$E($P(^XTMP("AUM11P1",ADT,"SKIPPED",A),U,1),1,55),?65,$E($P(^XTMP("AUM11P1",ADT,"SKIPPED",A),U,2),1,14)
 .D ^DIWW,PG:$Y>AUMBM
 .Q
 Q
RINA ;Report Inactive records
 S AUMHDR="     Name                                                        Mnemonic"
 W !,?5,"Name",?65,"Mnemonic",!
 S A="" F  S A=$O(^XTMP("AUM11P1",ADT,"INACTIVE",A)) Q:A=""  D
 .W ?5,$E($P(^XTMP("AUM11P1",ADT,"INACTIVE",A),U,1),1,55),?65,$E($P(^XTMP("AUM11P1",ADT,"INACTIVE",A),U,2),1,14)
 .D ^DIWW,PG:$Y>AUMBM
 .Q
 Q
RERR ;Report Errors
 S AUMHDR="     Name                                                        Mnemonic"
 W !,?5,"Name",?65,"Mnemonic"
 S A="" F  S A=$O(^XTMP("AUM11P1",ADT,"ERROR",A)) Q:A=""  D
 .W !,?10,"Error:  ",A,!
 .S B=0 F  S B=$O(^XTMP("AUM11P1",ADT,"ERROR",A,B)) Q:B'?1N.N  D
 ..W ?5,$E($P(^XTMP("AUM11P1",ADT,"ERROR",A,B),U,1),1,55),?65,$E($P(^XTMP("AUM11P1",ADT,"ERROR",A,B),U,2),1,14)
 ..D ^DIWW,PG:$Y>AUMBM
 ..Q
 .Q
 Q
RPKL ;Report of pick lists if we have any
 ;Pick Lists
 S AUMHDR="     Pick List Name                                              Topic EIN"
 W !,"EHR Pick Lists that may have been affected and need Review:",!
 W !,?5,"Pick List Name",?65,"Topic EIN",!
 S A="" F  S A=$O(^XTMP("AUM11P1",ADT,"PKLST",A)) Q:A=""  D
 .W ?5,$E(A,1,50)
 .S B=0 F  S B=$O(^XTMP("AUM11P1",ADT,"PKLST",A,B)) Q:B'?1N.N  D
 ..W ?65,$E(B,1,14),!
 ..D ^DIWW,PG:$Y>AUMBM
 ..Q
 .W !
 .Q
 Q
RNAM ;Report on Source items that are missing by name
 ;Records that are not in AUTTEDT, but should be
 W !,"Records that were not updated, by Name",!
 S AUMHDR="     Name"
 W !,?5,"Name",!
 S A="" F  S A=$O(^XTMP("AUM11P1",ADT,"MISSING NM",A)) Q:A=""  D
 .W ?5,$E($P(A,U,1),1,55)
 .D ^DIWW,PG:$Y>AUMBM
 .Q
 Q
RMNE ;Report on Source items that are missing by Mnemonic
 ;Records that were not updated in AUTTEDT, but should be
 W !,"Records that were not updated, by Mnemonic",!
 S AUMHDR="     Mnemonic"
 W !,?5,"Mnemonic",!
 S A="" F  S A=$O(^XTMP("AUM11P1",ADT,"MISSING MNE",A)) Q:A=""  D
 .W ?5,$E($P(A,U,1),1,55)
 .D ^DIWW,PG:$Y>AUMBM
 .Q
 Q
END ;EP
 W !!!
 I IO(0)=IO D
 .I IOST["C-",'$D(IO("S")) S Y=$$DIR^XBDIR("E","Press RETURN To Continue or Escape to Cancel...","","","",1) X ^%ZOSF("TRMRD")
 .D ^DIWW
 .Q
END1 ;
 D ^%ZISC
 Q
PG ; --- Paginate, write header
 I IOST["C-",'$D(IO("S")) S Y=$$DIR^XBDIR("E","Press RETURN To Continue or Escape to Cancel...","","","",1) X ^%ZOSF("TRMRD")
 S AUMPG=AUMPG+1
 W @IOF,!!!?DIWL-1,?($S($G(IOM):IOM,1:75)-$L("Page "_AUMPG)),"Page ",AUMPG,!!,AUMHDR,!
 Q
 ;
FBADNAM ;Find all missing names
 N A,B,X,MN
 S TNMISS=0
 S A="" F  S A=$O(^AUMPCLN(A)) Q:A=""  S X=^(A),MN=$P(X,U,2),B="",B=$O(^AUTTEDT("B",MN,B)) S:B="" ^XTMP("AUM11P1",ADT,"MISSING NM",MN)="",TNMISS=TNMISS+1
 Q
FBADMN ;Find all missing Mnemonics
 N A,B,X,MN
 S TMNMISS=0
 S A="" F  S A=$O(^AUMPCLN(A)) Q:A=""  S X=^(A),MN=$P(X,U,3),B="",B=$O(^AUTTEDT("C",MN,B)) S:B="" ^XTMP("AUM11P1",ADT,"MISSING MNE",MN)="",TMNMISS=TMNMISS+1
 Q
RTRIM(X) ;Strip off trailing spaces
 F %=$L(X):-1:1 S:$A(X,%)=32 X=$E(X,0,%-1)
 Q
 ;end of routine AUMUPD102
