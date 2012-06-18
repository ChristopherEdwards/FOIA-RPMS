DG53293B ;AR/BP - ALS EXTRACT; ; 7/25/00 10:38am
 ;;5.3;Registration;**293**;Aug 13, 1993
 ;
 ;Description:
 ;This routine contains calls to various Mailman functions.  The calls
 ;vary from sending mail to the user, to mailgroups or server groups.
 ;
 ;
SETMAIL(DGTATION,DGDFN) ;
 I DGLINE=0 D INITMAIL(1)
 ;
 S DGLINE=DGLINE+1
 S DGPECE=1
 ;
 ; set first line of each record to station^ssn
 S ^XMB(3.9,XMZ,2,DGLINE,0)=DGTATION_"^"_$P($G(^DPT(+DGDFN,0)),"^",9)_"^"
 S DGLINE=DGLINE+1
 ;
 S DGFIELD=0
 F  S DGFIELD=$O(^XTMP("DGALS",$J,"DATA",2,DGDFN,DGFIELD)) Q:'DGFIELD  DO
 . ;set mailmsg for 1 dfn
 . I $$LINECALC(DGFIELD,DGLINE)>254 DO
 . . ; make sure end piece has last ^
 . . S $P(^XMB(3.9,XMZ,2,DGLINE,0),"^",DGPECE)=""
 . . S DGLINE=DGLINE+1
 . . S DGPECE=1
 . D SETLINE
 . S DGPECE=DGPECE+1
 ;
 ; make sure end piece has last ^
 S $P(^XMB(3.9,XMZ,2,DGLINE,0),"^",DGPECE)=""
 S DGLINE=DGLINE+1
 ; set record delimiter
 S ^XMB(3.9,XMZ,2,DGLINE,0)=">>>"
 ;
 Q
LINECALC(DGFIELD,DGLINE) ;
 ; return length that would be set
 Q $L($G(^XTMP("DGALS",$J,"DATA",2,DGDFN,DGFIELD,"E")))+$L($G(^XMB(3.9,XMZ,2,DGLINE,0)))
 ;
 ;
SETLINE ;set mailmsg from xtmp array
 ; $g will preserve piece position if field returned error
 S $P(^XMB(3.9,XMZ,2,DGLINE,0),"^",DGPECE)=$G(^XTMP("DGALS",$J,"DATA",2,DGDFN,DGFIELD,"E")) Q
 ;
 ;
INITMAIL(FLAG) ;-- This function will initialize mail variables
 ;
 S XMSUB="DG*5.3*293 "_(+$$SITE^VASITE())_" VA PATIENT SURVEY"
 S XMDUZ=.5,XMY(DUZ)="",XMY(XMDUZ)=""
 I $G(FLAG) DO
 . S XMY("HELPDESK@DOMAIN.NAME")=""
 . S XMY("HELPDESK@DOMAIN.NAME")=""
 D GET^XMA2
 Q
SMAIL(DGLINE) ;-- Send Mail Message containing records so far
 ;
 ; INPUT TOTAL- Total Lines in Message
 ;
 S ^XMB(3.9,XMZ,2,0)="^3.92A^"_DGLINE_U_DGLINE_U_DT
 D ENT1^XMD
 D KILL^XM
 Q
 ;
FMAIL(DATA) ;- This function will generate a summary mail message.
 ;
 S XMSUB="DG*5.3*293 "_(+$$SITE^VASITE())_" VA Patient Survey Error Summary"
 S XMDUZ=.5,XMY(DUZ)="",XMY(XMDUZ)=""
 I DATA S XMY("HELPDESK@DOMAIN.NAME")=""
 ;
 D GET^XMA2
 S ^XMB(3.9,XMZ,2,1,0)="VA Patient Survey completed."
 S ^XMB(3.9,XMZ,2,2,0)=""
 S ^XMB(3.9,XMZ,2,3,0)="Start Time: "_DGSTART
 S ^XMB(3.9,XMZ,2,4,0)=" Stop Time: "_$$FMTE^XLFDT($$NOW^XLFDT)
 S ^XMB(3.9,XMZ,2,5,0)=""
 ;
 S DGLINE=6
 I 'DATA DO  QUIT
 . S ^XMB(3.9,XMZ,2,DGLINE,0)="No data requested"
 . D SMAIL(DGLINE)
 ;
 S DGZ=$Q(^XTMP("DGALS",$J,"ERROR"))
 I DGZ]"",DGZ[("""DGALS"""_","_$J_","_"""ERROR""")
 E  DO  QUIT
 . S ^XMB(3.9,XMZ,2,DGLINE,0)=" Error Summary: No errors Found "
 . D SMAIL(DGLINE)
 ;
 S ^XMB(3.9,XMZ,2,DGLINE,0)=" Error Summary: "
 S DGLINE=DGLINE+1
 S ^XMB(3.9,XMZ,2,DGLINE,0)="""ERR"_$P(DGZ,"ERROR",2)_" = "_@DGZ
 ;
 F  S DGZ=$Q(@DGZ) Q:DGZ']""  Q:DGZ'[("""DGALS"""_","_$J_","_"""ERROR""")  DO
 . S DGLINE=DGLINE+1
 . S ^XMB(3.9,XMZ,2,DGLINE,0)="""ERR"_$P(DGZ,"ERROR",2)_" = "_@DGZ
 .;
 .;quit if this gets to be too much
 . I DGLINE>500 S DGZ="ZZZEND"
 D SMAIL(DGLINE)
 Q
