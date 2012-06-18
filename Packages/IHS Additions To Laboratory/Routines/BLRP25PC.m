BLRP25PC ; IHS/OIT/MKK - IHS Lab Patch 1025 Post install Checksum checker ;DEC 09, 2008 8:30 AM
 ;;5.2;IHS LABORATORY;**1025**;NOV 01, 1997
 ;;
EP ; EP -- Start here
 NEW CP                            ; Current Patch
 NEW CSSTR                         ; Checksum String
 NEW ERR                           ; Error Count
 NEW HEAD                          ; HEADer array
 NEW RCNT                          ; Routine Count
 NEW PATCH                         ; Latest Patch Number
 NEW SSTR                          ; String to hold $S results
 NEW STR                           ; String variable
 NEW VERSION                       ; Version Number
 NEW %1,%2,%3,X,Y,XT1,XT2,XT3,XT4  ; Looping variables
 ;
 S CP=$TR($P($T(+2),";",5),"*")     ; Current Patch
 ;
 S HEAD(1)=$$CJ^XLFSTR($$LOC^XBFUNC,IOM)     ; Location
 S HEAD(2)=$$CJ^XLFSTR("IHS Lab Patch "_CP_" Checksum routine",IOM)
 ;
 S STR="Run Date: "_$$UP^XLFSTR($TR($$HTE^XLFDT($H,"2MPZ"),"@"," "))
 S HEAD(3)=$$CJ^XLFSTR(STR,IOM)
 ;
 S HEAD(4)=" "
 ;
 S $E(HEAD(5),6)="Routine"
 S $E(HEAD(5),16)="Checksum"
 S $E(HEAD(5),26)="Status"
 S $E(HEAD(5),36)="Ver"
 S $E(HEAD(5),46)="Patch"
 S HEAD(6)=$TR($J("",IOM)," ","-")
 ;
 D ^XBCLS                    ; Clear Screen & "Home" cursor
 D MES^XPDUTL(.HEAD)
 ;
CONT ; 
 S (ERR,RCNT)=0
 S XT4="I 1",X=$T(+9)
 F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""!($P(XT2,";",2)="")  D
 . S X=$TR($P(XT2,";",2)," ")
 . S XT3=$TR($P(XT2,";",4)," ")
 . X XT4 I '$T Q
 . S RCNT=RCNT+1
 . K CSSTR
 . S CSSTR=$J(RCNT,3)
 . S $E(CSSTR,6)=X
 . X ^%ZOSF("RSUM")
 . S $E(CSSTR,16)=XT3
 . S SSTR=$S('XT3:"Not in UCI",XT3'=Y:"**Error**",1:"OK")
 . S $E(CSSTR,26)=SSTR
 . I XT3'=0 D
 .. S STR=$G(^ROUTINE(X,0,2))
 .. S VERSION=$P(STR,";",3)
 .. S $E(CSSTR,36)=VERSION
 .. S PATCH=$RE($P($RE($P($P(STR,";",5),"*",3)),",",1))
 .. S $E(CSSTR,46)=PATCH
 .. I XT3'=Y D
 ... K CSSTR
 ... S $E(CSSTR,1,4)="****"
 ... S $E(CSSTR,6)=X
 ... S $E(CSSTR,26)=SSTR
 ... S $E(CSSTR,46)="Calc "_Y_", off by "_(Y-XT3)
 ... S $E(CSSTR,77,80)="****"
 . D MES^XPDUTL(CSSTR)
 . I $$UP^XLFSTR(SSTR)="OK" Q
 . ;
 . ; Checksum error detected
 . S ERR=ERR+1
 . S ERR(ERR)=$$LJ^XLFSTR(X,8)_$J("",8)_$J(XT3,8)_$J("",10)_$J(Y,8)_$J("",10)_$J((Y-XT3),8)
 ;
 K CSSTR
 S CSSTR(1)=" "
 S CSSTR(2)="Number of Routines = "_RCNT
 S CSSTR(3)=" "
 D BMES^XPDUTL(.CSSTR)
 ;
 I ERR<1 D
 . S CSSTR(2)="No Checksum Errors detected"
 . D MES^XPDUTL(.CSSTR)
 ;
 I ERR>0 D RPTERROR
 ;
 W !
 Q
 ;
 ; Checksum Errors detected: produce report and send E-mail to LMI Mail Group
RPTERROR ;
 NEW NUMAGREE
 S NUMAGREE=$S(ERR>1:"Errors",1:"Error")
 W !,ERR," Checksum ",NUMAGREE," detected",!!
 ;
 NEW LINECNT,HOWMANY,RTNN
 K STR
 S LINECNT=1
 D ADDLINE($TR($J("",65)," ","*"),.STR,.LINECNT)
 D ADDLINE(" ",.STR,.LINECNT)
 D ADDLINE($$CJ^XLFSTR("IHS Lab Patch 1023",65),.STR,.LINECNT)
 S HOWMANY=$S(ERR>1:"Errors",1:"Error")
 S RTNN=$S(ERR>1:"Routines",1:"Routine")
 D ADDLINE($$CJ^XLFSTR("Systems Environment "_HOWMANY_" Detected.",65),.STR,.LINECNT)
 D ADDLINE($$CJ^XLFSTR(RTNN_" with CHECKSUM "_HOWMANY,65),.STR,.LINECNT)
 D ADDLINE(" ",.STR,.LINECNT)
 D ADDLINE($J("",3)_$RE($J($RE(RTNN),8))_$J("",8)_"Checksum"_$J("",8)_"Calculated"_$J("",9)_$J("Off by",9),.STR,.LINECNT)
 D ADDLINE($J("",3)_"--------"_$J("",8)_"--------"_$J("",8)_"----------"_$J("",9)_$J("------",9),.STR,.LINECNT)
 S ERR=0
 F  S ERR=$O(ERR(ERR))  Q:ERR=""  D
 . D ADDLINE($J("",3)_$G(ERR(ERR)),.STR,.LINECNT)
 D ADDLINE(" ",.STR,.LINECNT)
 D ADDLINE($$CJ^XLFSTR("Please print/capture this screen and",65),.STR,.LINECNT)
 D ADDLINE($$CJ^XLFSTR("notify the Support Center at",65),.STR,.LINECNT)
 D ADDLINE(" ",.STR,.LINECNT)
 D ADDLINE($$CJ^XLFSTR("1-999-999-9999.",65),.STR,.LINECNT)
 D ADDLINE(" ",.STR,.LINECNT)
 D ADDLINE($G(STR(1)),.STR,.LINECNT)
 D BMES^XPDUTL(.STR)
 ;
 Q
 ;
 D SENDMAIL("CHECKSUM ERROR DETECTED",.STR)
 Q
  ;
 ; Routine to build STR array for display
ADDLINE(DISPSTR,ARRAY,COUNTER) ;
 S ARRAY(COUNTER)=DISPSTR
 S COUNTER=COUNTER+1
 Q
 ;
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
 ;
SENDMAIL(SUBJECT,MAILMSG) ;
 D KILL^XM                    ; Kill any MAILMAN variables
 N XMSUB,XMTO,XMINSTR,XMZ
 I '$G(DUZ) N DUZ D DUZ^XUP(.5)
 S XMSUB=SUBJECT
 S XMTO="G.LMI"
 S XMINSTR("FROM")=.5         ; POSTMASTER DUZ
 S XMINSTR("ADDR FLAGS")="R"  ; Ignore any restrictions (domain closed or protected by security key)
 S XMZ=""                     ; Initialize variable
 D SENDMSG^XMXAPI(DUZ,XMSUB,"MAILMSG",XMTO,.XMINSTR,.XMZ)
 I $G(XMZ)="" D
 . W !!,"SENDMSG^XMXAPI failed",!!
 ;
 K X,XMDUZ,XMSUB,XMTEXT,Y     ; Cleanup
 Q
 ;
ROU ;;
        ;BLREXEC2;;5628952
        ;BLRMENU;;447878
        ;BLRMMRPT;;3417134
        ;BLRP41UI;;11319880
        ;BLRP41UP;;7639709
        ;BLRPCCBD;;1306119
        ;BLRPOC;;21027406
        ;BLRPRE25;;25330757
        ;BLRUTIL3;;3276664
        ;BLRVPTCH;;1896846
        ;LRVRPOCU;;8922327
        ;BLRALBA;;9158370
        ;BLRLINK2;;6773921
        ;BLRLINK3;;13802313
        ;BLRLINKP;;15982489
        ;BLRPCCVC;;2813203
        ;BLRPST;;7736873
        ;BLRTNB;;16690204
        ;BLRTNM;;29685300
        ;LREXPD;;5043997
        ;LRMIPC;;4289609
        ;LRMISEZB;;9753528
        ;LRMISR1;;3325470
        ;LRMITSPE;;6984513
        ;LRORD;;21951290
        ;LRORDK;;14521313
        ;LRRP1;;14957981
        ;LRRP2;;19052582
        ;LRSORC1A;;7595298
        ;LRTT5P1;;14263908
        ;LRUPAD;;7881930
        ;LRWLST;;18706544
        ;LRWRKLS1;;5404205
        ;LRX;;18631413
 ;;;
