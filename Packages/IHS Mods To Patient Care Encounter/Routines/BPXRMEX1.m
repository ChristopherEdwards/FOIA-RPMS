BPXRMEX1 ; IHS/MSC/MGH - Packing save routines. ;13-Aug-2015 12:06;du
 ;;2.0;CLINICAL REMINDERS;**1005**;Feb 04, 2005;Build 23
 ;==========================================
SROC(FILENUM,ROCIEN,PACKLIST) ;Reminder Order Checks.
 ;packed order check structure up
 D SGENR^PXRMEXPS(FILENUM,ROCIEN,.PACKLIST)
 N GBL,SUB,DRCL,FNUM,OI,OLIST,PHAR,RIEN,ROUTINE,TIEN,TLIST,WPNODE
 ;Process the pharmacy multiple.
 S PHAR=""
 F  S PHAR=$O(^PXD(801,ROCIEN,1.5,"B",PHAR)) Q:PHAR=""  D
 . S IEN=$P(PHAR,";"),GBL=$P(PHAR,";",2)
 . S FNUM=$$GETFNUM^PXRMEXPS(GBL)
 . S ROUTINE=$$GETSRTN^PXRMEXPS(FNUM)_"(FNUM,IEN,.PACKLIST)"
 . D @ROUTINE
 ;packed list of Orderable Item
 I $D(^PXD(801,ROCIEN,2)) D
 .S SUB=0 F  S SUB=$O(^PXD(801,ROCIEN,2,SUB)) Q:SUB'>0  D
 ..S OI=$P($G(^PXD(801,ROCIEN,2,SUB,0)),U) Q:OI'>0
 ..S ROUTINE=$$GETSRTN^PXRMEXPS(101.43)_"(101.43,OI,.PACKLIST)"
 ..D @ROUTINE
 ;loop through rules and packed definitions or terms
 S SUB=0 F  S SUB=$O(^PXD(801,ROCIEN,3,SUB)) Q:SUB'>0  D
 .S RIEN=$P($G(^PXD(801,ROCIEN,3,SUB,0)),U) Q:RIEN'>0
 .S ROUTINE=$$GETSRTN^PXRMEXPS(801.1)_"(801.1,RIEN,.PACKLIST)"
 .D @ROUTINE
 Q
SRULE(FILENUM,RULEIEN,PACKLIST) ;Reminder Order Check Rules.
 ;packed order check structure up
 D SGENR^PXRMEXPS(FILENUM,RULEIEN,.PACKLIST)
 N OLIST,RIEN,ROUTINE,TIEN,TLIST
 I $D(^PXD(801.1,RULEIEN,3,4))>0 D
 .;search for TIU Objects
 .D TIUSRCH^PXRMEXU1("^PXD(801.1,",RULEIEN,",4",.OLIST,.TLIST)
 .I $D(OLIST)>0 D
 ..S ROUTINE=$$GETSRTN^PXRMEXPS(8925.1)_"(8925.1,.OLIST,.PACKLIST)"
 ..D @ROUTINE K OLIST
 .K TLIST
 .;packed term up only
 S TIEN=$P($G(^PXD(801.1,RULEIEN,2)),U) I TIEN>0 D  Q
 .S ROUTINE=$$GETSRTN^PXRMEXPS(811.5)_"(811.5,TIEN,.PACKLIST)"
 .D @ROUTINE
 ;packed definition up if defined
 S RIEN=$P($G(^PXD(801.1,RULEIEN,3)),U) I RIEN>0 D
 .S ROUTINE=$$GETSRTN^PXRMEXPS(811.9)_"(811.9,RIEN,.PACKLIST)"
 .D @ROUTINE
 Q
 ;