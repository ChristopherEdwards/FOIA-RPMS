ADGFXDS ; cmi/flag/maw - Fix Day Surgery Visits ; [ 06/05/2002  1:14 PM ]
 ;;5.3;ADMISSION/DISCHARGE/TRANSFER;**1011**;MAR 25, 1999
 ;
 ;
 ;
MAIN ;-- this is the main routine driver
 D LOOP
 D EOJ
 Q
 ;
LOOP ;-- loop the day surgery file and call visit creator
 N ADGDA,ADGIEN,ADGOEN
 S ADGDA=3091019 F  S ADGDA=$O(^ADGDS("AA",ADGDA)) Q:'ADGDA  D
 . S ADGIEN=0 F  S ADGIEN=$O(^ADGDS("AA",ADGDA,ADGIEN)) Q:'ADGIEN  D
 .. S ADGOEN=0 F  S ADGOEN=$O(^ADGDS("AA",ADGDA,ADGIEN,ADGOEN)) Q:'ADGOEN  D
 ... S DGDFN1=ADGOEN
 ... S DFN=+$P($G(^ADGDS(ADGIEN,0)),U)
 ... D PCCVSIT^BDGDSA
 ... D DSIC
 Q
 ;
DSIC ;***> create incomplete chart entry
 ;IHS/ITSC/WAR 12/10/03 This section copied from BDGICEVT and modified
 ;
 S (BDGICREC,X)=""
 F  S X=$O(^BDGIC("B",DFN,X)) Q:X=""!(BDGICREC)  D
 .;Check IC Disch date/time v.s. DaySurg Release date/time
 .Q:'$D(^ADGDS(DFN,"DS",DGDFN1,2))
 .I $P(^BDGIC(X,0),U,5)=$P($P(^ADGDS(DFN,"DS",DGDFN1,2),U,1),".") S BDGICREC=X
 I +BDGICREC=0 D
 .S VST=BDGDSVST
 .S SERV=+$P(^ADGDS(DFN,"DS",DGDFN1,0),U,5)
 .S SRDATE=DGX
 .W !!,"Adding entry in Incomplete Chart file....",! K DIC
 .; make FM call to stuff data
 .S X=DFN,DIC="^BDGIC(",DLAYGO=9009016.1,DIC(0)="L"
 .; 4 slash visit to bypass file screen
 .S DIC("DR")=".03////"_VST_";.04///`"_SERV_";.05///"_(SRDATE\1)
 .L +^BDGIC(0):3 I '$T D  Q
 .. Q:$D(DGQUIET)
 .. W !,*7,"CANNOT ADD TO INCOMPLETE CHART FILE;"
 .. W "BEING UPDATED BY SOMEONE ELSE"
 .K DD,DO D FILE^DICN L -^BDGIC(0)
 K APCDALVR
 Q
 ;
EOJ ;-- end of job
 K DGDFN1,DFN,BDGIREC,VST,SERV,SRDATE
 Q
 ;
