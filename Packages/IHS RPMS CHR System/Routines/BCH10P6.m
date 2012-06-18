BCH10P6 ;IHS/CMI/LAB - IHS CHR patch 6 [ 09/18/98  1:29 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**6**;OCT 28, 1996
 ;
 ;go through all chr records, if any service is HE or CF
 ;find V POV and change code accordingly
START ;start processing patch 6
 S ZTQUEUED="" ;to prevent other routine from talking
 S (BCHRIEN,BCHCNT)=0 F  S BCHRIEN=$O(^BCHR(BCHRIEN)) Q:BCHRIEN'=+BCHRIEN  D
 .Q:'$P(^BCHR(BCHRIEN,0),U,15)  ;no pcc visit created
 .S (BCHP,BCHGOT)=0 F  S BCHP=$O(^BCHRPROB("AD",BCHRIEN,BCHP)) Q:BCHP'=+BCHP  D
 ..Q:'$D(^BCHRPROB(BCHP))
 ..Q:$P(^BCHRPROB(BCHP,0),U,4)=""
 ..S X=$P(^BCHRPROB(BCHP,0),U,4),X=$P(^BCHTSERV(X,0),U,3)
 ..Q:'(X="HE"!(X="CF"))
 ..S BCHGOT=1
 ..Q
 .Q:'BCHGOT
 .W " ",BCHRIEN
 .S BCHCNT=BCHCNT+1
 .S BCHR=BCHRIEN
 .S BCHEV("TYPE")="E"
 .S BCHEV("VFILES",9000010)=$P(^BCHR(BCHR,0),U,15)
 .S X=0 F  S X=$O(^BCHR(BCHR,31,X)) Q:X'=+X  S F=$P(^BCHR(BCHR,31,X,0),U),N=$P(^(0),U,2) I F,N S BCHEV("VFILES",F,N)=""
 .K ^BCHR(BCHR,31)
 .D PROTOCOL^BCHUADD1
 .Q
 W !!,"All done updating. ",BCHCNT," CHR Records updated.",!
 D EN^XBVK("BCH")
 K ZTQUEUED
 Q
