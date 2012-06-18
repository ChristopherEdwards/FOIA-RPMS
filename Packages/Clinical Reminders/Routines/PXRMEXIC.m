PXRMEXIC ; SLC/PKR/PJH - Routines to install repository entry components. ;24-Mar-2006 13:12;MGH
 ;;1.5;CLINICAL REMINDERS;**5,7,1002,1003,1004**;Jun 19, 2000
 ;IHS/CIA/MGH 5/17/05 Changes made to allow reminder exchange to work in IHS
 ;IHS/CIA/MGH 10/21/05 Changed to allow smooth exis from reminder install if finding is not replaced
 ;======================================================================
FILE(PXRMRIEN,EXISTS,IND120,JND120,ACTION,ATTR,NAMECHG) ;Read and process a
 ;file entry in repository entry PXRMRIEN. IND120 and JND120 are the
 ;indexes for the component list. ACTION is the possible actions, they
 ;are I=install, O=overwrite, C=copy to a new name. If the action is
 ;C then NAMECHG will contain the new name.
 I ACTION="S" Q
 N DATA,FDA,FDAEND,FDASTART,FIELD,FILENUM
 N IEN,IENS,IENREND,IENROOT,IENRSTR,IND,INDICES
 N LINE,MSG,OFDA,ORGIEN,NEW01,PXRMEDOK,PXRMEXCH
 N SRCIEN,TEMP,TOPFNUM
 N WPLCNT,WPTMP
 ;Set PXRMEDOK so files pointing to sponsors can be installed.
 ;Set PXRMEXCH so national entries can be installed and prevent
 ;execution of the input transform for custom logic fields.
 ;IHS/CIA/MGH -Set toolkit variable so it doesn't write to the screen
 S XTLKSAY=0
 S (PXRMEDOK,PXRMEXCH)=1
 S TEMP=^PXD(811.8,PXRMRIEN,120,IND120,1,JND120,0)
 S FDASTART=+$P(TEMP,U,2)
 S FDAEND=+$P(TEMP,U,3)
 S IENRSTR=+$P(TEMP,U,4)
 S IENREND=+$P(TEMP,U,5)
 F IND=FDASTART:1:FDAEND D
 . S LINE=^PXD(811.8,PXRMRIEN,100,IND,0)
 . S INDICES=$P(LINE,"~",1)
 . S DATA=$P(LINE,"~",2)
 . S FILENUM=$P(INDICES,";",1)
 . S IENS=$P(INDICES,";",2)
 . I IND=START S SRCIEN=+IENS
 . S FIELD=$P(INDICES,";",3)
 . I LINE["WP-start" D
 .. S DATA="WPTMP("_IND_","_+FIELD_")"
 .. S WPLCNT=$P(LINE,"~",3)
 .. D WORDPROC(PXRMRIEN,.WPTMP,IND,+FIELD,.IND,WPLCNT)
 . I (IND=START)&(FIELD=.01) D
 ..;Save the top level file number.
 .. S TOPFNUM=FILENUM
 ..;If the action is copy let FileMan determine where to put it.
 .. I ACTION="C" S IENROOT(SRCIEN)=""
 ..;
 ..;If the action is install try to install at the source ien. If
 ..;an entry already exists at the source ien let FileMan determine
 ..;where to put it.
 .. I ACTION="I" D
 ... S ORGIEN=+$$FIND1^DIC(FILENUM,"","Q","`"_SRCIEN)
 ... I ORGIEN>0 S IENROOT(SRCIEN)=""
 ... E  S IENROOT(SRCIEN)=SRCIEN
 ..;
 .. I ACTION="O" D
 ... S ORGIEN=$$EXISTS^PXRMEXIU(FILENUM,DATA)
 ... S IENROOT(SRCIEN)=""
 .;
 . S FDA(FILENUM,IENS,FIELD)=DATA
 ;
 ;Initialize the edit history.
 D INIEH(TOPFNUM,IENS,.FDA,.WPTMP)
 ;Build the IENROOT
 F IND=IENRSTR:1:IENREND D
 . I IND=0 Q
 . S TEMP=^PXD(811.8,PXRMRIEN,100,IND,0)
 . S IENROOT($P(TEMP,U,1))=$P(TEMP,U,2)
 ;Check for name changes, i.e., the copy action.
 D NAMECHG(.FDA,.NAMECHG,TOPFNUM)
 ;Special handling for file 801.41
 I TOPFNUM=801.41 D  Q:PXRMDONE
 . I ACTION="O" D MERGE^PXRMEXU5(801.41,EXISTS,"15;18*",.FDA,.IENROOT,"R")
 . D DLG^PXRMEXU4(.FDA,.NAMECHG)
 ;
 ;If the file number is 811.4 the user must have programmer
 ;access to install it.
 I (TOPFNUM=811.4)&(DUZ(0)'="@") D  Q
 . W !,"Only programmers can install Reminder Computed Findings."
 ;
 ;Special handling for file 811.5.
 I TOPFNUM=811.5 D  Q:'$D(FDA)
 .;If the site has any findings already mapped merge them in.
 . I ACTION="O" D MERGE^PXRMEXU5(811.5,EXISTS,"20*",.FDA,.IENROOT,"M")
 . D TERM^PXRMEXIU(.FDA,.NAMECHG)
 ;
 ;Special handling for file 811.9.
 ;IHS/CIA/MGH Changed to quit if FDA was killed during the call to PXRMEXIC
 I TOPFNUM=811.9 D  Q:'$D(FDA)
 . D DEF^PXRMEXIU(.FDA,.NAMECHG)
 .;Don't execute the input transform for custom logic fields.
 . S PXRMEXCH=1
 ;
 ;Special handling for file 9999999.64.
 I TOPFNUM=9999999.64 D
 . D HF^PXRMEXIU(.FDA,.NAMECHG)
 ;
 ;If the action is overwrite do a test install before deleting the
 ;original entry.
 I ACTION="O" D
 . K OFDA M OFDA=FDA
 .;Make the .01 unique for the test install.
 . S IENS=$O(FDA(TOPFNUM,""))
 . ;Modified by IHS/CIA/MGH to account for field length of entries
 . S FDA(TOPFNUM,IENS,.01)="tmp"_$E(FDA(TOPFNUM,IENS,.01),1,ATTR("FIELD LENGTH")-3)
 I $D(FDA) D UPDATE^DIE("E","FDA","IENROOT","MSG")
 I $D(MSG) D
 . W !,"The update failed, UPDATE^DIE returned the following error message:"
 . D AWRITE^PXRMUTIL("MSG")
 . W !!,ATTR("FILE NAME")," entry ",$G(ATTR("PT01"))," did not get installed!"
 . W !,"Examine the above error message for the reason.",!
 . H 2
 ;
 ;If the action was overwrite and the orginal update worked put the
 ;entry at its original ien.
 I (ACTION="O")&('$D(MSG)) D
 . D DELETE^PXRMEXFI(TOPFNUM,IENROOT(SRCIEN))
 . D DELETE^PXRMEXFI(TOPFNUM,ORGIEN)
 . S IENROOT(SRCIEN)=ORGIEN
 . D UPDATE^DIE("E","OFDA","IENROOT","MSG")
 Q
 ;
 ;======================================================================
INIEH(FILENUM,IENS,FDA,WPTMP) ;If the file is a clinical reminder file and
 ;it has an edit history initialize the history.
 I (FILENUM<800)!(FILENUM>811.9) Q
 ;
 N IENS,SFN,TARGET,WP
 D FIELD^DID(FILENUM,"EDIT HISTORY","","SPECIFIER","TARGET")
 S SFN=+$G(TARGET("SPECIFIER"))
 I SFN=0 Q
 S IENS=$O(FDA(SFN,""))
 I IENS="" Q
 S FDA(SFN,IENS,.01)=$$FMTE^XLFDT($$NOW^XLFDT,"5Z")
 S FDA(SFN,IENS,1)=$$GET1^DIQ(200,DUZ,.01)
 ;The word-processing field is set when the packing is done.
 S WP=FDA(SFN,IENS,2)
 K @WP
 S @WP@(1)="Exchange Install"
 Q
 ;
 ;======================================================================
NAMECHG(FDA,NAMECHG,FILENUM) ;If this component has been copied to a new
 ;name make the change.
 N CLASS,IENS,PT01
 S IENS=$O(FDA(FILENUM,""))
 S PT01=FDA(FILENUM,IENS,.01)
 I $D(NAMECHG(FILENUM,PT01)) D
 . S FDA(FILENUM,IENS,.01)=NAMECHG(FILENUM,PT01)
 . I (FILENUM<801.41)!(FILENUM>811.9) Q
 .;Once a component has been copied CLASS can no longer be national.
 . S CLASS=$G(FDA(FILENUM,IENS,100))
 . I CLASS["N" S FDA(FILENUM,IENS,100)="LOCAL"
 .;The Sponsor is also removed.
 . K FDA(FILENUM,IENS,101)
 Q
 ;
 ;======================================================================
RTNLD(PXRMRIEN,START,END,ATTR,RTN) ;Load a routine from the repository into
 ;the array RTN.
 N IND,LINE,LN,ROUTINE
 S LINE=^PXD(811.8,PXRMRIEN,100,START,0)
 S ROUTINE=$P(LINE,";",1)
 S ROUTINE=$TR(ROUTINE," ","")
 S ATTR("FILE NUMBER")=0
 S ATTR("NAME")=$P(LINE,";",1)
 S ATTR("NAME")=$TR(ATTR("NAME")," ","")
 S ATTR("MIN FIELD LENGTH")=3
 S ATTR("FIELD LENGTH")=8
 S LN=0
 F IND=START:1:END D
 . S LN=LN+1
 . S LINE=^PXD(811.8,PXRMRIEN,100,IND,0)
 . S RTN(LN,0)=LINE
 Q
 ;
 ;======================================================================
RTNSAVE(RTN,NAME) ;Save the routine loaded in RTN to the name
 ;found in NAMECHG.
 N DIE,XCN
 ;%ZOSF("SAVE") requires a global.
 K ^TMP($J,"PXRMRTN")
 S DIE="^TMP($J,""PXRMRTN"","
 M ^TMP($J,"PXRMRTN")=RTN
 S XCN=0
 S X=NAME
 X ^%ZOSF("SAVE")
 K ^TMP($J,"PXRMRTN")
 Q
 ;
 ;======================================================================
WORDPROC(PXRMRIEN,WPTMP,I1,I2,IND,WPLCNT) ;Load WPTMP with the word
 ;processing field.
 N I3
 F I3=1:1:WPLCNT D
 . S IND=IND+1
 . S WPTMP(I1,I2,I3)=$G(^PXD(811.8,PXRMRIEN,100,IND,0))
 Q
 ;
