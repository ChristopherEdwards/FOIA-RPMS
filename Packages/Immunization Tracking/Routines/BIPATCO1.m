BIPATCO1 ;IHS/CMI/MWR - BUILD LIST ARRAY OF CONTRAS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  BUILD LISTMANAGER ARRAY FOR DISPLAY AND EDIT OF
 ;;  PATIENT'S CONTRAINDICATIONS.
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 ;
 S VALMSG="Enter ?? for more actions."
 ;
 ;---> If BIDFN not supplied, set Error Code and quit.
 I '$G(BIDFN) D ERRCD^BIUTL2(201,,1) Q
 ;
 ;---> Initialize RPC variables.
 ;     BI31     - Delimiter between return value and return error.
 ;     BIRETVAL - Return value of valid data from RPC.
 ;     BIRETERR - Return value (text string) of error from RPC.
 ;
 N BI31,BIRETVAL,BIRETERR
 S BI31=$C(31)_$C(31),BIRETVAL=""
 ;
 ;---> RPC to gather Contraindications History.
 D CONTRAS^BIRPC5(.BIRETVAL,BIDFN)
 ;
 ;---> If BIRETERR has a value, display it and quit.
 S BIRETERR=$P(BIRETVAL,BI31,2)
 I BIRETERR]"" D EN^DDIOL("* "_BIRETERR,"","!!?5"),DIRZ^BIUTL3() Q
 ;
 ;---> Set BICONT=to a string of Contraindications for this patient.
 ;---> * NOTE! BICONT(BIDFN) is not newed; it is used to edit and delete
 ;       Immunizations for this patient (sub BIDFN for insurance).
 ;
 K BICONT(BIDFN)
 S BICONT(BIDFN)=$P(BIRETVAL,BI31,1)
 ;
 ;---> Build Listmanager array from BICONT(BIDFN) string.
 K ^TMP("BILMCO",$J)
 N BIENT,BILINE,I,V,X,Y,Z
 S BIENT=0,BILINE=0,V="|",Z=""
 ;
 ;---> Insert blank line at the top of the List Region.
 S ^TMP("BILMCO",$J,1,0)=""
 S ^TMP("BILMCO",$J,"IDX",1,1)=""
 ;
 ;---> Build Listmanager array from BICONT string.
 ;
 F I=1:1 S Y=$P(BICONT(BIDFN),U,I) Q:Y=""  D
 .;---> Build display line for this Contraindication.
 .S X="    "_I_"  "
 .S X=X_$P(Y,V,2)_":",X=$$PAD^BIUTL5(X,19)_$P(Y,V,3)
 .S X=$$PAD^BIUTL5(X,47)_$P(Y,V,4)
 .;
 .;---> Set formatted Contraindication line and index in ^TMP.
 .S ^TMP("BILMCO",$J,I+1,0)=X
 .S ^TMP("BILMCO",$J,"IDX",I+1,I)=""
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=I
 I VALMCNT>12 D
 .S VALMSG="Scroll down to view more. Type ?? for more actions."
 Q
