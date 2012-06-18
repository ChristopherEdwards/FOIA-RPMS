BIEXP ;IHS/CMI/MWR - EXPORT IMMUNIZATION RECORDS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EXPORT IMMUNIZATION RECORDS: MAIN DRIVER.
 ;
 ;
 ;----------
START ;EP
 ;---> Export Immunization Data.
 ;
 D SETVARS^BIUTL5 N BIRTN
 ;
 ;---> Introduction.
 N BIPOP S BIPOP=0
 S BITL="EXPORT IMMUNIZATION RECORDS"
 D TITLE^BIUTL5(BITL),TEXT1
 D DIRZ^BIUTL3(.BIPOP)
 Q:BIPOP
 ;
 ;
 F  D  Q:BIPOP
 .;---> Choose to select either individually or by group.
 .N A,X,Y
 .D TITLE^BIUTL5(BITL),TEXT2
 .S A="     Enter either 1 or 2: "
 .S X="SOAB^1:Individually;2:Group"
 .D DIR^BIFMAN(X,.Y,.BIPOP,A)
 .Q:BIPOP
 .;
 .;---> Select Patients individually and export data.
 .I Y=1 D ^BIEXP1 Q
 .;---> Select Patients by group and export data.
 .D ^BIEXP2
 ;
 D EXIT
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;
 ;;This program will allow you to select a group of patients and to
 ;;export their demographic and immunization data either to a file
 ;;or to your screen (for capture by a PC).
 ;;
 ;;You will have the opportunity to either select individual patients
 ;;(by Name or Chart#), or to select a group of patients by specifying
 ;;Status in the Register, Visit History, Age Range, Facility, and
 ;;Current Community.  You will also be able to limit the export data
 ;;to specific Vaccines.
 ;;
 ;;Lastly, you will be given the option of exporting the data in
 ;;either an ASCII text format or Immserve data format.
 ;;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;
 ;;Do you wish to:
 ;;
 ;;     1) Select patients INDIVIDUALLY by entering their Names
 ;;        or Chart Numbers,
 ;;or
 ;;     2) Select patients by GROUP, specifying Age Range, Status,
 ;;        Current Community, etc.
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> EOJ cleanup.
 K ^TMP("BIEXP1",$J),^TMP("BIEXP2",$J)
 D KILLALL^BIUTL8(1)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
 ;
 ;----------
EXPVT ;EP
 ;---> Export Vaccine Table to a CVS (Excel compatible) host file.
 D SETVARS^BIUTL5
 N BIFLNM,BIPATH,BIPOP
 S BIFLNM="RPMS Vaccine Table.csv"
 D HFS^BIEXPRT8(BIFLNM,.BIPATH,1,.BIPOP)
 I $G(BIPOP) D ^%ZISC W !!?3,"Failure to open Host File." D DIRZ^BIUTL3() Q
 ;
 ;---> Host file is open.
 ;---> Use "," for CSV delimiter.
 N Q,D S Q="""",D=Q_","_Q
 ;
 ;---> Write Header row.
 W Q_"CVX Code"_D_"Name"_D_"Short Name"_D_"Vaccine Group"_D_"VIS Date"_D_"Active"
 W D_"Related Contra CVX's"_D_"1st Brand Name"_D_"2nd Brand Name"_D_"Long Name"_Q
 ;
 ;---> Write data records.
 N N S N=0
 F  S N=$O(^BITN(N)) Q:'N  D
 .N Y,Z S Y=^BITN(N,0),Z=$G(^BITN(N,1))
 .W !,Q_$P(Y,U,3)_D_$P(Y,U,1)_D_$P(Y,U,2)_D_$$VGROUP^BIUTL2($P(Y,U,9))
 .W D_$$SLDT1^BIUTL5($P(Y,U,13))_D_$S($P(Y,U,7)=1:"Inactive",1:"Active")
 .W D_$P(Y,U,12)_D_$P(Z,U,1)_D_$P(Z,U,3)_D_$P(Z,U,14)_Q
 ;
 ;---> Close the host file and report its location.
 D ^%ZISC
 D TITLE^BIUTL5("EXPORT VACCINE TABLE TO EXCEL FILE")
 W !!?5,"The Vaccine Table has been exported to:"
 W !!?10,BIPATH_BIFLNM
 D TEXT3
 D DIRZ^BIUTL3()
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;
 ;;
 ;;
 ;;Note that the path ("folder" or "directory") in which the file
 ;;was placed is taken from the Immunization Site Parameter #6.
 ;;You can change that to a different location by editing the site
 ;;parameter (IMM-->MGR-->ESP-->6).
 ;;
 ;
 D PRINTX("TEXT3")
 Q
