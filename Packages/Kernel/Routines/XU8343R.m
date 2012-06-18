XU8343R ;BPOIFO/DW - Post-install for XU*8*343 continued ; 14 April 2004
 ;;8.0;KERNEL;**343**; Jul 10, 1995;
 Q
 ;
NOTICE(XUT) ;Send a notification when the conversion process is stopped\done
 ;IN:
 ; XUT(1)=Number of records processed
 ; XUT(2)=Last processed IEN
 ; XUT(3)=Total NPF entries
 ; XUT(4)=1 if the conversion process was cancelled, 0 if it was done.
 ;
 ;If called within a task, protect variables
 N %,DIFROM
 ;I $D(ZTQUEUED) N %,DIFROM
 ;
 N RDT,Y
 D NOW^%DTC S Y=% X ^DD("DD")
 S RDT=$P(Y,"@",1)_"@"_$P($P(Y,"@",2),":",1,2)
 ;
 N XMY,XMTEXT,XMDUZ,XUSUB,XUWHAT,XUSITE,XUPLACE,XUNUM,XUSTOP,XMSUB
 ;
 S XUSITE=$$SITE^VASITE
 S XUPLACE=$P(XUSITE,"^",2)
 S XUNUM=$P(XUSITE,"^",3)
 ;
 S XMDUZ=.5
 S XMY(DUZ)=""
 S XMY("G.XUPS IDENTITY MANAGEMENT@DOMAIN.NAME")=""
 S XMSUB="XUPS NPF NAME STANDARDIZATION - "_XUPLACE_"("_XUNUM_")"
 ;
 S XUSTOP=$S(XUT(4):"cancelled.",1:"DONE!")
 S XUWHAT(1)=" New Person file name conversion (XU*8*343) is "_XUSTOP
 S XUWHAT(2)=""
 S XUWHAT(3)="                 Facility Name: "_XUPLACE
 S XUWHAT(4)="                Station Number: "_XUNUM
 S XUWHAT(5)=""
 S XUWHAT(6)=" Total records to be processed: "_XUT(3)
 S XUWHAT(7)="   Number of records processed: "_XUT(1)
 S XUWHAT(8)="            Last IEN processed: "_XUT(2)
 S XUWHAT(9)=""
 S XUWHAT(10)="                    Date/Time: "_RDT
 ;
 S XMTEXT="XUWHAT("
 ;
 D ^XMD
 ;
 Q
 ;
HEADER(XULINE,XUSUB) ;Report Header
 N C1,C0
 S XULINE=XULINE+1
 S ^TMP(XUNMSP,$J,XULINE)=""
 ;
 I '$D(^XTMP(XUNMSP,XUSUB)) D  Q
 . S XULINE=XULINE+1
 . S ^TMP(XUNMSP,$J,XULINE)="None."
 ;
 I XUSUB="CHANGED" D
 . S C0=$$LJ^XLFSTR("IEN",15," ")
 . S C1=$$LJ^XLFSTR("NAME",35," ")
 . S XULINE=XULINE+1
 . S ^TMP(XUNMSP,$J,XULINE)=C0_" "_C1
 . S C1=$$LJ^XLFSTR("=============== ==============================",51," ")
 . S XULINE=XULINE+1
 . S ^TMP(XUNMSP,$J,XULINE)=C1
 ;
 I XUSUB="UNCHANGED" D
 . S C0=$$LJ^XLFSTR("IEN",15," ")
 . S C1=$$LJ^XLFSTR("NAME",35," ")
 . S XULINE=XULINE+1
 . S ^TMP(XUNMSP,$J,XULINE)=C0_" "_C1
 . S C1=$$LJ^XLFSTR("=============== ==============================",51," ")
 . S XULINE=XULINE+1
 . S ^TMP(XUNMSP,$J,XULINE)=C1
 Q
 ;
REPORT ;Report
 S:'$G(XUNMSP) XUNMSP="XUNAME"
 N XULINE,XUSUB,XUIEN,XUOLD,XUNEW,C1,C2,C0,C,XUC,XU20P
 S XULINE=0
 S C=$$LJ^XLFSTR(" ",15," ")
 F XUSUB="CHANGED","UNCHANGED" D
 . K ^TMP(XUNMSP,$J)
 . I XUSUB="CHANGED" S XUT="are converted"
 . I XUSUB="UNCHANGED" S XUT="could not be converted"
 . S XULINE=XULINE+1
 . S ^TMP(XUNMSP,$J,XULINE)="The following names "_XUT_":"
 . D HEADER(.XULINE,XUSUB)
 . S XUIEN=0 F  S XUIEN=$O(^XTMP(XUNMSP,XUSUB,XUIEN)) Q:XUIEN=""  D
 .. S XUOLD=$G(^XTMP(XUNMSP,XUSUB,XUIEN,"OLD"))
 .. S XUNEW=$G(^XTMP(XUNMSP,XUSUB,XUIEN,"NEW"))
 .. S XULINE=XULINE+1
 .. S C0=$$LJ^XLFSTR(XUIEN,15," ")
 .. S C1=$$LJ^XLFSTR(XUOLD,35," ")
 .. S C2=$$LJ^XLFSTR(XUNEW,35," ")
 .. I XUSUB="CHANGED" D
 ... S ^TMP(XUNMSP,$J,XULINE)=C0_" Old: "_C1
 ... S XULINE=XULINE+1
 ... S ^TMP(XUNMSP,$J,XULINE)=C_" New: "_C2
 ... K XUC D NMCOM(XUIEN,.XUC)
 ... S XULINE=XULINE+1
 ... S ^TMP(XUNMSP,$J,XULINE)=C_"      Given: "_$G(XUC("GIVEN"))
 ... S XULINE=XULINE+1
 ... S ^TMP(XUNMSP,$J,XULINE)=C_"     Middle: "_$G(XUC("MIDDLE"))
 ... S XULINE=XULINE+1
 ... S ^TMP(XUNMSP,$J,XULINE)=C_"     Family: "_$G(XUC("FAMILY"))
 ... S XULINE=XULINE+1
 ... S ^TMP(XUNMSP,$J,XULINE)=C_"     Suffix: "_$G(XUC("SUFFIX"))
 ... S XULINE=XULINE+1
 ... S ^TMP(XUNMSP,$J,XULINE)=""
 .. I XUSUB="UNCHANGED" S ^TMP(XUNMSP,$J,XULINE)=C0_" "_C1
 . D EMAIL(XUNMSP)
 . K ^TMP(XUNMSP,$J)
 Q
 ;
NMCOM(XUIEN,XUC) ;Get name components from file #20.
 N DIC,DR,DA,DIQ,XUR,XUCOM,XUI,XUCOMP,XUNC,C,XU20P,X,Y
 ;
 S XU20P=$P($G(^VA(200,XUIEN,3.1)),U)
 ;
 S DIC=20
 S DR="1;2;3;4;5;6"
 S DA=XU20P
 S DIQ="XUR"
 D EN^DIQ1
 ;
 S XUCOM="FAMILY^GIVEN^MIDDLE^PREFIX^SUFFIX^DEGREE"
 F XUI=1:1:6 D
 . S XUCOMP=$P(XUCOM,U,XUI)
 . S XUC(XUCOMP)=$G(XUR(20,XU20P,XUI))
 Q
 ;
EMAIL(XUNMSP) ;SEND THE REPORT
 N %,DIFROM
 ;I $D(ZTQUEUED) N %,DIFROM
 ;
 N RDT,Y
 D NOW^%DTC S Y=% X ^DD("DD")
 S RDT=$P(Y,"@",1)_"@"_$P($P(Y,"@",2),":",1,2)
 ;
 N XMY,XMTEXT,XMDUZ,XMSUB
 ;
 S XMY(DUZ)="",XMDUZ=.5
 S XMSUB="NEW PERSON File Name Conversion Report"
 S XMTEXT="^TMP("""_XUNMSP_""",$J,"
 D ^XMD
 Q
