ABSPOSSC ;IHS/SD/lwj  - Set Cache device type in ABSP Dial out file [ 09/16/2002  9:37 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**2**;JUN 21, 2001
 ;
 ;IHS/SD/lwj 6/13/02
 ; This routine is a post-init routine called from the Kids 
 ; installation file for Patch 2 of Pharmacy POS.  It's only 
 ; purpose is to stuff the Cache device value into the newly
 ; created Cache device field (420.03) of the ABSP(9002313.55
 ; file.
 ;
 ; The value that will be stuffed represent the device and 
 ; port - |TCP|6802 .
 ;
 ;
CACHE ;EP  As of Patch 3, this routine is called from ABSPOSJ1 as part
 ; of the post init functionality
 ;
 N ABSPLIN,ABSPIEN,FDA,MSG
 ;
 S ABSPLIN="ENVOY DIRECT VIA T1 LINE"    ;line name
 S ABSPIEN=$O(^ABSP(9002313.55,"B",ABSPLIN,0)) ;ien for stuffing
 ;
 ; fda(root,ien,field number)=value
 ; field 420.03 is on the DEVICE node and represents the Cache device
 S FDA(9002313.55,ABSPIEN_",",420.03)="|TCP|6802"  ;absp dial out file
 D FILE^DIE(,"FDA","MSG")
 ;
 I $D(MSG) U 0 W !,"Error in setting Cache device...",! D ZWRITE^ABSPOS("MSG") Q
 ;
 ;
 Q
