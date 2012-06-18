XMRENT ;(WASH ISC)/CMW - NETWORK MAIL API ENTRY POINTS ;10/18/93  19:32 [ 12/07/95  1:22 PM ]
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
 ;
 ;Extrinsic Function for API call to parse network header
 ;Parameter #1=Message #
 ;
 ;Output=STRING
 ;  Message-date ^ Encryption-code ^ Returned addr of sender ^ Message ID
 ;   ^ Sender ^ Message subject ^ Message ID of In-reply-to ^ Message Type
 ;
NET(XMZ) ;New all variables that are used in PARSE^XMR1
 I '$D(^XMB(3.9,XMZ,0)) Q ""
 N I,J,K,XMDATE,XMENCR,XMFROM,XMREMID,XMSEND,XMSUB,XMZ2,X,X1
 ;
 ;Put all outputs into string
 G @$S($O(^XMB(3.9,XMZ,2,0))<1:"NETMAIL",1:"LOCMAIL")
 ;
 ;Get data for Locally originated message
LOCMAIL N XMP S XMP=^XMB(3.9,XMZ,0)
 S Y=$P(XMP,U,3),%DT="S" D DD^%DT S XMDATE=Y
 S XMZ2=$S($P(XMP,U,8):^XMB("NETNAME")_"@"_$P(XMP,U,8),1:"")
 S XMSEND=$S($P(XMP,U,4)="":"",1:$P(^VA(200,$P(XMP,U,4),0),U))
 S XMENCR=$P(XMP,U,10),XMFROM=$S($P(XMP,U,2):$P(^VA(200,$P(XMP,U,2),0),U),1:$P(XMP,U,2)),XMSUB=$$SUBGET^XMGAPI0(XMZ),XMREMID=^XMB("NETNAME")_"@"_XMZ
 G SET
 ;Get data for Message that originated from another domain
NETMAIL D PARSE^XMR1
 S XMFROM=$TR(XMFROM,"<,>"," , ")
 S I=1,J=$L(XMFROM," ") F K=I:1:J I $P(XMFROM," ",K,K+1)["@" S XMFROM="<"_$P(XMFROM," ",K,K+1)_">",XMFROM=$TR(XMFROM," ")
 ;I XMREMID[".VA.GOV" S XMFROM=$TR($P(XMFROM,"@"),"._+",", .")_"@"_$P(XMFROM,"@",2)
 I XMREMID[".IHS.GOV" S XMFROM=$TR($P(XMFROM,"@"),"._+",", .")_"@"_$P(XMFROM,"@",2)   ;IHS/MFD added line
 ;
SET S %=XMDATE_U_XMENCR_U_XMFROM_U_XMREMID_U_XMSEND_U_XMSUB_U_$G(XMZ2)_U_$P($G(^XMB(3.9,XMZ,0)),U,7)
 Q %
