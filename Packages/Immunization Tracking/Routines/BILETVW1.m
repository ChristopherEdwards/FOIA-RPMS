BILETVW1 ;IHS/CMI/MWR - VIEW/EDIT FORM LETTERS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  INIT FOR VIEW/EDIT FORM LETTERS.
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 ;
 ;---> If BIIEN not supplied, set Error Code and quit.
 I '$G(BIIEN) D ERRCD^BIUTL2(609,,1) S VALMQUIT="" Q
 I '$D(^BILET(BIIEN,0)) D ERRCD^BIUTL2(610,,1) S VALMQUIT="" Q
 ;
 ;---> Set Lower Frame Bar and Screen Title.
 S VALMSG="Enter ?? for more actions."
 ;
 ;---> Build Listmanager array from Form Letter global.
 K ^TMP("BILMLT",$J)
 S BILINE=0
 ;
 ;---> If Forecast comes first, set BIFF=1
 N BIFF S BIFF=$P(^BILET(BIIEN,0),U,6)
 ;
 D SECTION(BIIEN,.BILINE,1,"top")
 D
 .I BIFF D FORECAST(BIIEN,.BILINE) Q
 .D HISTORY(BIIEN,.BILINE)
 D SECTION(BIIEN,.BILINE,2,"middle")
 D
 .I BIFF D HISTORY(BIIEN,.BILINE) Q
 .D FORECAST(BIIEN,.BILINE)
 D SECTION(BIIEN,.BILINE,3,"bottom")
 D DATELOC(BIIEN,.BILINE)
 D SECTION(BIIEN,.BILINE,4,"closing")
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE
 I VALMCNT>12 D
 .S VALMSG="Scroll down to view more.  Type ?? for more actions."
 Q
 ;
 ;
 ;----------
SECTION(BIIEN,BILINE,BISEC,BISECLB) ;EP
 ;---> Set a Section of a Form Letter into Listman array.
 ;---> Parameters:
 ;     1 - BIIEN   (req) IEN of Form Letter.
 ;     2 - BILINE  (ret) Last line written into Listman array.
 ;     3 - BISEC   (req) Section of Form Letter to retrieve.
 ;     4 - BISECLB (req) Section Label.
 ;
 Q:'$G(BIIEN)
 Q:'$G(BISEC)
 S:'$G(BILINE) BILINE=0
 S:$G(BISECLB)="" BISECLB="UNLABELED SECTION"
 ;
 D SECTBRK(.BILINE,BISECLB)
 ;
 D:$D(^BILET(BIIEN,BISEC,0))
 .N N S N=0
 .F  S N=$O(^BILET(BIIEN,BISEC,N)) Q:'N  D
 ..S BILINE=BILINE+1
 ..S ^TMP("BILMLT",$J,BILINE,0)=^BILET(BIIEN,BISEC,N,0)
 ;
 Q
 ;
 ;
 ;----------
HISTORY(BIIEN,L) ;EP
 ;---> Set an example of a patient's Immunization History Section
 ;---> of a Form Letter into Listman array.
 ;---> Parameters:
 ;     1 - BIIEN   (req) IEN of Form Letter.
 ;     2 - L  (ret) Last line written into Listman array.
 ;
 Q:'$G(BIIEN)
 S:'$G(L) L=0
 Q:'$P(^BILET(BIIEN,0),U,2)
 D SECTBRK(.L,"history")
 ;
 N BIFORM,X
 S BIFORM=$P(^BILET(BIIEN,0),U,2)
 I BIFORM=1 D  Q
 .;---> Example list of Immunization History by Date.
 .S X="        12-Aug-1994:  1-DTP, 1-OPV, 1-PEDVAXHIB, 1-HEP B VAC"
 .D WRITE(.L,X)
 .S X="        10-Oct-1994:  2-DTP, 2-OPV, 2-PEDVAXHIB, 2-HEP B VAC"
 .D WRITE(.L,X)
 ;
 I BIFORM=2 D  Q
 .;---> Example list of Immunization History by Date.
 .S X="        12-Aug-1994:  1-DTP (099E), 1-OPV (7845F), 1-PEDVAXHIB"
 .S X=X_" (78T032)"
 .D WRITE(.L,X)
 .S X="                      2-HEP B VAC (900RT4)"
 .D WRITE(.L,X)
 .S X="        10-Oct-1994:  2-DTP (101E2), 2-OPV (877K1), 2-PEDVAXHIB"
 .D WRITE(.L,X)
 ;
 ;---> Example list of Immunization History by Vaccine.
 S X="       Immunization   Date Received     Location"
 S:BIFORM=4 X=X_"            Lot#"
 D WRITE(.L,X)
 S X="       ------------   -------------     ---------------"
 S:BIFORM=4 X=X_"     ----------"
 D WRITE(.L,X)
 S X="       1-DTP          12-Aug-1994       Anch Med Ctr"
 S:BIFORM=4 X=X_"        0900E"
 D WRITE(.L,X)
 S X="       2-DTP          12-Oct-1994       Kotzebue Hospital"
 S:BIFORM=4 X=X_"   94-56t"
 D WRITE(.L,X)
 S X="       3-DTP          19-Dec-1994       Anch Med Ctr"
 S:BIFORM=4 X=X_"        0901F"
 D WRITE(.L,X)
 D WRITE(.L)
 S X="       1-OPV          12-Aug-1994       Anch Med Ctr"
 S:BIFORM=4 X=X_"        468-781b"
 D WRITE(.L,X)
 S X="       2-OPV          12-Oct-1994       Kotzebue Hospital"
 S:BIFORM=4 X=X_"   468-732f"
 D WRITE(.L,X)
 S X="       3-OPV          25-Oct-1995       RedLake Hospital"
 S:BIFORM=4 X=X_"    468-81a"
 D WRITE(.L,X)
 D WRITE(.L)
 S X="       1-PEDVAXHIB    12-Aug-1994       Anch Med Ctr"
 D WRITE(.L,X)
 S X="       2-PEDVAXHIB    12-Oct-1994       Kotzebue Hospital"
 S:BIFORM=4 X=X_"   zr987v"
 D WRITE(.L,X)
 S X="       3-PEDVAXHIB    12-Jul-1995       Anch Med Ctr"
 D WRITE(.L,X)
 D WRITE(.L)
 S X="       1-HEP B        29-Jun-1994       Anch Med Ctr"
 S:BIFORM=4 X=X_"        500s-01"
 D WRITE(.L,X)
 S X="       2-HEP B        12-Aug-1994       Anch Med Ctr"
 D WRITE(.L,X)
 S X="       3-HEP B        19-Dec-1994       Anch Med Ctr"
 D WRITE(.L,X)
 D WRITE(.L)
 S X="       1-MMR          12-Jul-1995       Anch Med Ctr"
 S:BIFORM=4 X=X_"        345-101t"
 D WRITE(.L,X)
 ;
 ;---> Example list of Skin Tests.
 D WRITE(.L),WRITE(.L)
 S X="       Skin Test      Date Received     Location"
 S X=X_"            Result"
 D WRITE(.L,X)
 S X="       ------------   -------------     ---------------"
 S X=X_"     ---------"
 D WRITE(.L,X)
 S X="       MONO-VAC       12-Aug-1994       Anch Med Ctr"
 S X=X_"        Negative"
 D WRITE(.L,X)
 Q
 ;
 ;
 ;----------
WRITE(BILINE,X) ;EP
 ;---> Set text (X) in Listman Edit Letter temp global.
 ;---> Parameters:
 ;     1 - BILINE (req) Last line written into Listman array.
 ;     2 - X      (opt) Text of line.  If X=null, insert blank line.
 ;
 S BILINE=BILINE+1
 S:$G(X)="" X=" "
 S ^TMP("BILMLT",$J,BILINE,0)=X
 Q
 ;
 ;
 ;----------
FORECAST(BIIEN,BILINE) ;EP
 ;---> Set an example of a patient's Immunization Forecast Section
 ;---> of a Form Letter into Listman array.
 ;---> Parameters:
 ;     1 - BIIEN   (req) IEN of Form Letter.
 ;     2 - BILINE  (ret) Last line written into Listman array.
 ;
 Q:'$G(BIIEN)
 S:'$G(BILINE) BILINE=0
 Q:'$P(^BILET(BIIEN,0),U,3)
 D SECTBRK(.BILINE,"forecast")
 ;
 N X
 S BILINE=BILINE+1
 S X="        DTP"
 S ^TMP("BILMLT",$J,BILINE,0)=X
 S BILINE=BILINE+1
 S X="        HEP B VAC"
 S ^TMP("BILMLT",$J,BILINE,0)=X
 Q
 ;
 ;
 ;----------
DATELOC(BIIEN,BILINE) ;EP
 ;---> Set an example of a Date Location line of a Form Letter
 ;---> into Listman array.
 ;---> Parameters:
 ;     1 - BIIEN   (req) IEN of Form Letter.
 ;     2 - BILINE  (ret) Last line written into Listman array.
 ;
 Q:'$G(BIIEN)
 S:'$G(BILINE) BILINE=0
 Q:'$P(^BILET(BIIEN,0),U,4)
 D SECTBRK(.BILINE,"date/location")
 ;
 N X
 S BILINE=BILINE+1
 S X="     10-Dec-1994  at Kiddy Klinic, Alaska Native Medical Center"
 S ^TMP("BILMLT",$J,BILINE,0)=X
 Q
 ;
 ;
 ;----------
SECTBRK(BILINE,BISECLB) ;EP
 ;---> Insert a Section Break in Listman array.
 ;---> Parameters:
 ;     1 - BILINE  (ret) IEN of Form Letter.
 ;     2 - BISECLB (req) Section Label.
 ;
 S:'$G(BILINE) BILINE=0
 S:$G(BISECLB)="" BISECLB="UNLABELED SECTION"
 S BISECLB=IORVON_BISECLB_":"_IOINORM
 N BISECBK S BISECBK=$$SP^BIUTL5(79,"-")
 ;
 S BILINE=BILINE+1,^TMP("BILMLT",$J,BILINE,0)=BISECBK
 S BILINE=BILINE+1,^TMP("BILMLT",$J,BILINE,0)=BISECLB
 S BILINE=BILINE+1,^TMP("BILMLT",$J,BILINE,0)=""
 Q
